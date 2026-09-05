# 由原版 KeyboardInputManager 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/input/inputmanager.gd"

var forwardKey = null
var backKey = null
var leftKey = null
var rightKey = null
var fireKey = null
var keyStates = {}
static var _static_KeyboardInputManager: Dictionary = {}
static var _initialized_KeyboardInputManager = false
static func initialize_original_static():
	if _initialized_KeyboardInputManager: return
	_initialized_KeyboardInputManager = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_KeyboardInputManager.has(key): return _static_KeyboardInputManager[key]
	return JS.get_property(JS.module("InputManager"), key)
static func original_static_set(key, value):
	_static_KeyboardInputManager[key] = value
	return value
func original_own_fields():
	return ["forwardKey","backKey","leftKey","rightKey","fireKey","keyStates"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"playerId": _arg0, "data": _arg1}
	super._construct_create(_scope0["playerId"])
	JS.set_property(self, "forwardKey", JS.get_property(_scope0["data"], "forwardKey"))
	JS.set_property(self, "backKey", JS.get_property(_scope0["data"], "backKey"))
	JS.set_property(self, "leftKey", JS.get_property(_scope0["data"], "leftKey"))
	JS.set_property(self, "rightKey", JS.get_property(_scope0["data"], "rightKey"))
	JS.set_property(self, "fireKey", JS.get_property(_scope0["data"], "fireKey"))
	JS.invoke_method(self, "reset", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/input/keyboardinputmanager.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_update():
	var _scope1: Dictionary = {"game": null, "forwardState": null, "backState": null, "leftState": null, "rightState": null, "fireState": null, "stateChanged": null, "gameController": null, "inputState": null}
	super.original_update()
	_scope1["game"] = JS.invoke_method(JS.module("GameManager"), "getGame", [])
	if JS.truthy(_scope1["game"]):
		_scope1["forwardState"] = false
		_scope1["backState"] = false
		_scope1["leftState"] = false
		_scope1["rightState"] = false
		_scope1["fireState"] = false
		if JS.truthy(JS.get_property(JS.get_property(_scope1["game"], "input"), "enabled")):
			JS.set_property(_scope1, "forwardState", JS.logical("||", func():
				var _scope2: Dictionary = {}
				return JS.invoke_method(JS.get_property(JS.get_property(_scope1["game"], "input"), "keyboard"), "isDown", [JS.get_property(self, "forwardKey")])
				return null, func():
				var _scope3: Dictionary = {}
				return false
				return null))
			JS.set_property(_scope1, "backState", JS.logical("||", func():
				var _scope4: Dictionary = {}
				return JS.invoke_method(JS.get_property(JS.get_property(_scope1["game"], "input"), "keyboard"), "isDown", [JS.get_property(self, "backKey")])
				return null, func():
				var _scope5: Dictionary = {}
				return false
				return null))
			JS.set_property(_scope1, "leftState", JS.logical("||", func():
				var _scope6: Dictionary = {}
				return JS.invoke_method(JS.get_property(JS.get_property(_scope1["game"], "input"), "keyboard"), "isDown", [JS.get_property(self, "leftKey")])
				return null, func():
				var _scope7: Dictionary = {}
				return false
				return null))
			JS.set_property(_scope1, "rightState", JS.logical("||", func():
				var _scope8: Dictionary = {}
				return JS.invoke_method(JS.get_property(JS.get_property(_scope1["game"], "input"), "keyboard"), "isDown", [JS.get_property(self, "rightKey")])
				return null, func():
				var _scope9: Dictionary = {}
				return false
				return null))
			JS.set_property(_scope1, "fireState", JS.logical("||", func():
				var _scope10: Dictionary = {}
				return JS.invoke_method(JS.get_property(JS.get_property(_scope1["game"], "input"), "keyboard"), "isDown", [JS.get_property(self, "fireKey")])
				return null, func():
				var _scope11: Dictionary = {}
				return false
				return null))
		_scope1["stateChanged"] = false
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "keyStates"), JS.get_property(self, "forwardKey")), _scope1["forwardState"], true)))
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "keyStates"), JS.get_property(self, "backKey")), _scope1["backState"], true)))
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "keyStates"), JS.get_property(self, "leftKey")), _scope1["leftState"], true)))
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "keyStates"), JS.get_property(self, "rightKey")), _scope1["rightState"], true)))
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "keyStates"), JS.get_property(self, "fireKey")), _scope1["fireState"], true)))
		_scope1["gameController"] = JS.invoke_method(JS.module("GameManager"), "getGameController", [])
		if JS.truthy(JS.logical("&&", func():
			var _scope12: Dictionary = {}
			return _scope1["stateChanged"]
			return null, func():
			var _scope13: Dictionary = {}
			return _scope1["gameController"]
			return null)):
			_scope1["inputState"] = JS.invoke_method(JS.module("InputState"), "withState", [JS.get_property(self, "playerId"), _scope1["forwardState"], _scope1["backState"], _scope1["leftState"], _scope1["rightState"], _scope1["fireState"]])
			JS.invoke_method(_scope1["gameController"], "setInputState", [_scope1["inputState"]])
		JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "forwardKey"), _scope1["forwardState"])
		JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "backKey"), _scope1["backState"])
		JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "leftKey"), _scope1["leftState"])
		JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "rightKey"), _scope1["rightState"])
		JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "fireKey"), _scope1["fireState"])
	return null

func original_reset():
	var _scope14: Dictionary = {}
	JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "forwardKey"), false)
	JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "backKey"), false)
	JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "leftKey"), false)
	JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "rightKey"), false)
	JS.set_property(JS.get_property(self, "keyStates"), JS.get_property(self, "fireKey"), false)
	return null
