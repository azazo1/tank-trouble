extends "res://game/presentation/bridge/display_object.gd"

class TextCanvas extends Node2D:
	var contents = ""
	var font: Font
	var font_size = 28
	var color = Color.WHITE
	func _draw():
		draw_string(font, Vector2(0, font.get_ascent(font_size)), contents, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)

var label = TextCanvas.new()
var text = ""

static func create(host, horizontal, vertical, contents, style):
	var instance = load("res://game/presentation/bridge/text.gd").new()
	instance.game = host
	instance.x = horizontal
	instance.y = vertical
	instance.label.font = host.assets.font
	instance.label.font_size = int(float(str(style.font).split("px")[0]))
	instance.label.color = Color(style.get("fill", "#ffffff"))
	instance.view.add_child(instance.label)
	instance.setText(contents)
	return instance

func setText(contents):
	text = str(contents)
	label.contents = text
	intrinsic_size = label.font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, label.font_size)
	label.queue_redraw()
	return self

func sync_view():
	super.sync_view()
	label.position = -anchor.value() * intrinsic_size
