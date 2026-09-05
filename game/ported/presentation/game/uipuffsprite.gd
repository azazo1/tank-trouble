# 由原版 UIPuffSprite 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIPuffSprite: Dictionary = {}
static var _initialized_UIPuffSprite = false
static func initialize_original_static():
	if _initialized_UIPuffSprite: return
	_initialized_UIPuffSprite = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIPuffSprite.has(key): return _static_UIPuffSprite[key]
	return JS.get_property(JS.module("Phaser.Sprite"), key)
static func original_static_set(key, value):
	_static_UIPuffSprite[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "randomPuffIndex": null}
	_scope0["randomPuffIndex"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(3))])
	super._construct_create(_scope0["game"], 0, 0, "game", JS.add("puff", _scope0["randomPuffIndex"]))
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uipuffsprite.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope1: Dictionary = {"x": _arg0, "y": _arg1, "speedX": _arg2, "speedY": _arg3}
	JS.invoke_method(self, "reset", [_scope1["x"], _scope1["y"]])
	JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "enable", [self])
	JS.set_property(JS.get_property(self, "body"), "allowSleep", false)
	JS.set_property(JS.get_property(self, "body"), "dynamic", true)
	JS.set_property(JS.get_property(self, "body"), "fixedRotation", true)
	JS.set_property(JS.get_property(self, "body"), "damping", 0.1)
	JS.set_property(self, "alpha", JS.add(0.2, (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(0.3) - JS.number(0.2))))))
	JS.invoke_method(JS.get_property(self, "scale"), "set", [(JS.number(JS.add(0.5, JS.invoke_method("@Math", "random", []))) * JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")))])
	JS.invoke_method(JS.get_property(self, "body"), "setRectangle", [JS.get_property(self, "width"), JS.get_property(self, "height")])
	JS.invoke_method(JS.get_property(self, "body"), "setMaterial", [JS.get_property(JS.module("UIUtils"), "puffMaterial")])
	JS.invoke_method(JS.get_property(self, "body"), "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "puffCollisionGroup")])
	JS.invoke_method(JS.get_property(self, "body"), "collides", [JS.get_property(JS.module("UIUtils"), "wallCollisionGroup")])
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "x", (JS.number(JS.add(_scope1["speedX"], (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(250)))) - JS.number(125)))
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "y", (JS.number(JS.add(_scope1["speedY"], (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(250)))) - JS.number(125)))
	return null

func original_update():
	var _scope2: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	if JS.truthy(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")):
		return null
	super.original_update()
	JS.set_property(self, "alpha", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "alpha")) - JS.number((JS.number(0.03) - JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(0.0083))))))]))
	JS.invoke_method(JS.get_property(self, "scale"), "set", [JS.add(JS.get_property(JS.get_property(self, "scale"), "x"), 0.0415), JS.add(JS.get_property(JS.get_property(self, "scale"), "y"), 0.0415)])
	if JS.truthy(JS.equal(JS.get_property(self, "alpha"), 0, false)):
		JS.invoke_method(self, "kill", [])
	return null

func original_retire():
	var _scope3: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
