extends RefCounted

var world: WeakRef
var id: int

func _init(owner_world, handle):
	world = weakref(owner_world)
	id = handle

func GetFixtureA():
	var owner_world = world.get_ref()
	return owner_world.fixtures[owner_world.native.read_contact(id).fixtureA]

func GetFixtureB():
	var owner_world = world.get_ref()
	return owner_world.fixtures[owner_world.native.read_contact(id).fixtureB]

func IsTouching():
	return world.get_ref().native.read_contact(id).touching

func SetEnabled(enabled):
	world.get_ref().native.set_contact_enabled(id, enabled)

func GetWorldManifold(manifold):
	var data = world.get_ref().native.read_contact(id)
	manifold.m_normal.Set(data.normal.x, data.normal.y)
	for i in range(data.points.size()): manifold.m_points[i].Set(data.points[i].x, data.points[i].y)
