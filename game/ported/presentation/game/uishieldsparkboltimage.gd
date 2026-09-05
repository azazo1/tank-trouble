# 由原版 UIShieldSparkBoltImage 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIShieldSparkBoltImage: Dictionary = {}
static var _initialized_UIShieldSparkBoltImage = false
static func initialize_original_static():
	if _initialized_UIShieldSparkBoltImage: return
	_initialized_UIShieldSparkBoltImage = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIShieldSparkBoltImage.has(key): return _static_UIShieldSparkBoltImage[key]
	return JS.get_property(JS.module("Phaser.Image"), key)
static func original_static_set(key, value):
	_static_UIShieldSparkBoltImage[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "randomBoltIndex": null}
	_scope0["randomBoltIndex"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(3))])
	super._construct_create(_scope0["game"], 0, 0, "game", JS.add("shieldSparkBolt", _scope0["randomBoltIndex"]))
	JS.invoke_method(JS.get_property(self, "anchor"), "setTo", [0.5, 0.84])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uishieldsparkboltimage.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	if JS.truthy(JS.logical("||", func():
		var _scope2: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope3: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return null
	JS.set_property(self, "alpha", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "alpha")) - JS.number(0.035))]))
	if JS.truthy(JS.equal(JS.get_property(self, "alpha"), 0, false)):
		JS.invoke_method(self, "kill", [])
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope4: Dictionary = {"x": _arg0, "y": _arg1, "rotation": _arg2}
	JS.invoke_method(self, "reset", [_scope4["x"], _scope4["y"]])
	JS.set_property(self, "alpha", 1)
	JS.set_property(self, "rotation", JS.add(_scope4["rotation"], (JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5))))
	return null

func original_retire():
	var _scope5: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
