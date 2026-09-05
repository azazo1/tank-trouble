# 由原版 Shotgun 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/projectile.gd"

static var _static_Shotgun: Dictionary = {}
static var _initialized_Shotgun = false
static func initialize_original_static():
	if _initialized_Shotgun: return
	_initialized_Shotgun = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Shotgun.has(key): return _static_Shotgun[key]
	return JS.get_property(JS.module("Projectile"), key)
static func original_static_set(key, value):
	_static_Shotgun[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/shotgun.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

func original_hitShield():
	var _scope0: Dictionary = {}
	super._construct_create()
	JS.set_property(self, "timeAlive", JS.invoke_method("@Math", "max", [JS.get_property(self, "timeAlive"), (JS.number(JS.get_property(JS.module("Constants"), "SHOTGUN_MAX_LIFETIME")) - JS.number(JS.get_property(JS.module("Constants"), "SHOTGUN_LIFETIME_AFTER_MAZE_HIT")))]))
	return null

func original_hitMaze():
	var _scope1: Dictionary = {}
	super._construct_create()
	JS.set_property(self, "timeAlive", JS.invoke_method("@Math", "max", [JS.get_property(self, "timeAlive"), (JS.number(JS.get_property(JS.module("Constants"), "SHOTGUN_MAX_LIFETIME")) - JS.number(JS.get_property(JS.module("Constants"), "SHOTGUN_LIFETIME_AFTER_MAZE_HIT")))]))
	return null
