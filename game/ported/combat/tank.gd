# 由原版 Tank 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var playerId = null
var x = 0
var y = 0
var forward = false
var back = false
var rotation = 0
var left = false
var right = false
var fireDown = false
var locked = false
var b2dbody = null
var speed = 0
var rotationSpeed = 0
var roundModel = null
var log = null
static var _static_Tank: Dictionary = {}
static var _initialized_Tank = false
static func initialize_original_static():
	if _initialized_Tank: return
	_initialized_Tank = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Tank.has(key): return _static_Tank[key]
	return null
static func original_static_set(key, value):
	_static_Tank[key] = value
	return value
func original_own_fields():
	return ["playerId","x","y","forward","back","rotation","left","right","fireDown","locked","b2dbody","speed","rotationSpeed","roundModel","log"]
func original_is_weak_field(key):
	return ["roundModel"].has(key) or super.original_is_weak_field(key)

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"tankState": _arg0, "roundModel": _arg1}
	JS.invoke_method(self, "setTankState", [_scope0["tankState"]])
	JS.set_property(self, "roundModel", _scope0["roundModel"])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", [JS.add("Tank ", JS.get_property(self, "playerId"))]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/combat/tank.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_setTankState(_arg0 = null, _arg1 = null):
	var _scope1: Dictionary = {"tankState": _arg0, "speedX": null, "speedY": null}
	JS.set_property(self, "playerId", JS.invoke_method(_scope1["tankState"], "getPlayerId", []))
	JS.set_property(self, "x", JS.invoke_method(_scope1["tankState"], "getX", []))
	JS.set_property(self, "y", JS.invoke_method(_scope1["tankState"], "getY", []))
	JS.set_property(self, "forward", JS.invoke_method(_scope1["tankState"], "getForward", []))
	JS.set_property(self, "back", JS.invoke_method(_scope1["tankState"], "getBack", []))
	JS.set_property(self, "rotation", JS.invoke_method(_scope1["tankState"], "getRotation", []))
	JS.set_property(self, "left", JS.invoke_method(_scope1["tankState"], "getLeft", []))
	JS.set_property(self, "right", JS.invoke_method(_scope1["tankState"], "getRight", []))
	JS.set_property(self, "fireDown", JS.invoke_method(_scope1["tankState"], "getFireDown", []))
	JS.set_property(self, "locked", JS.invoke_method(_scope1["tankState"], "getLocked", []))
	if JS.truthy(JS.get_property(self, "b2dbody")):
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetPositionAndAngle", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(self, "x"), JS.get_property(self, "y")]), JS.get_property(self, "rotation")])
		if JS.truthy(JS.get_property(self, "locked")):
			JS.invoke_method(JS.get_property(self, "b2dbody"), "SetLinearVelocity", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [0, 0])])
			JS.invoke_method(JS.get_property(self, "b2dbody"), "SetAngularVelocity", [0])
		else:
			JS.invoke_method(self, "_computeSpeed", [])
			JS.invoke_method(self, "_computeRotationSpeed", [])
			_scope1["speedX"] = (JS.number(JS.invoke_method("@Math", "sin", [JS.get_property(self, "rotation")])) * JS.number(JS.get_property(self, "speed")))
			_scope1["speedY"] = (JS.number(-(JS.invoke_method("@Math", "cos", [JS.get_property(self, "rotation")]))) * JS.number(JS.get_property(self, "speed")))
			JS.invoke_method(JS.get_property(self, "b2dbody"), "SetLinearVelocity", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [_scope1["speedX"], _scope1["speedY"]])])
			JS.invoke_method(JS.get_property(self, "b2dbody"), "SetAngularVelocity", [JS.get_property(self, "rotationSpeed")])
	return null

func original_getTankState():
	var _scope2: Dictionary = {"ts": null}
	_scope2["ts"] = JS.invoke_method(JS.module("TankState"), "withState", [JS.get_property(self, "playerId"), JS.get_property(self, "x"), JS.get_property(self, "y"), JS.get_property(self, "forward"), JS.get_property(self, "back"), JS.get_property(self, "rotation"), JS.get_property(self, "left"), JS.get_property(self, "right"), JS.get_property(self, "fireDown"), JS.get_property(self, "locked")])
	return _scope2["ts"]
	return null

func original_getPlayerId():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "playerId")
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

func original_setForward(_arg0 = null):
	var _scope8: Dictionary = {"forward": _arg0}
	JS.set_property(self, "forward", _scope8["forward"])
	return null

func original_getForward():
	var _scope9: Dictionary = {}
	if JS.truthy(JS.get_property(self, "locked")):
		return false
	return JS.get_property(self, "forward")
	return null

func original_setBack(_arg0 = null):
	var _scope10: Dictionary = {"back": _arg0}
	JS.set_property(self, "back", _scope10["back"])
	return null

func original_getBack():
	var _scope11: Dictionary = {}
	if JS.truthy(JS.get_property(self, "locked")):
		return false
	return JS.get_property(self, "back")
	return null

func original_setRotation(_arg0 = null):
	var _scope12: Dictionary = {"rotation": _arg0}
	JS.set_property(self, "rotation", _scope12["rotation"])
	return null

