# 由原版 TankState 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var data = {}
static var _static_TankState: Dictionary = {}
static var _initialized_TankState = false
static func initialize_original_static():
	if _initialized_TankState: return
	_initialized_TankState = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_TankState.has(key): return _static_TankState[key]
	return null
static func original_static_set(key, value):
	_static_TankState[key] = value
	return value
func original_own_fields():
	return ["data"]

func _construct_withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var _scope0: Dictionary = {"playerId": _arg0, "x": _arg1, "y": _arg2, "forward": _arg3, "back": _arg4, "rotation": _arg5, "left": _arg6, "right": _arg7, "fireDown": _arg8, "locked": _arg9}
	JS.set_property(JS.get_property(self, "data"), "playerId", _scope0["playerId"])
	JS.set_property(JS.get_property(self, "data"), "x", _scope0["x"])
	JS.set_property(JS.get_property(self, "data"), "y", _scope0["y"])
	JS.set_property(JS.get_property(self, "data"), "forward", _scope0["forward"])
	JS.set_property(JS.get_property(self, "data"), "back", _scope0["back"])
	JS.set_property(JS.get_property(self, "data"), "rotation", _scope0["rotation"])
	JS.set_property(JS.get_property(self, "data"), "left", _scope0["left"])
	JS.set_property(JS.get_property(self, "data"), "right", _scope0["right"])
	JS.set_property(JS.get_property(self, "data"), "fireDown", _scope0["fireDown"])
	JS.set_property(JS.get_property(self, "data"), "locked", _scope0["locked"])
	return null
static func withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var instance = load("res://game/ported/states/tankstate.gd").new()
	instance._construct_withState(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9)
	return instance

func _construct_withObject(_arg0 = null):
	var _scope1: Dictionary = {"obj": _arg0}
	JS.set_property(self, "data", _scope1["obj"])
	return null
static func withObject(_arg0 = null):
	var instance = load("res://game/ported/states/tankstate.gd").new()
	instance._construct_withObject(_arg0)
	return instance

func original_getPlayerId():
	var _scope2: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "playerId")
	return null

func original_getX():
	var _scope3: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "x")
	return null

func original_setX(_arg0 = null):
	var _scope4: Dictionary = {"x": _arg0}
	JS.set_property(JS.get_property(self, "data"), "x", _scope4["x"])
	return null

func original_getY():
	var _scope5: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "y")
	return null

func original_setY(_arg0 = null):
	var _scope6: Dictionary = {"y": _arg0}
	JS.set_property(JS.get_property(self, "data"), "y", _scope6["y"])
	return null

func original_getForward():
	var _scope7: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "forward")
	return null

func original_setForward(_arg0 = null):
	var _scope8: Dictionary = {"forward": _arg0}
	JS.set_property(JS.get_property(self, "data"), "forward", _scope8["forward"])
	return null

func original_getBack():
	var _scope9: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "back")
	return null

func original_setBack(_arg0 = null):
	var _scope10: Dictionary = {"back": _arg0}
	JS.set_property(JS.get_property(self, "data"), "back", _scope10["back"])
	return null

func original_getRotation():
	var _scope11: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "rotation")
	return null

func original_setRotation(_arg0 = null):
	var _scope12: Dictionary = {"rotation": _arg0}
	JS.set_property(JS.get_property(self, "data"), "rotation", _scope12["rotation"])
	return null

func original_getLeft():
	var _scope13: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "left")
	return null

func original_setLeft(_arg0 = null):
	var _scope14: Dictionary = {"left": _arg0}
	JS.set_property(JS.get_property(self, "data"), "left", _scope14["left"])
	return null

func original_getRight():
	var _scope15: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "right")
	return null

func original_setRight(_arg0 = null):
	var _scope16: Dictionary = {"right": _arg0}
	JS.set_property(JS.get_property(self, "data"), "right", _scope16["right"])
	return null

func original_getFireDown():
	var _scope17: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "fireDown")
	return null

func original_setFireDown(_arg0 = null):
	var _scope18: Dictionary = {"fireDown": _arg0}
	JS.set_property(JS.get_property(self, "data"), "fireDown", _scope18["fireDown"])
	return null

func original_getLocked():
	var _scope19: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "locked")
	return null

func original_setLocked(_arg0 = null):
	var _scope20: Dictionary = {"locked": _arg0}
	JS.set_property(JS.get_property(self, "data"), "locked", _scope20["locked"])
	return null

func original_toObj():
	var _scope21: Dictionary = {}
	return JS.get_property(self, "data")
	return null
