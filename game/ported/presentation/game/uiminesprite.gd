# 由原版 UIMineSprite 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIMineSprite: Dictionary = {}
static var _initialized_UIMineSprite = false
static func initialize_original_static():
	if _initialized_UIMineSprite: return
	_initialized_UIMineSprite = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIMineSprite.has(key): return _static_UIMineSprite[key]
	return JS.get_property(JS.module("Phaser.Sprite"), key)
static func original_static_set(key, value):
	_static_UIMineSprite[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1, "activateSound": _arg2, "tripSound": _arg3, "detonateSound": _arg4}
	super._construct_create(_scope0["game"], 0, 0, "game", "mine")
	JS.set_property(self, "activateSound", _scope0["activateSound"])
	JS.set_property(self, "tripSound", _scope0["tripSound"])
	JS.set_property(self, "detonateSound", _scope0["detonateSound"])
	JS.invoke_method(JS.get_property(self, "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.set_property(self, "glow", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Image"), [_scope0["game"], 0, 0, "game", "mineGlow"])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "glow"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(JS.get_property(self, "glow"), "alpha", 0)
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uiminesprite.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4)
	return instance

func original_update():
	var _scope1: Dictionary = {"trap": null, "speedX": null, "speedY": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	_scope1["trap"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTrap", [JS.get_property(self, "trapId")])
	if JS.truthy(_scope1["trap"]):
		JS.set_property(self, "x", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["trap"], "getX", [])]))
		JS.set_property(self, "y", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["trap"], "getY", [])]))
		_scope1["speedX"] = JS.invoke_method(_scope1["trap"], "getSpeedX", [])
		_scope1["speedY"] = JS.invoke_method(_scope1["trap"], "getSpeedY", [])
		if JS.truthy(JS.compare(">", JS.add((JS.number(_scope1["speedX"]) * JS.number(_scope1["speedX"])), (JS.number(_scope1["speedY"]) * JS.number(_scope1["speedY"]))), 0)):
			JS.set_property(self, "rotation", (JS.number(JS.invoke_method("@Math", "atan2", [_scope1["speedY"], _scope1["speedX"]])) - JS.number((JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5)))))
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope2: Dictionary = {"x": _arg0, "y": _arg1, "trapId": _arg2, "playerId": _arg3, "activated": _arg4, "tripped": _arg5, "self": null}
	JS.invoke_method(self, "reset", [_scope2["x"], _scope2["y"]])
	JS.set_property(self, "alpha", 1)
	JS.set_property(JS.get_property(self, "glow"), "alpha", 0)
	JS.set_property(self, "trapId", _scope2["trapId"])
	JS.set_property(self, "playerId", _scope2["playerId"])
	_scope2["self"] = self
	JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
		var _scope3: Dictionary = {"result": _arg0}
		if JS.truthy(JS.equal(JS.type_of(_scope3["result"]), "object", false)):
			JS.set_property(_scope2["self"], "tint", JS.get_property(JS.invoke_method(_scope3["result"], "getTurretColour", []), "numericValue"))
		else:
			JS.set_property(_scope2["self"], "tint", JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_UNAVAILABLE_COLOUR"), "numericValue"))
		return null, func(_arg0 = null):
		var _scope4: Dictionary = {"result": _arg0}
		return null, func(_arg0 = null):
		var _scope5: Dictionary = {"result": _arg0}
		return null, JS.get_property(self, "playerId"), JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
	if JS.truthy(_scope2["tripped"]):
		JS.set_property(self, "glowTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "glow")]), "to", [{"alpha": 1}, 100, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Cubic"), "InOut"), true, 0, -(1), true]))
	else:
		if JS.truthy(_scope2["activated"]):
			JS.set_property(self, "alpha", 0)
	return null

func original_activate():
	var _scope6: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "activateSound"), "play", [])
	JS.set_property(self, "fadeTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"alpha": 0}, 500, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true, 1000]))
	JS.set_property(self, "glowTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "glow")]), "to", [{"alpha": 1}, 200, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Cubic"), "InOut"), true, 0, -(1), true]))
	return null

func original_trip():
	var _scope7: Dictionary = {}
	if JS.truthy(JS.get_property(self, "glowTween")):
		JS.invoke_method(JS.get_property(self, "glowTween"), "stop", [])
	if JS.truthy(JS.get_property(self, "fadeTween")):
		JS.invoke_method(JS.get_property(self, "fadeTween"), "stop", [])
	JS.invoke_method(JS.get_property(self, "activateSound"), "stop", [])
	JS.invoke_method(JS.get_property(self, "tripSound"), "play", [])
	JS.set_property(self, "fadeTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"alpha": 1}, 100, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]))
	JS.set_property(JS.get_property(self, "glow"), "alpha", 0)
	JS.set_property(self, "glowTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "glow")]), "to", [{"alpha": 1}, 100, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Cubic"), "InOut"), true, 0, -(1), true]))
	return null

func original_detonate():
	var _scope8: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "detonateSound"), "play", [])
	return null

func original_remove():
	var _scope9: Dictionary = {}
	if JS.truthy(JS.get_property(self, "glowTween")):
		JS.invoke_method(JS.get_property(self, "glowTween"), "stop", [])
	if JS.truthy(JS.get_property(self, "fadeTween")):
		JS.invoke_method(JS.get_property(self, "fadeTween"), "stop", [])
	JS.invoke_method(JS.get_property(self, "detonateSound"), "stop", [])
	JS.invoke_method(self, "kill", [])
	return null

func original_retire():
	var _scope10: Dictionary = {}
	if JS.truthy(JS.get_property(self, "glowTween")):
		JS.invoke_method(JS.get_property(self, "glowTween"), "stop", [])
	if JS.truthy(JS.get_property(self, "fadeTween")):
		JS.invoke_method(JS.get_property(self, "fadeTween"), "stop", [])
	JS.invoke_method(self, "kill", [])
	return null
