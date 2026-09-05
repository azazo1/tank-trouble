# 由原版 UIWeaponIconImage 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIWeaponIconImage: Dictionary = {}
static var _initialized_UIWeaponIconImage = false
static func initialize_original_static():
	if _initialized_UIWeaponIconImage: return
	_initialized_UIWeaponIconImage = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIWeaponIconImage.has(key): return _static_UIWeaponIconImage[key]
	return JS.get_property(JS.module("Phaser.Image"), key)
static func original_static_set(key, value):
	_static_UIWeaponIconImage[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0}
	super._construct_create(_scope0["game"], 0, 0, "game", "crate0-0")
	JS.invoke_method(JS.get_property(self, "anchor"), "set", [0.5, 0.5])
	JS.set_property(self, "alpha", 0.7)
	JS.set_property(self, "removeTween", null)
	JS.set_property(self, "theme", 0)
	JS.set_property(self, "contentFrame", 0)
	JS.invoke_method(self, "kill", [])
	JS.invoke_method(JS.get_property(self, "scale"), "set", [0, 0])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UIWeaponIconImage"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uiweaponiconimage.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_setTheme(_arg0 = null):
	var _scope1: Dictionary = {"theme": _arg0}
	JS.set_property(self, "theme", _scope1["theme"])
	JS.set_property(self, "frameName", JS.add(JS.add(JS.add("crate", JS.get_property(self, "theme")), "-"), JS.get_property(self, "contentFrame")))
	return null

func original_update():
	var _scope2: Dictionary = {}
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope3: Dictionary = {"x": _arg0, "y": _arg1, "scale": _arg2, "contentFrame": _arg3}
	JS.set_property(self, "contentFrame", _scope3["contentFrame"])
	JS.invoke_method(self, "reset", [_scope3["x"], _scope3["y"]])
	JS.set_property(self, "frameName", JS.add(JS.add(JS.add("crate", JS.get_property(self, "theme")), "-"), JS.get_property(self, "contentFrame")))
	if JS.truthy(JS.get_property(self, "removeTween")):
		JS.invoke_method(JS.get_property(self, "removeTween"), "stop", [])
	JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": _scope3["scale"], "y": _scope3["scale"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true])
	return null

func original_refresh(_arg0 = null, _arg1 = null):
	var _scope4: Dictionary = {"x": _arg0, "scale": _arg1}
	JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"x": _scope4["x"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": _scope4["scale"], "y": _scope4["scale"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	return null

func original_remove():
	var _scope5: Dictionary = {}
	JS.set_property(self, "removeTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 0, "y": 0}, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "removeTween"), "onComplete"), "add", [func():
		var _scope6: Dictionary = {}
		JS.invoke_method(JS.callback_receiver(self), "kill", [])
		return null, self])
	return null

func original_retire():
	var _scope7: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
