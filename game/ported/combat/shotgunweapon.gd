# 由原版 ShotgunWeapon 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/weapon.gd"

var _numBullets = 0
var _triggerPulled = false
var _reloadTime = 0
static var _static_ShotgunWeapon: Dictionary = {}
static var _initialized_ShotgunWeapon = false
static func initialize_original_static():
	if _initialized_ShotgunWeapon: return
	_initialized_ShotgunWeapon = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_ShotgunWeapon.has(key): return _static_ShotgunWeapon[key]
	return JS.get_property(JS.module("Weapon"), key)
static func original_static_set(key, value):
	_static_ShotgunWeapon[key] = value
	return value
func original_own_fields():
	return ["_numBullets","_triggerPulled","_reloadTime"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/combat/shotgunweapon.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

func original_fire():
	var _scope0: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "_triggerPulled")))):
		JS.set_property(self, "_triggerPulled", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope1: Dictionary = {}
			return JS.compare("<=", JS.get_property(self, "_reloadTime"), 0)
			return null, func():
			var _scope2: Dictionary = {}
			return JS.compare(">", JS.get_property(self, "_numBullets"), 0)
			return null)):
			JS.increment(self, "_numBullets", -1, false)
			JS.set_property(self, "_reloadTime", JS.get_property(JS.module("Constants"), "SHOTGUN_RELOAD_TIME"))
			JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_FIRED"), self])
			return true
	return false
	return null

func original_getProjectileStates(_arg0 = null):
	var _scope3: Dictionary = {"tank": _arg0, "result": null, "i": null, "randomSeed": null, "rot": null, "spread": null, "sinRot": null, "cosRot": null, "speed": null, "projectileState": null}
	_scope3["result"] = []
	_scope3["i"] = 0
	while JS.truthy(JS.compare("<", _scope3["i"], JS.get_property(JS.module("Constants"), "SHOTGUN_NUM_BUCKSHOT"))):
		_scope3["randomSeed"] = (JS.number(JS.invoke_method("@Math", "random", [])) - JS.number(0.5))
		_scope3["rot"] = JS.add(JS.invoke_method(_scope3["tank"], "getRotation", []), (JS.number(_scope3["randomSeed"]) * JS.number(JS.get_property(JS.module("Constants"), "SHOTGUN_BUCKSHOT_SPREAD"))))
		_scope3["spread"] = (JS.number(_scope3["randomSeed"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN"), "SPACE"), "m")))
		_scope3["sinRot"] = JS.invoke_method("@Math", "sin", [_scope3["rot"]])
		_scope3["cosRot"] = JS.invoke_method("@Math", "cos", [_scope3["rot"]])
		_scope3["speed"] = JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN"), "MIN_SPEED"), "m"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN"), "MAX_SPEED"), "m")) - JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN"), "MIN_SPEED"), "m"))))))
		_scope3["projectileState"] = JS.invoke_method(JS.module("ProjectileState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["sg"]), JS.invoke_method(_scope3["tank"], "getPlayerId", []), JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), JS.add(JS.add(JS.invoke_method(_scope3["tank"], "getX", []), (JS.number(_scope3["sinRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN"), "OFFSET"), "m")))), (JS.number(_scope3["cosRot"]) * JS.number(_scope3["spread"]))), JS.add((JS.number(JS.invoke_method(_scope3["tank"], "getY", [])) - JS.number((JS.number(_scope3["cosRot"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN"), "OFFSET"), "m"))))), (JS.number(_scope3["sinRot"]) * JS.number(_scope3["spread"]))), (JS.number(_scope3["sinRot"]) * JS.number(_scope3["speed"])), (JS.number(-(_scope3["cosRot"])) * JS.number(_scope3["speed"]))])
		JS.invoke_method(_scope3["result"], "push", [_scope3["projectileState"]])
		JS.increment(_scope3, "i", 1, false)
	return _scope3["result"]
	return null

func original_getTrapStates(_arg0 = null):
	var _scope4: Dictionary = {"tank": _arg0}
	return []
	return null

func original_release():
	var _scope5: Dictionary = {}
	JS.set_property(self, "_triggerPulled", false)
	return null

func original_reload(_arg0 = null):
	var _scope6: Dictionary = {"projectile": _arg0}
	return null

func original_movementLocked():
	var _scope7: Dictionary = {}
	return false
	return null

func original_update(_arg0 = null):
	var _scope8: Dictionary = {"deltaTime": _arg0}
	if JS.truthy(JS.compare(">", JS.get_property(self, "_reloadTime"), 0)):
		JS.set_property(self, "_reloadTime", (JS.number(JS.get_property(self, "_reloadTime")) - JS.number(_scope8["deltaTime"])))
	return null

func original_done():
	var _scope9: Dictionary = {}
	return JS.logical("&&", func():
		var _scope10: Dictionary = {}
		return JS.equal(JS.get_property(self, "_numBullets"), 0, false)
		return null, func():
		var _scope11: Dictionary = {}
		return JS.compare("<=", JS.get_property(self, "_reloadTime"), 0)
		return null)
	return null

func original_isDefault():
	var _scope12: Dictionary = {}
	return false
	return null

static func original_createInitialWeaponState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope13: Dictionary = {"id": _arg0, "playerId": _arg1, "numBullets": _arg2, "fields": null}
	_scope13["fields"] = {"_numBullets": _scope13["numBullets"], "_triggerPulled": false, "_reloadTime": 0}
	return JS.invoke_method(JS.module("Weapon"), "createInitialWeaponState", [_scope13["id"], _scope13["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), JS.invoke_method("@JSON", "stringify", [_scope13["fields"]])])
	return null
