# 由原版 Weapon 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var id = null
var playerId = null
var type = 0
var roundModel = null
var evtHandler = null
var evtContext = null
var log = null
static var _static_Weapon: Dictionary = {}
static var _initialized_Weapon = false
static func initialize_original_static():
	if _initialized_Weapon: return
	_initialized_Weapon = true
	_static_Weapon["_EVENTS"] = {"WEAPON_FIRED": "weapon fired", "WEAPON_DELAYED_FIRE": "weapon delayed fire", "WEAPON_EMPTY": "weapon empty", "HOMING_MISSILE_TARGET_CHANGED": "homing missile target changed", "MINE_ACTIVATED": "mine activated", "MINE_TRIPPED": "mine tripped", "MINE_DETONATED": "mine detonated"}
static func original_static_get(key):
	initialize_original_static()
	if _static_Weapon.has(key): return _static_Weapon[key]
	return null
static func original_static_set(key, value):
	_static_Weapon[key] = value
	return value
func original_own_fields():
	return ["id","playerId","type","roundModel","evtHandler","evtContext","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"weaponState": _arg0, "roundModel": _arg1, "evtHandler": _arg2, "evtContext": _arg3}
	JS.invoke_method(self, "setWeaponState", [_scope0["weaponState"]])
	JS.set_property(self, "roundModel", _scope0["roundModel"])
	JS.set_property(self, "evtHandler", _scope0["evtHandler"])
	JS.set_property(self, "evtContext", _scope0["evtContext"])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["Weapon"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/weapon.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3)
	return instance

func original_getId():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "id")
	return null

func original_getPlayerId():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "playerId")
	return null

func original_getType():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "type")
	return null

func original_fire():
	var _scope4: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Weapon.fire. fire() must be overridden in subclasses"])
	return null

func original_getProjectileStates(_arg0 = null):
	var _scope5: Dictionary = {"tank": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Weapon.getProjectileStates. getProjectileStates() must be overridden in subclasses"])
	return null

func original_getTrapStates(_arg0 = null):
	var _scope6: Dictionary = {"tank": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Weapon.getTrapStates. getTrapStates() must be overridden in subclasses"])
	return null

func original_release():
	var _scope7: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Weapon.release. release() must be overridden in subclasses"])
	return null

func original_reload(_arg0 = null):
	var _scope8: Dictionary = {"projectile": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Weapon.reload. reload() must be overridden in subclasses"])
	return null

func original_movementLocked():
	var _scope9: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Weapon.movementLocked. movementLocked() must be overridden in subclasses"])
	return null

func original_update(_arg0 = null):
	var _scope10: Dictionary = {"deltaTime": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Weapon.update. update() must be overridden in subclasses"])
	return null

func original_done():
	var _scope11: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Weapon.done. done() must be overridden in subclasses"])
	return null

func original_isDefault():
	var _scope12: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Weapon.isDefault. isDefault() must be overridden in subclasses"])
	return null

func original_setWeaponState(_arg0 = null):
	var _scope13: Dictionary = {"weaponState": _arg0}
	JS.set_property(self, "id", JS.invoke_method(_scope13["weaponState"], "getId", []))
	JS.set_property(self, "playerId", JS.invoke_method(_scope13["weaponState"], "getPlayerId", []))
	JS.set_property(self, "type", JS.invoke_method(_scope13["weaponState"], "getType", []))
	JS.invoke_method(self, "_setFields", [JS.invoke_method(_scope13["weaponState"], "getFields", [])])
	return null

func original_getWeaponState():
	var _scope14: Dictionary = {}
	return JS.invoke_method(JS.module("WeaponState"), "withState", [JS.get_property(self, "id"), JS.get_property(self, "playerId"), JS.get_property(self, "type"), JS.invoke_method("@JSON", "stringify", [JS.invoke_method(self, "getFields", [])])])
	return null

func original_getField(_arg0 = null):
	var _scope15: Dictionary = {"fieldName": _arg0}
	if JS.truthy(JS.invoke_method(JS.invoke_method(self, "classs", []), "hasOwnField", [JS.add("_", _scope15["fieldName"])])):
		return JS.get_property(self, JS.add("_", _scope15["fieldName"]))
	else:
		return null
	return null

func original_getFields():
	var _scope16: Dictionary = {"fields": null, "fieldsObj": null, "i": null}
	_scope16["fields"] = JS.invoke_method(JS.invoke_method(self, "classs", []), "listOwnFields", [])
	_scope16["fieldsObj"] = {}
	_scope16["i"] = 0
	while JS.truthy(JS.compare("<", _scope16["i"], JS.get_property(_scope16["fields"], "length"))):
		JS.set_property(_scope16["fieldsObj"], JS.get_property(_scope16["fields"], _scope16["i"]), JS.get_property(self, JS.get_property(_scope16["fields"], _scope16["i"])))
		JS.increment(_scope16, "i", 1, false)
	return _scope16["fieldsObj"]
	return null

func original__emitEvent(_arg0 = null, _arg1 = null):
	var _scope17: Dictionary = {"evt": _arg0, "data": _arg1}
	if JS.truthy(JS.logical("&&", func():
		var _scope18: Dictionary = {}
		return JS.get_property(self, "evtHandler")
		return null, func():
		var _scope19: Dictionary = {}
		return JS.get_property(self, "evtContext")
		return null)):
		JS.invoke_method(self, "evtHandler", [JS.get_property(self, "evtContext"), _scope17["evt"], _scope17["data"]])
	return null

func original__setFields(_arg0 = null):
	var _scope20: Dictionary = {"fieldsObj": _arg0, "fields": null, "i": null}
	_scope20["fields"] = JS.invoke_method(JS.invoke_method(self, "classs", []), "listOwnFields", [])
	_scope20["i"] = 0
	while JS.truthy(JS.compare("<", _scope20["i"], JS.get_property(_scope20["fields"], "length"))):
		JS.set_property(self, JS.get_property(_scope20["fields"], _scope20["i"]), JS.get_property(_scope20["fieldsObj"], JS.get_property(_scope20["fields"], _scope20["i"])))
		JS.increment(_scope20, "i", 1, false)
	return null

static func original_createInitialWeaponState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope21: Dictionary = {"id": _arg0, "playerId": _arg1, "type": _arg2, "fieldsJSON": _arg3, "weaponState": null}
	_scope21["weaponState"] = JS.invoke_method(JS.module("WeaponState"), "withState", [_scope21["id"], _scope21["playerId"], _scope21["type"], _scope21["fieldsJSON"]])
	return _scope21["weaponState"]
	return null
