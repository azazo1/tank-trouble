extends Node2D

var geometry: Array = []
var textures: Dictionary = {}

func _draw():
	for item in geometry:
		var tint = Color(item.color[0], item.color[1], item.color[2], item.color[3])
		if tint.a <= 0.0: continue
		for offset in range(0, item.triangles.size(), 3):
			var vertices = PackedVector2Array()
			var uvs = PackedVector2Array()
			for corner in range(3):
				var index = int(item.triangles[offset + corner]) * 2
				vertices.append(Vector2(item.vertices[index], -item.vertices[index + 1]))
				uvs.append(Vector2(item.uvs[index], item.uvs[index + 1]))
			draw_colored_polygon(vertices, tint, uvs, textures[item.texture])
