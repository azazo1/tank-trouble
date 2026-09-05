# 由原版 Projectile 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var id = null
var playerId = null
var type = 0
var x = 0
var y = 0
var speedX = 0
var speedY = 0
var lifetime = 0
var timeoutWindow = 0
var timeoutBounceCount = 0
var b2dbody = null
var roundModel = null
var timeAlive = 0
var deadlyToOwner = false
var initialSpeedSquared = 0
var initialSpeed = 0
var stopped = false
var bounces = []
var evtHandler = null
var evtContext = null
var log = null
static var _static_Projectile: Dictionary = {}
static var _initialized_Projectile = false
static func initialize_original_static():
	if _initialized_Projectile: return
	_initialized_Projectile = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Projectile.has(key): return _static_Projectile[key]
	return null
static func original_static_set(key, value):
	_static_Projectile[key] = value
	return value
func original_own_fields():
	return ["id","playerId","type","x","y","speedX","speedY","lifetime","timeoutWindow","timeoutBounceCount","b2dbody","roundModel","timeAlive","deadlyToOwner","initialSpeedSquared","initialSpeed","stopped","bounces","evtHandler","evtContext","log"]
func original_is_weak_field(key):
	return ["roundModel","evtContext"].has(key) or super.original_is_weak_field(key)

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"projectileState": _arg0, "lifetime": _arg1, "timeoutWindow": _arg2, "timeoutBounceCount": _arg3, "roundModel": _arg4, "evtHandler": _arg5, "evtContext": _arg6}
	JS.invoke_method(self, "setProjectileState", [_scope0["projectileState"]])
	JS.set_property(self, "timeAlive", 0)
	JS.set_property(self, "lifetime", _scope0["lifetime"])
	JS.set_property(self, "timeoutWindow", _scope0["timeoutWindow"])
	JS.set_property(self, "timeoutBounceCount", _scope0["timeoutBounceCount"])
	JS.set_property(self, "deadlyToOwner", false)
	JS.set_property(self, "initialSpeedSquared", JS.add((JS.number(JS.get_property(self, "speedX")) * JS.number(JS.get_property(self, "speedX"))), (JS.number(JS.get_property(self, "speedY")) * JS.number(JS.get_property(self, "speedY")))))
	JS.set_property(self, "initialSpeed", JS.invoke_method("@Math", "sqrt", [JS.get_property(self, "initialSpeedSquared")]))
	JS.set_property(self, "stopped", false)
	JS.set_property(self, "bounces", [])
	JS.set_property(self, "roundModel", _scope0["roundModel"])
	JS.set_property(self, "evtHandler", _scope0["evtHandler"])
	JS.set_property(self, "evtContext", _scope0["evtContext"])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["Projectile"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/combat/projectile.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6)
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

func original_isDeadlyToOwner():
	var _scope14: Dictionary = {}
	return JS.get_property(self, "deadlyToOwner")
	return null

func original_makeDeadlyToOwner():
	var _scope15: Dictionary = {}
	JS.set_property(self, "deadlyToOwner", true)
	return null

func original_getTimeAlive():
	var _scope16: Dictionary = {}
	return JS.get_property(self, "timeAlive")
	return null

func original_setProjectileState(_arg0 = null):
	var _scope17: Dictionary = {"projectileState": _arg0}
	JS.set_property(self, "id", JS.invoke_method(_scope17["projectileState"], "getId", []))
	JS.set_property(self, "playerId", JS.invoke_method(_scope17["projectileState"], "getPlayerId", []))
	JS.set_property(self, "x", JS.invoke_method(_scope17["projectileState"], "getX", []))
	JS.set_property(self, "y", JS.invoke_method(_scope17["projectileState"], "getY", []))
	JS.set_property(self, "speedX", JS.invoke_method(_scope17["projectileState"], "getSpeedX", []))
	JS.set_property(self, "speedY", JS.invoke_method(_scope17["projectileState"], "getSpeedY", []))
	JS.set_property(self, "type", JS.invoke_method(_scope17["projectileState"], "getType", []))
	if JS.truthy(JS.get_property(self, "b2dbody")):
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(self, "x"), JS.get_property(self, "y")])])
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetLinearVelocity", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(self, "speedX"), JS.get_property(self, "speedY")])])
	return null

