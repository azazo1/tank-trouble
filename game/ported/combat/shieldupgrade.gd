# 由原版 ShieldUpgrade 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/upgrade.gd"

var _lifetime = 0
var _weakened = false
static var _static_ShieldUpgrade: Dictionary = {}
static var _initialized_ShieldUpgrade = false
static func initialize_original_static():
	if _initialized_ShieldUpgrade: return
	_initialized_ShieldUpgrade = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_ShieldUpgrade.has(key): return _static_ShieldUpgrade[key]
	return JS.get_property(JS.module("Upgrade"), key)
static func original_static_set(key, value):
	_static_ShieldUpgrade[key] = value
	return value
func original_own_fields():
	return ["_lifetime","_weakened"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/shieldupgrade.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

func original_update(_arg0 = null):
	var _scope0: Dictionary = {"deltaTime": _arg0}
	JS.set_property(self, "_lifetime", (JS.number(JS.get_property(self, "_lifetime")) - JS.number(_scope0["deltaTime"])))
	if JS.truthy((not JS.truthy(JS.get_property(self, "_weakened")))):
		if JS.truthy(JS.compare("<=", JS.get_property(self, "_lifetime"), JS.get_property(JS.module("Constants"), "SHIELD_WEAKEN_TIME"))):
			JS.set_property(self, "_weakened", true)
			JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_WEAKENED"), JS.get_property(self, "id")])
	return null

func original_done():
	var _scope1: Dictionary = {}
	return JS.compare("<=", JS.get_property(self, "_lifetime"), 0)
	return null

static func original_createInitialUpgradeState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null):
	var _scope2: Dictionary = {"id": _arg0, "playerId": _arg1, "lifetime": _arg2, "fields": null}
	_scope2["fields"] = {"_lifetime": _scope2["lifetime"], "_weakened": false}
	return JS.invoke_method(JS.module("Upgrade"), "createInitialUpgradeState", [_scope2["id"], _scope2["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SHIELD"), JS.invoke_method("@JSON", "stringify", [_scope2["fields"]])])
	return null
