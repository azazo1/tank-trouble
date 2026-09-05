#include "original_spine.h"
#include <godot_cpp/variant/utility_functions.hpp>

namespace tank_trouble {
using namespace godot;
using original::Value;
using original::Arguments;

static std::string utf8(const String &text) { return text.utf8().get_data(); }

void TTOriginalSpine::_bind_methods() {
    ClassDB::bind_method(D_METHOD("initialize", "atlas_text", "skeleton_data", "images", "flip_x"), &TTOriginalSpine::initialize);
    ClassDB::bind_method(D_METHOD("set_mix", "from", "to", "duration"), &TTOriginalSpine::set_mix);
    ClassDB::bind_method(D_METHOD("set_animation", "track", "name", "loop"), &TTOriginalSpine::set_animation);
    ClassDB::bind_method(D_METHOD("add_animation", "track", "name", "loop", "delay"), &TTOriginalSpine::add_animation);
    ClassDB::bind_method(D_METHOD("clear_track", "track"), &TTOriginalSpine::clear_track);
    ClassDB::bind_method(D_METHOD("set_flip_x", "flipped"), &TTOriginalSpine::set_flip_x);
    ClassDB::bind_method(D_METHOD("current_animation", "track"), &TTOriginalSpine::current_animation);
    ClassDB::bind_method(D_METHOD("advance", "seconds"), &TTOriginalSpine::advance);
    ClassDB::bind_method(D_METHOD("geometry"), &TTOriginalSpine::geometry);
    ClassDB::bind_method(D_METHOD("bone_transforms"), &TTOriginalSpine::bone_transforms);
}

Value TTOriginalSpine::call(Value object, const char *method, const Arguments &arguments) {
    return runtime.invoke(runtime.get(object, method), object, arguments);
}

Value TTOriginalSpine::from_variant(const Variant &value) {
    switch (value.get_type()) {
        case Variant::NIL: return Value::null();
        case Variant::BOOL: return Value(static_cast<bool>(value));
        case Variant::INT: return Value(static_cast<double>(static_cast<int64_t>(value)));
        case Variant::FLOAT: return Value(static_cast<double>(value));
        case Variant::STRING: return Value(utf8(value));
        case Variant::ARRAY: {
            Array items = value;
            Arguments result;
            for (int i = 0; i < items.size(); ++i) result.push_back(from_variant(items[i]));
            return runtime.array(result);
        }
        case Variant::DICTIONARY: {
            Dictionary items = value;
            auto keys = items.keys();
            auto result = runtime.object();
            for (int i = 0; i < keys.size(); ++i) runtime.set(result, Value(utf8(keys[i])), from_variant(items[keys[i]]));
            return result;
        }
        default: throw std::runtime_error("不支持的 Spine 数据类型");
    }
}

Array TTOriginalSpine::numbers(Value array) {
    Array result;
    for (auto item : array.node->elements) result.push_back(runtime.number(item));
    return result;
}

bool TTOriginalSpine::initialize(const String &atlas_text, const Dictionary &skeleton_data, const Dictionary &images, bool flip_x) {
    try {
        runtime.instruction_budget = 1000000;
        runtime.install_spine_builtins();
        spine = original::initialize_spine(runtime);
        auto loader = runtime.host([images](original::Runtime &r, Value, const Arguments &args) {
            const auto path = r.text(args[0]);
            Dictionary dimensions = images[String(path.c_str())];
            auto image = r.object();
            r.set(image, "width", Value(static_cast<double>(dimensions["width"])));
            r.set(image, "height", Value(static_cast<double>(dimensions["height"])));
            auto texture = r.object();
            r.set(texture, "name", path);
            r.set(texture, "image", image);
            r.set(texture, "getImage", r.host([](original::Runtime &rt, Value self, const Arguments &) { return rt.get(self, "image"); }));
            auto no_op = r.host([](original::Runtime &, Value, const Arguments &) { return Value(); });
            r.set(texture, "setFilters", no_op);
            r.set(texture, "setWraps", no_op);
            return texture;
        });
        atlas = runtime.construct(runtime.get(spine, "TextureAtlas"), {Value(utf8(atlas_text)), loader});
        auto attachment_loader = runtime.construct(runtime.get(spine, "AtlasAttachmentLoader"), {atlas});
        auto reader = runtime.construct(runtime.get(spine, "SkeletonJson"), {attachment_loader});
        auto data = call(reader, "readSkeletonData", {from_variant(skeleton_data)});
        skeleton = runtime.construct(runtime.get(spine, "Skeleton"), {data});
        runtime.set(skeleton, "flipX", Value(flip_x));
        runtime.set(skeleton, "flipY", Value(false));
        call(skeleton, "setToSetupPose");
        call(skeleton, "updateWorldTransform");
        state_data = runtime.construct(runtime.get(spine, "AnimationStateData"), {data});
        state = runtime.construct(runtime.get(spine, "AnimationState"), {state_data});
        runtime.collect({spine, atlas, skeleton, state, state_data});
        return true;
    } catch (const std::exception &error) {
        UtilityFunctions::push_error(String("Spine 初始化失败: ") + error.what());
        return false;
    }
}

void TTOriginalSpine::set_mix(const String &from, const String &to, double duration) {
    try {
        auto easing = runtime.get(runtime.get(runtime.get(runtime.global("Phaser"), "Easing"), "Quadratic"), "InOut");
        call(state_data, "setMix", {Value(utf8(from)), Value(utf8(to)), Value(duration), easing});
    } catch (const std::exception &error) { UtilityFunctions::push_error(error.what()); }
}

void TTOriginalSpine::set_animation(int track, const String &name, bool loop) {
    try { call(state, "setAnimation", {Value(track), Value(utf8(name)), Value(loop)}); }
    catch (const std::exception &error) { UtilityFunctions::push_error(error.what()); }
}

void TTOriginalSpine::add_animation(int track, const String &name, bool loop, double delay) {
    try { call(state, "addAnimation", {Value(track), Value(utf8(name)), Value(loop), Value(delay)}); }
    catch (const std::exception &error) { UtilityFunctions::push_error(error.what()); }
}

void TTOriginalSpine::clear_track(int track) {
    try { call(state, "clearTrack", {Value(track)}); }
    catch (const std::exception &error) { UtilityFunctions::push_error(error.what()); }
}

void TTOriginalSpine::set_flip_x(bool flipped) {
    try {
        runtime.set(skeleton, "flipX", Value(flipped));
        call(skeleton, "updateWorldTransform");
    } catch (const std::exception &error) { UtilityFunctions::push_error(error.what()); }
}

String TTOriginalSpine::current_animation(int track) {
    if (state.kind != Value::OBJECT) return "";
    auto entry = runtime.get(runtime.get(state, "tracks"), Value(track));
    if (!runtime.truthy(entry)) return "";
    auto animation = runtime.get(entry, "animation");
    return runtime.truthy(animation) ? String(runtime.text(runtime.get(animation, "name")).c_str()) : String();
}

void TTOriginalSpine::advance(double seconds) {
    try {
        runtime.instruction_budget = 1000000;
        call(state, "update", {Value(seconds)});
        call(state, "apply", {skeleton});
        call(skeleton, "updateWorldTransform");
        runtime.collect({spine, atlas, skeleton, state, state_data});
    } catch (const std::exception &error) { UtilityFunctions::push_error(String("Spine 更新失败: ") + error.what()); }
}

Array TTOriginalSpine::geometry() {
    Array result;
    try {
        for (auto slot : runtime.get(skeleton, "drawOrder").node->elements) {
            auto attachment = runtime.get(slot, "attachment");
            if (!runtime.truthy(attachment)) continue;
            const bool region = runtime.truthy(runtime.binary("instanceof", attachment, runtime.get(spine, "RegionAttachment")));
            const bool mesh = runtime.truthy(runtime.binary("instanceof", attachment, runtime.get(spine, "MeshAttachment")));
            if (!region && !mesh) continue;
            const int length = region ? 8 : runtime.number(runtime.get(attachment, "worldVerticesLength"));
            auto vertices = runtime.array(Arguments(length, Value(0)));
            if (region) call(attachment, "computeWorldVertices", {runtime.get(slot, "bone"), vertices, Value(0), Value(2)});
            else call(attachment, "computeWorldVertices", {slot, Value(0), Value(length), vertices, Value(0), Value(2)});
            Dictionary item;
            item["vertices"] = numbers(vertices);
            item["uvs"] = numbers(runtime.get(attachment, "uvs"));
            item["triangles"] = region ? Array::make(0, 1, 2, 2, 3, 0) : numbers(runtime.get(attachment, "triangles"));
            item["texture"] = String(runtime.text(runtime.get(runtime.get(runtime.get(attachment, "region"), "texture"), "name")).c_str());
            item["slot"] = String(runtime.text(runtime.get(runtime.get(slot, "data"), "name")).c_str());
            item["blend"] = runtime.number(runtime.get(runtime.get(slot, "data"), "blendMode"));
            Array color;
            for (const char *component : {"r", "g", "b", "a"}) {
                color.push_back(runtime.number(runtime.get(runtime.get(skeleton, "color"), component)) * runtime.number(runtime.get(runtime.get(slot, "color"), component)) * runtime.number(runtime.get(runtime.get(attachment, "color"), component)));
            }
            item["color"] = color;
            result.push_back(item);
        }
        runtime.collect({spine, atlas, skeleton, state, state_data});
    } catch (const std::exception &error) { UtilityFunctions::push_error(String("Spine 顶点生成失败: ") + error.what()); }
    return result;
}

Array TTOriginalSpine::bone_transforms() {
    Array result;
    for (auto bone : runtime.get(skeleton, "bones").node->elements) {
        Array values;
        for (const char *key : {"a", "b", "c", "d", "worldX", "worldY"}) values.push_back(runtime.number(runtime.get(bone, key)));
        result.push_back(values);
    }
    return result;
}

}
