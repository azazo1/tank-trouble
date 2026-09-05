# 由原版 HomingMissile 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/combat/projectile.gd"

var currentTargetPlayerId = null
static var _static_HomingMissile: Dictionary = {}
static var _initialized_HomingMissile = false
static func initialize_original_static():
	if _initialized_HomingMissile: return
	_initialized_HomingMissile = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_HomingMissile.has(key): return _static_HomingMissile[key]
	return JS.get_property(JS.module("Projectile"), key)
static func original_static_set(key, value):
	_static_HomingMissile[key] = value
	return value
func original_own_fields():
	return ["currentTargetPlayerId"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/combat/homingmissile.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

func original_update(_arg0 = null):
	var _scope0: Dictionary = {"deltaTime": _arg0, "currentTimeout": null, "i": null, "tanks": null, "maze": null, "shortestDistance": null, "targetPosition": null, "targetPlayerId": null, "startPosition": null, "distances": null, "tank": null, "endPosition": null, "currentDistance": null, "shortestPath": null, "relativeToMissile": null, "newSpeedX": null, "newSpeedY": null, "targetChange": null, "velocity": null, "length": null}
	JS.set_property(self, "timeAlive", JS.add(JS.get_property(self, "timeAlive"), _scope0["deltaTime"]))
	_scope0["currentTimeout"] = (JS.number(JS.invoke_method(JS.construct("@Date", []), "getTime", [])) - JS.number(JS.get_property(self, "timeoutWindow")))
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.get_property(self, "bounces"), "length"))):
		if JS.truthy(JS.compare(">=", JS.get_property(JS.get_property(self, "bounces"), _scope0["i"]), _scope0["currentTimeout"])):
			JS.invoke_method(JS.get_property(self, "bounces"), "splice", [0, _scope0["i"]])
			break
		JS.increment(_scope0, "i", 1, false)
	if JS.truthy(JS.compare(">", JS.get_property(self, "timeAlive"), JS.get_property(JS.module("Constants"), "HOMING_MISSILE_ACTIVATION_TIME"))):
		if JS.truthy((not JS.truthy(JS.invoke_method(self, "isDeadlyToOwner", [])))):
			JS.invoke_method(self, "makeDeadlyToOwner", [])
		_scope0["tanks"] = JS.invoke_method(JS.get_property(self, "roundModel"), "getTanks", [])
		_scope0["maze"] = JS.invoke_method(JS.get_property(self, "roundModel"), "getMaze", [])
		if JS.truthy(_scope0["maze"]):
			_scope0["shortestDistance"] = null
			_scope0["targetPosition"] = null
			_scope0["targetPlayerId"] = null
			_scope0["startPosition"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(self, "x")) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(self, "y")) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
			_scope0["distances"] = JS.invoke_method(_scope0["maze"], "getDistancesFromPosition", [_scope0["startPosition"]])
			if JS.truthy(not JS.equal(_scope0["distances"], false, true)):
				for _iteration0 in JS.keys(_scope0["tanks"]):
					JS.set_property(_scope0, "tank", _iteration0)
					_scope0["endPosition"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope0["tanks"], _scope0["tank"]), "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope0["tanks"], _scope0["tank"]), "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
					_scope0["currentDistance"] = JS.invoke_method(_scope0["maze"], "getDistanceToPosition", [_scope0["distances"], _scope0["endPosition"]])
					if JS.truthy(not JS.equal(_scope0["currentDistance"], false, true)):
						if JS.truthy(JS.logical("||", func():
							var _scope1: Dictionary = {}
							return JS.logical("||", func():
								var _scope2: Dictionary = {}
								return JS.equal(_scope0["shortestDistance"], null, true)
								return null, func():
								var _scope3: Dictionary = {}
								return JS.compare("<", _scope0["currentDistance"], _scope0["shortestDistance"])
								return null)
							return null, func():
							var _scope4: Dictionary = {}
							return JS.logical("&&", func():
								var _scope5: Dictionary = {}
								return JS.equal(_scope0["currentDistance"], _scope0["shortestDistance"], true)
								return null, func():
								var _scope6: Dictionary = {}
								return not JS.equal(_scope0["tank"], JS.invoke_method(self, "getPlayerId", []), true)
								return null)
							return null)):
							JS.set_property(_scope0, "shortestDistance", _scope0["currentDistance"])
							JS.set_property(_scope0, "targetPosition", _scope0["endPosition"])
							JS.set_property(_scope0, "targetPlayerId", _scope0["tank"])
			if JS.truthy(_scope0["targetPlayerId"]):
				if JS.truthy(JS.compare("<=", _scope0["shortestDistance"], 1)):
					JS.set_property(_scope0["targetPosition"], "x", JS.invoke_method(JS.get_property(_scope0["tanks"], _scope0["targetPlayerId"]), "getX", []))
					JS.set_property(_scope0["targetPosition"], "y", JS.invoke_method(JS.get_property(_scope0["tanks"], _scope0["targetPlayerId"]), "getY", []))
				else:
					_scope0["shortestPath"] = JS.invoke_method(_scope0["maze"], "getShortestPathWithGraph", [_scope0["startPosition"], _scope0["targetPosition"]])
					JS.set_property(_scope0["targetPosition"], "x", (JS.number(JS.add(JS.get_property(JS.get_property(_scope0["shortestPath"], 0), "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))))
					JS.set_property(_scope0["targetPosition"], "y", (JS.number(JS.add(JS.get_property(JS.get_property(_scope0["shortestPath"], 0), "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))))
				_scope0["relativeToMissile"] = JS.invoke_method(JS.module("B2DUtils"), "toLocalSpace", [JS.get_property(self, "b2dbody"), _scope0["targetPosition"]])
				_scope0["newSpeedX"] = JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "x")
				_scope0["newSpeedY"] = JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "y")
				if JS.truthy(JS.compare("<", JS.get_property(_scope0["relativeToMissile"], "x"), 0)):
					JS.set_property(_scope0, "newSpeedX", (JS.number(_scope0["newSpeedX"]) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "HOMING_MISSILE"), "ACCELERATION")) * JS.number(_scope0["deltaTime"])))))
				else:
					JS.set_property(_scope0, "newSpeedX", JS.add(_scope0["newSpeedX"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "HOMING_MISSILE"), "ACCELERATION")) * JS.number(_scope0["deltaTime"]))))
				if JS.truthy(JS.compare("<", JS.get_property(_scope0["relativeToMissile"], "y"), 0)):
					JS.set_property(_scope0, "newSpeedY", (JS.number(_scope0["newSpeedY"]) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "HOMING_MISSILE"), "ACCELERATION")) * JS.number(_scope0["deltaTime"])))))
				else:
					JS.set_property(_scope0, "newSpeedY", JS.add(_scope0["newSpeedY"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "HOMING_MISSILE"), "ACCELERATION")) * JS.number(_scope0["deltaTime"]))))
				JS.invoke_method(JS.get_property(self, "b2dbody"), "SetLinearVelocity", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [_scope0["newSpeedX"], _scope0["newSpeedY"]])])
			if JS.truthy(not JS.equal(_scope0["targetPlayerId"], JS.get_property(self, "currentTargetPlayerId"), true)):
				_scope0["targetChange"] = JS.invoke_method(JS.module("TargetChange"), "create", [JS.get_property(self, "id"), _scope0["targetPlayerId"]])
				JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "HOMING_MISSILE_TARGET_CHANGED"), _scope0["targetChange"]])
			JS.set_property(self, "currentTargetPlayerId", _scope0["targetPlayerId"])
	if JS.truthy(JS.compare(">", (JS.number(JS.invoke_method(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "LengthSquared", [])) - JS.number(JS.get_property(self, "initialSpeedSquared"))), 0.01)):
		_scope0["velocity"] = JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", [])
		_scope0["length"] = JS.invoke_method(_scope0["velocity"], "Length", [])
		JS.invoke_method(_scope0["velocity"], "Multiply", [(JS.number(JS.get_property(self, "initialSpeed")) / JS.number(_scope0["length"]))])
	JS.set_property(self, "x", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "x"))
	JS.set_property(self, "y", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "y"))
	JS.set_property(self, "speedX", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "x"))
	JS.set_property(self, "speedY", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetLinearVelocity", []), "y"))
	return null
