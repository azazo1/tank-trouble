#include "original_p2.h"
#include <godot_cpp/variant/callable.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace original { Value initialize_p2(Runtime &runtime); }

namespace tank_trouble {
using namespace godot;
using original::Value;
using original::Arguments;

static std::string utf8(const String &text) { return text.utf8().get_data(); }

void TTOriginalP2::_bind_methods() {
    ClassDB::bind_method(D_METHOD("initialize"), &TTOriginalP2::initialize);
    ClassDB::bind_method(D_METHOD("create_object", "name", "arguments"), &TTOriginalP2::create_object);
    ClassDB::bind_method(D_METHOD("invoke_object", "handle", "method", "arguments"), &TTOriginalP2::invoke_object);
    ClassDB::bind_method(D_METHOD("read_property", "handle", "key"), &TTOriginalP2::read_property);
    ClassDB::bind_method(D_METHOD("write_property", "handle", "key", "value"), &TTOriginalP2::write_property);
    ClassDB::bind_method(D_METHOD("write_component", "handle", "key", "index", "value"), &TTOriginalP2::write_component);
    ClassDB::bind_method(D_METHOD("collect"), &TTOriginalP2::collect);
}

bool TTOriginalP2::initialize() {
    try {
        runtime.instruction_budget = 1000000;
        runtime.install_spine_builtins();
        p2 = original::initialize_p2(runtime);
        return true;
    } catch (const std::exception &error) {
        UtilityFunctions::push_error(String("P2 初始化失败: ") + error.what());
        return false;
    }
}

Dictionary TTOriginalP2::reference(Value value) {
    auto found = identifiers.find(value.node);
    int64_t id;
    if (found == identifiers.end()) {
        id = next_handle++;
        identifiers[value.node] = id;
        handles[id] = value;
    } else id = found->second;
    Dictionary result;
    result["$p2"] = id;
    return result;
}

Value TTOriginalP2::from_variant(const Variant &value) {
    switch (value.get_type()) {
        case Variant::NIL: return Value::null();
        case Variant::BOOL: return Value(static_cast<bool>(value));
        case Variant::INT: return Value(static_cast<double>(static_cast<int64_t>(value)));
        case Variant::FLOAT: return Value(static_cast<double>(value));
        case Variant::STRING: return Value(utf8(value));
        case Variant::ARRAY: {
            Array input = value;
            Arguments items;
            for (int i = 0; i < input.size(); ++i) items.push_back(from_variant(input[i]));
            return runtime.array(items);
        }
        case Variant::DICTIONARY: {
            Dictionary input = value;
            if (input.has("$p2")) return handles.at(static_cast<int64_t>(input["$p2"]));
            auto result = runtime.object();
            auto keys = input.keys();
            for (int i = 0; i < keys.size(); ++i) runtime.set(result, utf8(keys[i]), from_variant(input[keys[i]]));
            return result;
        }
        case Variant::CALLABLE: {
            Callable callback = value;
            return runtime.host([this, callback](original::Runtime &, Value, const Arguments &args) {
                Array values;
                for (const auto &item : args) values.push_back(to_variant(item));
                return from_variant(callback.callv(values));
            });
        }
        default: throw std::runtime_error("不支持的 P2 数据类型");
    }
}

Variant TTOriginalP2::to_variant(Value value) {
    switch (value.kind) {
        case Value::UNDEFINED: case Value::NULL_VALUE: return Variant();
        case Value::BOOLEAN: return runtime.truthy(value);
        case Value::NUMBER: return value.numeric;
        case Value::STRING: return String(value.string.c_str());
        case Value::OBJECT: {
            if (!value.node->array) return reference(value);
            Array items;
            for (const auto &item : value.node->elements) items.push_back(to_variant(item));
            return items;
        }
    }
    return Variant();
}

Dictionary TTOriginalP2::create_object(const String &name, const Array &arguments) {
    try {
        runtime.instruction_budget = 1000000;
        Arguments args;
        for (int i = 0; i < arguments.size(); ++i) args.push_back(from_variant(arguments[i]));
        return reference(runtime.construct(runtime.get(p2, utf8(name)), args));
    } catch (const std::exception &error) {
        UtilityFunctions::push_error(String("P2 创建 ") + name + ": " + error.what());
        return Dictionary();
    }
}

Variant TTOriginalP2::invoke_object(int64_t handle, const String &method, const Array &arguments) {
    try {
        runtime.instruction_budget = 1000000;
        Arguments args;
        for (int i = 0; i < arguments.size(); ++i) args.push_back(from_variant(arguments[i]));
        auto receiver = handles.at(handle);
        auto result = runtime.invoke(runtime.get(receiver, utf8(method)), receiver, args);
        // 原版射线等接口通过数组参数返回结果, 必须保留调用方的数组身份.
        for (int i = 0; i < arguments.size(); ++i) {
            if (arguments[i].get_type() != Variant::ARRAY) continue;
            Array target = arguments[i];
            Array source = to_variant(args[i]);
            target.resize(source.size());
            for (int j = 0; j < source.size(); ++j) target[j] = source[j];
        }
        return to_variant(result);
    } catch (const std::exception &error) {
        UtilityFunctions::push_error(String("P2 调用 ") + method + ": " + error.what());
        return Variant();
    }
}

Variant TTOriginalP2::read_property(int64_t handle, const String &key) {
    try { return to_variant(runtime.get(handles.at(handle), utf8(key))); }
    catch (const std::exception &error) { UtilityFunctions::push_error(error.what()); return Variant(); }
}

void TTOriginalP2::write_property(int64_t handle, const String &key, const Variant &value) {
    try { runtime.set(handles.at(handle), utf8(key), from_variant(value)); }
    catch (const std::exception &error) { UtilityFunctions::push_error(error.what()); }
}

void TTOriginalP2::collect() {
    Arguments roots = {p2};
    for (const auto &entry : handles) roots.push_back(entry.second);
    runtime.collect(roots);
}

void TTOriginalP2::write_component(int64_t handle, const String &key, int64_t index, double value) {
    try { runtime.set(runtime.get(handles.at(handle), utf8(key)), Value(static_cast<double>(index)), Value(value)); }
    catch (const std::exception &error) { UtilityFunctions::push_error(String::utf8(error.what())); }
}

}
