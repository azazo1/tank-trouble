extends "res://game/presentation/bridge/display_object.gd"

var cursor_index = 0
var length:
	get: return children.size()

func _construct_create(host = null, parent = null, _c = null, _d = null, _e = null, _f = null, _g = null, _h = null, _i = null, _j = null, _k = null, _l = null, _m = null, _n = null, _o = null, _p = null, _q = null, _r = null, _s = null, _t = null, _u = null, _v = null, _w = null, _x = null):
	game = host
	if parent != null: parent.addChild(self)
	return null

static func create(host = null, parent = null):
	var instance = load("res://game/presentation/bridge/group.gd").new()
	instance._construct_create(host, parent)
	return instance

func original_create(horizontal = 0, vertical = 0, key = null, frame = null):
	return addChild(preload("res://game/presentation/bridge/image.gd").create(game, horizontal, vertical, key, frame))

func getFirstExists(value):
	for child in children:
		if child.exists == value: return child
	return null

func next():
	cursor_index = (cursor_index + 1) % children.size()
	return children[cursor_index]

func countLiving():
	return children.filter(func(child): return child.alive).size()

func forEach(callback, context = null):
	for child in children: JS.invoke_context(callback, context, [child])

func setAll(property, value):
	for child in children.duplicate():
		if property == "pendingDestroy" and value:
			removeChild(child)
			child.original_destroy()
		else: JS.set_property(child, property, value)

func setBounds(horizontal, vertical, _width, _height):
	view.position = Vector2(-horizontal, -vertical)

func callAll(method, _context = null, argument = null):
	for child in children: JS.invoke_method(child, method, [argument])

func removeAll(destroy = false):
	for child in children.duplicate():
		removeChild(child)
		if destroy: child.original_destroy()
