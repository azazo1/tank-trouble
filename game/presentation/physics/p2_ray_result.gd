extends RefCounted

static func create():
	var host = load("res://game/runtime/js_support.gd").module("GameManager").original_getGame()
	var world = host.physics.p2
	return preload("res://game/presentation/physics/p2_object.gd").from_native(world, world.engine.create_object("RaycastResult", []))
