#pragma once

#include "../source/value.h"
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>

namespace tank_trouble {

class TTOriginalSpine : public godot::RefCounted {
    GDCLASS(TTOriginalSpine, godot::RefCounted)
    original::Runtime runtime;
    original::Value spine, atlas, skeleton, state, state_data;
    original::Value call(original::Value object, const char *method, const original::Arguments &arguments = {});
    original::Value from_variant(const godot::Variant &value);
    godot::Array numbers(original::Value array);

protected:
    static void _bind_methods();

public:
    bool initialize(const godot::String &atlas_text, const godot::Dictionary &skeleton_data, const godot::Dictionary &images, bool flip_x);
    void set_mix(const godot::String &from, const godot::String &to, double duration);
    void set_animation(int track, const godot::String &name, bool loop);
    void add_animation(int track, const godot::String &name, bool loop, double delay);
    void clear_track(int track);
    godot::String current_animation(int track);
    void advance(double seconds);
    godot::Array geometry();
    godot::Array bone_transforms();
};

}
