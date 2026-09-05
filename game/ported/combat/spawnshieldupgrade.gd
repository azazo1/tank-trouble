# 由原版 SpawnShieldUpgrade 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/upgrade.gd"

var distSquared = 0
var _lifetime = 0
var _weakenDistanceSquared = 0
var _maxDistanceSquared = 0
var _x = 0
var _y = 0
var _weakened = false
static var _static_SpawnShieldUpgrade: Dictionary = {}
static var _initialized_SpawnShieldUpgrade = false
static func initialize_original_static():
	if _initialized_SpawnShieldUpgrade: return
	_initialized_SpawnShieldUpgrade = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_SpawnShieldUpgrade.has(key): return _static_SpawnShieldUpgrade[key]
	return JS.get_property(JS.module("Upgrade"), key)
static func original_static_set(key, value):
	_static_SpawnShieldUpgrade[key] = value
	return value
func original_own_fields():
	return ["distSquared","_lifetime","_weakenDistanceSquared","_maxDistanceSquared","_x","_y","_weakened"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/spawnshieldupgrade.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

func original_update(_arg0 = null):
	var _scope0: Dictionary = {"deltaTime": _arg0, "tank": null, "currentX": null, "currentY": null}
	JS.set_property(self, "_lifetime", (JS.number(JS.get_property(self, "_lifetime")) - JS.number(_scope0["deltaTime"])))
	_scope0["tank"] = JS.invoke_method(JS.get_property(self, "roundModel"), "getTank", [JS.get_property(self, "playerId")])
	JS.set_property(self, "distSquared", 0)
	if JS.truthy(_scope0["tank"]):
		_scope0["currentX"] = JS.invoke_method(_scope0["tank"], "getX", [])
		_scope0["currentY"] = JS.invoke_method(_scope0["tank"], "getY", [])
		JS.set_property(self, "distSquared", JS.add((JS.number((JS.number(_scope0["currentX"]) - JS.number(JS.get_property(self, "_x")))) * JS.number((JS.number(_scope0["currentX"]) - JS.number(JS.get_property(self, "_x"))))), (JS.number((JS.number(_scope0["currentY"]) - JS.number(JS.get_property(self, "_y")))) * JS.number((JS.number(_scope0["currentY"]) - JS.number(JS.get_property(self, "_y")))))))
	if JS.truthy((not JS.truthy(JS.get_property(self, "_weakened")))):
		if JS.truthy(JS.logical("||", func():
			var _scope1: Dictionary = {}
			return JS.compare("<=", JS.get_property(self, "_lifetime"), JS.get_property(JS.module("Constants"), "SPAWN_SHIELD_WEAKEN_TIME"))
			return null, func():
			var _scope2: Dictionary = {}
			return JS.compare(">", JS.get_property(self, "distSquared"), JS.get_property(self, "_weakenDistanceSquared"))
			return null)):
			JS.set_property(self, "_weakened", true)
			JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_WEAKENED"), JS.get_property(self, "id")])
	else:
		if JS.truthy(JS.logical("&&", func():
			var _scope3: Dictionary = {}
			return JS.compare(">", JS.get_property(self, "_lifetime"), JS.get_property(JS.module("Constants"), "SPAWN_SHIELD_WEAKEN_TIME"))
			return null, func():
			var _scope4: Dictionary = {}
			return JS.compare("<=", JS.get_property(self, "distSquared"), JS.get_property(self, "_weakenDistanceSquared"))
			return null)):
			JS.set_property(self, "_weakened", false)
			JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_STRENGTHENED"), JS.get_property(self, "id")])
	return null

func original_done():
	var _scope5: Dictionary = {}
	return JS.logical("||", func():
		var _scope6: Dictionary = {}
		return JS.compare("<=", JS.get_property(self, "_lifetime"), 0)
		return null, func():
		var _scope7: Dictionary = {}
		return JS.compare(">", JS.get_property(self, "distSquared"), JS.get_property(self, "_maxDistanceSquared"))
		return null)
	return null

static func original_createInitialUpgradeState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null):
	var _scope8: Dictionary = {"id": _arg0, "playerId": _arg1, "lifetime": _arg2, "weakenDistanceSquared": _arg3, "maxDistanceSquared": _arg4, "x": _arg5, "y": _arg6, "fields": null}
	_scope8["fields"] = {"_lifetime": _scope8["lifetime"], "_weakenDistanceSquared": _scope8["weakenDistanceSquared"], "_maxDistanceSquared": _scope8["maxDistanceSquared"], "_x": _scope8["x"], "_y": _scope8["y"], "_weakened": false}
	return JS.invoke_method(JS.module("Upgrade"), "createInitialUpgradeState", [_scope8["id"], _scope8["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SPAWN_SHIELD"), JS.invoke_method("@JSON", "stringify", [_scope8["fields"]])])
	return null
