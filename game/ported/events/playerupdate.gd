# 由原版 PlayerUpdate 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var playerId = ""
var iconChanged = false
var usernameChanged = false
static var _static_PlayerUpdate: Dictionary = {}
static var _initialized_PlayerUpdate = false
static func initialize_original_static():
	if _initialized_PlayerUpdate: return
	_initialized_PlayerUpdate = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_PlayerUpdate.has(key): return _static_PlayerUpdate[key]
	return null
static func original_static_set(key, value):
	_static_PlayerUpdate[key] = value
	return value
func original_own_fields():
	return ["playerId","iconChanged","usernameChanged"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"playerId": _arg0, "iconChanged": _arg1, "usernameChanged": _arg2}
	JS.set_property(self, "playerId", _scope0["playerId"])
	JS.set_property(self, "iconChanged", _scope0["iconChanged"])
	JS.set_property(self, "usernameChanged", _scope0["usernameChanged"])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/events/playerupdate.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_getPlayerId():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "playerId")
	return null

func original_getIconChanged():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "iconChanged")
	return null

func original_getUsernameChanged():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "usernameChanged")
	return null
