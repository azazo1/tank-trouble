# 由原版 Trap 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var id = null
var playerId = null
var type = 0
var x = 0
var y = 0
var speedX = 0
var speedY = 0
var b2dbody = null
var roundModel = null
var timeAlive = 0
var evtHandler = null
var evtContext = null
var log = null
static var _static_Trap: Dictionary = {}
static var _initialized_Trap = false
static func initialize_original_static():
	if _initialized_Trap: return
	_initialized_Trap = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Trap.has(key): return _static_Trap[key]
	return null
static func original_static_set(key, value):
	_static_Trap[key] = value
	return value
func original_own_fields():
	return ["id","playerId","type","x","y","speedX","speedY","b2dbody","roundModel","timeAlive","evtHandler","evtContext","log"]
func original_is_weak_field(key):
	return ["roundModel","evtContext"].has(key) or super.original_is_weak_field(key)

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"trapState": _arg0, "roundModel": _arg1, "evtHandler": _arg2, "evtContext": _arg3}
	JS.invoke_method(self, "setTrapState", [_scope0["trapState"]])
	JS.sequence([JS.set_property(self, "timeAlive", 0), JS.set_property(self, "roundModel", _scope0["roundModel"])])
	JS.set_property(self, "evtHandler", _scope0["evtHandler"])
	JS.set_property(self, "evtContext", _scope0["evtContext"])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["Trap"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/trap.gd").new()
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

func original_setX(_arg0 = null):
	var _scope4: Dictionary = {"x": _arg0}
	JS.set_property(self, "x", _scope4["x"])
	return null

func original_getX():
	var _scope5: Dictionary = {}
	return JS.get_property(self, "x")
	return null

func original_setY(_arg0 = null):
	var _scope6: Dictionary = {"y": _arg0}
	JS.set_property(self, "y", _scope6["y"])
	return null

func original_getY():
	var _scope7: Dictionary = {}
	return JS.get_property(self, "y")
	return null

func original_setSpeedX(_arg0 = null):
	var _scope8: Dictionary = {"speedX": _arg0}
	JS.set_property(self, "speedX", _scope8["speedX"])
	return null

func original_getSpeedX():
	var _scope9: Dictionary = {}
	return JS.get_property(self, "speedX")
	return null

func original_setSpeedY(_arg0 = null):
	var _scope10: Dictionary = {"speedY": _arg0}
	JS.set_property(self, "speedY", _scope10["speedY"])
	return null

func original_getSpeedY():
	var _scope11: Dictionary = {}
	return JS.get_property(self, "speedY")
	return null

func original_setB2DBody(_arg0 = null):
	var _scope12: Dictionary = {"b2dbody": _arg0}
	JS.set_property(self, "b2dbody", _scope12["b2dbody"])
	return null

func original_getB2DBody():
	var _scope13: Dictionary = {}
	return JS.get_property(self, "b2dbody")
	return null

func original_getTimeAlive():
	var _scope14: Dictionary = {}
	return JS.get_property(self, "timeAlive")
	return null

func original_update(_arg0 = null):
	var _scope15: Dictionary = {"deltaTime": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Trap.update. update() must be overridden in subclasses"])
	return null

func original_trip(_arg0 = null, _arg1 = null):
	var _scope16: Dictionary = {"playerId": _arg0, "entered": _arg1}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Trap.trip. trip() must be overridden in subclasses"])
	return null

func original_released():
	var _scope17: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Trap.released. released() must be overridden in subclasses"])
	return null

func original_getProjectileStates(_arg0 = null):
	var _scope18: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Trap.getProjectileStates. getProjectileStates() must be overridden in subclasses"])
	return null

func original_done():
	var _scope19: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call Trap.done. done() must be overridden in subclasses"])
	return null

func original_setTrapState(_arg0 = null):
	var _scope20: Dictionary = {"trapState": _arg0}
	JS.set_property(self, "id", JS.invoke_method(_scope20["trapState"], "getId", []))
	JS.set_property(self, "playerId", JS.invoke_method(_scope20["trapState"], "getPlayerId", []))
	JS.set_property(self, "x", JS.invoke_method(_scope20["trapState"], "getX", []))
	JS.set_property(self, "y", JS.invoke_method(_scope20["trapState"], "getY", []))
	JS.set_property(self, "speedX", JS.invoke_method(_scope20["trapState"], "getSpeedX", []))
	JS.set_property(self, "speedY", JS.invoke_method(_scope20["trapState"], "getSpeedY", []))
	JS.set_property(self, "type", JS.invoke_method(_scope20["trapState"], "getType", []))
	JS.invoke_method(self, "_setFields", [JS.invoke_method(_scope20["trapState"], "getFields", [])])
	if JS.truthy(JS.get_property(self, "b2dbody")):
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(self, "x"), JS.get_property(self, "y")])])
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetLinearVelocity", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(self, "speedX"), JS.get_property(self, "speedY")])])
	return null

