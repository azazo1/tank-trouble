extends RefCounted

static func original_static_get(key):
	return {"CLOSEST": 1, "ANY": 2, "ALL": 4}.get(key)

static func create(options):
	var host = load("res://game/runtime/js_support.gd").module("GameManager").original_getGame()
	var world = host.physics.p2
	return preload("res://game/presentation/physics/p2_object.gd").from_native(world, world.engine.create_object("Ray", [options]))
