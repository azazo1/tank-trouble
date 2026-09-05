# 由原版 InputState 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var data = {}
static var _static_InputState: Dictionary = {}
static var _initialized_InputState = false
static func initialize_original_static():
	if _initialized_InputState: return
	_initialized_InputState = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_InputState.has(key): return _static_InputState[key]
	return null
static func original_static_set(key, value):
	_static_InputState[key] = value
	return value
func original_own_fields():
	return ["data"]

func _construct_withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var _scope0: Dictionary = {"playerId": _arg0, "forward": _arg1, "back": _arg2, "left": _arg3, "right": _arg4, "fire": _arg5}
	JS.set_property(JS.get_property(self, "data"), "playerId", _scope0["playerId"])
	JS.set_property(JS.get_property(self, "data"), "forward", _scope0["forward"])
	JS.set_property(JS.get_property(self, "data"), "back", _scope0["back"])
	JS.set_property(JS.get_property(self, "data"), "left", _scope0["left"])
	JS.set_property(JS.get_property(self, "data"), "right", _scope0["right"])
	JS.set_property(JS.get_property(self, "data"), "fire", _scope0["fire"])
	return null
static func withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var instance = load("res://game/ported/states/inputstate.gd").new()
	instance._construct_withState(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5)
	return instance

func _construct_withObject(_arg0 = null):
	var _scope1: Dictionary = {"obj": _arg0}
	JS.set_property(self, "data", _scope1["obj"])
	return null
static func withObject(_arg0 = null):
	var instance = load("res://game/ported/states/inputstate.gd").new()
	instance._construct_withObject(_arg0)
	return instance

func original_getPlayerId():
	var _scope2: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "playerId")
	return null

func original_getForward():
	var _scope3: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "forward")
	return null

func original_getBack():
	var _scope4: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "back")
	return null

func original_getLeft():
	var _scope5: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "left")
	return null

func original_getRight():
	var _scope6: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "right")
	return null

func original_getFire():
	var _scope7: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "fire")
	return null

func original_toObj():
	var _scope8: Dictionary = {}
	return JS.get_property(self, "data")
	return null
