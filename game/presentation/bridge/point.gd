extends RefCounted

var x = 0.0
var y = 0.0
var owner: WeakRef
var kind: String

static func create(horizontal = 0.0, vertical = 0.0):
	return load("res://game/presentation/bridge/point.gd").new(null, "", Vector2(horizontal, vertical))

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

func getMagnitude():
	return sqrt(x * x + y * y)

func copyFrom(point):
	return setTo(point.x, point.y)

func dot(point):
	return x * point.x + y * point.y

func normalize():
	var magnitude = getMagnitude()
	if magnitude > 0: setTo(x / magnitude, y / magnitude)
	return self

static func subtract(first, second):
	return create(first.x - second.x, first.y - second.y)
