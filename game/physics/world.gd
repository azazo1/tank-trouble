extends RefCounted

const JS = preload("res://game/runtime/js_support.gd")
const Vec = preload("res://game/physics/vector.gd")
const Body = preload("res://game/physics/body.gd")
const Fixture = preload("res://game/physics/fixture.gd")
const Contact = preload("res://game/physics/contact.gd")

var native
var bodies: Dictionary = {}
var fixtures: Dictionary = {}
var listener: WeakRef

func _init(gravity = null, allow_sleep = true):
	assert(ClassDB.class_exists("TTLegacyWorld"), "原生物理扩展未加载")
	native = ClassDB.instantiate("TTLegacyWorld")
	native.configure(gravity.x if gravity else 0.0, gravity.y if gravity else 0.0, allow_sleep)

func CreateBody(definition):
	var data = definition.duplicate()
	data.x = definition.position.x
	data.y = definition.position.y
	data.vx = definition.linearVelocity.x
	data.vy = definition.linearVelocity.y
	var body = Body.new(self, native.create_body(data))
	bodies[body.id] = body
	return body

func DestroyBody(body):
	var ids = native.read_body(body.id).fixtures
	native.destroy_body(body.id, _contact_event)
	for fixture in ids: fixtures.erase(fixture)
	bodies.erase(body.id)

func create_fixture(body, definition):
	var data = definition.duplicate()
	data.shape = definition.shape.to_data()
	data.merge(definition.filter)
	var fixture = Fixture.new(self, native.create_fixture(body.id, data), body, definition)
	fixtures[fixture.id] = fixture
	return fixture

func destroy_fixture(body, fixture):
	native.destroy_fixture(body.id, fixture.id, _contact_event)
	fixtures.erase(fixture.id)

func SetContactListener(value):
	listener = weakref(value) if value != null else null

func Step(delta, velocity_iterations, position_iterations):
	native.step(delta, velocity_iterations, position_iterations, _contact_event)

func RayCast(callback, start, end):
	native.ray_cast(func(id, point, normal, fraction):
		return JS.invoke(callback, [fixtures[id], Vec.Make(point.x, point.y), Vec.Make(normal.x, normal.y), fraction]), start.x, start.y, end.x, end.y)

func QueryShape(callback, shape, transform = null):
	native.query_shape(func(id): return JS.invoke(callback, [fixtures[id]]), shape.to_data(), transform.position.x if transform else 0.0, transform.position.y if transform else 0.0, atan2(transform.R.col1.y, transform.R.col1.x) if transform else 0.0)

func _contact_event(kind, id, extra):
	if listener == null: return
	var target = listener.get_ref()
	if target == null: return
	var callback = JS.get_property(target, kind)
	if callback != null: JS.invoke(callback, [Contact.new(self, id), extra])
