#pragma once

#include "value.h"
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/callable.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <memory>
#include <unordered_map>

namespace tank_trouble {

class TTLegacyWorld : public godot::RefCounted {
    GDCLASS(TTLegacyWorld, godot::RefCounted)

    mutable original::Runtime runtime;
    original::Value box2d;
    original::Value world;
    std::unordered_map<int64_t, original::Value> bodies;
    std::unordered_map<int64_t, original::Value> fixtures;
    std::unordered_map<int64_t, original::Value> contacts;
    int64_t next_body = 1;
    int64_t next_fixture = 1;
    int64_t next_contact = 1;
    godot::Callable listener;

    original::Value path(const char *name) const;
    original::Value call(original::Value receiver, const char *method, const original::Arguments &args = {}) const;
    original::Value vector(double x, double y) const;
    original::Value make_shape(const godot::Dictionary &definition) const;
    godot::Dictionary point(original::Value value) const;
    original::Value from_variant(const godot::Variant &value) const;
    void notify(const char *kind, original::Value contact);
    void collect();

protected:
    static void _bind_methods();

public:
    void configure(double gravity_x, double gravity_y, bool allow_sleep);
    int64_t create_body(const godot::Dictionary &definition);
    void destroy_body(int64_t id, const godot::Callable &callback);
    godot::Dictionary read_body(int64_t id) const;
    void set_transform(int64_t id, double x, double y, double angle);
    void set_velocity(int64_t id, double x, double y);
    void set_angular_velocity(int64_t id, double value);
    godot::Dictionary local_point(int64_t id, double x, double y) const;
    int64_t create_fixture(int64_t body, const godot::Dictionary &definition);
    void destroy_fixture(int64_t body, int64_t fixture, const godot::Callable &callback);
    godot::Dictionary read_fixture(int64_t id) const;
    void step(double delta, int64_t velocity_iterations, int64_t position_iterations, const godot::Callable &callback);
    godot::Dictionary read_contact(int64_t id) const;
    void set_contact_enabled(int64_t id, bool enabled);
    void ray_cast(const godot::Callable &callback, double x1, double y1, double x2, double y2);
    void query_shape(const godot::Callable &callback, const godot::Dictionary &shape, double x, double y, double angle);

};

}
