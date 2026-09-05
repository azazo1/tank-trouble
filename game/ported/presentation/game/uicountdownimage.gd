# 由原版 UICountDownImage 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UICountDownImage: Dictionary = {}
static var _initialized_UICountDownImage = false
static func initialize_original_static():
	if _initialized_UICountDownImage: return
	_initialized_UICountDownImage = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UICountDownImage.has(key): return _static_UICountDownImage[key]
	return JS.get_property(JS.module("Phaser.Image"), key)
static func original_static_set(key, value):
	_static_UICountDownImage[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0}
	super._construct_create(_scope0["game"], 0, 0, "game", "countdown0")
	JS.invoke_method(JS.get_property(self, "anchor"), "set", [0.5, 0.5])
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uicountdownimage.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	return null

func original_spawn(_arg0 = null):
	var _scope2: Dictionary = {"countDownValue": _arg0}
	JS.invoke_method(self, "revive", [])
	JS.set_property(self, "frameName", JS.add("countdown", _scope2["countDownValue"]))
	JS.set_property(self, "alpha", 1)
	JS.invoke_method(JS.get_property(self, "scale"), "set", [0, 0])
	if JS.truthy(JS.compare(">", _scope2["countDownValue"], 0)):
		JS.set_property(self, "removeEvent", JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "add", [JS.get_property(JS.module("UIConstants"), "COUNT_DOWN_DISPLAY_TIME"), JS.get_property(self, "remove"), self]))
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 1, "y": 1}, 300, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true])
	else:
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 2, "y": 2}, 500, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Cubic"), "Out"), true])
		JS.invoke_method(JS.get_property(JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"alpha": 0}, 100, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true, 400]), "onComplete"), "add", [func():
			var _scope3: Dictionary = {}
			JS.invoke_method(JS.callback_receiver(self), "kill", [])
			return null, self])
	return null

func original_remove():
	var _scope4: Dictionary = {}
	JS.set_property(self, "removeEvent", null)
	JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"alpha": 0}, 100, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true])
	JS.invoke_method(JS.get_property(JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 1.5, "y": 1.5}, 100, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]), "onComplete"), "add", [func():
		var _scope5: Dictionary = {}
		JS.invoke_method(JS.callback_receiver(self), "kill", [])
		return null, self])
	return null

func original_retire():
	var _scope6: Dictionary = {}
	if JS.truthy(JS.get_property(self, "removeEvent")):
		JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "remove", [JS.get_property(self, "removeEvent")])
	JS.invoke_method(self, "kill", [])
	return null
