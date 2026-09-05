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
	if not engine.initialize():
		push_error("P2 原生物理初始化失败")
		return
	var native_world = engine.create_object("World", [{"gravity": [0, 0]}])
	world = preload("res://game/presentation/physics/p2_object.gd").from_native(self, native_world)
	call_native(world, "on", ["beginContact", _begin_contact])

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
	var reference = object.data if object is Object else object
	return engine.invoke_object(reference["$p2"], method, arguments)

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
	engine.collect()

func post_update():
	for body in bodies: body.sync_sprite()

func getBodies():
	return bodies.duplicate()

func _begin_contact(event):
	var first = get_native(event, "bodyA")
	var second = get_native(event, "bodyB")
	var body_a
	var body_b
	for body in bodies:
		if body.data == first: body_a = body
		if body.data == second: body_b = body
	if body_a != null: body_a.onBeginContact.dispatch([body_b, second, get_native(event, "shapeA"), get_native(event, "shapeB"), get_native(event, "contactEquations")])
	if body_b != null: body_b.onBeginContact.dispatch([body_a, first, get_native(event, "shapeB"), get_native(event, "shapeA"), get_native(event, "contactEquations")])

func clear():
	for body in bodies.duplicate(): removeBody(body)
