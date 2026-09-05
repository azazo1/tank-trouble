# 由原版 DoubleBarrelWeapon 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/weapon.gd"

var _numBullets = 0
var _triggerPulled = false
var _leftBarrel = false
static var _static_DoubleBarrelWeapon: Dictionary = {}
static var _initialized_DoubleBarrelWeapon = false
static func initialize_original_static():
	if _initialized_DoubleBarrelWeapon: return
	_initialized_DoubleBarrelWeapon = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_DoubleBarrelWeapon.has(key): return _static_DoubleBarrelWeapon[key]
	return JS.get_property(JS.module("Weapon"), key)
static func original_static_set(key, value):
	_static_DoubleBarrelWeapon[key] = value
	return value
func original_own_fields():
	return ["_numBullets","_triggerPulled","_leftBarrel"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/combat/doublebarrelweapon.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

func original_fire():
	var _scope0: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "_triggerPulled")))):
		JS.set_property(self, "_triggerPulled", true)
		if JS.truthy(JS.compare(">", JS.get_property(self, "_numBullets"), 0)):
			JS.increment(self, "_numBullets", -1, false)
			JS.set_property(self, "_leftBarrel", (not JS.truthy(JS.get_property(self, "_leftBarrel"))))
			JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_FIRED"), self])
			return true
	return false
	return null

func original_getProjectileStates(_arg0 = null):
	var _scope1: Dictionary = {"tank": _arg0, "sinRot": null, "cosRot": null, "speedModifier": null, "projectileState": null}
	_scope1["sinRot"] = JS.invoke_method("@Math", "sin", [JS.invoke_method(_scope1["tank"], "getRotation", [])])
	_scope1["cosRot"] = JS.invoke_method("@Math", "cos", [JS.invoke_method(_scope1["tank"], "getRotation", [])])
	_scope1["speedModifier"] = JS.invoke_method(JS.get_property(self, "roundModel"), "getModifier", [JS.invoke_method(_scope1["tank"], "getPlayerId", []), JS.get_property(JS.get_property(JS.module("Constants"), "MODIFIER_TYPES"), "SPEED")])
	if JS.truthy(JS.get_property(self, "_leftBarrel")):
		_scope1["projectileState"] = JS.invoke_method(JS.module("ProjectileState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["db"]), JS.invoke_method(_scope1["tank"], "getPlayerId", []), JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), (JS.number(JS.add(JS.invoke_method(_scope1["tank"], "getX", []), (JS.number(_scope1["sinRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "OFFSET"), "m"))))) - JS.number((JS.number(_scope1["cosRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "SPACE"), "m"))))), (JS.number((JS.number(JS.invoke_method(_scope1["tank"], "getY", [])) - JS.number((JS.number(_scope1["cosRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "OFFSET"), "m")))))) - JS.number((JS.number(_scope1["sinRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "SPACE"), "m"))))), (JS.number((JS.number(_scope1["sinRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "SPEED"), "m")))) * JS.number(_scope1["speedModifier"])), (JS.number((JS.number(-(_scope1["cosRot"])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "SPEED"), "m")))) * JS.number(_scope1["speedModifier"]))])
		return [_scope1["projectileState"]]
	else:
		_scope1["projectileState"] = JS.invoke_method(JS.module("ProjectileState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["db"]), JS.invoke_method(_scope1["tank"], "getPlayerId", []), JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), JS.add(JS.add(JS.invoke_method(_scope1["tank"], "getX", []), (JS.number(_scope1["sinRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "OFFSET"), "m")))), (JS.number(_scope1["cosRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "SPACE"), "m")))), JS.add((JS.number(JS.invoke_method(_scope1["tank"], "getY", [])) - JS.number((JS.number(_scope1["cosRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "OFFSET"), "m"))))), (JS.number(_scope1["sinRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "SPACE"), "m")))), (JS.number((JS.number(_scope1["sinRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "SPEED"), "m")))) * JS.number(_scope1["speedModifier"])), (JS.number((JS.number(-(_scope1["cosRot"])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "SPEED"), "m")))) * JS.number(_scope1["speedModifier"]))])
		return [_scope1["projectileState"]]
	return null

func original_getTrapStates(_arg0 = null):
	var _scope2: Dictionary = {"tank": _arg0}
	return []
	return null

func original_release():
	var _scope3: Dictionary = {}
	JS.set_property(self, "_triggerPulled", false)
	return null

func original_reload(_arg0 = null):
	var _scope4: Dictionary = {"projectile": _arg0}
	return null

func original_movementLocked():
	var _scope5: Dictionary = {}
	return false
	return null

func original_update(_arg0 = null):
	var _scope6: Dictionary = {"deltaTime": _arg0}
	return null

func original_done():
	var _scope7: Dictionary = {}
	return JS.logical("&&", func():
		var _scope8: Dictionary = {}
		return JS.equal(JS.get_property(self, "_numBullets"), 0, false)
		return null, func():
		var _scope9: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "_triggerPulled")))
		return null)
	return null

func original_isDefault():
	var _scope10: Dictionary = {}
	return false
	return null

static func original_createInitialWeaponState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope11: Dictionary = {"id": _arg0, "playerId": _arg1, "numBullets": _arg2, "fields": null}
	_scope11["fields"] = {"_numBullets": _scope11["numBullets"], "_triggerPulled": false, "_leftBarrel": false}
	return JS.invoke_method(JS.module("Weapon"), "createInitialWeaponState", [_scope11["id"], _scope11["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), JS.invoke_method("@JSON", "stringify", [_scope11["fields"]])])
	return null
