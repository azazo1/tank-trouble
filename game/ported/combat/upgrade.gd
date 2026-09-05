# 由原版 Upgrade 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var id = null
var playerId = null
var type = 0
var roundModel = null
var evtHandler = null
var evtContext = null
var log = null
static var _static_Upgrade: Dictionary = {}
static var _initialized_Upgrade = false
static func initialize_original_static():
	if _initialized_Upgrade: return
	_initialized_Upgrade = true
	_static_Upgrade["_EVENTS"] = {"UPGRADE_ACTIVATED": "upgrade activated", "UPGRADE_WEAKENED": "upgrade weakened", "UPGRADE_STRENGTHENED": "upgrade strengthened"}
static func original_static_get(key):
	initialize_original_static()
	if _static_Upgrade.has(key): return _static_Upgrade[key]
	return null
static func original_static_set(key, value):
	_static_Upgrade[key] = value
	return value
func original_own_fields():
	return ["id","playerId","type","roundModel","evtHandler","evtContext","log"]
func original_is_weak_field(key):
	return ["roundModel","evtContext"].has(key) or super.original_is_weak_field(key)

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"upgradeState": _arg0, "roundModel": _arg1, "evtHandler": _arg2, "evtContext": _arg3}
	JS.invoke_method(self, "setUpgradeState", [_scope0["upgradeState"]])
	JS.set_property(self, "roundModel", _scope0["roundModel"])
	JS.set_property(self, "evtHandler", _scope0["evtHandler"])
	JS.set_property(self, "evtContext", _scope0["evtContext"])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["Upgrade"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/combat/upgrade.gd").new()
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

func original_update(_arg0 = null):
	var _scope4: Dictionary = {"deltaTime": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Upgrade.update. update() must be overridden in subclasses"])
	return null

func original_done():
	var _scope5: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Upgrade.done. done() must be overridden in subclasses"])
	return null

func original_setUpgradeState(_arg0 = null):
	var _scope6: Dictionary = {"upgradeState": _arg0}
	JS.set_property(self, "id", JS.invoke_method(_scope6["upgradeState"], "getId", []))
	JS.set_property(self, "playerId", JS.invoke_method(_scope6["upgradeState"], "getPlayerId", []))
	JS.set_property(self, "type", JS.invoke_method(_scope6["upgradeState"], "getType", []))
	JS.invoke_method(self, "_setFields", [JS.invoke_method(_scope6["upgradeState"], "getFields", [])])
	return null

func original_getUpgradeState():
	var _scope7: Dictionary = {}
	return JS.invoke_method(JS.module("UpgradeState"), "withState", [JS.get_property(self, "id"), JS.get_property(self, "playerId"), JS.get_property(self, "type"), JS.invoke_method("@JSON", "stringify", [JS.invoke_method(self, "getFields", [])])])
	return null

func original_getField(_arg0 = null):
	var _scope8: Dictionary = {"fieldName": _arg0}
	if JS.truthy(JS.invoke_method(JS.invoke_method(self, "classs", []), "hasOwnField", [JS.add("_", _scope8["fieldName"])])):
		return JS.get_property(self, JS.add("_", _scope8["fieldName"]))
	else:
		return null
	return null

func original_getFields():
	var _scope9: Dictionary = {"fields": null, "fieldsObj": null, "i": null}
	_scope9["fields"] = JS.invoke_method(JS.invoke_method(self, "classs", []), "listOwnFields", [])
	_scope9["fieldsObj"] = {}
	_scope9["i"] = 0
	while JS.truthy(JS.compare("<", _scope9["i"], JS.get_property(_scope9["fields"], "length"))):
		JS.set_property(_scope9["fieldsObj"], JS.get_property(_scope9["fields"], _scope9["i"]), JS.get_property(self, JS.get_property(_scope9["fields"], _scope9["i"])))
		JS.increment(_scope9, "i", 1, false)
	return _scope9["fieldsObj"]
	return null

func original__emitEvent(_arg0 = null, _arg1 = null):
	var _scope10: Dictionary = {"evt": _arg0, "data": _arg1}
	if JS.truthy(JS.logical("&&", func():
		var _scope11: Dictionary = {}
		return JS.get_property(self, "evtHandler")
		return null, func():
		var _scope12: Dictionary = {}
		return JS.get_property(self, "evtContext")
		return null)):
		JS.invoke_method(self, "evtHandler", [JS.get_property(self, "evtContext"), _scope10["evt"], _scope10["data"]])
	return null

func original__setFields(_arg0 = null):
	var _scope13: Dictionary = {"fieldsObj": _arg0, "fields": null, "i": null}
	_scope13["fields"] = JS.invoke_method(JS.invoke_method(self, "classs", []), "listOwnFields", [])
	_scope13["i"] = 0
	while JS.truthy(JS.compare("<", _scope13["i"], JS.get_property(_scope13["fields"], "length"))):
		JS.set_property(self, JS.get_property(_scope13["fields"], _scope13["i"]), JS.get_property(_scope13["fieldsObj"], JS.get_property(_scope13["fields"], _scope13["i"])))
		JS.increment(_scope13, "i", 1, false)
	return null

static func original_createInitialUpgradeState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null):
	var _scope14: Dictionary = {"id": _arg0, "playerId": _arg1, "type": _arg2, "fieldsJSON": _arg3, "upgradeState": null}
	_scope14["upgradeState"] = JS.invoke_method(JS.module("UpgradeState"), "withState", [_scope14["id"], _scope14["playerId"], _scope14["type"], _scope14["fieldsJSON"]])
	return _scope14["upgradeState"]
	return null
