extends "res://game/presentation/bridge/display_object.gd"

class Drawing extends Node2D:
	var segments: Array = []
	func _draw():
		for segment in segments: draw_polyline(segment.points, segment.color, segment.width, true)

var drawing = Drawing.new()
var pen = Vector2.ZERO
var line_width = 0.0
var line_color = Color.WHITE

func _construct_create(host = null, horizontal = 0, vertical = 0, _d = null, _e = null, _f = null, _g = null, _h = null, _i = null, _j = null, _k = null, _l = null, _m = null, _n = null, _o = null, _p = null, _q = null, _r = null, _s = null, _t = null, _u = null, _v = null, _w = null, _z = null):
	game = host
	x = horizontal
	y = vertical
	view.add_child(drawing)

func clear():
	drawing.segments.clear()
	drawing.queue_redraw()
	return self

func lineStyle(size, color, opacity = 1.0):
	line_width = size
	line_color = Color.hex((int(color) << 8) | 0xff)
	line_color.a = opacity
	return self

func moveTo(horizontal, vertical):
	pen = Vector2(horizontal, vertical)
	return self

func lineTo(horizontal, vertical):
	var point = Vector2(horizontal, vertical)
	drawing.segments.append({"points": PackedVector2Array([pen, point]), "color": line_color, "width": line_width})
	pen = point
	drawing.queue_redraw()
	return self
