extends SceneTree

const World = preload("res://game/physics/world.gd")
const Definitions = preload("res://game/physics/definitions.gd")
const Shapes = preload("res://game/physics/shapes.gd")
var frame: int
var events: Array = []

func _initialize():
	call_deferred("_run")

func _run():
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	for scenario in ["free-flight", "wall-bounce", "corner-bounce", "near-wall-fire", "shield-bounce", "tank-wall", "tank-pair", "damping"]:
		var data = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/physics-%s.json" % scenario))
		var world = World.new()
		var bodies: Array = []
		for item in data.bodies:
			var definition = Definitions.body_definition()
			for key in item:
				if definition.has(key): definition[key] = item[key]
			definition.position.Set(item.x, item.y)
			definition.linearVelocity.Set(item.get("vx", 0.0), item.get("vy", 0.0))
			var body = world.CreateBody(definition)
			bodies.append(body)
			for fixture_data in item.fixtures:
				var fixture = Definitions.fixture_definition()
				fixture.merge(fixture_data, true)
				var shape = fixture_data.shape
				fixture.shape = Shapes.Circle.new(shape.radius) if shape.kind == "circle" else Shapes.Polygon.AsBox(shape.hx, shape.hy)
				body.CreateFixture(fixture)
		world.SetContactListener(self)
		events = []
		var frames: Array = []
		for i in range(data.deltas.size()):
			frame = i
			world.Step(data.deltas[i], 10, 10)
			var states: Array = []
			for body in bodies:
				var state = world.native.read_body(body.id)
				state.erase("fixtures")
				states.append(state)
			frames.append(states)
		var output = FileAccess.open("res://.tmp/physics-%s.actual.json" % scenario, FileAccess.WRITE)
		output.store_string(JSON.stringify({"frames": frames, "events": events}, "", false, true))
	quit(0)

func _record(kind, contact):
	events.append({"frame": frame, "kind": kind, "a": contact.GetFixtureA().id, "b": contact.GetFixtureB().id})

func BeginContact(contact):
	_record("BeginContact", contact)

func EndContact(contact):
	_record("EndContact", contact)

func PreSolve(contact, _manifold):
	_record("PreSolve", contact)

func PostSolve(contact, _impulse):
	_record("PostSolve", contact)
