extends RefCounted

const Vec = preload("res://game/physics/vector.gd")

class Matrix:
	extends RefCounted
	var col1 = Vec.Make(1.0, 0.0)
	var col2 = Vec.Make(0.0, 1.0)

	static func FromAngle(angle):
		var result = Matrix.new()
		result.col1.Set(cos(angle), sin(angle))
		result.col2.Set(-sin(angle), cos(angle))
		return result

class Transform:
	extends RefCounted
	var position
	var R

	func _init(point = null, rotation = null):
		position = point.Copy() if point != null else Vec.Make()
		R = rotation if rotation != null else Matrix.FromAngle(0.0)

class WorldManifold:
	extends RefCounted
	var m_normal = Vec.Make()
	var m_points = [Vec.Make(), Vec.Make()]

static func Dot(a, b):
	return a.x * b.x + a.y * b.y

static func MulMV(matrix, value):
	return Vec.Make(matrix.col1.x * value.x + matrix.col2.x * value.y, matrix.col1.y * value.x + matrix.col2.y * value.y)
