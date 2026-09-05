extends RefCounted

var world: WeakRef
var id: int
var shape
var user_data
var body_id: int

func _init(owner_world, handle, owner_body, definition):
	world = weakref(owner_world)
	id = handle
	body_id = owner_body.id
	shape = definition.shape
	user_data = definition.userData

func GetNext():
	var owner_world = world.get_ref()
	return owner_world.fixtures.get(owner_world.native.read_fixture(id).next)

func GetBody():
	return world.get_ref().bodies[body_id]

func GetShape():
	return shape

func GetFilterData():
	return world.get_ref().native.read_fixture(id)

func GetUserData():
	return user_data
