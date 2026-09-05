# 由原版 UIButtonGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UIButtonGroup: Dictionary = {}
static var _initialized_UIButtonGroup = false
static func initialize_original_static():
	if _initialized_UIButtonGroup: return
	_initialized_UIButtonGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIButtonGroup.has(key): return _static_UIButtonGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIButtonGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "x": _arg1, "y": _arg2, "type": _arg3, "size": _arg4, "text": _arg5, "pressedFunction": _arg6, "context": _arg7, "minWidth": _arg8, "keyboardShortcut": _arg9}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "x", _scope0["x"])
	JS.set_property(self, "y", _scope0["y"])
	JS.set_property(self, "type", _scope0["type"])
	JS.set_property(self, "size", _scope0["size"])
	JS.set_property(self, "text", _scope0["text"])
	JS.set_property(self, "pressedFunction", _scope0["pressedFunction"])
	JS.set_property(self, "context", _scope0["context"])
	JS.set_property(self, "minWidth", JS.logical("||", func():
		var _scope1: Dictionary = {}
		return _scope0["minWidth"]
		return null, func():
		var _scope2: Dictionary = {}
		return 0
		return null))
	JS.set_property(self, "keyboardShortcut", JS.logical("||", func():
		var _scope3: Dictionary = {}
		return _scope0["keyboardShortcut"]
		return null, func():
		var _scope4: Dictionary = {}
		return false
		return null))
	JS.set_property(self, "isInputEnabled", true)
	JS.set_property(self, "isEnabled", true)
	JS.invoke_method(self, "setSize", [JS.get_property(self, "size")])
	JS.invoke_method(self, "enable", [])
	JS.set_property(self, "removeTween", null)
	JS.set_property(self, "spawnTween", null)
	JS.invoke_method(JS.get_property(self, "scale"), "set", [0, 0])
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/uibuttongroup.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9)
	return instance

