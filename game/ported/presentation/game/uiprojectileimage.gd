# 由原版 UIProjectileImage 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIProjectileImage: Dictionary = {}
static var _initialized_UIProjectileImage = false
static func initialize_original_static():
	if _initialized_UIProjectileImage: return
	_initialized_UIProjectileImage = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIProjectileImage.has(key): return _static_UIProjectileImage[key]
	return JS.get_property(JS.module("Phaser.Image"), key)
static func original_static_set(key, value):
	_static_UIProjectileImage[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1}
	super._construct_create(_scope0["game"], 0, 0, "game", "")
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.invoke_method(JS.get_property(self, "anchor"), "setTo", [0.5, 0.5])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uiprojectileimage.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_update():
	var _scope1: Dictionary = {"projectile": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	_scope1["projectile"] = JS.invoke_method(JS.get_property(self, "gameController"), "getProjectile", [JS.get_property(self, "projectileId")])
	if JS.truthy(_scope1["projectile"]):
		JS.set_property(self, "x", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["projectile"], "getX", [])]))
		JS.set_property(self, "y", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["projectile"], "getY", [])]))
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope2: Dictionary = {"x": _arg0, "y": _arg1, "projectileId": _arg2, "frameName": _arg3}
	JS.set_property(self, "frameName", _scope2["frameName"])
	JS.invoke_method(self, "reset", [_scope2["x"], _scope2["y"]])
	JS.set_property(self, "projectileId", _scope2["projectileId"])
	return null

func original_remove():
	var _scope3: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null

func original_retire():
	var _scope4: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
