# 由原版 VictoryAward 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var playerIds = null
var experiencePerWinner = 0
var goldAmountPerWinner = 0
var rankChanges = null
static var _static_VictoryAward: Dictionary = {}
static var _initialized_VictoryAward = false
static func initialize_original_static():
	if _initialized_VictoryAward: return
	_initialized_VictoryAward = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_VictoryAward.has(key): return _static_VictoryAward[key]
	return null
static func original_static_set(key, value):
	_static_VictoryAward[key] = value
	return value
func original_own_fields():
	return ["playerIds","experiencePerWinner","goldAmountPerWinner","rankChanges"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"playerIds": _arg0, "experiencePerWinner": _arg1, "goldAmountPerWinner": _arg2, "rankChanges": _arg3}
	JS.set_property(self, "playerIds", _scope0["playerIds"])
	JS.set_property(self, "experiencePerWinner", _scope0["experiencePerWinner"])
	JS.set_property(self, "goldAmountPerWinner", _scope0["goldAmountPerWinner"])
	JS.set_property(self, "rankChanges", _scope0["rankChanges"])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/events/victoryaward.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3)
	return instance

func original_getPlayerIds():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "playerIds")
	return null

func original_getExperiencePerWinner():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "experiencePerWinner")
	return null

func original_getGoldAmountPerWinner():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "goldAmountPerWinner")
	return null

func original_getRankChanges(_arg0 = null):
	var _scope4: Dictionary = {}
	return JS.get_property(self, "rankChanges")
	return null
