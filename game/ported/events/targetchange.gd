# 由原版 TargetChange 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var projectileId = null
var targetId = null
static var _static_TargetChange: Dictionary = {}
static var _initialized_TargetChange = false
static func initialize_original_static():
	if _initialized_TargetChange: return
	_initialized_TargetChange = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_TargetChange.has(key): return _static_TargetChange[key]
	return null
static func original_static_set(key, value):
	_static_TargetChange[key] = value
	return value
func original_own_fields():
	return ["projectileId","targetId"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"projectileId": _arg0, "targetId": _arg1}
	JS.set_property(self, "projectileId", _scope0["projectileId"])
	JS.set_property(self, "targetId", _scope0["targetId"])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/events/targetchange.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_getProjectileId():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "projectileId")
	return null

func original_getTargetId():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "targetId")
	return null
