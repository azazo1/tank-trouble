#include "javascript_values.h"
#include <charconv>
#include <cmath>
#include <string>

namespace tank_trouble {

void TTJavaScriptValues::_bind_methods() {
    godot::ClassDB::bind_method(godot::D_METHOD("number_to_string", "value"), &TTJavaScriptValues::number_to_string);
}

godot::String TTJavaScriptValues::number_to_string(double value) const {
    if (std::isnan(value)) return "NaN";
    if (std::isinf(value)) return value < 0 ? "-Infinity" : "Infinity";
    if (value == 0) return "0";
    char buffer[128];
    auto result = std::to_chars(buffer, buffer + sizeof(buffer), value, std::chars_format::general);
    std::string text(buffer, result.ptr);
    auto exponent_at = text.find('e');
    if (exponent_at != std::string::npos) {
        int exponent = std::stoi(text.substr(exponent_at + 1));
        bool negative = text.front() == '-';
        auto digits = text.substr(negative ? 1 : 0, exponent_at - (negative ? 1 : 0));
        auto decimal_at = digits.find('.');
        if (decimal_at != std::string::npos) digits.erase(decimal_at, 1);
        // ECMAScript 在 [1e-6, 1e21) 内使用十进制定点表示.
        if (exponent >= -6 && exponent < 21) {
            int point = exponent + 1;
            if (point <= 0) text = "0." + std::string(-point, '0') + digits;
            else if (point >= static_cast<int>(digits.size())) text = digits + std::string(point - digits.size(), '0');
            else text = digits.substr(0, point) + "." + digits.substr(point);
            if (negative) text.insert(0, "-");
        } else {
            text = text.substr(0, exponent_at) + "e" + (exponent >= 0 ? "+" : "-") + std::to_string(std::abs(exponent));
        }
    }
    return godot::String::utf8(text.c_str());
}

}
