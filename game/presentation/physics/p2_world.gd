extends RefCounted

var engine
var world
var bodies: Array = []
var paused = false
var collision_id = 2
var game: WeakRef

func _init(host):
	game = weakref(host)
	engine = ClassDB.instantiate("TTOriginalP2")
	assert(engine.initialize())
	world = engine.create_object("World", [{"gravity": [0, 0]}])

func createCollisionGroup():
	var result = {"mask": 1 << collision_id}
	collision_id += 1
	return result

func createMaterial(_name = ""):
	return engine.create_object("Material", [])

func createContactMaterial(first, second):
	var material = engine.create_object("ContactMaterial", [first, second])
	call_native(world, "addContactMaterial", [material])
	return material

func call_native(object, method, arguments = []):
	return engine.invoke_object(object["$p2"], method, arguments)

func set_native(object, key, value):
	engine.write_property(object["$p2"], key, value)

func get_native(object, key):
	return engine.read_property(object["$p2"], key)

func enable(sprite):
	if sprite.body != null: return
	sprite.body = preload("res://game/presentation/physics/p2_body.gd").create(game.get_ref(), sprite, sprite.x, sprite.y)
	sprite.anchor.setTo(0.5)

func addBody(body):
	if bodies.has(body): return false
	bodies.append(body)
	call_native(world, "addBody", [body.data])
	return true

func removeBody(body):
	if not bodies.has(body): return false
	bodies.erase(body)
	call_native(world, "removeBody", [body.data])
	return true

func advance():
	if paused: return
	call_native(world, "step", [1.0 / 60.0])
	for body in bodies: body.sync_sprite()
	engine.collect()

func clear():
	for body in bodies.duplicate(): removeBody(body)
