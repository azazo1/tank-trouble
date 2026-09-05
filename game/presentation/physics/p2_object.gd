extends RefCounted

var owner: WeakRef
var data: Dictionary

static func from_native(world, value):
	if value is Dictionary and value.has("$p2"):
		var object = load("res://game/presentation/physics/p2_object.gd").new()
		object.owner = weakref(world)
		object.data = value
		return object
	return value

static func unwrap(value):
	return value.data if value is Object and value.get_script() == load("res://game/presentation/physics/p2_object.gd") else value

func _get(key):
	return from_native(owner.get_ref(), owner.get_ref().get_native(data, key))

func _set(key, value):
	owner.get_ref().set_native(data, key, unwrap(value))
	return true

func native_invoke(method, arguments):
	var args = arguments.map(unwrap)
	return from_native(owner.get_ref(), owner.get_ref().call_native(data, method, args))
