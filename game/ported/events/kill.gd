# 由原版 Kill 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var victimPlayerId = null
var killerPlayerId = null
var experience = 0
var deadlyId = null
var deadlyType = null
static var _static_Kill: Dictionary = {}
static var _initialized_Kill = false
static func initialize_original_static():
	if _initialized_Kill: return
	_initialized_Kill = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Kill.has(key): return _static_Kill[key]
	return null
static func original_static_set(key, value):
	_static_Kill[key] = value
	return value
func original_own_fields():
	return ["victimPlayerId","killerPlayerId","experience","deadlyId","deadlyType"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"victimPlayerId": _arg0, "killerPlayerId": _arg1, "experience": _arg2, "deadlyId": _arg3, "deadlyType": _arg4}
	JS.set_property(self, "victimPlayerId", _scope0["victimPlayerId"])
	JS.set_property(self, "killerPlayerId", _scope0["killerPlayerId"])
	JS.set_property(self, "experience", _scope0["experience"])
	JS.set_property(self, "deadlyId", _scope0["deadlyId"])
	JS.set_property(self, "deadlyType", _scope0["deadlyType"])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/events/kill.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4)
	return instance

func original_getVictimPlayerId():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "victimPlayerId")
	return null

func original_getKillerPlayerId():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "killerPlayerId")
	return null

func original_getExperience():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "experience")
	return null

func original_getDeadlyId():
	var _scope4: Dictionary = {}
	return JS.get_property(self, "deadlyId")
	return null

func original_getDeadlyType():
	var _scope5: Dictionary = {}
	return JS.get_property(self, "deadlyType")
	return null
