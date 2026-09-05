extends "res://game/presentation/bridge/display_object.gd"

var sprite = Sprite2D.new()
var key
var body
var animations
var outlines: Array = []
var tint = 0xffffff
var frameName:
	get: return fields.get("frameName", "")
	set(value):
		fields["frameName"] = value
		if key != null: _set_texture(game.assets.texture(key, value))

func _construct_create(host = null, horizontal = null, vertical = null, texture_key = null, frame = null, _f = null, _g = null, _h = null, _i = null, _j = null, _k = null, _l = null, _m = null, _n = null, _o = null, _p = null, _q = null, _r = null, _s = null, _t = null, _u = null, _v = null, _w = null, _x = null):
	key = texture_key
	fields["frameName"] = frame
	initialize(host, horizontal, vertical, host.assets.texture(key, frame))
	return null

static func create(host, horizontal, vertical, texture_key, frame = null):
	var instance = load("res://game/presentation/bridge/image.gd").new()
	instance._construct_create(host, horizontal, vertical, texture_key, frame)
	return instance

func initialize(host, horizontal, vertical, texture):
	game = host
	x = horizontal
	y = vertical
	sprite.centered = false
	_set_texture(texture)
	animations = preload("res://game/presentation/animation/frame_animation.gd").new(self)
	if key is Object:
		var width = JS.get_property(JS.module("UIConstants"), "TANK_ICON_OUTLINE_WIDTH")
		var diagonal = sqrt(width * width / 2.0)
		for offset in [Vector2(-width, 0), Vector2(-diagonal, -diagonal), Vector2(-diagonal, diagonal), Vector2(0, width), Vector2(0, -width), Vector2(diagonal, -diagonal), Vector2(diagonal, diagonal), Vector2(width, 0)]:
			var outline = Sprite2D.new()
			outline.centered = false
			outline.texture = texture
			outline.self_modulate = Color(0.2, 0.2, 0.2, 1)
			outlines.append({"sprite": outline, "offset": offset})
			view.add_child(outline)
	view.add_child(sprite)
	return self

func _set_texture(texture):
	sprite.texture = texture
	intrinsic_size = texture.get_size()

func _exists_changed(value):
	# Phaser.Component.Core.exists 同步可见性和 P2 物理体的世界登记.
	visible = value
	if body != null:
		if value: body.addToWorld()
		else: body.removeFromWorld()

func getLocalBounds():
	return {"x": -anchor.x * intrinsic_size.x, "y": -anchor.y * intrinsic_size.y, "width": intrinsic_size.x, "height": intrinsic_size.y}

func sync_view():
	super.sync_view()
	sprite.position = -anchor.value() * intrinsic_size
	for outline in outlines: outline.sprite.position = sprite.position + outline.offset
	sprite.self_modulate = Color.hex((int(tint) << 8) | 0xff)

func original_reset(horizontal, vertical, _health = null):
	x = horizontal
	y = vertical
	original_revive()
	if body != null:
		body.reset(x, y)
	return self

func pre_update(milliseconds):
	if exists: animations.advance(milliseconds)
	super.pre_update(milliseconds)

func original_destroy(destroy_children = null):
	if body != null: body.removeFromWorld()
	body = null
	if animations != null: animations.clear()
	return super.original_destroy(destroy_children)
