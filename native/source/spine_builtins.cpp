#include "value.h"

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdlib>
#include <regex>
#include <stdexcept>

namespace original {

void Runtime::checkpoint(int function, int offset) {
    if (instruction_budget == 0) return;
    if (--instruction_budget == 0) throw std::runtime_error("原生执行预算耗尽, 函数 " + std::to_string(function) + ", 源码位置 " + std::to_string(offset));
}

static Value arg(const Arguments &args, size_t index) {
    return index < args.size() ? args[index] : Value();
}

std::vector<std::string> Runtime::keys(Value object) const {
    std::vector<std::string> result;
    if (object.kind != Value::OBJECT) return result;
    if (object.node->array) for (size_t i = 0; i < object.node->elements.size(); ++i) result.push_back(std::to_string(i));
    for (const auto &key : object.node->property_order) if (object.node->fields.count(key)) result.push_back(key);
    for (const auto &entry : object.node->fields) {
        if (std::find(result.begin(), result.end(), entry.first) == result.end() && entry.first.rfind("@", 0) != 0) result.push_back(entry.first);
    }
    return result;
}

Value Runtime::regexp(const std::string &pattern, const std::string &flags) {
    auto value = object();
    set(value, "@pattern", pattern);
    set(value, "@flags", flags);
    return value;
}

void Runtime::install_spine_builtins() {
    set(global("Array"), "isArray", host([](Runtime &, Value, const Arguments &args) {
        auto value = arg(args, 0);
        return Value(value.kind == Value::OBJECT && value.node->array && value.node->array_type == 0);
    }));
    object_prototype->fields["toString"] = host([](Runtime &, Value self, const Arguments &) {
        if (self.kind == Value::OBJECT && self.node->array) return Value("[object Array]");
        return Value("[object Object]");
    });
    set(global("Object"), "setPrototypeOf", host([](Runtime &, Value, const Arguments &args) {
        args[0].node->prototype = args[1].kind == Value::OBJECT ? args[1].node : nullptr;
        return args[0];
    }));
    set(global("Object"), "create", host([](Runtime &r, Value, const Arguments &args) {
        auto result = r.object();
        result.node->prototype = args[0].kind == Value::OBJECT ? args[0].node : nullptr;
        return result;
    }));
    object_prototype->fields["hasOwnProperty"] = host([](Runtime &r, Value self, const Arguments &args) {
        return Value(self.node->fields.count(r.text(args[0])) != 0);
    });
    for (const auto &entry : std::vector<std::pair<std::string, int>>{{"Float32Array", 1}, {"Int16Array", 2}, {"Uint16Array", 3}, {"Uint32Array", 4}, {"Int32Array", 5}}) {
        auto constructor = host([type = entry.second](Runtime &r, Value, const Arguments &args) {
            auto input = arg(args, 0);
            const auto size = input.kind == Value::OBJECT ? input.node->elements.size() : static_cast<size_t>(r.number(input));
            auto result = r.array(Arguments(size, Value(0)));
            result.node->array_type = type;
            if (input.kind == Value::OBJECT) for (size_t i = 0; i < size; ++i) r.set(result, Value(static_cast<double>(i)), input.node->elements[i]);
            return result;
        });
        globals[entry.first] = constructor;
    }
    array_prototype->fields["pop"] = host([](Runtime &, Value self, const Arguments &) {
        auto &items = self.node->elements;
        if (items.empty()) return Value();
        auto result = items.back();
        items.pop_back();
        return result;
    });
    array_prototype->fields["slice"] = host([](Runtime &r, Value self, const Arguments &args) {
        auto &items = self.node->elements;
        const int size = items.size();
        int start = args.empty() ? 0 : r.number(args[0]);
        int end = args.size() < 2 ? size : r.number(args[1]);
        start = std::clamp(start < 0 ? size + start : start, 0, size);
        end = std::clamp(end < 0 ? size + end : end, start, size);
        return r.array(Arguments(items.begin() + start, items.begin() + end));
    });
    globals["@string:trim"] = host([](Runtime &, Value self, const Arguments &) {
        auto start = self.string.find_first_not_of(" \t\r\n");
        if (start == std::string::npos) return Value("");
        return Value(self.string.substr(start, self.string.find_last_not_of(" \t\r\n") - start + 1));
    });
    globals["@string:toLowerCase"] = host([](Runtime &, Value self, const Arguments &) {
        auto result = self.string;
        std::transform(result.begin(), result.end(), result.begin(), [](unsigned char c) { return std::tolower(c); });
        return Value(result);
    });
    globals["@string:charAt"] = host([](Runtime &r, Value self, const Arguments &args) {
        const auto index = static_cast<size_t>(r.number(arg(args, 0)));
        return Value(index < self.string.size() ? self.string.substr(index, 1) : "");
    });
    globals["@string:substring"] = host([](Runtime &r, Value self, const Arguments &args) {
        int size = self.string.size();
        int start = std::clamp(static_cast<int>(r.number(arg(args, 0))), 0, size);
        int end = args.size() > 1 ? std::clamp(static_cast<int>(r.number(args[1])), 0, size) : size;
        if (start > end) std::swap(start, end);
        return Value(self.string.substr(start, end - start));
    });
    globals["@string:substr"] = host([](Runtime &r, Value self, const Arguments &args) {
        int size = self.string.size(), start = r.number(arg(args, 0));
        start = std::clamp(start < 0 ? size + start : start, 0, size);
        int length = args.size() > 1 ? std::clamp(static_cast<int>(r.number(args[1])), 0, size - start) : size - start;
        return Value(self.string.substr(start, length));
    });
    globals["@string:split"] = host([](Runtime &r, Value self, const Arguments &args) {
        auto separator = arg(args, 0);
        Arguments parts;
        if (separator.kind == Value::OBJECT) {
            std::regex pattern(r.text(r.get(separator, "@pattern")));
            size_t start = 0;
            for (auto it = std::sregex_iterator(self.string.begin(), self.string.end(), pattern); it != std::sregex_iterator(); ++it) {
                parts.emplace_back(self.string.substr(start, it->position() - start));
                start = it->position() + it->length();
            }
            parts.emplace_back(self.string.substr(start));
        } else {
            const auto delimiter = r.text(separator);
            if (delimiter.empty()) for (char c : self.string) parts.emplace_back(std::string(1, c));
            else {
                size_t start = 0, end;
                while ((end = self.string.find(delimiter, start)) != std::string::npos) {
                    parts.emplace_back(self.string.substr(start, end - start));
                    start = end + delimiter.size();
                }
                parts.emplace_back(self.string.substr(start));
            }
        }
        return r.array(parts);
    });
    globals["parseFloat"] = host([](Runtime &r, Value, const Arguments &args) { return Value(std::strtod(r.text(arg(args, 0)).c_str(), nullptr)); });
    auto phaser = object(), easing = object(), quadratic = object();
    set(quadratic, "InOut", host([](Runtime &r, Value, const Arguments &args) {
        double k = r.number(arg(args, 0)) * 2;
        if (k < 1) return Value(0.5 * k * k);
        k -= 1;
        return Value(-0.5 * (k * (k - 2) - 1));
    }));
    set(easing, "Quadratic", quadratic);
    set(phaser, "Easing", easing);
    globals["Phaser"] = phaser;
    auto date = object();
    set(date, "now", host([](Runtime &, Value, const Arguments &) {
        return Value(static_cast<double>(std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count()));
    }));
    globals["Date"] = date;
    globals["console"] = object();
    globals["JSON"] = object();
}

}
