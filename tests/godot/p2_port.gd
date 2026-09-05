extends SceneTree

var engine
var contacts: Array = []
var current_frame = 0
var dynamic_body

func _initialize():
	call_deferred("_run")

func _contact(event, kind):
	contacts.append({"frame": current_frame, "kind": kind, "bodyA": read(event, "bodyA") == dynamic_body, "bodyB": read(event, "bodyB") == dynamic_body})

func read(object, key):
	return engine.read_property(object["$p2"], key)

func invoke(object, method, args = []):
	return engine.invoke_object(object["$p2"], method, args)

func _run():
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	for name in ["free-fragment", "floor-fragment", "kinematic-tank"]:
		var expected = JSON.parse_string(FileAccess.get_file_as_string("res://.tmp/p2-%s.expected.json" % name))
		var scenario = expected.scenario
		engine = ClassDB.instantiate("TTOriginalP2")
		assert(engine.initialize())
		var world = engine.create_object("World", [{"gravity": scenario.gravity}])
		var material_a = engine.create_object("Material", [])
		var material_b = engine.create_object("Material", [])
		var contact = engine.create_object("ContactMaterial", [material_a, material_b, {"restitution": 0.35, "friction": 1, "relaxation": 10}])
		invoke(world, "addContactMaterial", [contact])
		dynamic_body = engine.create_object("Body", [scenario])
		var shape = engine.create_object("Box", [{"width": 0.4, "height": 0.3, "material": material_a, "collisionGroup": 2, "collisionMask": 1}])
		invoke(dynamic_body, "addShape", [shape])
		invoke(world, "addBody", [dynamic_body])
		if scenario.floor:
			var floor_body = engine.create_object("Body", [{"mass": 0}])
			var plane = engine.create_object("Plane", [{"material": material_b, "collisionGroup": 1, "collisionMask": 2}])
			invoke(floor_body, "addShape", [plane])
			invoke(world, "addBody", [floor_body])
		contacts = []
		for kind in ["beginContact", "endContact"]: invoke(world, "on", [kind, _contact.bind(kind)])
		var frames: Array = []
		for frame in range(expected.frames.size()):
			current_frame = frame
			invoke(world, "step", [1.0 / 60.0])
			var state = {}
			for key in ["position", "velocity", "angle", "angularVelocity"]: state[key] = read(dynamic_body, key)
			frames.append(state)
			engine.collect()
		var output = FileAccess.open("res://.tmp/p2-%s.actual.json" % name, FileAccess.WRITE)
		output.store_string(JSON.stringify({"frames": frames, "contacts": contacts}, "", false, true))
		engine = null
	quit(0)