func original_spawn():
	var _scope5: Dictionary = {"delay": null}
	JS.set_property(self, "exists", true)
	JS.set_property(self, "visible", true)
	JS.invoke_method(self, "enable", [])
	_scope5["delay"] = JS.add(50, (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(200)))
	if JS.truthy(JS.get_property(self, "removeTween")):
		JS.invoke_method(JS.get_property(self, "removeTween"), "stop", [])
		JS.set_property(self, "removeTween", null)
	JS.set_property(self, "spawnTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 1, "y": 1}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true, _scope5["delay"]]))
	return null

func original_setMinWidth(_arg0 = null):
	var _scope6: Dictionary = {"minWidth": _arg0}
	JS.set_property(self, "minWidth", _scope6["minWidth"])
	JS.invoke_method(self, "_updateSize", [])
	return null

func original_setText(_arg0 = null):
	var _scope7: Dictionary = {"text": _arg0}
	JS.set_property(self, "text", _scope7["text"])
	JS.invoke_method(JS.get_property(self, "buttonText"), "setText", [_scope7["text"]])
	JS.invoke_method(self, "_updateSize", [])
	return null

func original_setSize(_arg0 = null):
	var _scope8: Dictionary = {"size": _arg0}
	JS.set_property(self, "size", _scope8["size"])
	if JS.truthy(JS.get_property(self, "buttonSlice")):
		JS.invoke_method(self, "removeChild", [JS.get_property(self, "buttonSlice")])
		JS.invoke_method(JS.get_property(self, "buttonSlice"), "destroy", [])
	JS.set_property(self, "buttonSlice", JS.invoke_method(self, "addChild", [JS.construct(JS.module("PhaserNineSlice.NineSlice"), [JS.get_property(self, "game"), 0, 0, JS.add(JS.add("button", JS.get_property(self, "type")), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_RESOLUTIONS"), JS.get_property(self, "size"))), null, 1, 1])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "buttonSlice"), "anchor"), "setTo", [0.5, 0.5])
	if JS.truthy(JS.get_property(self, "buttonSliceActive")):
		JS.invoke_method(self, "removeChild", [JS.get_property(self, "buttonSliceActive")])
		JS.invoke_method(JS.get_property(self, "buttonSliceActive"), "destroy", [])
	JS.set_property(self, "buttonSliceActive", JS.invoke_method(self, "addChild", [JS.construct(JS.module("PhaserNineSlice.NineSlice"), [JS.get_property(self, "game"), 0, 0, JS.add(JS.add(JS.add("button", JS.get_property(self, "type")), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_RESOLUTIONS"), JS.get_property(self, "size"))), "Active"), null, 1, 1])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "buttonSliceActive"), "anchor"), "setTo", [0.5, 0.5])
	if JS.truthy(JS.get_property(self, "buttonSliceDisabled")):
		JS.invoke_method(self, "removeChild", [JS.get_property(self, "buttonSliceDisabled")])
		JS.invoke_method(JS.get_property(self, "buttonSliceDisabled"), "destroy", [])
	JS.set_property(self, "buttonSliceDisabled", JS.invoke_method(self, "addChild", [JS.construct(JS.module("PhaserNineSlice.NineSlice"), [JS.get_property(self, "game"), 0, 0, JS.add(JS.add("button", JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_RESOLUTIONS"), JS.get_property(self, "size"))), "Disabled"), null, 1, 1])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "buttonSliceDisabled"), "anchor"), "setTo", [0.5, 0.5])
	if JS.truthy(JS.get_property(self, "buttonText")):
		JS.invoke_method(self, "removeChild", [JS.get_property(self, "buttonText")])
		JS.invoke_method(JS.get_property(self, "buttonText"), "destroy", [])
	JS.set_property(self, "buttonText", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Text"), [JS.get_property(self, "game"), 0, 0, JS.get_property(self, "text"), {"font": JS.add(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_FONT_SIZES"), JS.get_property(self, "size")), "px TankTrouble"), "fill": "#fff"}])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "buttonText"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "buttonTextY", JS.invoke_method(JS.module("UIUtils"), "computeButtonTextY", [JS.get_property(self, "size"), JS.get_property(JS.module("UIConstants"), "BUTTON_FONT_BASELINE_FRACTION")]))
	JS.set_property(JS.get_property(self, "buttonText"), "y", JS.get_property(self, "buttonTextY"))
	JS.invoke_method(self, "_updateSize", [])
	if JS.truthy(JS.get_property(self, "isInputEnabled")):
		JS.set_property(JS.get_property(self, "buttonSlice"), "inputEnabled", true)
		JS.set_property(JS.get_property(JS.get_property(self, "buttonSlice"), "input"), "useHandCursor", true)
		JS.set_property(JS.get_property(self, "buttonSliceActive"), "inputEnabled", true)
		JS.set_property(JS.get_property(JS.get_property(self, "buttonSliceActive"), "input"), "useHandCursor", true)
	else:
		JS.set_property(JS.get_property(self, "buttonSlice"), "inputEnabled", false)
		JS.set_property(JS.get_property(self, "buttonSliceActive"), "inputEnabled", false)
	if JS.truthy(JS.get_property(self, "isEnabled")):
		JS.invoke_method(JS.get_property(self, "buttonSlice"), "revive", [])
		JS.invoke_method(JS.get_property(self, "buttonSliceActive"), "kill", [])
		JS.invoke_method(JS.get_property(self, "buttonSliceDisabled"), "kill", [])
	else:
		JS.invoke_method(JS.get_property(self, "buttonSlice"), "kill", [])
		JS.invoke_method(JS.get_property(self, "buttonSliceActive"), "kill", [])
		JS.invoke_method(JS.get_property(self, "buttonSliceDisabled"), "revive", [])
		JS.set_property(JS.get_property(self, "buttonText"), "y", JS.get_property(self, "buttonTextY"))
	JS.invoke_method(JS.module("UIUtils"), "addButton", [JS.get_property(self, "buttonSlice"), func(_arg0 = null):
		var _scope9: Dictionary = {"self": _arg0}
		JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope9["self"], "game"), "input"), "mousePointer"), "leftButton"), "reset", [])
		JS.invoke_method(JS.get_property(_scope9["self"], "buttonSlice"), "kill", [])
		JS.invoke_method(JS.get_property(_scope9["self"], "buttonSliceActive"), "revive", [])
		JS.set_property(JS.get_property(_scope9["self"], "buttonText"), "y", JS.add(JS.get_property(_scope9["self"], "buttonTextY"), JS.get_property(JS.module("UIConstants"), "BUTTON_ACTIVE_OFFSET")))
		return null, func(_arg0 = null):
		var _scope10: Dictionary = {"self": _arg0}
		JS.invoke_method(JS.get_property(_scope10["self"], "buttonSlice"), "revive", [])
		JS.invoke_method(JS.get_property(_scope10["self"], "buttonSliceActive"), "kill", [])
		JS.set_property(JS.get_property(_scope10["self"], "buttonText"), "y", JS.get_property(_scope10["self"], "buttonTextY"))
		return null, func(_arg0 = null):
		var _scope11: Dictionary = {"self": _arg0}
		JS.invoke_method(JS.get_property(_scope11["self"], "pressedFunction"), "call", [JS.get_property(_scope11["self"], "context")])
		return null, self])
	return null

func original_enableInput():
	var _scope12: Dictionary = {}
	JS.set_property(self, "isInputEnabled", true)
	JS.set_property(JS.get_property(self, "buttonSlice"), "inputEnabled", true)
	JS.set_property(JS.get_property(JS.get_property(self, "buttonSlice"), "input"), "useHandCursor", true)
	JS.set_property(JS.get_property(self, "buttonSliceActive"), "inputEnabled", true)
	JS.set_property(JS.get_property(JS.get_property(self, "buttonSliceActive"), "input"), "useHandCursor", true)
	return null

func original_disableInput():
	var _scope13: Dictionary = {}
	JS.set_property(self, "isInputEnabled", false)
	JS.set_property(JS.get_property(self, "buttonSlice"), "inputEnabled", false)
	JS.set_property(JS.get_property(self, "buttonSliceActive"), "inputEnabled", false)
	return null

func original_enable():
	var _scope14: Dictionary = {}
	JS.set_property(self, "isEnabled", true)
	JS.invoke_method(self, "enableInput", [])
	JS.invoke_method(JS.get_property(self, "buttonSlice"), "revive", [])
	JS.invoke_method(JS.get_property(self, "buttonSliceActive"), "kill", [])
	JS.invoke_method(JS.get_property(self, "buttonSliceDisabled"), "kill", [])
	return null

func original_disable():
	var _scope15: Dictionary = {}
	JS.set_property(self, "isEnabled", false)
	JS.invoke_method(self, "disableInput", [])
	JS.invoke_method(JS.get_property(self, "buttonSlice"), "kill", [])
	JS.invoke_method(JS.get_property(self, "buttonSliceActive"), "kill", [])
	JS.invoke_method(JS.get_property(self, "buttonSliceDisabled"), "revive", [])
	JS.set_property(JS.get_property(self, "buttonText"), "y", JS.get_property(self, "buttonTextY"))
	return null

func original__updateSize():
	var _scope16: Dictionary = {"width": null, "height": null}
	_scope16["width"] = JS.add(JS.invoke_method("@Math", "max", [JS.get_property(self, "minWidth"), JS.add(JS.get_property(JS.get_property(self, "buttonText"), "width"), (JS.number(2) * JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_MARGINS"), JS.get_property(self, "size")))))]), (JS.number(2) * JS.number(JS.get_property(JS.module("UIConstants"), "BUTTON_SHADOW_WIDTH"))))
	_scope16["height"] = JS.add(JS.add(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(self, "size")), JS.get_property(JS.module("UIConstants"), "BUTTON_SHADOW_HEIGHT_TOP")), JS.get_property(JS.module("UIConstants"), "BUTTON_SHADOW_HEIGHT_BOTTOM"))
	JS.invoke_method(JS.get_property(self, "buttonSlice"), "resize", [_scope16["width"], _scope16["height"]])
	JS.invoke_method(JS.get_property(self, "buttonSliceActive"), "resize", [_scope16["width"], _scope16["height"]])
	JS.invoke_method(JS.get_property(self, "buttonSliceDisabled"), "resize", [_scope16["width"], _scope16["height"]])
	return null

func original_update():
	var _scope17: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	if JS.truthy(JS.logical("&&", func():
		var _scope18: Dictionary = {}
		return JS.logical("&&", func():
			var _scope19: Dictionary = {}
			return JS.get_property(self, "isEnabled")
			return null, func():
			var _scope20: Dictionary = {}
			return JS.get_property(self, "isInputEnabled")
			return null)
		return null, func():
		var _scope21: Dictionary = {}
		return JS.get_property(self, "keyboardShortcut")
		return null)):
		if JS.truthy(JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "input"), "keyboard"), "downDuration", [JS.get_property(self, "keyboardShortcut"), 16])):
			JS.invoke_method(JS.get_property(self, "pressedFunction"), "call", [JS.get_property(self, "context")])
	super.original_update()
	return null

func original_postUpdate():
	var _scope22: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_remove():
	var _scope23: Dictionary = {}
	JS.invoke_method(self, "disableInput", [])
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
		JS.set_property(self, "spawnTween", null)
	JS.set_property(self, "removeTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 0, "y": 0}, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "removeTween"), "onComplete"), "add", [func():
		var _scope24: Dictionary = {}
		JS.set_property(JS.callback_receiver(self), "exists", false)
		JS.set_property(JS.callback_receiver(self), "visible", false)
		return null, self])
	return null

func original_retire():
	var _scope25: Dictionary = {}
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
