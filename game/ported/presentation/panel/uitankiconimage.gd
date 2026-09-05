# 由原版 UITankIconImage 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UITankIconImage: Dictionary = {}
static var _initialized_UITankIconImage = false
static func initialize_original_static():
	if _initialized_UITankIconImage: return
	_initialized_UITankIconImage = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UITankIconImage.has(key): return _static_UITankIconImage[key]
	return JS.get_property(JS.module("Phaser.Image"), key)
static func original_static_set(key, value):
	_static_UITankIconImage[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "active": _arg1, "size": _arg2}
	JS.set_property(self, "iconWidth", 0)
	JS.set_property(self, "iconHeight", 0)
	JS.set_property(self, "size", _scope0["size"])
	var _switch0 = JS.get_property(self, "size")
	var _switch0_start = -1
	if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_SIZES"), "SMALL"), true): _switch0_start = 0
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_SIZES"), "MEDIUM"), true): _switch0_start = 1
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_SIZES"), "LARGE"), true): _switch0_start = 2
	while true:
		if _switch0_start >= 0 and _switch0_start <= 0:
			JS.set_property(self, "iconWidth", JS.get_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_SMALL"))
			JS.set_property(self, "iconHeight", JS.get_property(JS.module("UIConstants"), "TANK_ICON_HEIGHT_SMALL"))
			break
		if _switch0_start >= 0 and _switch0_start <= 1:
			JS.set_property(self, "iconWidth", JS.get_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_MEDIUM"))
			JS.set_property(self, "iconHeight", JS.get_property(JS.module("UIConstants"), "TANK_ICON_HEIGHT_MEDIUM"))
			break
		if _switch0_start >= 0 and _switch0_start <= 2:
			JS.set_property(self, "iconWidth", JS.get_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_LARGE"))
			JS.set_property(self, "iconHeight", JS.get_property(JS.module("UIConstants"), "TANK_ICON_HEIGHT_LARGE"))
			break
		break
	super._construct_create(_scope0["game"], 0, 0, JS.invoke_method(JS.get_property(_scope0["game"], "add"), "bitmapData", [JS.get_property(self, "iconWidth"), JS.get_property(self, "iconHeight")]))
	JS.invoke_method(JS.get_property(self, "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "tankIconPlaceholder", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Sprite"), [_scope0["game"], 0, 0, JS.add("tankiconplaceholder-", JS.get_property(self, "size"))])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankIconPlaceholder"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "inputEnabled", _scope0["active"])
	JS.set_property(self, "playerId", null)
	JS.set_property(self, "showingDetails", false)
	JS.set_property(self, "spawnTween", null)
	JS.set_property(self, "removeTween", null)
	JS.set_property(self, "updateHideTween", null)
	JS.set_property(self, "updateShowTween", null)
	JS.invoke_method(self, "kill", [])
	JS.invoke_method(JS.get_property(self, "scale"), "set", [0, 0])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UITankIconImage"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/panel/uitankiconimage.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope2: Dictionary = {"x": _arg0, "y": _arg1, "playerId": _arg2, "flipped": _arg3, "animate": _arg4, "targetScale": _arg5, "delay": null}
	JS.invoke_method(self, "reset", [_scope2["x"], _scope2["y"]])
	JS.invoke_method(JS.get_property(self, "tankIconPlaceholder"), "revive", [])
	JS.invoke_method(JS.get_property(self, "scale"), "set", [0, 0])
	JS.invoke_method(JS.get_property(self, "key"), "clear", [])
	JS.set_property(self, "playerId", _scope2["playerId"])
	JS.set_property(self, "flipped", _scope2["flipped"])
	JS.set_property(self, "targetScale", JS.logical("||", func():
		var _scope3: Dictionary = {}
		return _scope2["targetScale"]
		return null, func():
		var _scope4: Dictionary = {}
		return 1
		return null))
	_scope2["delay"] = JS.add(50, (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(200)))
	if JS.truthy(JS.get_property(self, "removeTween")):
		JS.invoke_method(JS.get_property(self, "removeTween"), "stop", [])
		JS.set_property(self, "removeTween", null)
	if JS.truthy(_scope2["animate"]):
		JS.set_property(self, "spawnTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": (-(JS.get_property(self, "targetScale")) if JS.truthy(JS.get_property(self, "flipped")) else JS.get_property(self, "targetScale")), "y": JS.get_property(self, "targetScale")}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true, _scope2["delay"]]))
	else:
		JS.invoke_method(JS.get_property(self, "scale"), "set", [(-(JS.get_property(self, "targetScale")) if JS.truthy(JS.get_property(self, "flipped")) else JS.get_property(self, "targetScale")), JS.get_property(self, "targetScale")])
	JS.invoke_method(JS.module("UITankIcon"), "loadPlayerTankIcon", [JS.get_property(JS.get_property(self, "key"), "canvas"), JS.get_property(self, "size"), JS.get_property(self, "playerId"), func(_arg0 = null):
		var _scope5: Dictionary = {"self": _arg0}
		JS.invoke_method(JS.get_property(_scope5["self"], "tankIconPlaceholder"), "kill", [])
		JS.invoke_method(JS.get_property(_scope5["self"], "key"), "clear", [])
		JS.set_property(_scope5["self"], "showingDetails", true)
		return null, self])
	return null

