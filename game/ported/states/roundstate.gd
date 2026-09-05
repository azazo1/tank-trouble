# 由原版 RoundState 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var data = {"tankStates": [], "projectileStates": [], "trapStates": [], "collectibleStates": [], "weaponStates": [], "upgradeStates": [], "counterStates": [], "zoneStates": []}
var cachedTankStates = null
var cachedProjectileStates = null
var cachedTrapStates = null
var cachedCollectibleStates = null
var cachedWeaponStates = null
var cachedUpgradeStates = null
var cachedCounterStates = null
var cachedZoneStates = null
static var _static_RoundState: Dictionary = {}
static var _initialized_RoundState = false
static func initialize_original_static():
	if _initialized_RoundState: return
	_initialized_RoundState = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_RoundState.has(key): return _static_RoundState[key]
	return null
static func original_static_set(key, value):
	_static_RoundState[key] = value
	return value
func original_own_fields():
	return ["data","cachedTankStates","cachedProjectileStates","cachedTrapStates","cachedCollectibleStates","cachedWeaponStates","cachedUpgradeStates","cachedCounterStates","cachedZoneStates"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {}
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/states/roundstate.gd").new()
	instance._construct_create()
	return instance

func _construct_withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var _scope1: Dictionary = {"tankStates": _arg0, "projectileStates": _arg1, "trapStates": _arg2, "collectibleStates": _arg3, "weaponStates": _arg4, "upgradeStates": _arg5, "counterStates": _arg6, "zoneStates": _arg7}
	JS.set_property(JS.get_property(self, "data"), "tankStates", _scope1["tankStates"])
	JS.set_property(JS.get_property(self, "data"), "projectileStates", _scope1["projectileStates"])
	JS.set_property(JS.get_property(self, "data"), "trapStates", _scope1["trapStates"])
	JS.set_property(JS.get_property(self, "data"), "collectibleStates", _scope1["collectibleStates"])
	JS.set_property(JS.get_property(self, "data"), "weaponStates", _scope1["weaponStates"])
	JS.set_property(JS.get_property(self, "data"), "upgradeStates", _scope1["upgradeStates"])
	JS.set_property(JS.get_property(self, "data"), "counterStates", _scope1["counterStates"])
	JS.set_property(JS.get_property(self, "data"), "zoneStates", _scope1["zoneStates"])
	return null
static func withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var instance = load("res://game/ported/states/roundstate.gd").new()
	instance._construct_withState(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7)
	return instance

func _construct_withObject(_arg0 = null):
	var _scope2: Dictionary = {"obj": _arg0}
	JS.set_property(self, "data", _scope2["obj"])
	return null
static func withObject(_arg0 = null):
	var instance = load("res://game/ported/states/roundstate.gd").new()
	instance._construct_withObject(_arg0)
	return instance

func original_getTankStates():
	var _scope3: Dictionary = {"tankStates": null, "i": null}
	if JS.truthy(JS.get_property(self, "cachedTankStates")):
		return JS.get_property(self, "cachedTankStates")
	_scope3["tankStates"] = []
	_scope3["i"] = 0
	while JS.truthy(JS.compare("<", _scope3["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "tankStates"), "length"))):
		JS.invoke_method(_scope3["tankStates"], "push", [JS.invoke_method(JS.module("TankState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "tankStates"), _scope3["i"])])])
		JS.increment(_scope3, "i", 1, false)
	JS.set_property(self, "cachedTankStates", _scope3["tankStates"])
	return _scope3["tankStates"]
	return null

func original_setTankStates(_arg0 = null):
	var _scope4: Dictionary = {"tankStates": _arg0, "i": null}
	JS.set_property(self, "cachedTankStates", _scope4["tankStates"])
	JS.set_property(JS.get_property(self, "data"), "tankStates", [])
	_scope4["i"] = 0
	while JS.truthy(JS.compare("<", _scope4["i"], JS.get_property(_scope4["tankStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "tankStates"), "push", [JS.invoke_method(JS.get_property(_scope4["tankStates"], _scope4["i"]), "toObj", [])])
		JS.increment(_scope4, "i", 1, false)
	return null

func original_getProjectileStates(_arg0 = null):
	var _scope5: Dictionary = {"projectileStates": null, "i": null}
	if JS.truthy(JS.get_property(self, "cachedProjectileStates")):
		return JS.get_property(self, "cachedProjectileStates")
	_scope5["projectileStates"] = []
	_scope5["i"] = 0
	while JS.truthy(JS.compare("<", _scope5["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "projectileStates"), "length"))):
		JS.invoke_method(_scope5["projectileStates"], "push", [JS.invoke_method(JS.module("ProjectileState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "projectileStates"), _scope5["i"])])])
		JS.increment(_scope5, "i", 1, false)
	JS.set_property(self, "projectileStates", _scope5["projectileStates"])
	return _scope5["projectileStates"]
	return null

func original_setProjectileStates(_arg0 = null):
	var _scope6: Dictionary = {"projectileStates": _arg0, "i": null}
	JS.set_property(self, "cachedProjectileStates", _scope6["projectileStates"])
	JS.set_property(JS.get_property(self, "data"), "projectileStates", [])
	_scope6["i"] = 0
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["projectileStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "projectileStates"), "push", [JS.invoke_method(JS.get_property(_scope6["projectileStates"], _scope6["i"]), "toObj", [])])
		JS.increment(_scope6, "i", 1, false)
	return null

func original_getTrapStates(_arg0 = null):
	var _scope7: Dictionary = {"trapStates": null, "i": null}
	if JS.truthy(JS.get_property(self, "cachedTrapStates")):
		return JS.get_property(self, "cachedTrapStates")
	_scope7["trapStates"] = []
	_scope7["i"] = 0
	while JS.truthy(JS.compare("<", _scope7["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "trapStates"), "length"))):
		JS.invoke_method(_scope7["trapStates"], "push", [JS.invoke_method(JS.module("TrapState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "trapStates"), _scope7["i"])])])
		JS.increment(_scope7, "i", 1, false)
	JS.set_property(self, "trapStates", _scope7["trapStates"])
	return _scope7["trapStates"]
	return null

func original_setTrapStates(_arg0 = null):
	var _scope8: Dictionary = {"trapStates": _arg0, "i": null}
	JS.set_property(self, "cachedTrapStates", _scope8["trapStates"])
	JS.set_property(JS.get_property(self, "data"), "trapStates", [])
	_scope8["i"] = 0
	while JS.truthy(JS.compare("<", _scope8["i"], JS.get_property(_scope8["trapStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "trapStates"), "push", [JS.invoke_method(JS.get_property(_scope8["trapStates"], _scope8["i"]), "toObj", [])])
		JS.increment(_scope8, "i", 1, false)
	return null

func original_getCollectibleStates():
	var _scope9: Dictionary = {"collectibleStates": null, "i": null}
	if JS.truthy(JS.get_property(self, "cachedCollectibleStates")):
		return JS.get_property(self, "cachedCollectibleStates")
	_scope9["collectibleStates"] = []
	_scope9["i"] = 0
	while JS.truthy(JS.compare("<", _scope9["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "collectibleStates"), "length"))):
		JS.invoke_method(_scope9["collectibleStates"], "push", [JS.invoke_method(JS.module("CollectibleState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "collectibleStates"), _scope9["i"])])])
		JS.increment(_scope9, "i", 1, false)
	JS.set_property(self, "cachedCollectibleStates", _scope9["collectibleStates"])
	return _scope9["collectibleStates"]
	return null

func original_setCollectibleStates(_arg0 = null):
	var _scope10: Dictionary = {"collectibleStates": _arg0, "i": null}
	JS.set_property(self, "cachedCollectibleStates", _scope10["collectibleStates"])
	JS.set_property(JS.get_property(self, "data"), "collectibleStates", [])
	_scope10["i"] = 0
	while JS.truthy(JS.compare("<", _scope10["i"], JS.get_property(_scope10["collectibleStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "collectibleStates"), "push", [JS.invoke_method(JS.get_property(_scope10["collectibleStates"], _scope10["i"]), "toObj", [])])
		JS.increment(_scope10, "i", 1, false)
	return null

func original_getWeaponStates():
	var _scope11: Dictionary = {"weaponStates": null, "i": null}
	if JS.truthy(JS.get_property(self, "cachedWeaponStates")):
		return JS.get_property(self, "cachedWeaponStates")
	_scope11["weaponStates"] = []
	_scope11["i"] = 0
	while JS.truthy(JS.compare("<", _scope11["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "weaponStates"), "length"))):
		JS.invoke_method(_scope11["weaponStates"], "push", [JS.invoke_method(JS.module("WeaponState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "weaponStates"), _scope11["i"])])])
		JS.increment(_scope11, "i", 1, false)
	JS.set_property(self, "cachedWeaponStates", _scope11["weaponStates"])
	return _scope11["weaponStates"]
	return null

func original_setWeaponStates(_arg0 = null):
	var _scope12: Dictionary = {"weaponStates": _arg0, "i": null}
	JS.set_property(self, "cachedWeaponStates", _scope12["weaponStates"])
	JS.set_property(JS.get_property(self, "data"), "weaponStates", [])
	_scope12["i"] = 0
	while JS.truthy(JS.compare("<", _scope12["i"], JS.get_property(_scope12["weaponStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "weaponStates"), "push", [JS.invoke_method(JS.get_property(_scope12["weaponStates"], _scope12["i"]), "toObj", [])])
		JS.increment(_scope12, "i", 1, false)
	return null

func original_getUpgradeStates():
	var _scope13: Dictionary = {"upgradeStates": null, "i": null}
	if JS.truthy(JS.get_property(self, "cachedUpgradeStates")):
		return JS.get_property(self, "cachedUpgradeStates")
	_scope13["upgradeStates"] = []
	_scope13["i"] = 0
	while JS.truthy(JS.compare("<", _scope13["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "upgradeStates"), "length"))):
		JS.invoke_method(_scope13["upgradeStates"], "push", [JS.invoke_method(JS.module("UpgradeState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "upgradeStates"), _scope13["i"])])])
		JS.increment(_scope13, "i", 1, false)
	JS.set_property(self, "cachedUpgradeStates", _scope13["upgradeStates"])
	return _scope13["upgradeStates"]
	return null

func original_setUpgradeStates(_arg0 = null):
	var _scope14: Dictionary = {"upgradeStates": _arg0, "i": null}
	JS.set_property(self, "cachedUpgradeStates", _scope14["upgradeStates"])
	JS.set_property(JS.get_property(self, "data"), "upgradeStates", [])
	_scope14["i"] = 0
	while JS.truthy(JS.compare("<", _scope14["i"], JS.get_property(_scope14["upgradeStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "upgradeStates"), "push", [JS.invoke_method(JS.get_property(_scope14["upgradeStates"], _scope14["i"]), "toObj", [])])
		JS.increment(_scope14, "i", 1, false)
	return null

func original_getCounterStates():
	var _scope15: Dictionary = {"counterStates": null, "i": null}
	if JS.truthy(JS.get_property(self, "cachedCounterStates")):
		return JS.get_property(self, "cachedCounterStates")
	_scope15["counterStates"] = []
	_scope15["i"] = 0
	while JS.truthy(JS.compare("<", _scope15["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "counterStates"), "length"))):
		JS.invoke_method(_scope15["counterStates"], "push", [JS.invoke_method(JS.module("CounterState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "counterStates"), _scope15["i"])])])
		JS.increment(_scope15, "i", 1, false)
	JS.set_property(self, "cachedCounterStates", _scope15["counterStates"])
	return _scope15["counterStates"]
	return null

func original_setCounterStates(_arg0 = null):
	var _scope16: Dictionary = {"counterStates": _arg0, "i": null}
	JS.set_property(self, "cachedCounterStates", _scope16["counterStates"])
	JS.set_property(JS.get_property(self, "data"), "counterStates", [])
	_scope16["i"] = 0
	while JS.truthy(JS.compare("<", _scope16["i"], JS.get_property(_scope16["counterStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "counterStates"), "push", [JS.invoke_method(JS.get_property(_scope16["counterStates"], _scope16["i"]), "toObj", [])])
		JS.increment(_scope16, "i", 1, false)
	return null

func original_getZoneStates():
	var _scope17: Dictionary = {"zoneStates": null, "i": null}
	if JS.truthy(JS.get_property(self, "cachedZoneStates")):
		return JS.get_property(self, "cachedZoneStates")
	_scope17["zoneStates"] = []
	_scope17["i"] = 0
	while JS.truthy(JS.compare("<", _scope17["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "zoneStates"), "length"))):
		JS.invoke_method(_scope17["zoneStates"], "push", [JS.invoke_method(JS.module("ZoneState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "zoneStates"), _scope17["i"])])])
		JS.increment(_scope17, "i", 1, false)
	JS.set_property(self, "cachedZoneStates", _scope17["zoneStates"])
	return _scope17["zoneStates"]
	return null

func original_setZoneStates(_arg0 = null):
	var _scope18: Dictionary = {"zoneStates": _arg0, "i": null}
	JS.set_property(self, "cachedZoneStates", _scope18["zoneStates"])
	JS.set_property(JS.get_property(self, "data"), "zoneStates", [])
	_scope18["i"] = 0
	while JS.truthy(JS.compare("<", _scope18["i"], JS.get_property(_scope18["zoneStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "zoneStates"), "push", [JS.invoke_method(JS.get_property(_scope18["zoneStates"], _scope18["i"]), "toObj", [])])
		JS.increment(_scope18, "i", 1, false)
	return null

func original_isExpanded():
	var _scope19: Dictionary = {}
	return JS.logical("||", func():
		var _scope20: Dictionary = {}
		return JS.logical("||", func():
			var _scope21: Dictionary = {}
			return JS.logical("||", func():
				var _scope22: Dictionary = {}
				return JS.compare(">", JS.get_property(JS.get_property(JS.get_property(self, "data"), "weaponStates"), "length"), 0)
				return null, func():
				var _scope23: Dictionary = {}
				return JS.compare(">", JS.get_property(JS.get_property(JS.get_property(self, "data"), "upgradeStates"), "length"), 0)
				return null)
			return null, func():
			var _scope24: Dictionary = {}
			return JS.compare(">", JS.get_property(JS.get_property(JS.get_property(self, "data"), "counterStates"), "length"), 0)
			return null)
		return null, func():
		var _scope25: Dictionary = {}
		return JS.compare(">", JS.get_property(JS.get_property(JS.get_property(self, "data"), "zoneStates"), "length"), 0)
		return null)
	return null

func original_toObj():
	var _scope26: Dictionary = {}
	return JS.get_property(self, "data")
	return null