func original_getRotation():
	var _scope13: Dictionary = {}
	return JS.get_property(self, "rotation")
	return null

func original_setLeft(_arg0 = null):
	var _scope14: Dictionary = {"left": _arg0}
	JS.set_property(self, "left", _scope14["left"])
	return null

func original_getLeft():
	var _scope15: Dictionary = {}
	if JS.truthy(JS.get_property(self, "locked")):
		return false
	return JS.get_property(self, "left")
	return null

func original_setRight(_arg0 = null):
	var _scope16: Dictionary = {"right": _arg0}
	JS.set_property(self, "right", _scope16["right"])
	return null

func original_getRight():
	var _scope17: Dictionary = {}
	if JS.truthy(JS.get_property(self, "locked")):
		return false
	return JS.get_property(self, "right")
	return null

func original_setFireDown(_arg0 = null):
	var _scope18: Dictionary = {"fireDown": _arg0}
	JS.set_property(self, "fireDown", _scope18["fireDown"])
	return null

func original_getFireDown():
	var _scope19: Dictionary = {}
	if JS.truthy(JS.get_property(self, "locked")):
		return false
	return JS.get_property(self, "fireDown")
	return null

func original_setLocked(_arg0 = null):
	var _scope20: Dictionary = {"locked": _arg0}
	JS.set_property(self, "locked", _scope20["locked"])
	return null

func original_getLocked():
	var _scope21: Dictionary = {}
	return JS.get_property(self, "locked")
	return null

func original_setB2DBody(_arg0 = null):
	var _scope22: Dictionary = {"b2dbody": _arg0}
	JS.set_property(self, "b2dbody", _scope22["b2dbody"])
	return null

func original_getB2DBody():
	var _scope23: Dictionary = {}
	return JS.get_property(self, "b2dbody")
	return null

func original_getSpeed():
	var _scope24: Dictionary = {}
	if JS.truthy(JS.get_property(self, "locked")):
		return 0
	return JS.get_property(self, "speed")
	return null

func original_getRotationSpeed():
	var _scope25: Dictionary = {}
	if JS.truthy(JS.get_property(self, "locked")):
		return 0
	return JS.get_property(self, "rotationSpeed")
	return null

func original_update(_arg0 = null):
	var _scope26: Dictionary = {"deltaTime": _arg0, "speedX": null, "speedY": null}
	JS.set_property(self, "x", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "x"))
	JS.set_property(self, "y", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "y"))
	JS.set_property(self, "rotation", JS.invoke_method(JS.get_property(self, "b2dbody"), "GetAngle", []))
	if JS.truthy(JS.get_property(self, "locked")):
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetLinearVelocity", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [0, 0])])
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetAngularVelocity", [0])
	else:
		JS.invoke_method(self, "_computeSpeed", [])
		JS.invoke_method(self, "_computeRotationSpeed", [])
		_scope26["speedX"] = (JS.number(JS.invoke_method("@Math", "sin", [JS.get_property(self, "rotation")])) * JS.number(JS.get_property(self, "speed")))
		_scope26["speedY"] = (JS.number(-(JS.invoke_method("@Math", "cos", [JS.get_property(self, "rotation")]))) * JS.number(JS.get_property(self, "speed")))
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetLinearVelocity", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [_scope26["speedX"], _scope26["speedY"]])])
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetAngularVelocity", [JS.get_property(self, "rotationSpeed")])
	return null

func original__computeSpeed():
	var _scope27: Dictionary = {"speedModifier": null}
	JS.set_property(self, "speed", 0)
	_scope27["speedModifier"] = JS.invoke_method(JS.get_property(self, "roundModel"), "getModifier", [JS.get_property(self, "playerId"), JS.get_property(JS.get_property(JS.module("Constants"), "MODIFIER_TYPES"), "SPEED")])
	if JS.truthy(JS.get_property(self, "forward")):
		JS.set_property(self, "speed", JS.add(JS.get_property(self, "speed"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "FORWARD_SPEED"), "m")) * JS.number(_scope27["speedModifier"]))))
	if JS.truthy(JS.get_property(self, "back")):
		JS.set_property(self, "speed", (JS.number(JS.get_property(self, "speed")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "BACK_SPEED"), "m")) * JS.number(_scope27["speedModifier"])))))
	return null

func original__computeRotationSpeed():
	var _scope28: Dictionary = {"speedModifier": null}
	JS.set_property(self, "rotationSpeed", 0)
	_scope28["speedModifier"] = JS.invoke_method(JS.get_property(self, "roundModel"), "getModifier", [JS.get_property(self, "playerId"), JS.get_property(JS.get_property(JS.module("Constants"), "MODIFIER_TYPES"), "SPEED")])
	if JS.truthy(JS.get_property(self, "left")):
		JS.set_property(self, "rotationSpeed", JS.add(JS.get_property(self, "rotationSpeed"), (JS.number(-(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "ROTATION_SPEED"))) * JS.number(_scope28["speedModifier"]))))
	if JS.truthy(JS.get_property(self, "right")):
		JS.set_property(self, "rotationSpeed", JS.add(JS.get_property(self, "rotationSpeed"), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "ROTATION_SPEED")) * JS.number(_scope28["speedModifier"]))))
	return null
