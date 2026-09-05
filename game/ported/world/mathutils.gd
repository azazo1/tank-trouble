# 由原版 MathUtils 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_MathUtils: Dictionary = {}
static var _initialized_MathUtils = false
static func initialize_original_static():
	if _initialized_MathUtils: return
	_initialized_MathUtils = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_MathUtils.has(key): return _static_MathUtils[key]
	return null
static func original_static_set(key, value):
	_static_MathUtils[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/world/mathutils.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

static func original_linearInterpolation(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope0: Dictionary = {"a": _arg0, "b": _arg1, "t": _arg2}
	return JS.add((JS.number((JS.number(1) - JS.number(_scope0["t"]))) * JS.number(_scope0["a"])), (JS.number(_scope0["t"]) * JS.number(_scope0["b"])))
	return null

static func original_randomRange(_arg0 = null, _arg1 = null):
	var _scope1: Dictionary = {"min": _arg0, "max": _arg1}
	return JS.add(_scope1["min"], (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(_scope1["max"]) - JS.number(_scope1["min"])))))
	return null

static func original_randomAroundZero(_arg0 = null):
	var _scope2: Dictionary = {"interval": _arg0}
	return (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(_scope2["interval"]))) - JS.number((JS.number(_scope2["interval"]) * JS.number(0.5))))
	return null

static func original_randomArrayEntry(_arg0 = null):
	var _scope3: Dictionary = {"array": _arg0}
	return JS.get_property(_scope3["array"], JS.invoke_method("@Math", "floor", [JS.invoke_method(JS.module("MathUtils"), "randomRange", [0, JS.get_property(_scope3["array"], "length")])]))
	return null

static func original_randomSign(_arg0 = null):
	var _scope4: Dictionary = {"x": _arg0}
	return (_scope4["x"] if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5)) else -(_scope4["x"]))
	return null

static func original_getClosestAxis(_arg0 = null):
	var _scope5: Dictionary = {"direction": _arg0, "absX": null, "absY": null}
	_scope5["absX"] = JS.invoke_method("@Math", "abs", [JS.get_property(_scope5["direction"], "x")])
	_scope5["absY"] = JS.invoke_method("@Math", "abs", [JS.get_property(_scope5["direction"], "y")])
	if JS.truthy(JS.compare(">=", _scope5["absX"], _scope5["absY"])):
		return ({"x": 1, "y": 0} if JS.truthy(JS.compare(">", JS.get_property(_scope5["direction"], "x"), 0)) else {"x": -(1), "y": 0})
	else:
		return ({"x": 0, "y": 1} if JS.truthy(JS.compare(">", JS.get_property(_scope5["direction"], "y"), 0)) else {"x": 0, "y": -(1)})
	return null
