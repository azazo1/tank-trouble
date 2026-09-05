# 由原版 IdGenerator 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var genId = null
var nextId = 0
static var _static_IdGenerator: Dictionary = {}
static var _initialized_IdGenerator = false
static func initialize_original_static():
	if _initialized_IdGenerator: return
	_initialized_IdGenerator = true
	_static_IdGenerator["instance"] = create()
static func original_static_get(key):
	initialize_original_static()
	if _static_IdGenerator.has(key): return _static_IdGenerator[key]
	return null
static func original_static_set(key, value):
	_static_IdGenerator[key] = value
	return value
func original_own_fields():
	return ["genId","nextId"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {}
	JS.set_property(self, "genId", JS.invoke_method(self, "_s4", []))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/match/idgenerator.gd").new()
	instance._construct_create()
	return instance

func original_gen(_arg0 = null):
	var _scope1: Dictionary = {"prefix": _arg0}
	if JS.truthy(JS.compare(">=", JS.get_property(self, "nextId"), JS.get_property("@Number", "MAX_VALUE"))):
		JS.set_property(self, "genId", JS.invoke_method(self, "_s4", []))
		JS.set_property(self, "nextId", 0)
	JS.set_property(_scope1, "prefix", JS.logical("||", func():
		var _scope2: Dictionary = {}
		return JS.add(_scope1["prefix"], "-")
		return null, func():
		var _scope3: Dictionary = {}
		return ""
		return null))
	return JS.add(JS.add(JS.add(_scope1["prefix"], JS.get_property(self, "genId")), "-"), JS.increment(self, "nextId", 1, true))
	return null

func original__s4():
	var _scope4: Dictionary = {}
	return JS.invoke_method(JS.invoke_method(JS.invoke_method("@Math", "floor", [(JS.number(JS.add(1, JS.invoke_method("@Math", "random", []))) * JS.number(65536))]), "toString", [16]), "substring", [1])
	return null