func original_refresh(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope6: Dictionary = {"x": _arg0, "y": _arg1, "targetScale": _arg2}
	if JS.truthy(not JS.equal(_scope6["x"], null, true)):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"x": _scope6["x"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	if JS.truthy(not JS.equal(_scope6["y"], null, true)):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"y": _scope6["y"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	if JS.truthy(not JS.equal(_scope6["targetScale"], null, true)):
		JS.set_property(self, "targetScale", _scope6["targetScale"])
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": (-(JS.get_property(self, "targetScale")) if JS.truthy(JS.get_property(self, "flipped")) else JS.get_property(self, "targetScale")), "y": JS.get_property(self, "targetScale")}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	return null

func original_updateIcon():
	var _scope7: Dictionary = {}
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
	if JS.truthy((not JS.truthy(JS.get_property(self, "removeTween")))):
		if JS.truthy(JS.get_property(self, "updateHideTween")):
			JS.invoke_method(JS.get_property(self, "updateHideTween"), "stop", [])
		if JS.truthy(JS.get_property(self, "updateShowTween")):
			JS.invoke_method(JS.get_property(self, "updateShowTween"), "stop", [])
		JS.set_property(self, "updateHideTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 0, "y": 0}, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None")]))
		JS.set_property(self, "updateShowTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": (-(JS.get_property(self, "targetScale")) if JS.truthy(JS.get_property(self, "flipped")) else JS.get_property(self, "targetScale")), "y": JS.get_property(self, "targetScale")}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out")]))
		JS.invoke_method(JS.get_property(JS.get_property(self, "updateHideTween"), "onComplete"), "add", [func():
			var _scope8: Dictionary = {}
			JS.invoke_method(JS.module("UITankIcon"), "loadPlayerTankIcon", [JS.get_property(JS.get_property(JS.callback_receiver(self), "key"), "canvas"), JS.get_property(JS.callback_receiver(self), "size"), JS.get_property(JS.callback_receiver(self), "playerId"), func(_arg0 = null):
				var _scope9: Dictionary = {"self": _arg0}
				JS.invoke_method(JS.get_property(_scope9["self"], "tankIconPlaceholder"), "kill", [])
				JS.invoke_method(JS.get_property(_scope9["self"], "key"), "clear", [])
				JS.invoke_method(JS.get_property(_scope9["self"], "updateShowTween"), "start", [])
				return null, JS.callback_receiver(self)])
			return null, self])
		JS.invoke_method(JS.get_property(self, "updateHideTween"), "start", [])
	return null

func original_remove():
	var _scope10: Dictionary = {}
	JS.set_property(self, "showingDetails", false)
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
	if JS.truthy(JS.get_property(self, "updateHideTween")):
		JS.invoke_method(JS.get_property(self, "updateHideTween"), "stop", [])
	if JS.truthy(JS.get_property(self, "updateShowTween")):
		JS.invoke_method(JS.get_property(self, "updateShowTween"), "stop", [])
	JS.set_property(self, "removeTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 0, "y": 0}, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "removeTween"), "onComplete"), "add", [func():
		var _scope11: Dictionary = {}
		JS.set_property(JS.callback_receiver(self), "removeTween", null)
		JS.invoke_method(JS.callback_receiver(self), "kill", [])
		return null, self])
	return null

func original_retire():
	var _scope12: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
