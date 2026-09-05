# 由原版 UIRoundTitleGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UIRoundTitleGroup: Dictionary = {}
static var _initialized_UIRoundTitleGroup = false
static func initialize_original_static():
	if _initialized_UIRoundTitleGroup: return
	_initialized_UIRoundTitleGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIRoundTitleGroup.has(key): return _static_UIRoundTitleGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIRoundTitleGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.set_property(self, "title", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Text"), [_scope0["game"], 0, (JS.number(-(JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_SPACING"))) / JS.number(2)), "", {"font": JS.add(JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_FONT_SIZE"), "px TankTrouble"), "fontWeight": "bold", "fill": "#ffffff", "stroke": "#000000", "strokeThickness": JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_STROKE_WIDTH")}])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "title"), "anchor"), "setTo", [0.5, 0.5])
	JS.invoke_method(JS.get_property(self, "title"), "kill", [])
	JS.set_property(self, "subtitle", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Text"), [_scope0["game"], 0, (JS.number(JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_SPACING")) / JS.number(2)), "", {"font": JS.add(JS.get_property(JS.module("UIConstants"), "ROUND_RANKED_FONT_SIZE"), "px TankTrouble"), "fontWeight": "bold", "fill": "#e00000", "stroke": "#000000", "strokeThickness": JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_STROKE_WIDTH")}])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "subtitle"), "anchor"), "setTo", [0.5, 0.5])
	JS.invoke_method(JS.get_property(self, "subtitle"), "kill", [])
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uiroundtitlegroup.gd").new()
	instance._construct_create(_arg0, _arg1)
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

func original_spawn(_arg0 = null, _arg1 = null):
	var _scope3: Dictionary = {"title": _arg0, "subtitle": _arg1}
	JS.set_property(self, "exists", true)
	JS.set_property(self, "visible", true)
	JS.invoke_method(JS.get_property(self, "title"), "revive", [])
	JS.set_property(JS.get_property(self, "title"), "text", _scope3["title"])
	JS.invoke_method(JS.get_property(JS.get_property(self, "title"), "scale"), "set", [0, 0])
	if JS.truthy(not JS.equal(_scope3["subtitle"], "", false)):
		JS.invoke_method(JS.get_property(self, "subtitle"), "revive", [])
		JS.set_property(JS.get_property(self, "subtitle"), "text", _scope3["subtitle"])
		JS.invoke_method(JS.get_property(JS.get_property(self, "subtitle"), "scale"), "set", [0, 0])
	else:
		JS.invoke_method(JS.get_property(self, "subtitle"), "kill", [])
	JS.set_property(self, "removeEvent", JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "add", [JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_DISPLAY_TIME"), JS.get_property(self, "remove"), self]))
	JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(JS.get_property(self, "title"), "scale")]), "to", [{"x": 1, "y": 1}, 300, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true])
	if JS.truthy(not JS.equal(_scope3["subtitle"], "", false)):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(JS.get_property(self, "subtitle"), "scale")]), "to", [{"x": 1, "y": 1}, 300, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true])
	return null

func original_remove():
	var _scope4: Dictionary = {}
	JS.set_property(self, "removeEvent", null)
	JS.invoke_method(JS.get_property(JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(JS.get_property(self, "title"), "scale")]), "to", [{"x": 0, "y": 0}, 100, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]), "onComplete"), "add", [func():
		var _scope5: Dictionary = {}
		JS.invoke_method(JS.callback_receiver(self), "kill", [])
		JS.set_property(JS.callback_receiver(self), "exists", false)
		JS.set_property(JS.callback_receiver(self), "visible", false)
		return null, JS.get_property(self, "title")])
	JS.invoke_method(JS.get_property(JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(JS.get_property(self, "subtitle"), "scale")]), "to", [{"x": 0, "y": 0}, 100, JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]), "onComplete"), "add", [func():
		var _scope6: Dictionary = {}
		JS.invoke_method(JS.callback_receiver(self), "kill", [])
		return null, JS.get_property(self, "subtitle")])
	return null

func original_retire():
	var _scope7: Dictionary = {}
	if JS.truthy(JS.get_property(self, "removeEvent")):
		JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "remove", [JS.get_property(self, "removeEvent")])
	JS.invoke_method(JS.get_property(self, "title"), "kill", [])
	JS.invoke_method(JS.get_property(self, "subtitle"), "kill", [])
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
