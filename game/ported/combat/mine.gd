# 由原版 Mine 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/trap.gd"

var _activated = false
var _tripped = false
var _detonated = false
var _trippingTankIds = []
var _detonationTime = 0
static var _static_Mine: Dictionary = {}
static var _initialized_Mine = false
static func initialize_original_static():
	if _initialized_Mine: return
	_initialized_Mine = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Mine.has(key): return _static_Mine[key]
	return JS.get_property(JS.module("Trap"), key)
static func original_static_set(key, value):
	_static_Mine[key] = value
	return value
func original_own_fields():
	return ["_activated","_tripped","_detonated","_trippingTankIds","_detonationTime"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/mine.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

func original_update(_arg0 = null):
	var _scope0: Dictionary = {"deltaTime": _arg0, "i": null, "velocity": null, "length": null, "newLength": null}
	JS.set_property(self, "timeAlive", JS.add(JS.get_property(self, "timeAlive"), _scope0["deltaTime"]))
	_scope0["i"] = (JS.number(JS.get_property(JS.get_property(self, "_trippingTankIds"), "length")) - JS.number(1))
	while JS.truthy(JS.compare(">=", _scope0["i"], 0)):
		if JS.truthy((not JS.truthy(JS.invoke_method(JS.get_property(self, "roundModel"), "getTank", [JS.get_property(JS.get_property(self, "_trippingTankIds"), _scope0["i"])])))):
			JS.invoke_method(JS.get_property(self, "_trippingTankIds"), "splice", [_scope0["i"], 1])
		JS.increment(_scope0, "i", -1, true)
	_scope0["velocity"] = JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", [])
	_scope0["length"] = JS.invoke_method(_scope0["velocity"], "Length", [])
	if JS.truthy(JS.compare(">", _scope0["length"], 0)):
		_scope0["newLength"] = JS.invoke_method("@Math", "max", [0, (JS.number(_scope0["length"]) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MINE"), "ACCELERATION")) * JS.number(_scope0["deltaTime"]))))])
		JS.invoke_method(_scope0["velocity"], "Multiply", [(JS.number(_scope0["newLength"]) / JS.number(_scope0["length"]))])
	if JS.truthy(JS.logical("&&", func():
		var _scope1: Dictionary = {}
		return JS.compare(">=", JS.get_property(self, "timeAlive"), JS.get_property(JS.module("Constants"), "MINE_ACTIVATION_DELAY"))
		return null, func():
		var _scope2: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "_activated")))
		return null)):
		JS.set_property(self, "_activated", true)
		JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_ACTIVATED"), JS.get_property(self, "id")])
	if JS.truthy(JS.logical("&&", func():
		var _scope3: Dictionary = {}
		return JS.logical("&&", func():
			var _scope4: Dictionary = {}
			return JS.compare(">", JS.get_property(JS.get_property(self, "_trippingTankIds"), "length"), 0)
			return null, func():
			var _scope5: Dictionary = {}
			return JS.get_property(self, "_activated")
			return null)
		return null, func():
		var _scope6: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "_tripped")))
		return null)):
		JS.set_property(self, "_tripped", true)
		JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_TRIPPED"), JS.get_property(self, "id")])
	else:
		if JS.truthy(JS.logical("&&", func():
			var _scope7: Dictionary = {}
			return JS.logical("&&", func():
				var _scope8: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(self, "_trippingTankIds"), "length"), 0, false)
				return null, func():
				var _scope9: Dictionary = {}
				return JS.get_property(self, "_tripped")
				return null)
			return null, func():
			var _scope10: Dictionary = {}
			return (not JS.truthy(JS.get_property(self, "_detonated")))
			return null)):
			JS.set_property(self, "_detonated", true)
			JS.set_property(self, "_detonationTime", JS.get_property(JS.module("Constants"), "MINE_DETONATION_DELAY"))
			JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_DETONATED"), JS.get_property(self, "id")])
	if JS.truthy(JS.get_property(self, "_detonated")):
		JS.set_property(self, "_detonationTime", (JS.number(JS.get_property(self, "_detonationTime")) - JS.number(_scope0["deltaTime"])))
	JS.set_property(self, "x", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "x"))
	JS.set_property(self, "y", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "y"))
	JS.set_property(self, "speedX", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "x"))
	JS.set_property(self, "speedY", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "y"))
	return null

