# 由原版 LaserAimerUpgrade 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/upgrade.gd"

var _activated = false
var _weaponId = 0
var _length = 0
static var _static_LaserAimerUpgrade: Dictionary = {}
static var _initialized_LaserAimerUpgrade = false
static func initialize_original_static():
	if _initialized_LaserAimerUpgrade: return
	_initialized_LaserAimerUpgrade = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_LaserAimerUpgrade.has(key): return _static_LaserAimerUpgrade[key]
	return JS.get_property(JS.module("Upgrade"), key)
static func original_static_set(key, value):
	_static_LaserAimerUpgrade[key] = value
	return value
func original_own_fields():
	return ["_activated","_weaponId","_length"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/laseraimerupgrade.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

func original_update(_arg0 = null):
	var _scope0: Dictionary = {"deltaTime": _arg0, "activeWeapon": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "_activated")))):
		_scope0["activeWeapon"] = JS.invoke_method(JS.get_property(self, "roundModel"), "getActiveWeapon", [JS.get_property(self, "playerId")])
		if JS.truthy(JS.logical("&&", func():
			var _scope1: Dictionary = {}
			return _scope0["activeWeapon"]
			return null, func():
			var _scope2: Dictionary = {}
			return JS.equal(JS.invoke_method(_scope0["activeWeapon"], "getId", []), JS.get_property(self, "_weaponId"), true)
			return null)):
			JS.set_property(self, "_activated", true)
			JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_ACTIVATED"), JS.get_property(self, "id")])
	return null

func original_done():
	var _scope3: Dictionary = {"activeWeapon": null}
	if JS.truthy(JS.get_property(self, "_activated")):
		_scope3["activeWeapon"] = JS.invoke_method(JS.get_property(self, "roundModel"), "getActiveWeapon", [JS.get_property(self, "playerId")])
		if JS.truthy(JS.logical("&&", func():
			var _scope4: Dictionary = {}
			return _scope3["activeWeapon"]
			return null, func():
			var _scope5: Dictionary = {}
			return JS.logical("||", func():
				var _scope6: Dictionary = {}
				return JS.invoke_method(_scope3["activeWeapon"], "getField", ["fired"])
				return null, func():
				var _scope7: Dictionary = {}
				return not JS.equal(JS.invoke_method(_scope3["activeWeapon"], "getId", []), JS.get_property(self, "_weaponId"), true)
				return null)
			return null)):
			return true
	return false
	return null

static func original_createInitialUpgradeState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null):
	var _scope8: Dictionary = {"id": _arg0, "playerId": _arg1, "weaponId": _arg2, "length": _arg3, "fields": null}
	_scope8["fields"] = {"_activated": false, "_weaponId": _scope8["weaponId"], "_length": _scope8["length"]}
	return JS.invoke_method(JS.module("Upgrade"), "createInitialUpgradeState", [_scope8["id"], _scope8["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "LASER_AIMER"), JS.invoke_method("@JSON", "stringify", [_scope8["fields"]])])
	return null
