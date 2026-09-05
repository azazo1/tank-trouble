#include "value.h"

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <iomanip>
#include <limits>
#include <sstream>
#include <stdexcept>

namespace original {

static Value argument(const Arguments &arguments, size_t index) {
    return index < arguments.size() ? arguments[index] : Value();
}

static bool index_key(const std::string &key, size_t &index) {
    if (key.empty() || (key.size() > 1 && key[0] == '0')) return false;
    uint64_t result = 0;
    for (char character : key) {
        if (character < '0' || character > '9') return false;
        result = result * 10 + character - '0';
        if (result >= 0xffffffff) return false;
    }
    index = result;
    return true;
}

Node *Runtime::allocate() {
    nodes.push_back(std::make_unique<Node>());
    return nodes.back().get();
}

Environment *Runtime::environment(Environment *parent, size_t count) {
    auto item = std::make_unique<Environment>();
    item->parent = parent;
    item->slots.resize(count);
    environments.push_back(std::move(item));
    return environments.back().get();
}

Value Runtime::object() {
    auto node = allocate();
    node->prototype = object_prototype;
    return Value(node);
}

Value Runtime::array(const Arguments &items) {
    auto node = allocate();
    node->prototype = array_prototype;
    node->array = true;
    node->elements = items;
    return Value(node);
}

Value Runtime::function(Function function, Environment *closure) {
    auto node = allocate();
    node->prototype = function_prototype;
    node->callable = true;
    node->function = function;
    node->closure = closure;
    auto prototype = object();
    prototype.node->fields["constructor"] = Value(node);
    node->fields["prototype"] = prototype;
    return Value(node);
}

Value Runtime::host(HostFunction callback) {
    auto result = function(nullptr, nullptr);
    result.node->host = std::move(callback);
    return result;
}

Value Runtime::global(const std::string &name) const {
    auto found = globals.find(name);
    if (found == globals.end()) throw std::runtime_error("未移植的原生全局对象: " + name);
    return found->second;
}

Value Runtime::get(Value object, Value key) const {
    const auto name = text(key);
    if (object.kind == Value::STRING) {
        if (name == "length") return Value(static_cast<double>(object.string.size()));
        if (name == "indexOf") return globals.at("@stringIndexOf");
        auto method = globals.find("@string:" + name);
        if (method != globals.end()) return method->second;
        size_t index;
        if (index_key(name, index) && index < object.string.size()) return Value(object.string.substr(index, 1));
        return Value();
    }
    if (object.kind != Value::OBJECT) throw std::runtime_error("不能读取原生属性: " + name + " (" + text(object) + ")");
    auto node = object.node;
    if (node->array) {
        if (name == "length") {
            auto length = node->fields.find("@length");
            return length != node->fields.end() ? length->second : Value(static_cast<double>(node->elements.size()));
        }
        size_t index;
        if (index_key(name, index) && index < node->elements.size()) return node->elements[index];
    }
    for (; node; node = node->prototype) {
        auto getter = node->fields.find("@get:" + name);
        if (getter != node->fields.end()) return const_cast<Runtime *>(this)->invoke(getter->second, object, {});
        auto found = node->fields.find(name);
        if (found != node->fields.end()) return found->second;
    }
    return Value();
}

Value Runtime::set(Value object, Value key, Value value) {
    if (object.kind != Value::OBJECT) throw std::runtime_error("不能写入原生属性: " + text(key));
    auto node = object.node;
    auto name = text(key);
    for (auto prototype = node; prototype; prototype = prototype->prototype) {
        auto setter = prototype->fields.find("@set:" + name);
        if (setter != prototype->fields.end()) { invoke(setter->second, object, {value}); return value; }
    }
    if (node->array) {
        if (name == "length") {
            const auto length = static_cast<size_t>(number(value));
            if (length > 65536 && node->array_type == 0) node->fields["@length"] = value;
            else {
                node->fields.erase("@length");
                node->elements.resize(length);
            }
            for (auto it = node->fields.begin(); it != node->fields.end();) {
                size_t index;
                if (index_key(it->first, index) && index >= length) it = node->fields.erase(it);
                else ++it;
            }
            return value;
        }
        size_t index;
        if (index_key(name, index)) {
            if (node->array_type != 0 && index >= node->elements.size()) return value;
            if (index >= 65536 && node->array_type == 0) {
                const auto length = get(object, "length");
                node->fields["@length"] = Value(std::max(number(length), static_cast<double>(index + 1)));
                if (!node->fields.count(name)) node->property_order.push_back(name);
                node->fields[name] = value;
                return value;
            }
            if (index >= node->elements.size()) node->elements.resize(index + 1);
            if (node->array_type == 1) node->elements[index] = Value(static_cast<double>(static_cast<float>(number(value))));
            else if (node->array_type == 2) node->elements[index] = Value(static_cast<double>(static_cast<int16_t>(number(value))));
            else if (node->array_type == 3) node->elements[index] = Value(static_cast<double>(static_cast<uint16_t>(number(value))));
            else if (node->array_type == 4) node->elements[index] = Value(static_cast<double>(static_cast<uint32_t>(number(value))));
            else if (node->array_type == 5) node->elements[index] = Value(static_cast<double>(static_cast<int32_t>(number(value))));
            else node->elements[index] = value;
            return value;
        }
    }
    if (!node->fields.count(name)) node->property_order.push_back(name);
    node->fields[name] = value;
    return value;
}

Value Runtime::erase(Value object, Value key) {
    if (object.kind == Value::OBJECT) object.node->fields.erase(text(key));
    return Value(true);
}

Value Runtime::invoke(Value function, Value receiver, const Arguments &arguments) {
    if (function.kind != Value::OBJECT || !function.node->callable) throw std::runtime_error("原生对象不可调用");
    auto node = function.node;
    if (node->host) return node->host(*this, receiver, arguments);
    try {
        return node->function(*this, receiver, arguments, node->closure, function);
    } catch (const std::exception &error) {
        const auto found = function_names.find(node->function);
        const auto label = found == function_names.end() ? "Box2D " + std::to_string(box2d_function_id(node->function)) : found->second;
        throw std::runtime_error(label + ": " + error.what());
    }
}

Value Runtime::construct(Value function, const Arguments &arguments) {
    auto instance = object();
    auto prototype = get(function, "prototype");
    if (prototype.kind == Value::OBJECT) instance.node->prototype = prototype.node;
    const auto result = invoke(function, instance, arguments);
    return result.kind == Value::OBJECT ? result : instance;
}

bool Runtime::truthy(Value value) const {
    if (value.kind == Value::UNDEFINED || value.kind == Value::NULL_VALUE) return false;
    if (value.kind == Value::NUMBER || value.kind == Value::BOOLEAN) return value.numeric != 0 && !std::isnan(value.numeric);
    if (value.kind == Value::STRING) return !value.string.empty();
    return true;
}

double Runtime::number(Value value) const {
    if (value.kind == Value::NULL_VALUE) return 0;
    if (value.kind == Value::BOOLEAN || value.kind == Value::NUMBER) return value.numeric;
    if (value.kind == Value::STRING) {
        if (value.string.empty()) return 0;
        char *end;
        auto result = std::strtod(value.string.c_str(), &end);
        if (end != value.string.c_str() && *end == '\0') return result;
    }
    return std::numeric_limits<double>::quiet_NaN();
}

std::string Runtime::text(Value value) const {
    if (value.kind == Value::STRING) return value.string;
    if (value.kind == Value::UNDEFINED) return "undefined";
    if (value.kind == Value::NULL_VALUE) return "null";
    if (value.kind == Value::BOOLEAN) return value.numeric ? "true" : "false";
    if (value.kind == Value::OBJECT) return "[object Object]";
    std::ostringstream out;
    out << std::setprecision(17) << value.numeric;
    return out.str();
}

bool Runtime::equal(Value left, Value right, bool strict) const {
    if (left.kind != right.kind) {
        if (strict) return false;
        if ((left.kind == Value::NULL_VALUE || left.kind == Value::UNDEFINED) && (right.kind == Value::NULL_VALUE || right.kind == Value::UNDEFINED)) return true;
        if (left.kind == Value::NULL_VALUE || left.kind == Value::UNDEFINED || right.kind == Value::NULL_VALUE || right.kind == Value::UNDEFINED) return false;
        return number(left) == number(right);
    }
    if (left.kind == Value::OBJECT) return left.node == right.node;
    if (left.kind == Value::STRING) return left.string == right.string;
    return left.numeric == right.numeric;
}

static uint32_t uint32_number(double number) {
    if (!std::isfinite(number) || number == 0) return 0;
    double result = std::fmod(std::trunc(number), 4294967296.0);
    if (result < 0) result += 4294967296.0;
    return static_cast<uint32_t>(result);
}

Value Runtime::binary(const std::string &operation, Value left, Value right) const {
    if (operation == "in") {
        if (right.kind != Value::OBJECT) return Value(false);
        auto name = text(left);
        for (auto node = right.node; node; node = node->prototype) if (node->fields.count(name)) return Value(true);
        size_t index;
        return Value(right.node->array && index_key(name, index) && index < right.node->elements.size());
    }
    if (operation == "==" || operation == "===") return Value(equal(left, right, operation == "==="));
    if (operation == "!=" || operation == "!==") return Value(!equal(left, right, operation == "!=="));
    if (operation == "+" && (left.kind == Value::STRING || right.kind == Value::STRING)) return Value(text(left) + text(right));
    if (operation == "instanceof") {
        if (left.kind != Value::OBJECT || right.kind != Value::OBJECT || !right.node->callable) return Value(false);
        const auto prototype = get(right, "prototype");
        for (auto node = left.node->prototype; node; node = node->prototype) if (prototype.node == node) return Value(true);
        return Value(false);
    }
    if (operation == "<" || operation == "<=" || operation == ">" || operation == ">=") {
        if (left.kind == Value::OBJECT) left = Value(text(left));
        if (right.kind == Value::OBJECT) right = Value(text(right));
        if (left.kind == Value::STRING && right.kind == Value::STRING) {
            if (operation == "<") return Value(left.string < right.string);
            if (operation == "<=") return Value(left.string <= right.string);
            if (operation == ">") return Value(left.string > right.string);
            return Value(left.string >= right.string);
        }
    }
    const double a = number(left), b = number(right);
    if (operation == "+") return Value(a + b);
    if (operation == "-") return Value(a - b);
    if (operation == "*") return Value(a * b);
    if (operation == "/") return Value(a / b);
    if (operation == "%") return Value(std::fmod(a, b));
    if (operation == "<") return Value(a < b);
    if (operation == "<=") return Value(a <= b);
    if (operation == ">") return Value(a > b);
    if (operation == ">=") return Value(a >= b);
    const uint32_t ua = uint32_number(a), ub = uint32_number(b);
    if (operation == "&") return Value(static_cast<double>(static_cast<int32_t>(ua & ub)));
    if (operation == "|") return Value(static_cast<double>(static_cast<int32_t>(ua | ub)));
    if (operation == "^") return Value(static_cast<double>(static_cast<int32_t>(ua ^ ub)));
    if (operation == "<<") return Value(static_cast<double>(static_cast<int32_t>(ua << (ub & 31))));
    if (operation == ">>") return Value(static_cast<double>(static_cast<int32_t>(ua) >> (ub & 31)));
    if (operation == ">>>") return Value(static_cast<double>(ua >> (ub & 31)));
    throw std::runtime_error("未移植的原生运算: " + operation);
}

Value Runtime::unary(const std::string &operation, Value value) const {
    if (operation == "!") return Value(!truthy(value));
    if (operation == "-") return Value(-number(value));
    if (operation == "+") return Value(number(value));
    if (operation == "~") return Value(static_cast<double>(static_cast<int32_t>(~uint32_number(number(value)))));
    if (operation == "void") return Value();
    if (operation == "typeof") {
        switch (value.kind) {
            case Value::UNDEFINED: return "undefined";
            case Value::BOOLEAN: return "boolean";
            case Value::NUMBER: return "number";
            case Value::STRING: return "string";
            case Value::OBJECT: return value.node->callable ? "function" : "object";
            default: return "object";
        }
    }
    throw std::runtime_error("未移植的原生单目运算: " + operation);
}

void Runtime::mark(Value value) {
    if (value.kind != Value::OBJECT || value.node->marked) return;
    auto node = value.node;
    node->marked = true;
    if (node->prototype) mark(Value(node->prototype));
    for (const auto &entry : node->fields) mark(entry.second);
    for (auto entry : node->elements) mark(entry);
    mark(node->closure);
}

void Runtime::mark(Environment *environment) {
    if (!environment || environment->marked) return;
    environment->marked = true;
    mark(environment->parent);
    for (auto value : environment->slots) mark(value);
}

void Runtime::collect(const Arguments &roots) {
    for (auto &node : nodes) node->marked = false;
    for (auto &environment : environments) environment->marked = false;
    for (const auto &entry : globals) mark(entry.second);
    mark(Value(object_prototype));
    mark(Value(array_prototype));
    mark(Value(function_prototype));
    for (auto value : roots) mark(value);
    nodes.erase(std::remove_if(nodes.begin(), nodes.end(), [](const auto &node) { return !node->marked; }), nodes.end());
    environments.erase(std::remove_if(environments.begin(), environments.end(), [](const auto &environment) { return !environment->marked; }), environments.end());
}

Runtime::Runtime() {
    object_prototype = allocate();
    array_prototype = allocate();
    array_prototype->prototype = object_prototype;
    function_prototype = allocate();
    function_prototype->prototype = object_prototype;
    globals["Object"] = host([](Runtime &r, Value, const Arguments &) { return r.object(); });
    set(globals["Object"], "defineProperty", host([](Runtime &r, Value, const Arguments &args) {
        auto object = argument(args, 0), key = argument(args, 1), descriptor = argument(args, 2);
        for (const char *kind : {"get", "set"}) {
            auto accessor = r.get(descriptor, kind);
            if (accessor.kind != Value::UNDEFINED) object.node->fields["@" + std::string(kind) + ":" + r.text(key)] = accessor;
        }
        auto value = r.get(descriptor, "value");
        if (value.kind != Value::UNDEFINED) r.set(object, key, value);
        return object;
    }));
    globals["Function"] = host([](Runtime &, Value, const Arguments &) -> Value { throw std::runtime_error("不支持动态编译函数"); });
    globals["Array"] = host([](Runtime &r, Value, const Arguments &arguments) {
        if (arguments.size() == 1 && arguments[0].kind == Value::NUMBER) return r.array(Arguments(static_cast<size_t>(r.number(arguments[0]))));
        return r.array(arguments);
    });
    set(globals["Object"], "prototype", Value(object_prototype));
    set(globals["Array"], "prototype", Value(array_prototype));
    set(globals["Function"], "prototype", Value(function_prototype));
    object_prototype->fields["constructor"] = globals["Object"];
    array_prototype->fields["constructor"] = globals["Array"];
    function_prototype->fields["constructor"] = globals["Function"];
    function_prototype->fields["apply"] = host([](Runtime &r, Value self, const Arguments &args) {
        auto list = argument(args, 1);
        return r.invoke(self, argument(args, 0), list.kind == Value::OBJECT ? list.node->elements : Arguments());
    });
    function_prototype->fields["call"] = host([](Runtime &r, Value self, const Arguments &args) {
        return r.invoke(self, argument(args, 0), args.size() > 1 ? Arguments(args.begin() + 1, args.end()) : Arguments());
    });
    array_prototype->fields["push"] = host([](Runtime &, Value self, const Arguments &args) {
        self.node->elements.insert(self.node->elements.end(), args.begin(), args.end());
        return Value(static_cast<double>(self.node->elements.size()));
    });
    array_prototype->fields["indexOf"] = host([](Runtime &r, Value self, const Arguments &args) {
        const auto &items = self.node->elements;
        int start = args.size() > 1 ? static_cast<int>(r.number(args[1])) : 0;
        if (start < 0) start = std::max(0, static_cast<int>(items.size()) + start);
        for (size_t i = static_cast<size_t>(start); i < items.size(); ++i) if (r.equal(items[i], argument(args, 0), true)) return Value(static_cast<double>(i));
        return Value(-1.0);
    });
    array_prototype->fields["splice"] = host([](Runtime &r, Value self, const Arguments &args) {
        auto &items = self.node->elements;
        int start = static_cast<int>(r.number(argument(args, 0))), size = static_cast<int>(items.size());
        start = std::clamp(start < 0 ? size + start : start, 0, size);
        int count = args.size() > 1 ? static_cast<int>(r.number(args[1])) : size - start;
        count = std::clamp(count, 0, size - start);
        auto removed = r.array(Arguments(items.begin() + start, items.begin() + start + count));
        items.erase(items.begin() + start, items.begin() + start + count);
        if (args.size() > 2) items.insert(items.begin() + start, args.begin() + 2, args.end());
        return removed;
    });
    globals["@stringIndexOf"] = host([](Runtime &r, Value self, const Arguments &args) {
        const auto start = args.size() > 1 ? static_cast<size_t>(std::max(0.0, r.number(args[1]))) : 0;
        const auto found = self.string.find(r.text(argument(args, 0)), start);
        return Value(found == std::string::npos ? -1.0 : static_cast<double>(found));
    });
    globals["Number"] = host([](Runtime &r, Value, const Arguments &args) { return Value(r.number(argument(args, 0))); });
    set(globals["Number"], "MIN_VALUE", Value(std::numeric_limits<double>::denorm_min()));
    set(globals["Number"], "MAX_VALUE", Value(std::numeric_limits<double>::max()));
    set(globals["Number"], "POSITIVE_INFINITY", Value(INFINITY));
    globals["parseInt"] = host([](Runtime &r, Value, const Arguments &args) { return Value(static_cast<double>(std::strtol(r.text(argument(args, 0)).c_str(), nullptr, args.size() > 1 ? static_cast<int>(r.number(args[1])) : 10))); });
    globals["Error"] = host([](Runtime &r, Value, const Arguments &args) { auto error = r.object(); r.set(error, "message", argument(args, 0)); return error; });
    globals["isFinite"] = host([](Runtime &r, Value, const Arguments &args) { return Value(std::isfinite(r.number(argument(args, 0)))); });
    globals["isNaN"] = host([](Runtime &r, Value, const Arguments &args) { return Value(std::isnan(r.number(argument(args, 0)))); });
    auto math = object();
    globals["Math"] = math;
    set(math, "PI", Value(3.1415926535897932384626433832795));
    const std::unordered_map<std::string, double (*)(double)> unary_math = {{"abs", std::fabs}, {"sqrt", std::sqrt}, {"sin", std::sin}, {"cos", std::cos}, {"tan", std::tan}, {"floor", std::floor}, {"ceil", std::ceil}, {"atan", std::atan}, {"acos", std::acos}, {"asin", std::asin}};
    for (const auto &entry : unary_math) set(math, entry.first, host([function = entry.second](Runtime &r, Value, const Arguments &args) { return Value(function(r.number(argument(args, 0)))); }));
    set(math, "pow", host([](Runtime &r, Value, const Arguments &args) { return Value(std::pow(r.number(argument(args, 0)), r.number(argument(args, 1)))); }));
    set(math, "atan2", host([](Runtime &r, Value, const Arguments &args) { return Value(std::atan2(r.number(argument(args, 0)), r.number(argument(args, 1)))); }));
    set(math, "min", host([](Runtime &r, Value, const Arguments &args) { double result = INFINITY; for (auto value : args) result = std::min(result, r.number(value)); return Value(result); }));
    set(math, "max", host([](Runtime &r, Value, const Arguments &args) { double result = -INFINITY; for (auto value : args) result = std::max(result, r.number(value)); return Value(result); }));
}

}
