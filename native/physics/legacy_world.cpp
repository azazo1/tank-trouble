#include "legacy_world.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/error_macros.hpp>
#include <sstream>

using namespace godot;
using original::Value;
using original::Arguments;

namespace tank_trouble {

static double number(const Dictionary &object, const char *key, double fallback = 0.0) {
    return object.get(key, fallback);
}

void TTLegacyWorld::_bind_methods() {
    ClassDB::bind_method(D_METHOD("configure", "gravity_x", "gravity_y", "allow_sleep"), &TTLegacyWorld::configure);
    ClassDB::bind_method(D_METHOD("create_body", "definition"), &TTLegacyWorld::create_body);
    ClassDB::bind_method(D_METHOD("destroy_body", "id", "callback"), &TTLegacyWorld::destroy_body);
    ClassDB::bind_method(D_METHOD("read_body", "id"), &TTLegacyWorld::read_body);
    ClassDB::bind_method(D_METHOD("set_transform", "id", "x", "y", "angle"), &TTLegacyWorld::set_transform);
    ClassDB::bind_method(D_METHOD("set_velocity", "id", "x", "y"), &TTLegacyWorld::set_velocity);
    ClassDB::bind_method(D_METHOD("set_angular_velocity", "id", "value"), &TTLegacyWorld::set_angular_velocity);
    ClassDB::bind_method(D_METHOD("local_point", "id", "x", "y"), &TTLegacyWorld::local_point);
    ClassDB::bind_method(D_METHOD("create_fixture", "body", "definition"), &TTLegacyWorld::create_fixture);
    ClassDB::bind_method(D_METHOD("destroy_fixture", "body", "fixture", "callback"), &TTLegacyWorld::destroy_fixture);
    ClassDB::bind_method(D_METHOD("read_fixture", "id"), &TTLegacyWorld::read_fixture);
    ClassDB::bind_method(D_METHOD("step", "delta", "velocity_iterations", "position_iterations", "callback"), &TTLegacyWorld::step);
    ClassDB::bind_method(D_METHOD("read_contact", "id"), &TTLegacyWorld::read_contact);
    ClassDB::bind_method(D_METHOD("set_contact_enabled", "id", "enabled"), &TTLegacyWorld::set_contact_enabled);
    ClassDB::bind_method(D_METHOD("ray_cast", "callback", "x1", "y1", "x2", "y2"), &TTLegacyWorld::ray_cast);
    ClassDB::bind_method(D_METHOD("query_shape", "callback", "shape", "x", "y", "angle"), &TTLegacyWorld::query_shape);
}

Value TTLegacyWorld::path(const char *name) const {
    Value result = box2d;
    std::istringstream parts(name);
    std::string part;
    while (std::getline(parts, part, '.')) result = runtime.get(result, part);
    return result;
}

Value TTLegacyWorld::call(Value receiver, const char *method, const Arguments &args) const {
    return runtime.invoke(runtime.get(receiver, method), receiver, args);
}

Value TTLegacyWorld::vector(double x, double y) const {
    return runtime.construct(path("Common.Math.b2Vec2"), {Value(x), Value(y)});
}

Dictionary TTLegacyWorld::point(Value value) const {
    Dictionary result;
    result["x"] = runtime.number(runtime.get(value, "x"));
    result["y"] = runtime.number(runtime.get(value, "y"));
    return result;
}

Value TTLegacyWorld::from_variant(const Variant &value) const {
    switch (value.get_type()) {
        case Variant::BOOL: return Value(static_cast<bool>(value));
        case Variant::INT:
        case Variant::FLOAT: return Value(static_cast<double>(value));
        case Variant::STRING: return Value(static_cast<String>(value).utf8().get_data());
        default: return Value::null();
    }
}

void TTLegacyWorld::configure(double x, double y, bool allow_sleep) {
    ERR_FAIL_COND(world.kind != Value::UNDEFINED);
    try {
        box2d = original::initialize_box2d(runtime);
        const auto settings = path("Common.b2Settings");
        runtime.set(settings, "b2_maxTranslation", Value(8.0));
        runtime.set(settings, "b2_maxTranslationSquared", Value(64.0));
        runtime.set(settings, "b2_velocityThreshold", Value(0.0));
        world = runtime.construct(path("Dynamics.b2World"), {vector(x, y), Value(allow_sleep)});
        auto contact_listener = runtime.object();
        for (const char *kind : {"BeginContact", "EndContact", "PreSolve", "PostSolve"}) {
            runtime.set(contact_listener, kind, runtime.host([this, kind](original::Runtime &, Value, const Arguments &args) {
                notify(kind, args[0]);
                return Value();
            }));
        }
        call(world, "SetContactListener", {contact_listener});
        collect();
    } catch (const std::exception &error) { ERR_PRINT(String("原版物理初始化失败: ") + error.what()); }
}

int64_t TTLegacyWorld::create_body(const Dictionary &definition) {
    auto body = runtime.construct(path("Dynamics.b2BodyDef"), {});
    for (const char *key : {"type", "angle", "angularVelocity", "linearDamping", "angularDamping", "allowSleep", "awake", "fixedRotation", "bullet", "active"}) {
        if (definition.has(key)) runtime.set(body, key, from_variant(definition[key]));
    }
    runtime.set(body, "position", vector(number(definition, "x"), number(definition, "y")));
    runtime.set(body, "linearVelocity", vector(number(definition, "vx"), number(definition, "vy")));
    const auto id = next_body++;
    runtime.set(body, "userData", Value(static_cast<double>(id)));
    bodies[id] = call(world, "CreateBody", {body});
    return id;
}

void TTLegacyWorld::destroy_body(int64_t id, const Callable &callback) {
    ERR_FAIL_COND(!bodies.count(id));
    std::vector<int64_t> removed;
    for (auto fixture = call(bodies.at(id), "GetFixtureList"); runtime.truthy(fixture); fixture = call(fixture, "GetNext")) removed.push_back(static_cast<int64_t>(runtime.number(call(fixture, "GetUserData"))));
    listener = callback;
    call(world, "DestroyBody", {bodies.at(id)});
    listener = {};
    contacts.clear();
    for (auto fixture : removed) fixtures.erase(fixture);
    bodies.erase(id);
}

Dictionary TTLegacyWorld::read_body(int64_t id) const {
    ERR_FAIL_COND_V(!bodies.count(id), Dictionary());
    const auto body = bodies.at(id);
    auto result = point(call(body, "GetPosition"));
    result["angle"] = runtime.number(call(body, "GetAngle"));
    auto velocity = point(call(body, "GetLinearVelocity"));
    result["vx"] = velocity["x"];
    result["vy"] = velocity["y"];
    result["angularVelocity"] = runtime.number(call(body, "GetAngularVelocity"));
    Array ids;
    for (auto fixture = call(body, "GetFixtureList"); runtime.truthy(fixture); fixture = call(fixture, "GetNext")) ids.push_back(static_cast<int64_t>(runtime.number(call(fixture, "GetUserData"))));
    result["fixtures"] = ids;
    return result;
}

void TTLegacyWorld::set_transform(int64_t id, double x, double y, double angle) {
    ERR_FAIL_COND(!bodies.count(id));
    call(bodies.at(id), "SetPositionAndAngle", {vector(x, y), Value(angle)});
}

void TTLegacyWorld::set_velocity(int64_t id, double x, double y) {
    ERR_FAIL_COND(!bodies.count(id));
    call(bodies.at(id), "SetLinearVelocity", {vector(x, y)});
}

void TTLegacyWorld::set_angular_velocity(int64_t id, double value) {
    ERR_FAIL_COND(!bodies.count(id));
    call(bodies.at(id), "SetAngularVelocity", {Value(value)});
}

Dictionary TTLegacyWorld::local_point(int64_t id, double x, double y) const {
    ERR_FAIL_COND_V(!bodies.count(id), Dictionary());
    return point(call(bodies.at(id), "GetLocalPoint", {vector(x, y)}));
}

Value TTLegacyWorld::make_shape(const Dictionary &definition) const {
    const String kind = definition.get("kind", "polygon");
    if (kind == "circle") {
        auto shape = runtime.construct(path("Collision.Shapes.b2CircleShape"), {Value(number(definition, "radius"))});
        runtime.set(shape, "m_p", vector(number(definition, "x"), number(definition, "y")));
        return shape;
    }
    const auto polygon = path("Collision.Shapes.b2PolygonShape");
    if (kind == "box") return call(polygon, "AsBox", {Value(number(definition, "hx")), Value(number(definition, "hy"))});
    const Array coordinates = definition["vertices"];
    Arguments vertices;
    for (int i = 0; i < coordinates.size(); ++i) {
        const Dictionary vertex = coordinates[i];
        vertices.push_back(vector(number(vertex, "x"), number(vertex, "y")));
    }
    return call(polygon, "AsArray", {runtime.array(vertices)});
}

int64_t TTLegacyWorld::create_fixture(int64_t id, const Dictionary &definition) {
    ERR_FAIL_COND_V(!bodies.count(id), 0);
    auto fixture = runtime.construct(path("Dynamics.b2FixtureDef"), {});
    runtime.set(fixture, "shape", make_shape(definition["shape"]));
    for (const char *key : {"density", "friction", "restitution", "isSensor"}) if (definition.has(key)) runtime.set(fixture, key, from_variant(definition[key]));
    auto filter = runtime.get(fixture, "filter");
    for (const char *key : {"categoryBits", "maskBits", "groupIndex"}) if (definition.has(key)) runtime.set(filter, key, from_variant(definition[key]));
    const auto handle = next_fixture++;
    runtime.set(fixture, "userData", Value(static_cast<double>(handle)));
    fixtures[handle] = call(bodies.at(id), "CreateFixture", {fixture});
    return handle;
}

void TTLegacyWorld::destroy_fixture(int64_t body, int64_t fixture, const Callable &callback) {
    ERR_FAIL_COND(!bodies.count(body) || !fixtures.count(fixture));
    listener = callback;
    call(bodies.at(body), "DestroyFixture", {fixtures.at(fixture)});
    listener = {};
    contacts.clear();
    fixtures.erase(fixture);
}

Dictionary TTLegacyWorld::read_fixture(int64_t id) const {
    ERR_FAIL_COND_V(!fixtures.count(id), Dictionary());
    const auto fixture = fixtures.at(id);
    const auto filter = call(fixture, "GetFilterData");
    Dictionary result;
    for (const char *key : {"categoryBits", "maskBits", "groupIndex"}) result[key] = static_cast<int64_t>(runtime.number(runtime.get(filter, key)));
    const auto next = call(fixture, "GetNext");
    result["next"] = runtime.truthy(next) ? static_cast<int64_t>(runtime.number(call(next, "GetUserData"))) : 0;
    return result;
}

void TTLegacyWorld::collect() {
    Arguments roots = {box2d, world};
    for (const auto &body : bodies) roots.push_back(body.second);
    for (const auto &fixture : fixtures) roots.push_back(fixture.second);
    runtime.collect(roots);
}

void TTLegacyWorld::step(double delta, int64_t velocity_iterations, int64_t position_iterations, const Callable &callback) {
    listener = callback;
    try {
        call(world, "Step", {Value(delta), Value(static_cast<double>(velocity_iterations)), Value(static_cast<double>(position_iterations))});
    } catch (const std::exception &error) { ERR_PRINT(String("原版物理更新失败: ") + error.what()); }
    listener = {};
    contacts.clear();
    collect();
}

void TTLegacyWorld::notify(const char *kind, Value contact) {
    if (!listener.is_valid()) return;
    const auto id = next_contact++;
    contacts[id] = contact;
    listener.call(String(kind), id, Dictionary());
}

Dictionary TTLegacyWorld::read_contact(int64_t id) const {
    ERR_FAIL_COND_V(!contacts.count(id), Dictionary());
    const auto contact = contacts.at(id);
    const auto manifold = runtime.construct(path("Collision.b2WorldManifold"), {});
    call(contact, "GetWorldManifold", {manifold});
    Dictionary result;
    result["fixtureA"] = static_cast<int64_t>(runtime.number(call(call(contact, "GetFixtureA"), "GetUserData")));
    result["fixtureB"] = static_cast<int64_t>(runtime.number(call(call(contact, "GetFixtureB"), "GetUserData")));
    result["touching"] = runtime.truthy(call(contact, "IsTouching"));
    result["normal"] = point(runtime.get(manifold, "m_normal"));
    Array points;
    for (auto value : runtime.get(manifold, "m_points").node->elements) points.push_back(point(value));
    result["points"] = points;
    return result;
}

void TTLegacyWorld::set_contact_enabled(int64_t id, bool enabled) {
    ERR_FAIL_COND(!contacts.count(id));
    call(contacts.at(id), "SetEnabled", {Value(enabled)});
}

void TTLegacyWorld::ray_cast(const Callable &callback, double x1, double y1, double x2, double y2) {
    auto ray = runtime.host([this, callback](original::Runtime &, Value, const Arguments &args) {
        return Value(static_cast<double>(callback.call(static_cast<int64_t>(runtime.number(call(args[0], "GetUserData"))), point(args[1]), point(args[2]), runtime.number(args[3]))));
    });
    call(world, "RayCast", {ray, vector(x1, y1), vector(x2, y2)});
}

void TTLegacyWorld::query_shape(const Callable &callback, const Dictionary &definition, double x, double y, double angle) {
    auto query = runtime.host([this, callback](original::Runtime &, Value, const Arguments &args) {
        return Value(static_cast<bool>(callback.call(static_cast<int64_t>(runtime.number(call(args[0], "GetUserData"))))));
    });
    const auto rotation = call(path("Common.Math.b2Mat22"), "FromAngle", {Value(angle)});
    const auto transform = runtime.construct(path("Common.Math.b2Transform"), {vector(x, y), rotation});
    call(world, "QueryShape", {query, make_shape(definition), transform});
}

}
