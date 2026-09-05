extends RefCounted

var x = 0.0
var y = 0.0
var owner: WeakRef
var kind: String

func _init(target = null, property_name = "", initial = Vector2.ZERO):
	if target != null: owner = weakref(target)
	kind = property_name
	x = initial.x
	y = initial.y

func setTo(horizontal = 0, vertical = null):
	x = horizontal
	y = horizontal if vertical == null else vertical
	return self

func original_set(horizontal = 0, vertical = null):
	return setTo(horizontal, vertical)

func value():
	return Vector2(float(x), float(y))
