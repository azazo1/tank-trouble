extends RefCounted

var world: WeakRef
var sprite: WeakRef
var data
var collidesWith: Array = []
var collision_group = 1
var material
var x:
	get: return -20.0 * _get("position")[0]
	set(value): world.get_ref().engine.write_component(data["$p2"], "position", 0, -0.05 * value)
var y:
	get: return -20.0 * _get("position")[1]
	set(value): world.get_ref().engine.write_component(data["$p2"], "position", 1, -0.05 * value)
var rotation:
	get: return _get("angle")
	set(value): _set("angle", value)
var dynamic:
	get: return _get("type") == 1
	set(value): _set("type", 1 if value else 2); _call("updateMassProperties")
var kinematic:
	get: return _get("type") == 4
	set(value): _set("type", 4 if value else 1); _call("updateMassProperties")

static func create(host, actor = null, horizontal = 0, vertical = 0, mass_value = 1):
	var result = load("res://game/presentation/physics/p2_body.gd").new()
	result.world = weakref(host.physics.p2)
	result.sprite = weakref(actor) if actor != null else null
	result.data = host.physics.p2.engine.create_object("Body", [{"position": [-0.05 * horizontal, -0.05 * vertical], "mass": mass_value}])
	if actor != null:
		result.setRectangle(actor.width, actor.height)
		if actor.exists: host.physics.p2.addBody(result)
	return result

func _get(key):
	return world.get_ref().get_native(data, key)

func _set(key, value):
	if key == "static":
		_set("type", 2 if value else 1)
		_call("updateMassProperties")
		return true
	world.get_ref().set_native(data, key, value)
	return true

func _call(method, arguments = []):
	return world.get_ref().call_native(data, method, arguments)

func clearShapes():
	for shape in _get("shapes"): _call("removeShape", [shape])

func addRectangle(width, height, offset_x = 0.0, offset_y = 0.0, angle = 0.0):
	var shape = world.get_ref().engine.create_object("Box", [{"width": 0.05 * width, "height": 0.05 * height}])
	_call("addShape", [shape, [-0.05 * offset_x, -0.05 * offset_y], angle])
	return shape

func setRectangle(width = 16, height = 16, offset_x = 0.0, offset_y = 0.0, angle = 0.0):
	clearShapes()
	return addRectangle(width, height, offset_x, offset_y, angle)

func setCircle(radius, offset_x = 0.0, offset_y = 0.0):
	clearShapes()
	var shape = world.get_ref().engine.create_object("Circle", [{"radius": 0.05 * radius}])
	_call("addShape", [shape, [-0.05 * offset_x, -0.05 * offset_y]])
	return shape

func setCollisionGroup(group):
	collision_group = group.mask
	for shape in _get("shapes"):
		world.get_ref().set_native(shape, "collisionGroup", collision_group)
		world.get_ref().set_native(shape, "collisionMask", getCollisionMask())

func collides(groups):
	for group in groups:
		if not collidesWith.has(group): collidesWith.append(group)
	for shape in _get("shapes"): world.get_ref().set_native(shape, "collisionMask", getCollisionMask())

func getCollisionMask():
	var result = 2
	for group in collidesWith: result |= int(group.mask)
	return result

func setMaterial(value):
	material = value
	for shape in _get("shapes"): world.get_ref().set_native(shape, "material", value)

func reset(horizontal, vertical):
	_call("setZeroForce")
	world.get_ref().engine.write_component(data["$p2"], "velocity", 0, 0)
	world.get_ref().engine.write_component(data["$p2"], "velocity", 1, 0)
	_set("angularVelocity", 0)
	x = horizontal
	y = vertical

func sync_sprite():
	var actor = sprite.get_ref() if sprite != null else null
	if actor != null:
		actor.x = x
		actor.y = y
		if not _get("fixedRotation"): actor.rotation = rotation

func removeFromWorld():
	world.get_ref().removeBody(self)

func addToWorld():
	world.get_ref().addBody(self)
