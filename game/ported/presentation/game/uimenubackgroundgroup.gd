# 由原版 UIMenuBackgroundGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UIMenuBackgroundGroup: Dictionary = {}
static var _initialized_UIMenuBackgroundGroup = false
static func initialize_original_static():
	if _initialized_UIMenuBackgroundGroup: return
	_initialized_UIMenuBackgroundGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIMenuBackgroundGroup.has(key): return _static_UIMenuBackgroundGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIMenuBackgroundGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "x": _arg1, "y": _arg2}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "x", _scope0["x"])
	JS.set_property(self, "y", _scope0["y"])
	JS.set_property(self, "backgroundImage", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "image", [0, 0, "menuBackground", 0, self]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "backgroundImage"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "laikaSpine", JS.invoke_method(self, "addChild", [JS.construct(JS.module("UILaikaSpine"), [JS.get_property(self, "game"), JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_X"), JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_Y")])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "laikaSpine"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "dimitriSpine", JS.invoke_method(self, "addChild", [JS.construct(JS.module("UIDimitriSpine"), [JS.get_property(self, "game"), JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_X"), JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_Y")])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "dimitriSpine"), "anchor"), "setTo", [0.5, 0.5])
	JS.invoke_method(JS.get_property(self, "laikaSpine"), "idle", [])
	JS.invoke_method(JS.get_property(self, "dimitriSpine"), "idle", [])
	JS.set_property(self, "laikaEventDelay", JS.add(JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_MIN_EVENT_DELAY"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_MAX_EVENT_DELAY")) - JS.number(JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_MIN_EVENT_DELAY")))))))
	JS.set_property(self, "dimitriEventDelay", JS.add(JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_MIN_EVENT_DELAY"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_MAX_EVENT_DELAY")) - JS.number(JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_MIN_EVENT_DELAY")))))))
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UIMenuBackgroundGroup"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uimenubackgroundgroup.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_update()
	JS.set_property(self, "laikaEventDelay", (JS.number(JS.get_property(self, "laikaEventDelay")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000)))))
	if JS.truthy(JS.compare("<", JS.get_property(self, "laikaEventDelay"), 0)):
		JS.set_property(self, "laikaEventDelay", JS.add(JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_MIN_EVENT_DELAY"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_MAX_EVENT_DELAY")) - JS.number(JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_MIN_EVENT_DELAY")))))))
		if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5)):
			JS.invoke_method(JS.get_property(self, "laikaSpine"), "growl", [JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_GROWL_TIME")])
		else:
			JS.invoke_method(JS.get_property(self, "laikaSpine"), "howl", [JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_HOWL_TIME")])
	JS.set_property(self, "dimitriEventDelay", (JS.number(JS.get_property(self, "dimitriEventDelay")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000)))))
	if JS.truthy(JS.compare("<", JS.get_property(self, "dimitriEventDelay"), 0)):
		JS.set_property(self, "dimitriEventDelay", JS.add(JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_MIN_EVENT_DELAY"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_MAX_EVENT_DELAY")) - JS.number(JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_MIN_EVENT_DELAY")))))))
		JS.invoke_method(JS.get_property(self, "dimitriSpine"), "scowl", [JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_SCOWL_TIME")])
	return null

func original_retire():
	var _scope2: Dictionary = {}
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.invoke_method(JS.get_property(self, "laikaSpine"), "retire", [])
	JS.invoke_method(JS.get_property(self, "dimitriSpine"), "retire", [])
	return null
