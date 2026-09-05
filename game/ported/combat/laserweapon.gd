# 由原版 LaserWeapon 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/weapon.gd"

var _fired = false
var _timeSinceFire = 0
static var _static_LaserWeapon: Dictionary = {}
static var _initialized_LaserWeapon = false
static func initialize_original_static():
	if _initialized_LaserWeapon: return
	_initialized_LaserWeapon = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_LaserWeapon.has(key): return _static_LaserWeapon[key]
	return JS.get_property(JS.module("Weapon"), key)
static func original_static_set(key, value):
	_static_LaserWeapon[key] = value
	return value
func original_own_fields():
	return ["_fired","_timeSinceFire"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/combat/laserweapon.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

func original_fire():
	var _scope0: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "_fired")))):
		JS.set_property(self, "_fired", true)
		JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_FIRED"), self])
		return true
	return false
	return null

func original_getProjectileStates(_arg0 = null):
	var _scope1: Dictionary = {"tank": _arg0, "projectileState": null}
	_scope1["projectileState"] = JS.invoke_method(JS.module("ProjectileState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["l"]), JS.invoke_method(_scope1["tank"], "getPlayerId", []), JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), JS.add(JS.invoke_method(_scope1["tank"], "getX", []), (JS.number(JS.invoke_method("@Math", "sin", [JS.invoke_method(_scope1["tank"], "getRotation", [])])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER"), "OFFSET"), "m")))), (JS.number(JS.invoke_method(_scope1["tank"], "getY", [])) - JS.number((JS.number(JS.invoke_method("@Math", "cos", [JS.invoke_method(_scope1["tank"], "getRotation", [])])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER"), "OFFSET"), "m"))))), (JS.number(JS.invoke_method("@Math", "sin", [JS.invoke_method(_scope1["tank"], "getRotation", [])])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER"), "SPEED"), "m"))), (JS.number(-(JS.invoke_method("@Math", "cos", [JS.invoke_method(_scope1["tank"], "getRotation", [])]))) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER"), "SPEED"), "m")))])
	return [_scope1["projectileState"]]
	return null

func original_getTrapStates(_arg0 = null):
	var _scope2: Dictionary = {"tank": _arg0}
	return []
	return null

func original_release():
	var _scope3: Dictionary = {}
	return null

func original_reload(_arg0 = null):
	var _scope4: Dictionary = {"projectile": _arg0}
	return null

func original_movementLocked():
	var _scope5: Dictionary = {}
	return JS.logical("&&", func():
		var _scope6: Dictionary = {}
		return JS.get_property(self, "_fired")
		return null, func():
		var _scope7: Dictionary = {}
		return JS.compare("<=", JS.get_property(self, "_timeSinceFire"), JS.get_property(JS.module("Constants"), "LASER_LOCK_TIME"))
		return null)
	return null

func original_update(_arg0 = null):
	var _scope8: Dictionary = {"deltaTime": _arg0}
	if JS.truthy(JS.get_property(self, "_fired")):
		JS.set_property(self, "_timeSinceFire", JS.add(JS.get_property(self, "_timeSinceFire"), _scope8["deltaTime"]))
	return null

func original_done():
	var _scope9: Dictionary = {}
	return JS.logical("&&", func():
		var _scope10: Dictionary = {}
		return JS.get_property(self, "_fired")
		return null, func():
		var _scope11: Dictionary = {}
		return JS.compare(">", JS.get_property(self, "_timeSinceFire"), JS.get_property(JS.module("Constants"), "LASER_MAX_LIFETIME"))
		return null)
	return null

func original_isDefault():
	var _scope12: Dictionary = {}
	return false
	return null

static func original_createInitialWeaponState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope13: Dictionary = {"id": _arg0, "playerId": _arg1, "fields": null}
	_scope13["fields"] = {"_fired": false, "_timeSinceFire": 0}
	return JS.invoke_method(JS.module("Weapon"), "createInitialWeaponState", [_scope13["id"], _scope13["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), JS.invoke_method("@JSON", "stringify", [_scope13["fields"]])])
	return null
