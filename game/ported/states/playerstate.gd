# 由原版 PlayerState 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var data = {"playerId": "", "queued": false, "enqueueTime": null, "team": 0}
static var _static_PlayerState: Dictionary = {}
static var _initialized_PlayerState = false
static func initialize_original_static():
	if _initialized_PlayerState: return
	_initialized_PlayerState = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_PlayerState.has(key): return _static_PlayerState[key]
	return null
static func original_static_set(key, value):
	_static_PlayerState[key] = value
	return value
func original_own_fields():
	return ["data"]

func _construct_withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var _scope0: Dictionary = {"playerId": _arg0, "queued": _arg1, "enqueueTime": _arg2, "team": _arg3}
	JS.set_property(JS.get_property(self, "data"), "playerId", _scope0["playerId"])
	JS.set_property(JS.get_property(self, "data"), "queued", _scope0["queued"])
	JS.set_property(JS.get_property(self, "data"), "enqueueTime", _scope0["enqueueTime"])
	JS.set_property(JS.get_property(self, "data"), "team", _scope0["team"])
	return null
static func withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var instance = load("res://game/ported/states/playerstate.gd").new()
	instance._construct_withState(_arg0, _arg1, _arg2, _arg3)
	return instance

func _construct_withObject(_arg0 = null):
	var _scope1: Dictionary = {"obj": _arg0}
	JS.set_property(self, "data", _scope1["obj"])
	return null
static func withObject(_arg0 = null):
	var instance = load("res://game/ported/states/playerstate.gd").new()
	instance._construct_withObject(_arg0)
	return instance

func original_getPlayerId():
	var _scope2: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "playerId")
	return null

func original_getQueued():
	var _scope3: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "queued")
	return null

func original_getEnqueueTime():
	var _scope4: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "enqueueTime")
	return null

func original_getTeam(_arg0 = null):
	var _scope5: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "team")
	return null

func original_toObj():
	var _scope6: Dictionary = {}
	return JS.get_property(self, "data")
	return null
