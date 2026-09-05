extends RefCounted

const Vec = preload("res://game/physics/vector.gd")
var world: WeakRef
var id: int

func _init(owner_world, handle):
	world = weakref(owner_world)
	id = handle

func GetPosition():
	var state = world.get_ref().native.read_body(id)
	return Vec.Make(state.x, state.y)

func GetAngle():
	return world.get_ref().native.read_body(id).angle

func GetLinearVelocity():
	var state = world.get_ref().native.read_body(id)
	return Vec.Make(state.vx, state.vy)

func GetAngularVelocity():
	return world.get_ref().native.read_body(id).angularVelocity

func GetLocalPoint(point):
	var result = world.get_ref().native.local_point(id, point.x, point.y)
	return Vec.Make(result.x, result.y)

func SetPosition(point):
	world.get_ref().native.set_transform(id, point.x, point.y, GetAngle())

func SetPositionAndAngle(point, angle):
	world.get_ref().native.set_transform(id, point.x, point.y, angle)

func SetLinearVelocity(value):
	world.get_ref().native.set_velocity(id, value.x, value.y)

func SetAngularVelocity(value):
	world.get_ref().native.set_angular_velocity(id, value)

func CreateFixture(definition):
	return world.get_ref().create_fixture(self, definition)

func DestroyFixture(fixture):
	world.get_ref().destroy_fixture(self, fixture)

func GetFixtureList():
	var owner_world = world.get_ref()
	var ids = owner_world.native.read_body(id).fixtures
	return owner_world.fixtures[ids[0]] if ids.size() else null