func original_getProjectileState():
	var _scope18: Dictionary = {"ps": null}
	_scope18["ps"] = JS.invoke_method(JS.module("ProjectileState"), "withState", [JS.get_property(self, "id"), JS.get_property(self, "playerId"), JS.get_property(self, "type"), JS.get_property(self, "x"), JS.get_property(self, "y"), JS.get_property(self, "speedX"), JS.get_property(self, "speedY")])
	return _scope18["ps"]
	return null

func original_update(_arg0 = null):
	var _scope19: Dictionary = {"deltaTime": _arg0, "currentTimeout": null, "i": null, "velocity": null, "length": null}
	JS.set_property(self, "timeAlive", JS.add(JS.get_property(self, "timeAlive"), _scope19["deltaTime"]))
	_scope19["currentTimeout"] = (JS.number(JS.invoke_method(JS.construct("@Date", []), "getTime", [])) - JS.number(JS.get_property(self, "timeoutWindow")))
	_scope19["i"] = 0
	while JS.truthy(JS.compare("<", _scope19["i"], JS.get_property(JS.get_property(self, "bounces"), "length"))):
		if JS.truthy(JS.compare(">=", JS.get_property(JS.get_property(self, "bounces"), _scope19["i"]), _scope19["currentTimeout"])):
			JS.invoke_method(JS.get_property(self, "bounces"), "splice", [0, _scope19["i"]])
			break
		JS.increment(_scope19, "i", 1, false)
	if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "abs", [(JS.number(JS.invoke_method(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "LengthSquared", [])) - JS.number(JS.get_property(self, "initialSpeedSquared")))]), 0.01)):
		_scope19["velocity"] = JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", [])
		_scope19["length"] = JS.invoke_method(_scope19["velocity"], "Length", [])
		if JS.truthy(JS.equal(_scope19["length"], 0, true)):
			JS.set_property(self, "stopped", true)
		else:
			JS.invoke_method(_scope19["velocity"], "Multiply", [(JS.number(JS.get_property(self, "initialSpeed")) / JS.number(_scope19["length"]))])
	JS.set_property(self, "x", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "x"))
	JS.set_property(self, "y", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "y"))
	JS.set_property(self, "speedX", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "x"))
	JS.set_property(self, "speedY", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "y"))
	return null

func original_hitShield():
	var _scope20: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "bounces"), "push", [JS.invoke_method(JS.construct("@Date", []), "getTime", [])])
	return null

func original_hitMaze():
	var _scope21: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "bounces"), "push", [JS.invoke_method(JS.construct("@Date", []), "getTime", [])])
	return null

func original_done():
	var _scope22: Dictionary = {}
	return JS.logical("||", func():
		var _scope23: Dictionary = {}
		return JS.logical("||", func():
			var _scope24: Dictionary = {}
			return JS.compare(">=", JS.get_property(self, "timeAlive"), JS.get_property(self, "lifetime"))
			return null, func():
			var _scope25: Dictionary = {}
			return JS.get_property(self, "stopped")
			return null)
		return null, func():
		var _scope26: Dictionary = {}
		return JS.compare(">=", JS.get_property(JS.get_property(self, "bounces"), "length"), JS.get_property(self, "timeoutBounceCount"))
		return null)
	return null

func original__emitEvent(_arg0 = null, _arg1 = null):
	var _scope27: Dictionary = {"evt": _arg0, "data": _arg1}
	if JS.truthy(JS.logical("&&", func():
		var _scope28: Dictionary = {}
		return JS.get_property(self, "evtHandler")
		return null, func():
		var _scope29: Dictionary = {}
		return JS.get_property(self, "evtContext")
		return null)):
		JS.invoke_method(self, "evtHandler", [JS.get_property(self, "evtContext"), _scope27["evt"], _scope27["data"]])
	return null
