extends RefCounted

var changed: Callable
var x: float:
	set(value):
		x = value
		if changed.is_valid(): changed.call(x, y)
var y: float:
	set(value):
		y = value
		if changed.is_valid(): changed.call(x, y)

func _init(px = 0.0, py = 0.0):
	x = px
	y = py

static func Make(px = 0.0, py = 0.0):
	return load("res://game/physics/vector.gd").new(px, py)

func Set(px, py):
	x = px
	y = py

func SetV(value):
	x = value.x
	y = value.y

func SetZero():
	x = 0.0
	y = 0.0

func Copy():
	return Make(x, y)

func Add(value):
	x += value.x
	y += value.y

func Subtract(value):
	x -= value.x
	y -= value.y

func Multiply(value):
	x *= value
	y *= value

func LengthSquared():
	return x * x + y * y

func Length():
	return sqrt(x * x + y * y)

func Normalize():
	var length = Length()
	if length < pow(2.0, -1074): return 0.0
	var inverse = 1.0 / length
	x *= inverse
	y *= inverse
	return length

func to_data():
	return {"x": x, "y": y}