func original_trip(_arg0 = null, _arg1 = null):
	var _scope11: Dictionary = {"playerId": _arg0, "entered": _arg1, "index": null}
	if JS.truthy(_scope11["entered"]):
		_scope11["index"] = JS.invoke_method(JS.get_property(self, "_trippingTankIds"), "indexOf", [_scope11["playerId"]])
		if JS.truthy(JS.compare("<", _scope11["index"], 0)):
			JS.invoke_method(JS.get_property(self, "_trippingTankIds"), "push", [_scope11["playerId"]])
	else:
		_scope11["index"] = JS.invoke_method(JS.get_property(self, "_trippingTankIds"), "indexOf", [_scope11["playerId"]])
		if JS.truthy(JS.compare(">=", _scope11["index"], 0)):
			JS.invoke_method(JS.get_property(self, "_trippingTankIds"), "splice", [_scope11["index"], 1])
	return null

func original_released():
	var _scope12: Dictionary = {}
	return JS.logical("&&", func():
		var _scope13: Dictionary = {}
		return JS.get_property(self, "_detonated")
		return null, func():
		var _scope14: Dictionary = {}
		return JS.compare("<=", JS.get_property(self, "_detonationTime"), 0)
		return null)
	return null

func original_getProjectileStates(_arg0 = null):
	var _scope15: Dictionary = {"result": null, "i": null, "speed": null, "direction": null, "speedX": null, "speedY": null, "projectileState": null}
	_scope15["result"] = []
	_scope15["i"] = 0
	while JS.truthy(JS.compare("<", _scope15["i"], JS.get_property(JS.module("Constants"), "MINE_NUM_SHRAPNEL"))):
		_scope15["speed"] = JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MINE"), "MIN_SPEED"), "m"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MINE"), "MAX_SPEED"), "m")) - JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MINE"), "MIN_SPEED"), "m"))))))
		_scope15["direction"] = (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property("@Math", "PI")))) * JS.number(2))
		_scope15["speedX"] = (JS.number(JS.invoke_method("@Math", "cos", [_scope15["direction"]])) * JS.number(_scope15["speed"]))
		_scope15["speedY"] = (JS.number(JS.invoke_method("@Math", "sin", [_scope15["direction"]])) * JS.number(_scope15["speed"]))
		_scope15["projectileState"] = JS.invoke_method(JS.module("ProjectileState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["mb"]), JS.get_property(self, "playerId"), JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), JS.get_property(self, "x"), JS.get_property(self, "y"), _scope15["speedX"], _scope15["speedY"]])
		JS.invoke_method(_scope15["result"], "push", [_scope15["projectileState"]])
		JS.increment(_scope15, "i", 1, false)
	return _scope15["result"]
	return null

func original_done():
	var _scope16: Dictionary = {}
	return JS.invoke_method(self, "released", [])
	return null

static func original_createInitialTrapState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null):
	var _scope17: Dictionary = {"id": _arg0, "playerId": _arg1, "x": _arg2, "y": _arg3, "speedX": _arg4, "speedY": _arg5, "fields": null}
	_scope17["fields"] = {"_activated": false, "_tripped": false, "_detonated": false, "_trippingTankIds": [], "_detonationTime": 0}
	return JS.invoke_method(JS.module("Trap"), "createInitialTrapState", [_scope17["id"], _scope17["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), _scope17["x"], _scope17["y"], _scope17["speedX"], _scope17["speedY"], JS.invoke_method("@JSON", "stringify", [_scope17["fields"]])])
	return null
