# 由原版 Shrapnel 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/projectile.gd"

static var _static_Shrapnel: Dictionary = {}
static var _initialized_Shrapnel = false
static func initialize_original_static():
	if _initialized_Shrapnel: return
	_initialized_Shrapnel = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Shrapnel.has(key): return _static_Shrapnel[key]
	return JS.get_property(JS.module("Projectile"), key)
static func original_static_set(key, value):
	_static_Shrapnel[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/combat/shrapnel.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

func original_update(_arg0 = null):
	var _scope0: Dictionary = {"deltaTime": _arg0}
	if JS.truthy((not JS.truthy(JS.invoke_method(self, "isDeadlyToOwner", [])))):
		JS.invoke_method(self, "makeDeadlyToOwner", [])
	JS.set_property(self, "x", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "x"))
	JS.set_property(self, "y", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "y"))
	JS.set_property(self, "speedX", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "x"))
	JS.set_property(self, "speedY", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "y"))
	return null

func original_hitShield():
	var _scope1: Dictionary = {"velocity": null}
	_scope1["velocity"] = JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", [])
	JS.invoke_method(_scope1["velocity"], "Multiply", [0])
	return null

func original_hitMaze():
	var _scope2: Dictionary = {"velocity": null}
	_scope2["velocity"] = JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", [])
	JS.invoke_method(_scope2["velocity"], "Multiply", [0])
	return null

func original_done():
	var _scope3: Dictionary = {"velocity": null}
	_scope3["velocity"] = JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", [])
	return JS.compare("<=", JS.invoke_method(_scope3["velocity"], "LengthSquared", []), 0.01)
	return null
