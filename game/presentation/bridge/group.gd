extends "res://game/presentation/bridge/display_object.gd"

func _construct_create(host = null, parent = null, _c = null, _d = null, _e = null, _f = null, _g = null, _h = null, _i = null, _j = null, _k = null, _l = null, _m = null, _n = null, _o = null, _p = null):
	game = host
	if parent != null: parent.addChild(self)
	return null

static func create(host = null, parent = null):
	var instance = load("res://game/presentation/bridge/group.gd").new()
	instance._construct_create(host, parent)
	return instance
