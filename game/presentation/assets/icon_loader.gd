extends RefCounted

static func original_loadPlayerTankIcon(canvas, size, id, ready, context):
	var js = preload("res://game/runtime/js_support.gd")
	var profile = js.module("Backend").profiles[id]
	var width = {"small": 140, "medium": 200, "large": 320}[size]
	var resolution = 2 if canvas.texture.get_width() > width else 1
	js.invoke(ready, [context])
	canvas.texture.update(preload("res://game/presentation/assets/tank_icon.gd").texture(profile, width, resolution).get_image())
