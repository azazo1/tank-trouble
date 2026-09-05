extends RefCounted

var texture: ImageTexture
var canvas:
	get: return self

func _init(width, height):
	texture = ImageTexture.create_from_image(Image.create_empty(int(width), int(height), false, Image.FORMAT_RGBA8))

func clear():
	texture.update(Image.create_empty(texture.get_width(), texture.get_height(), false, Image.FORMAT_RGBA8))
