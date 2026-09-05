extends RefCounted

const Vec = preload("res://game/physics/vector.gd")

class Polygon:
	extends RefCounted
	var vertices: Array = []

	static func AsArray(points, count = 0):
		var result = Polygon.new()
		for i in range(points.size() if count == 0 else int(count)):
			result.vertices.append(points[i].Copy())
		return result

	static func AsBox(hx, hy):
		return AsArray([Vec.Make(-hx, -hy), Vec.Make(hx, -hy), Vec.Make(hx, hy), Vec.Make(-hx, hy)])

	func GetVertices():
		return vertices

	func GetVertexCount():
		return vertices.size()

	func to_data():
		return {"kind": "polygon", "vertices": vertices.map(func(p): return p.to_data())}

class Circle:
	extends RefCounted
	var m_radius: float
	var m_p = Vec.Make()

	func _init(radius = 0.0):
		m_radius = radius

	func GetRadius():
		return m_radius

	func to_data():
		return {"kind": "circle", "radius": m_radius, "x": m_p.x, "y": m_p.y}
