# 由原版 WeaponDeactivation 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var weaponId = null
var playerId = null
static var _static_WeaponDeactivation: Dictionary = {}
static var _initialized_WeaponDeactivation = false
static func initialize_original_static():
	if _initialized_WeaponDeactivation: return
	_initialized_WeaponDeactivation = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_WeaponDeactivation.has(key): return _static_WeaponDeactivation[key]
	return null
static func original_static_set(key, value):
	_static_WeaponDeactivation[key] = value
	return value
func original_own_fields():
	return ["weaponId","playerId"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"weaponId": _arg0, "playerId": _arg1}
	JS.set_property(self, "weaponId", _scope0["weaponId"])
	JS.set_property(self, "playerId", _scope0["playerId"])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/events/weapondeactivation.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_getWeaponId():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "weaponId")
	return null

func original_getPlayerId():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "playerId")
	return null
