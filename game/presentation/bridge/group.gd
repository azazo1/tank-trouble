extends "res://game/presentation/bridge/display_object.gd"

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

func callAll(method, _context = null, argument = null):
	for child in children: JS.invoke_method(child, method, [argument])

func removeAll(destroy = false):
	for child in children.duplicate():
		removeChild(child)
		if destroy: child.original_destroy()
