#include "physics/legacy_world.h"
#include <godot_cpp/godot.hpp>

static void initialize(godot::ModuleInitializationLevel level) {
    if (level == godot::MODULE_INITIALIZATION_LEVEL_SCENE) godot::ClassDB::register_class<tank_trouble::TTLegacyWorld>();
}

static void uninitialize(godot::ModuleInitializationLevel) {}

extern "C" {
GDExtensionBool GDE_EXPORT tank_trouble_library_init(GDExtensionInterfaceGetProcAddress get_proc_address, GDExtensionClassLibraryPtr library, GDExtensionInitialization *initialization) {
    godot::GDExtensionBinding::InitObject init(get_proc_address, library, initialization);
    init.register_initializer(initialize);
    init.register_terminator(uninitialize);
    init.set_minimum_library_initialization_level(godot::MODULE_INITIALIZATION_LEVEL_SCENE);
    return init.init();
}
}
