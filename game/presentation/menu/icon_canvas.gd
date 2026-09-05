extends Control

var texture: Texture2D
var outline_width = 1.0

func _draw():
	if texture == null: return
	var diagonal = sqrt(outline_width * outline_width / 2.0)
	for offset in [Vector2(-outline_width, 0), Vector2(-diagonal, -diagonal), Vector2(-diagonal, diagonal), Vector2(0, outline_width), Vector2(0, -outline_width), Vector2(diagonal, -diagonal), Vector2(diagonal, diagonal), Vector2(outline_width, 0)]:
		draw_texture_rect(texture, Rect2(offset, size), false, Color(0.2, 0.2, 0.2, 1.0))
	draw_texture_rect(texture, Rect2(Vector2.ZERO, size), false)
