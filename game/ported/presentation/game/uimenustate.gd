# 由原版 UIMenuState 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

var backgroundGroup = null
var onePlayerButton = null
var twoPlayerButton = null
var threePlayerButton = null
var buttonsScaledDown = false
var addingGuests = false
var log = null
static var _static_UIMenuState: Dictionary = {}
static var _initialized_UIMenuState = false
static func initialize_original_static():
	if _initialized_UIMenuState: return
	_initialized_UIMenuState = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIMenuState.has(key): return _static_UIMenuState[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIMenuState[key] = value
	return value
func original_own_fields():
	return ["backgroundGroup","onePlayerButton","twoPlayerButton","threePlayerButton","buttonsScaledDown","addingGuests","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {}
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uimenustate.gd").new()
	instance._construct_create()
	return instance

func original_preload():
	var _scope1: Dictionary = {}
	return null

func original_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope2: Dictionary = {}
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UIMenuState"]))
	JS.set_property(self, "backgroundGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "existing", [JS.construct(JS.module("UIMenuBackgroundGroup"), [JS.get_property(self, "game"), 0, 0])]))
	JS.set_property(self, "onePlayerButton", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "existing", [JS.construct(JS.module("UIButtonGroup"), [JS.get_property(self, "game"), 0, 0, "", JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"), "1 player", JS.get_property(self, "_onePlayer"), self, JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))])]))
	JS.set_property(self, "twoPlayerButton", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "existing", [JS.construct(JS.module("UIButtonGroup"), [JS.get_property(self, "game"), 0, 0, "", JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"), "2 players", JS.get_property(self, "_twoPlayer"), self, JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))])]))
	JS.set_property(self, "threePlayerButton", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "existing", [JS.construct(JS.module("UIButtonGroup"), [JS.get_property(self, "game"), 0, 0, "", JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"), "3 players", JS.get_property(self, "_threePlayer"), self, JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))])]))
	JS.invoke_method(JS.get_property(self, "onePlayerButton"), "spawn", [])
	JS.invoke_method(JS.get_property(self, "twoPlayerButton"), "spawn", [])
	JS.invoke_method(JS.get_property(self, "threePlayerButton"), "spawn", [])
	JS.invoke_method(self, "_onSizeChangeHandler", [])
	JS.set_property(self, "addingGuests", false)
	return null

func original_shutdown():
	var _scope3: Dictionary = {}
	JS.invoke_method(self, "_retireUI", [])
	return null

func original__onSizeChangeHandler():
	var _scope4: Dictionary = {"unscaledBackgroundWidth": null, "unscaledBackgroundHeight": null, "backgroundScale": null, "backgroundTopMargin": null, "buttonAnchorY": null, "scaleDown": null, "buttonSpacing": null, "playerButtonWidth": null, "playerButtonHalfHeight": null, "secondaryButtonHalfHeight": null}
	JS.invoke_method(JS.get_property(self, "log"), "debug", ["SIZE CHANGE!"])
	_scope4["unscaledBackgroundWidth"] = JS.get_property(JS.invoke_method(JS.get_property(self, "backgroundGroup"), "getLocalBounds", []), "width")
	_scope4["unscaledBackgroundHeight"] = JS.get_property(JS.invoke_method(JS.get_property(self, "backgroundGroup"), "getLocalBounds", []), "height")
	_scope4["backgroundScale"] = JS.invoke_method("@Math", "min", [1, JS.invoke_method("@Math", "min", [(JS.number(JS.get_property(JS.get_property(self, "game"), "width")) / JS.number(_scope4["unscaledBackgroundWidth"])), (JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "height")) * JS.number(JS.get_property(JS.module("UIConstants"), "MENU_BACKGROUND_HEIGHT_RATIO")))) / JS.number(_scope4["unscaledBackgroundHeight"]))])])
	JS.invoke_method(JS.get_property(JS.get_property(self, "backgroundGroup"), "scale"), "setTo", [_scope4["backgroundScale"]])
	_scope4["backgroundTopMargin"] = JS.invoke_method("@Math", "max", [JS.get_property(JS.module("UIConstants"), "MENU_BACKGROUND_MIN_TOP_MARGIN"), (JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "height")) * JS.number(JS.get_property(JS.module("UIConstants"), "MENU_BACKGROUND_Y_RATIO")))) - JS.number((JS.number(JS.get_property(JS.get_property(self, "backgroundGroup"), "height")) * JS.number(0.5))))])
	JS.invoke_method(JS.get_property(JS.get_property(self, "backgroundGroup"), "position"), "set", [(JS.number(JS.get_property(JS.get_property(self, "game"), "width")) * JS.number(0.5)), JS.add(_scope4["backgroundTopMargin"], (JS.number(JS.get_property(JS.get_property(self, "backgroundGroup"), "height")) * JS.number(0.5)))])
	_scope4["buttonAnchorY"] = JS.add(_scope4["backgroundTopMargin"], (JS.number(JS.get_property(JS.get_property(self, "backgroundGroup"), "height")) * JS.number(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_BACKGROUND_Y_RATIO"))))
	_scope4["scaleDown"] = false
	JS.set_property(_scope4, "scaleDown", JS.bitwise("|", _scope4["scaleDown"], JS.compare("<", JS.get_property(JS.get_property(self, "game"), "width"), JS.add((JS.number(3) * JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE")))), (JS.number(4) * JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))))))))
	JS.set_property(_scope4, "scaleDown", JS.bitwise("|", _scope4["scaleDown"], JS.compare("<", (JS.number(JS.get_property(JS.get_property(self, "game"), "height")) - JS.number(_scope4["buttonAnchorY"])), JS.add(JS.add((JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))) * JS.number(0.5)), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))) * JS.number(0.5))), (JS.number(2) * JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))))))))
	if JS.truthy(JS.logical("&&", func():
		var _scope5: Dictionary = {}
		return _scope4["scaleDown"]
		return null, func():
		var _scope6: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "buttonsScaledDown")))
		return null)):
		JS.set_property(self, "buttonsScaledDown", true)
		JS.invoke_method(JS.get_property(self, "onePlayerButton"), "setSize", [JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM")])
		JS.invoke_method(JS.get_property(self, "twoPlayerButton"), "setSize", [JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM")])
		JS.invoke_method(JS.get_property(self, "threePlayerButton"), "setSize", [JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM")])
		JS.invoke_method(JS.get_property(self, "onePlayerButton"), "setMinWidth", [JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))])
		JS.invoke_method(JS.get_property(self, "twoPlayerButton"), "setMinWidth", [JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))])
		JS.invoke_method(JS.get_property(self, "threePlayerButton"), "setMinWidth", [JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))])
	else:
		if JS.truthy(JS.logical("&&", func():
			var _scope7: Dictionary = {}
			return (not JS.truthy(_scope4["scaleDown"]))
			return null, func():
			var _scope8: Dictionary = {}
			return JS.get_property(self, "buttonsScaledDown")
			return null)):
			JS.set_property(self, "buttonsScaledDown", false)
			JS.invoke_method(JS.get_property(self, "onePlayerButton"), "setSize", [JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE")])
			JS.invoke_method(JS.get_property(self, "twoPlayerButton"), "setSize", [JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE")])
			JS.invoke_method(JS.get_property(self, "threePlayerButton"), "setSize", [JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE")])
			JS.invoke_method(JS.get_property(self, "onePlayerButton"), "setMinWidth", [JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))])
			JS.invoke_method(JS.get_property(self, "twoPlayerButton"), "setMinWidth", [JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))])
			JS.invoke_method(JS.get_property(self, "threePlayerButton"), "setMinWidth", [JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))])
	_scope4["buttonSpacing"] = JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))
	_scope4["playerButtonWidth"] = JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))
	_scope4["playerButtonHalfHeight"] = (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))) * JS.number(0.5))
	_scope4["secondaryButtonHalfHeight"] = (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))) * JS.number(0.5))
	if JS.truthy(JS.get_property(self, "buttonsScaledDown")):
		JS.set_property(_scope4, "buttonSpacing", JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM")))
		JS.set_property(_scope4, "playerButtonWidth", JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM")))
		JS.set_property(_scope4, "playerButtonHalfHeight", (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))) * JS.number(0.5)))
		JS.set_property(_scope4, "secondaryButtonHalfHeight", (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"))) * JS.number(0.5)))
	JS.invoke_method(JS.get_property(JS.get_property(self, "twoPlayerButton"), "position"), "set", [(JS.number(JS.get_property(JS.get_property(self, "game"), "width")) * JS.number(0.5)), _scope4["buttonAnchorY"]])
	JS.invoke_method(JS.get_property(JS.get_property(self, "onePlayerButton"), "position"), "set", [(JS.number((JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "width")) * JS.number(0.5))) - JS.number(_scope4["playerButtonWidth"]))) - JS.number(_scope4["buttonSpacing"])), _scope4["buttonAnchorY"]])
	JS.invoke_method(JS.get_property(JS.get_property(self, "threePlayerButton"), "position"), "set", [JS.add(JS.add((JS.number(JS.get_property(JS.get_property(self, "game"), "width")) * JS.number(0.5)), _scope4["playerButtonWidth"]), _scope4["buttonSpacing"]), _scope4["buttonAnchorY"]])
	return null

func original__onePlayer():
	var _scope9: Dictionary = {}
	JS.invoke_method(self, "_addGuests", [1])
	return null

func original__twoPlayer():
	var _scope10: Dictionary = {}
	JS.invoke_method(self, "_addGuests", [2])
	return null

func original__threePlayer():
	var _scope11: Dictionary = {}
	JS.invoke_method(self, "_addGuests", [3])
	return null

func original__updatePlayerButtons():
	var _scope12: Dictionary = {}
	if JS.truthy(JS.get_property(self, "addingGuests")):
		JS.invoke_method(JS.get_property(self, "onePlayerButton"), "disable", [])
		JS.invoke_method(JS.get_property(self, "twoPlayerButton"), "disable", [])
		JS.invoke_method(JS.get_property(self, "threePlayerButton"), "disable", [])
	else:
		JS.invoke_method(JS.get_property(self, "onePlayerButton"), "enable", [])
		JS.invoke_method(JS.get_property(self, "twoPlayerButton"), "enable", [])
		JS.invoke_method(JS.get_property(self, "threePlayerButton"), "enable", [])
	return null

func original__retireUI():
	var _scope13: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "backgroundGroup"), "retire", [])
	return null

func original_update():
	var _scope14: Dictionary = {}
	return null
