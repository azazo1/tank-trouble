# 由原版 UITankAvatarGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UITankAvatarGroup: Dictionary = {}
static var _initialized_UITankAvatarGroup = false
static func initialize_original_static():
	if _initialized_UITankAvatarGroup: return
	_initialized_UITankAvatarGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UITankAvatarGroup.has(key): return _static_UITankAvatarGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UITankAvatarGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "avatarSpine", null)
	JS.set_property(self, "name", null)
	JS.set_property(self, "playerId", null)
	JS.set_property(self, "spawnTween", null)
	JS.set_property(self, "removeTween", null)
	JS.invoke_method(JS.get_property(self, "scale"), "set", [0, 0])
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UITankAvatarGroup"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/panel/uitankavatargroup.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_update()
	return null

func original_postUpdate():
	var _scope2: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope3: Dictionary = {"x": _arg0, "y": _arg1, "playerId": _arg2, "animate": _arg3, "targetScale": _arg4, "ai": null, "delay": null}
	JS.set_property(self, "exists", true)
	JS.set_property(self, "visible", true)
	JS.set_property(self, "x", _scope3["x"])
	JS.set_property(self, "y", _scope3["y"])
	JS.set_property(self, "playerId", _scope3["playerId"])
	JS.set_property(self, "targetScale", JS.logical("||", func():
		var _scope4: Dictionary = {}
		return _scope3["targetScale"]
		return null, func():
		var _scope5: Dictionary = {}
		return 1
		return null))
	if JS.truthy(JS.logical("&&", func():
		var _scope6: Dictionary = {}
		return JS.invoke_method(JS.module("AIs"), "isReady", [])
		return null, func():
		var _scope7: Dictionary = {}
		return JS.invoke_method(JS.module("AIs"), "isAI", [JS.get_property(self, "playerId")])
		return null)):
		_scope3["ai"] = JS.invoke_method(JS.module("AIs"), "getAI", [JS.get_property(self, "playerId")])
		JS.set_property(self, "name", JS.get_property(_scope3["ai"], "name"))
		var _switch0 = JS.get_property(self, "name")
		var _switch0_start = -1
		if JS.equal(_switch0, "Laika", true): _switch0_start = 0
		elif JS.equal(_switch0, "Dimitri", true): _switch0_start = 1
		while true:
			if _switch0_start >= 0 and _switch0_start <= 0:
				JS.set_property(self, "avatarSpine", JS.invoke_method(self, "addChild", [JS.construct(JS.module("UILaikaSpine"), [JS.get_property(self, "game"), JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_X"), JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_Y"), JS.get_property(self, "playerId"), true])]))
				JS.set_property(self, "targetScale", (JS.number(JS.get_property(self, "targetScale")) * JS.number(JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_SCALE"))))
				break
			if _switch0_start >= 0 and _switch0_start <= 1:
				JS.set_property(self, "avatarSpine", JS.invoke_method(self, "addChild", [JS.construct(JS.module("UIDimitriSpine"), [JS.get_property(self, "game"), JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_X"), JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_Y"), JS.get_property(self, "playerId")])]))
				JS.set_property(self, "targetScale", (JS.number(JS.get_property(self, "targetScale")) * JS.number(JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_SCALE"))))
				break
			break
		JS.invoke_method(JS.get_property(JS.get_property(self, "avatarSpine"), "anchor"), "setTo", [0.5, 0.5])
		JS.invoke_method(JS.get_property(self, "avatarSpine"), "idle", [])
	_scope3["delay"] = JS.add(50, (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(200)))
	if JS.truthy(JS.get_property(self, "removeTween")):
		JS.invoke_method(JS.get_property(self, "removeTween"), "stop", [])
		JS.set_property(self, "removeTween", null)
	if JS.truthy(_scope3["animate"]):
		JS.set_property(self, "spawnTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": -(JS.get_property(self, "targetScale")), "y": JS.get_property(self, "targetScale")}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true, _scope3["delay"]]))
	else:
		JS.invoke_method(JS.get_property(self, "scale"), "set", [-(JS.get_property(self, "targetScale")), JS.get_property(self, "targetScale")])
	if JS.truthy(JS.get_property(self, "avatarSpine")):
		JS.set_property(JS.get_property(JS.get_property(self, "avatarSpine"), "skeleton"), "flipX", false)
	return null

func original_refresh(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope8: Dictionary = {"x": _arg0, "y": _arg1, "targetScale": _arg2}
	if JS.truthy(not JS.equal(_scope8["x"], null, true)):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"x": _scope8["x"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	if JS.truthy(not JS.equal(_scope8["y"], null, true)):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"y": _scope8["y"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	if JS.truthy(not JS.equal(_scope8["targetScale"], null, true)):
		JS.set_property(self, "targetScale", _scope8["targetScale"])
		var _switch1 = JS.get_property(self, "name")
		var _switch1_start = -1
		if JS.equal(_switch1, "Laika", true): _switch1_start = 0
		elif JS.equal(_switch1, "Dimitri", true): _switch1_start = 1
		while true:
			if _switch1_start >= 0 and _switch1_start <= 0:
				JS.set_property(self, "targetScale", (JS.number(JS.get_property(self, "targetScale")) * JS.number(JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_SCALE"))))
				break
			if _switch1_start >= 0 and _switch1_start <= 1:
				JS.set_property(self, "targetScale", (JS.number(JS.get_property(self, "targetScale")) * JS.number(JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_SCALE"))))
				break
			break
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": -(JS.get_property(self, "targetScale")), "y": JS.get_property(self, "targetScale")}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	return null

func original_remove():
	var _scope9: Dictionary = {}
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
	JS.set_property(self, "removeTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 0, "y": 0}, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "removeTween"), "onComplete"), "add", [func():
		var _scope10: Dictionary = {}
		if JS.truthy(JS.get_property(JS.callback_receiver(self), "avatarSpine")):
			JS.invoke_method(JS.get_property(JS.callback_receiver(self), "avatarSpine"), "retire", [])
			JS.invoke_method(JS.callback_receiver(self), "removeChild", [JS.get_property(JS.callback_receiver(self), "avatarSpine")])
			JS.invoke_method(JS.get_property(JS.callback_receiver(self), "avatarSpine"), "destroy", [])
			JS.set_property(JS.callback_receiver(self), "avatarSpine", null)
		JS.set_property(JS.callback_receiver(self), "exists", false)
		JS.set_property(JS.callback_receiver(self), "visible", false)
		return null, self])
	return null

func original_retire():
	var _scope11: Dictionary = {}
	if JS.truthy(JS.get_property(self, "avatarSpine")):
		JS.invoke_method(JS.get_property(self, "avatarSpine"), "retire", [])
		JS.invoke_method(self, "removeChild", [JS.get_property(self, "avatarSpine")])
		JS.invoke_method(JS.get_property(self, "avatarSpine"), "destroy", [])
		JS.set_property(self, "avatarSpine", null)
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
