# 由原版 GatlingGunWeapon 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/weapon.gd"

var _numBullets = 0
var _triggerPulled = false
var _weaponCharge = 0
var _timeSinceFire = 0
var _newBurst = true
static var _static_GatlingGunWeapon: Dictionary = {}
static var _initialized_GatlingGunWeapon = false
static func initialize_original_static():
	if _initialized_GatlingGunWeapon: return
	_initialized_GatlingGunWeapon = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_GatlingGunWeapon.has(key): return _static_GatlingGunWeapon[key]
	return JS.get_property(JS.module("Weapon"), key)
static func original_static_set(key, value):
	_static_GatlingGunWeapon[key] = value
	return value
func original_own_fields():
	return ["_numBullets","_triggerPulled","_weaponCharge","_timeSinceFire","_newBurst"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/gatlinggunweapon.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

func original_fire():
	var _scope0: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "_triggerPulled")))):
		JS.set_property(self, "_triggerPulled", true)
		JS.set_property(self, "_timeSinceFire", JS.get_property(JS.module("Constants"), "GATLING_GUN_FIRE_RATE"))
		JS.set_property(self, "_newBurst", true)
	return false
	return null

func original_getProjectileStates(_arg0 = null):
	var _scope1: Dictionary = {"tank": _arg0, "randomSeed": null, "rot": null, "spread": null, "sinRot": null, "cosRot": null, "speed": null, "projectileState": null}
	_scope1["randomSeed"] = (JS.number(JS.invoke_method("@Math", "random", [])) - JS.number(0.5))
	_scope1["rot"] = JS.add(JS.invoke_method(_scope1["tank"], "getRotation", []), (JS.number(_scope1["randomSeed"]) * JS.number(JS.get_property(JS.module("Constants"), "GATLING_GUN_BULLET_SPREAD"))))
	_scope1["spread"] = (JS.number(_scope1["randomSeed"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN"), "SPACE"), "m")))
	_scope1["sinRot"] = JS.invoke_method("@Math", "sin", [_scope1["rot"]])
	_scope1["cosRot"] = JS.invoke_method("@Math", "cos", [_scope1["rot"]])
	_scope1["speed"] = JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN"), "MIN_SPEED"), "m"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN"), "MAX_SPEED"), "m")) - JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN"), "MIN_SPEED"), "m"))))))
	_scope1["projectileState"] = JS.invoke_method(JS.module("ProjectileState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["gg"]), JS.invoke_method(_scope1["tank"], "getPlayerId", []), JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), JS.add(JS.add(JS.invoke_method(_scope1["tank"], "getX", []), (JS.number(_scope1["sinRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN"), "OFFSET"), "m")))), (JS.number(_scope1["cosRot"]) * JS.number(_scope1["spread"]))), JS.add((JS.number(JS.invoke_method(_scope1["tank"], "getY", [])) - JS.number((JS.number(_scope1["cosRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN"), "OFFSET"), "m"))))), (JS.number(_scope1["sinRot"]) * JS.number(_scope1["spread"]))), (JS.number(_scope1["sinRot"]) * JS.number(_scope1["speed"])), (JS.number(-(_scope1["cosRot"])) * JS.number(_scope1["speed"]))])
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
	if JS.truthy(JS.get_property(self, "_triggerPulled")):
		JS.set_property(self, "_weaponCharge", JS.invoke_method("@Math", "min", [JS.add(JS.get_property(self, "_weaponCharge"), (JS.number(_scope6["deltaTime"]) / JS.number(JS.get_property(JS.module("Constants"), "GATLING_GUN_CHARGE_TIME")))), 1]))
		if JS.truthy(JS.equal(JS.get_property(self, "_weaponCharge"), 1, false)):
			JS.set_property(self, "_timeSinceFire", JS.add(JS.get_property(self, "_timeSinceFire"), _scope6["deltaTime"]))
			if JS.truthy(JS.compare(">=", JS.get_property(self, "_timeSinceFire"), JS.get_property(JS.module("Constants"), "GATLING_GUN_FIRE_RATE"))):
				JS.set_property(self, "_timeSinceFire", (JS.number(JS.get_property(self, "_timeSinceFire")) - JS.number(JS.get_property(JS.module("Constants"), "GATLING_GUN_FIRE_RATE"))))
				if JS.truthy(JS.compare(">", JS.get_property(self, "_numBullets"), 0)):
					JS.increment(self, "_numBullets", -1, false)
					if JS.truthy(JS.get_property(self, "_newBurst")):
						JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_FIRED"), self])
						JS.set_property(self, "_newBurst", false)
					JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_DELAYED_FIRE"), JS.get_property(self, "playerId")])
				else:
					JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_EMPTY"), self])
	else:
		JS.set_property(self, "_weaponCharge", JS.invoke_method("@Math", "max", [(JS.number(JS.get_property(self, "_weaponCharge")) - JS.number((JS.number(_scope6["deltaTime"]) / JS.number(JS.get_property(JS.module("Constants"), "GATLING_GUN_DISCHARGE_TIME"))))), 0]))
	return null

func original_done():
	var _scope7: Dictionary = {}
	return JS.logical("&&", func():
		var _scope8: Dictionary = {}
		return JS.equal(JS.get_property(self, "_weaponCharge"), 0, false)
		return null, func():
		var _scope9: Dictionary = {}
		return JS.equal(JS.get_property(self, "_numBullets"), 0, false)
		return null)
	return null

func original_isDefault():
	var _scope10: Dictionary = {}
	return false
	return null

static func original_createInitialWeaponState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope11: Dictionary = {"id": _arg0, "playerId": _arg1, "numBullets": _arg2, "fields": null}
	_scope11["fields"] = {"_numBullets": _scope11["numBullets"], "_triggerPulled": false, "_weaponCharge": 0, "_timeSinceFire": 0, "_newBurst": true}
	return JS.invoke_method(JS.module("Weapon"), "createInitialWeaponState", [_scope11["id"], _scope11["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), JS.invoke_method("@JSON", "stringify", [_scope11["fields"]])])
	return null
