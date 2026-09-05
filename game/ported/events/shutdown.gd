# 由原版 Shutdown 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var reason = null
var reload = false
static var _static_Shutdown: Dictionary = {}
static var _initialized_Shutdown = false
static func initialize_original_static():
	if _initialized_Shutdown: return
	_initialized_Shutdown = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Shutdown.has(key): return _static_Shutdown[key]
	return null
static func original_static_set(key, value):
	_static_Shutdown[key] = value
	return value
func original_own_fields():
	return ["reason","reload"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"reason": _arg0, "reload": _arg1}
	JS.set_property(self, "reason", _scope0["reason"])
	JS.set_property(self, "reload", _scope0["reload"])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/events/shutdown.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_getReason():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "reason")
	return null

func original_getReload():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "reload")
	return null
