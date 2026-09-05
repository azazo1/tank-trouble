# 由原版 OvertimeCountUpCounter 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/match/counter.gd"

var _currentTime = 0
static var _static_OvertimeCountUpCounter: Dictionary = {}
static var _initialized_OvertimeCountUpCounter = false
static func initialize_original_static():
	if _initialized_OvertimeCountUpCounter: return
	_initialized_OvertimeCountUpCounter = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_OvertimeCountUpCounter.has(key): return _static_OvertimeCountUpCounter[key]
	return JS.get_property(JS.module("Counter"), key)
static func original_static_set(key, value):
	_static_OvertimeCountUpCounter[key] = value
	return value
func original_own_fields():
	return ["_currentTime"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/match/overtimecountupcounter.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

func original_update(_arg0 = null):
	var _scope0: Dictionary = {"deltaTime": _arg0}
	JS.set_property(self, "_currentTime", JS.add(JS.get_property(self, "_currentTime"), _scope0["deltaTime"]))
	return null

func original_done():
	var _scope1: Dictionary = {}
	return false
	return null

static func original_createInitialCounterState(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope2: Dictionary = {"id": _arg0, "currentTime": _arg1, "fields": null}
	_scope2["fields"] = {"_currentTime": _scope2["currentTime"]}
	return JS.invoke_method(JS.module("Counter"), "createInitialCounterState", [_scope2["id"], JS.get_property(JS.get_property(JS.module("Constants"), "COUNTER_TYPES"), "OVERTIME_COUNT_UP"), JS.invoke_method("@JSON", "stringify", [_scope2["fields"]])])
	return null
