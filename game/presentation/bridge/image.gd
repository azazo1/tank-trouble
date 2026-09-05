extends "res://game/presentation/bridge/display_object.gd"

var sprite = Sprite2D.new()

func initialize(host, horizontal, vertical, texture):
	game = host
	x = horizontal
	y = vertical
	sprite.texture = texture
	sprite.centered = false
	intrinsic_size = texture.get_size()
	view.add_child(sprite)
	return self

func sync_view():
	super.sync_view()
	sprite.position = -anchor.value() * intrinsic_size
