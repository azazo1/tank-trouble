# 由原版 Zone 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var id = null
var type = 0
var tiles = []
var b2dbody = null
var roundModel = null
var evtHandler = null
var evtContext = null
var log = null
static var _static_Zone: Dictionary = {}
static var _initialized_Zone = false
static func initialize_original_static():
	if _initialized_Zone: return
	_initialized_Zone = true
	_static_Zone["_EVENTS"] = {"ZONE_ENTERED": "zone entered", "ZONE_LEFT": "zone left", "ZONE_DESTABILIZED": "zone destabilized"}
static func original_static_get(key):
	initialize_original_static()
	if _static_Zone.has(key): return _static_Zone[key]
	return null
static func original_static_set(key, value):
	_static_Zone[key] = value
	return value
func original_own_fields():
	return ["id","type","tiles","b2dbody","roundModel","evtHandler","evtContext","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"zoneState": _arg0, "roundModel": _arg1, "evtHandler": _arg2, "evtContext": _arg3}
	JS.invoke_method(self, "setZoneState", [_scope0["zoneState"]])
	JS.set_property(self, "roundModel", _scope0["roundModel"])
	JS.set_property(self, "evtHandler", _scope0["evtHandler"])
	JS.set_property(self, "evtContext", _scope0["evtContext"])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["Counter"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/match/zone.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3)
	return instance

func original_getId():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "id")
	return null

func original_getType():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "type")
	return null

func original_getTiles():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "tiles")
	return null

func original_setB2DBody(_arg0 = null):
	var _scope4: Dictionary = {"b2dbody": _arg0}
	JS.set_property(self, "b2dbody", _scope4["b2dbody"])
	return null

func original_getB2DBody():
	var _scope5: Dictionary = {}
	return JS.get_property(self, "b2dbody")
	return null

func original_update(_arg0 = null):
	var _scope6: Dictionary = {"deltaTime": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Zone.update. update() must be overridden in subclasses"])
	return null

func original_done():
	var _scope7: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Zone.done. done() must be overridden in subclasses"])
	return null

func original_isPhysical():
	var _scope8: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Zone.isPhysical. isPhysical() must be overridden in subclasses"])
	return null

func original_setZoneState(_arg0 = null):
	var _scope9: Dictionary = {"zoneState": _arg0}
	JS.set_property(self, "id", JS.invoke_method(_scope9["zoneState"], "getId", []))
	JS.set_property(self, "type", JS.invoke_method(_scope9["zoneState"], "getType", []))
	JS.set_property(self, "tiles", JS.invoke_method(_scope9["zoneState"], "getTiles", []))
	JS.invoke_method(self, "_setFields", [JS.invoke_method(_scope9["zoneState"], "getFields", [])])
	return null

func original_getZoneState():
	var _scope10: Dictionary = {}
	return JS.invoke_method(JS.module("ZoneState"), "withState", [JS.get_property(self, "id"), JS.get_property(self, "type"), JS.get_property(self, "tiles"), JS.invoke_method("@JSON", "stringify", [JS.invoke_method(self, "getFields", [])])])
	return null

func original_getField(_arg0 = null):
	var _scope11: Dictionary = {"fieldName": _arg0}
	if JS.truthy(JS.invoke_method(JS.invoke_method(self, "classs", []), "hasOwnField", [JS.add("_", _scope11["fieldName"])])):
		return JS.get_property(self, JS.add("_", _scope11["fieldName"]))
	else:
		return null
	return null

func original_getFields():
	var _scope12: Dictionary = {"fields": null, "fieldsObj": null, "i": null}
	_scope12["fields"] = JS.invoke_method(JS.invoke_method(self, "classs", []), "listOwnFields", [])
	_scope12["fieldsObj"] = {}
	_scope12["i"] = 0
	while JS.truthy(JS.compare("<", _scope12["i"], JS.get_property(_scope12["fields"], "length"))):
		JS.set_property(_scope12["fieldsObj"], JS.get_property(_scope12["fields"], _scope12["i"]), JS.get_property(self, JS.get_property(_scope12["fields"], _scope12["i"])))
		JS.increment(_scope12, "i", 1, false)
	return _scope12["fieldsObj"]
	return null

func original__emitEvent(_arg0 = null, _arg1 = null):
	var _scope13: Dictionary = {"evt": _arg0, "data": _arg1}
	if JS.truthy(JS.logical("&&", func():
		var _scope14: Dictionary = {}
		return JS.get_property(self, "evtHandler")
		return null, func():
		var _scope15: Dictionary = {}
		return JS.get_property(self, "evtContext")
		return null)):
		JS.invoke_method(self, "evtHandler", [JS.get_property(self, "evtContext"), _scope13["evt"], _scope13["data"]])
	return null

func original__setFields(_arg0 = null):
	var _scope16: Dictionary = {"fieldsObj": _arg0, "fields": null, "i": null}
	_scope16["fields"] = JS.invoke_method(JS.invoke_method(self, "classs", []), "listOwnFields", [])
	_scope16["i"] = 0
	while JS.truthy(JS.compare("<", _scope16["i"], JS.get_property(_scope16["fields"], "length"))):
		JS.set_property(self, JS.get_property(_scope16["fields"], _scope16["i"]), JS.get_property(_scope16["fieldsObj"], JS.get_property(_scope16["fields"], _scope16["i"])))
		JS.increment(_scope16, "i", 1, false)
	return null

static func original_createInitialZoneState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope17: Dictionary = {"id": _arg0, "type": _arg1, "tiles": _arg2, "fieldsJSON": _arg3, "zoneState": null}
	_scope17["zoneState"] = JS.invoke_method(JS.module("ZoneState"), "withState", [_scope17["id"], _scope17["type"], _scope17["tiles"], _scope17["fieldsJSON"]])
	return _scope17["zoneState"]
	return null
