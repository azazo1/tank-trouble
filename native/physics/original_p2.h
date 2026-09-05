#pragma once

#include "../source/value.h"
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <unordered_map>

namespace tank_trouble {

class TTOriginalP2 : public godot::RefCounted {
    GDCLASS(TTOriginalP2, godot::RefCounted)
    original::Runtime runtime;
    original::Value p2;
    std::unordered_map<int64_t, original::Value> handles;
    std::unordered_map<original::Node *, int64_t> identifiers;
    int64_t next_handle = 1;

    original::Value from_variant(const godot::Variant &value);
    godot::Variant to_variant(original::Value value);
    godot::Dictionary reference(original::Value value);

protected:
    static void _bind_methods();

public:
    bool initialize();
    godot::Dictionary create_object(const godot::String &name, const godot::Array &arguments);
    godot::Variant invoke_object(int64_t handle, const godot::String &method, const godot::Array &arguments);
    godot::Variant read_property(int64_t handle, const godot::String &key);
    void write_property(int64_t handle, const godot::String &key, const godot::Variant &value);
    void collect();
};

}