func original_getTrapState():
	var _scope21: Dictionary = {"ts": null}
	_scope21["ts"] = JS.invoke_method(JS.module("TrapState"), "withState", [JS.get_property(self, "id"), JS.get_property(self, "playerId"), JS.get_property(self, "type"), JS.get_property(self, "x"), JS.get_property(self, "y"), JS.get_property(self, "speedX"), JS.get_property(self, "speedY"), JS.invoke_method("@JSON", "stringify", [JS.invoke_method(self, "getFields", [])])])
	return _scope21["ts"]
	return null

func original_getField(_arg0 = null):
	var _scope22: Dictionary = {"fieldName": _arg0}
	if JS.truthy(JS.invoke_method(JS.invoke_method(self, "classs", []), "hasOwnField", [JS.add("_", _scope22["fieldName"])])):
		return JS.get_property(self, JS.add("_", _scope22["fieldName"]))
	else:
		return null
	return null

func original_getFields():
	var _scope23: Dictionary = {"fields": null, "fieldsObj": null, "i": null}
	_scope23["fields"] = JS.invoke_method(JS.invoke_method(self, "classs", []), "listOwnFields", [])
	_scope23["fieldsObj"] = {}
	_scope23["i"] = 0
	while JS.truthy(JS.compare("<", _scope23["i"], JS.get_property(_scope23["fields"], "length"))):
		JS.set_property(_scope23["fieldsObj"], JS.get_property(_scope23["fields"], _scope23["i"]), JS.get_property(self, JS.get_property(_scope23["fields"], _scope23["i"])))
		JS.increment(_scope23, "i", 1, false)
	return _scope23["fieldsObj"]
	return null

func original__emitEvent(_arg0 = null, _arg1 = null):
	var _scope24: Dictionary = {"evt": _arg0, "data": _arg1}
	if JS.truthy(JS.logical("&&", func():
		var _scope25: Dictionary = {}
		return JS.get_property(self, "evtHandler")
		return null, func():
		var _scope26: Dictionary = {}
		return JS.get_property(self, "evtContext")
		return null)):
		JS.invoke_method(self, "evtHandler", [JS.get_property(self, "evtContext"), _scope24["evt"], _scope24["data"]])
	return null

func original__setFields(_arg0 = null):
	var _scope27: Dictionary = {"fieldsObj": _arg0, "fields": null, "i": null}
	_scope27["fields"] = JS.invoke_method(JS.invoke_method(self, "classs", []), "listOwnFields", [])
	_scope27["i"] = 0
	while JS.truthy(JS.compare("<", _scope27["i"], JS.get_property(_scope27["fields"], "length"))):
		JS.set_property(self, JS.get_property(_scope27["fields"], _scope27["i"]), JS.get_property(_scope27["fieldsObj"], JS.get_property(_scope27["fields"], _scope27["i"])))
		JS.increment(_scope27, "i", 1, false)
	return null

static func original_createInitialTrapState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null):
	var _scope28: Dictionary = {"id": _arg0, "playerId": _arg1, "type": _arg2, "x": _arg3, "y": _arg4, "speedX": _arg5, "speedY": _arg6, "fieldsJSON": _arg7, "trapState": null}
	_scope28["trapState"] = JS.invoke_method(JS.module("TrapState"), "withState", [_scope28["id"], _scope28["playerId"], _scope28["type"], _scope28["x"], _scope28["y"], _scope28["speedX"], _scope28["speedY"], _scope28["fieldsJSON"]])
	return _scope28["trapState"]
	return null
