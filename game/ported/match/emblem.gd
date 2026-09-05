# 由原版 Emblem 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var id = null
var playerId = null
var type = 0
var log = null
static var _static_Emblem: Dictionary = {}
static var _initialized_Emblem = false
static func initialize_original_static():
	if _initialized_Emblem: return
	_initialized_Emblem = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Emblem.has(key): return _static_Emblem[key]
	return null
static func original_static_set(key, value):
	_static_Emblem[key] = value
	return value
func original_own_fields():
	return ["id","playerId","type","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"emblemState": _arg0}
	JS.invoke_method(self, "setEmblemState", [_scope0["emblemState"]])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["Emblem"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/match/emblem.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_getId():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "id")
	return null

func original_getPlayerId():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "playerId")
	return null

func original_getType():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "type")
	return null

func original_setEmblemState(_arg0 = null):
	var _scope4: Dictionary = {"emblemState": _arg0}
	JS.set_property(self, "id", JS.invoke_method(_scope4["emblemState"], "getId", []))
	JS.set_property(self, "playerId", JS.invoke_method(_scope4["emblemState"], "getPlayerId", []))
	JS.set_property(self, "type", JS.invoke_method(_scope4["emblemState"], "getType", []))
	return null

func original_getEmblemState():
	var _scope5: Dictionary = {}
	return JS.invoke_method(JS.module("EmblemState"), "withState", [JS.get_property(self, "id"), JS.get_property(self, "playerId"), JS.get_property(self, "type")])
	return null
