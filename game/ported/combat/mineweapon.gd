# 由原版 MineWeapon 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/weapon.gd"

var _numMines = 0
var _triggerPulled = false
static var _static_MineWeapon: Dictionary = {}
static var _initialized_MineWeapon = false
static func initialize_original_static():
	if _initialized_MineWeapon: return
	_initialized_MineWeapon = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_MineWeapon.has(key): return _static_MineWeapon[key]
	return JS.get_property(JS.module("Weapon"), key)
static func original_static_set(key, value):
	_static_MineWeapon[key] = value
	return value
func original_own_fields():
	return ["_numMines","_triggerPulled"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/mineweapon.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

func original_fire():
	var _scope0: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "_triggerPulled")))):
		JS.set_property(self, "_triggerPulled", true)
		if JS.truthy(JS.compare(">", JS.get_property(self, "_numMines"), 0)):
			JS.increment(self, "_numMines", -1, false)
			JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_FIRED"), self])
			return true
	return false
	return null

func original_getProjectileStates(_arg0 = null):
	var _scope1: Dictionary = {"tank": _arg0}
	return []
	return null

func original_getTrapStates(_arg0 = null):
	var _scope2: Dictionary = {"tank": _arg0, "trapState": null}
	_scope2["trapState"] = JS.invoke_method(JS.module("Mine"), "createInitialTrapState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["mi"]), JS.invoke_method(_scope2["tank"], "getPlayerId", []), JS.add(JS.invoke_method(_scope2["tank"], "getX", []), (JS.number(JS.invoke_method("@Math", "sin", [JS.invoke_method(_scope2["tank"], "getRotation", [])])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MINE"), "OFFSET"), "m")))), (JS.number(JS.invoke_method(_scope2["tank"], "getY", [])) - JS.number((JS.number(JS.invoke_method("@Math", "cos", [JS.invoke_method(_scope2["tank"], "getRotation", [])])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MINE"), "OFFSET"), "m"))))), (JS.number(-(JS.invoke_method("@Math", "sin", [JS.invoke_method(_scope2["tank"], "getRotation", [])]))) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MINE"), "LAUNCH_SPEED"), "m"))), (JS.number(JS.invoke_method("@Math", "cos", [JS.invoke_method(_scope2["tank"], "getRotation", [])])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MINE"), "LAUNCH_SPEED"), "m")))])
	return [_scope2["trapState"]]
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
		return JS.equal(JS.get_property(self, "_numMines"), 0, false)
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
	var _scope11: Dictionary = {"id": _arg0, "playerId": _arg1, "numMines": _arg2, "fields": null}
	_scope11["fields"] = {"_numMines": _scope11["numMines"], "_triggerPulled": false}
	return JS.invoke_method(JS.module("Weapon"), "createInitialWeaponState", [_scope11["id"], _scope11["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), JS.invoke_method("@JSON", "stringify", [_scope11["fields"]])])
	return null
