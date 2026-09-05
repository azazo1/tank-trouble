# 由原版 AIUtils 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_AIUtils: Dictionary = {}
static var _initialized_AIUtils = false
static func initialize_original_static():
	if _initialized_AIUtils: return
	_initialized_AIUtils = true
	_static_AIUtils["_FIRING_RESULTS"] = {"SUICIDE": "suicide", "HIT": "hit", "NEAR": "near", "MISS": "miss"}
static func original_static_get(key):
	initialize_original_static()
	if _static_AIUtils.has(key): return _static_AIUtils[key]
	return null
static func original_static_set(key, value):
	_static_AIUtils[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/ai/aiutils.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

static func original_checkProtected(_arg0 = null, _arg1 = null):
	var _scope0: Dictionary = {"tankId": _arg0, "gameController": _arg1, "spawnShieldUpgrade": null, "shieldUpgrade": null}
	_scope0["spawnShieldUpgrade"] = JS.invoke_method(_scope0["gameController"], "getUpgradeByPlayerIdAndType", [_scope0["tankId"], JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SPAWN_SHIELD")])
	_scope0["shieldUpgrade"] = JS.invoke_method(_scope0["gameController"], "getUpgradeByPlayerIdAndType", [_scope0["tankId"], JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SHIELD")])
	if JS.truthy(JS.logical("||", func():
		var _scope1: Dictionary = {}
		return JS.logical("&&", func():
			var _scope2: Dictionary = {}
			return _scope0["spawnShieldUpgrade"]
			return null, func():
			var _scope3: Dictionary = {}
			return (not JS.truthy(JS.invoke_method(_scope0["spawnShieldUpgrade"], "getField", ["weakened"])))
			return null)
		return null, func():
		var _scope4: Dictionary = {}
		return JS.logical("&&", func():
			var _scope5: Dictionary = {}
			return _scope0["shieldUpgrade"]
			return null, func():
			var _scope6: Dictionary = {}
			return (not JS.truthy(JS.invoke_method(_scope0["shieldUpgrade"], "getField", ["weakened"])))
			return null)
		return null)):
		return true
	return false
	return null

static func original_checkProjectilePathForDodging(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope7: Dictionary = {"tank": _arg0, "path": _arg1, "projectile": _arg2, "b2dWorld": _arg3, "scaryProjectileDistanceSquared": _arg4, "projectileSpeed": null}
	_scope7["projectileSpeed"] = JS.invoke_method(JS.invoke_method(JS.invoke_method(_scope7["projectile"], "getB2DBody", []), "GetLinearVelocity", []), "Length", [])
	return JS.invoke_method(JS.module("AIUtils"), "_checkPathForDodging", [_scope7["tank"], _scope7["path"], _scope7["projectileSpeed"], JS.invoke_method(_scope7["projectile"], "getId", []), _scope7["b2dWorld"], _scope7["scaryProjectileDistanceSquared"]])
	return null

static func original_checkAimerPathForDodging(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope8: Dictionary = {"tank": _arg0, "path": _arg1, "aimer": _arg2, "b2dWorld": _arg3}
	return JS.invoke_method(JS.module("AIUtils"), "_checkPathForDodging", [_scope8["tank"], _scope8["path"], 1, JS.invoke_method(_scope8["aimer"], "getId", []), _scope8["b2dWorld"], JS.get_property("@Number", "MAX_VALUE")])
	return null

static func original__checkPathForDodging(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope9: Dictionary = {"tank": _arg0, "path": _arg1, "speed": _arg2, "id": _arg3, "b2dWorld": _arg4, "scaryDistanceSquared": _arg5, "closestDistanceSquared": null, "closestPosition": null, "closestDirection": null, "closestTime": null, "closestId": null, "tankPosition": null, "previousTime": null, "i": null, "segmentStartX": null, "segmentStartY": null, "segmentEndX": null, "segmentEndY": null, "diffSegmentX": null, "diffSegmentY": null, "diffSegmentLength": null, "segmentTime": null, "diffTankX": null, "diffTankY": null, "t": null, "position": null, "distanceSquared": null}
	_scope9["closestDistanceSquared"] = JS.get_property("@Number", "MAX_VALUE")
	_scope9["closestPosition"] = {"x": 0, "y": 0}
	_scope9["closestDirection"] = {"x": 0, "y": 0}
	_scope9["closestTime"] = JS.get_property("@Number", "MAX_VALUE")
	_scope9["closestId"] = ""
	_scope9["tankPosition"] = {"x": JS.invoke_method(_scope9["tank"], "getX", []), "y": JS.invoke_method(_scope9["tank"], "getY", [])}
	_scope9["previousTime"] = 0
	_scope9["i"] = 0
	while JS.truthy(JS.compare("<", _scope9["i"], (JS.number(JS.get_property(_scope9["path"], "length")) - JS.number(1)))):
		_scope9["segmentStartX"] = JS.get_property(JS.get_property(_scope9["path"], _scope9["i"]), "x")
		_scope9["segmentStartY"] = JS.get_property(JS.get_property(_scope9["path"], _scope9["i"]), "y")
		_scope9["segmentEndX"] = JS.get_property(JS.get_property(_scope9["path"], JS.add(_scope9["i"], 1)), "x")
		_scope9["segmentEndY"] = JS.get_property(JS.get_property(_scope9["path"], JS.add(_scope9["i"], 1)), "y")
		_scope9["diffSegmentX"] = (JS.number(_scope9["segmentEndX"]) - JS.number(_scope9["segmentStartX"]))
		_scope9["diffSegmentY"] = (JS.number(_scope9["segmentEndY"]) - JS.number(_scope9["segmentStartY"]))
		_scope9["diffSegmentLength"] = JS.invoke_method("@Math", "sqrt", [JS.add((JS.number(_scope9["diffSegmentX"]) * JS.number(_scope9["diffSegmentX"])), (JS.number(_scope9["diffSegmentY"]) * JS.number(_scope9["diffSegmentY"])))])
		_scope9["segmentTime"] = (JS.number(_scope9["diffSegmentLength"]) / JS.number(_scope9["speed"]))
		JS.set_property(_scope9, "diffSegmentX", (JS.number(_scope9["diffSegmentX"]) / JS.number(_scope9["segmentTime"])))
		JS.set_property(_scope9, "diffSegmentY", (JS.number(_scope9["diffSegmentY"]) / JS.number(_scope9["segmentTime"])))
		_scope9["diffTankX"] = (JS.number(JS.get_property(_scope9["tankPosition"], "x")) - JS.number(_scope9["segmentStartX"]))
		_scope9["diffTankY"] = (JS.number(JS.get_property(_scope9["tankPosition"], "y")) - JS.number(_scope9["segmentStartY"]))
		_scope9["t"] = (JS.number(JS.add((JS.number(_scope9["diffTankX"]) * JS.number(_scope9["diffSegmentX"])), (JS.number(_scope9["diffTankY"]) * JS.number(_scope9["diffSegmentY"])))) / JS.number((JS.number(_scope9["speed"]) * JS.number(_scope9["speed"]))))
		if JS.truthy(JS.compare(">=", _scope9["t"], 0)):
			JS.set_property(_scope9, "t", JS.invoke_method("@Math", "min", [JS.invoke_method("@Math", "max", [_scope9["t"], JS.get_property(JS.module("Constants"), "PATH_MIN_STEP_LENGTH")]), (JS.number(_scope9["segmentTime"]) - JS.number(JS.get_property(JS.module("Constants"), "PATH_MIN_STEP_LENGTH")))]))
			_scope9["position"] = {"x": JS.add(_scope9["segmentStartX"], (JS.number(_scope9["t"]) * JS.number(_scope9["diffSegmentX"]))), "y": JS.add(_scope9["segmentStartY"], (JS.number(_scope9["t"]) * JS.number(_scope9["diffSegmentY"])))}
			if JS.truthy((not JS.truthy(JS.invoke_method(JS.module("B2DUtils"), "checkLineForMazeCollision", [_scope9["b2dWorld"], _scope9["position"], _scope9["tankPosition"]])))):
				_scope9["distanceSquared"] = JS.add((JS.number((JS.number(JS.get_property(_scope9["tankPosition"], "x")) - JS.number(JS.get_property(_scope9["position"], "x")))) * JS.number((JS.number(JS.get_property(_scope9["tankPosition"], "x")) - JS.number(JS.get_property(_scope9["position"], "x"))))), (JS.number((JS.number(JS.get_property(_scope9["tankPosition"], "y")) - JS.number(JS.get_property(_scope9["position"], "y")))) * JS.number((JS.number(JS.get_property(_scope9["tankPosition"], "y")) - JS.number(JS.get_property(_scope9["position"], "y"))))))
				if JS.truthy(JS.compare("<", _scope9["distanceSquared"], _scope9["closestDistanceSquared"])):
					JS.set_property(_scope9, "closestDistanceSquared", _scope9["distanceSquared"])
					JS.set_property(_scope9, "closestPosition", _scope9["position"])
					JS.set_property(_scope9, "closestDirection", {"x": _scope9["diffSegmentX"], "y": _scope9["diffSegmentY"]})
					JS.set_property(_scope9, "closestTime", JS.add(_scope9["previousTime"], _scope9["t"]))
					JS.set_property(_scope9, "closestId", _scope9["id"])
		JS.set_property(_scope9, "previousTime", JS.add(_scope9["previousTime"], _scope9["segmentTime"]))
		if JS.truthy(JS.compare("<", _scope9["closestDistanceSquared"], _scope9["scaryDistanceSquared"])):
			break
		JS.increment(_scope9, "i", 1, false)
	return {"closestId": _scope9["closestId"], "closestDistance": JS.invoke_method("@Math", "sqrt", [_scope9["closestDistanceSquared"]]), "closestPosition": _scope9["closestPosition"], "closestDirection": _scope9["closestDirection"], "closestTime": _scope9["closestTime"]}
	return null

static func original_checkFiringPath(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null):
	var _scope10: Dictionary = {"tank": _arg0, "tanks": _arg1, "gameController": _arg2, "angle": _arg3, "bounces": _arg4, "maxLength": _arg5, "weaponType": _arg6, "pathInfo": null, "result": null, "closestDistanceSquared": null, "closestPathLength": null, "target": null, "currentPathLength": null, "i": null, "segmentStartX": null, "segmentStartY": null, "segmentEndX": null, "segmentEndY": null, "diffSegmentX": null, "diffSegmentY": null, "diffSegmentLength": null, "tankId": null, "tankPosition": null, "diffTankX": null, "diffTankY": null, "t": null, "position": null, "distanceSquared": null}
	_scope10["pathInfo"] = JS.invoke_method(JS.module("B2DUtils"), "calculateFiringPath", [JS.invoke_method(_scope10["gameController"], "getB2DWorld", []), _scope10["tank"], _scope10["angle"], _scope10["bounces"], _scope10["maxLength"], true])
	if JS.truthy(not JS.equal(_scope10["weaponType"], JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true)):
		if JS.truthy(JS.logical("&&", func():
			var _scope11: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope10["pathInfo"], "firstSegmentLength"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_FIRST_SEGMENT_TO_FIRE"))
			return null, func():
			var _scope12: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope10["pathInfo"], "length"), JS.get_property(_scope10["pathInfo"], "firstSegmentLength"))
			return null)):
			return {"result": JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "SUICIDE"), "target": _scope10["tank"], "closestDistance": 0, "pathLength": JS.get_property(_scope10["pathInfo"], "length"), "direction": JS.get_property(_scope10["pathInfo"], "direction")}
	if JS.truthy(JS.get_property(_scope10["pathInfo"], "hit")):
		_scope10["result"] = JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "HIT")
		if JS.truthy(JS.equal(JS.get_property(_scope10["pathInfo"], "hit"), _scope10["tank"], true)):
			JS.set_property(_scope10, "result", JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "SUICIDE"))
		return {"result": _scope10["result"], "target": JS.get_property(_scope10["pathInfo"], "hit"), "closestDistance": 0, "pathLength": JS.get_property(_scope10["pathInfo"], "length"), "direction": JS.get_property(_scope10["pathInfo"], "direction")}
	else:
		_scope10["closestDistanceSquared"] = JS.get_property("@Number", "MAX_VALUE")
		_scope10["closestPathLength"] = _scope10["maxLength"]
		_scope10["result"] = JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "MISS")
		_scope10["target"] = null
		_scope10["currentPathLength"] = 0
		_scope10["i"] = 0
		while JS.truthy(JS.compare("<", _scope10["i"], (JS.number(JS.get_property(JS.get_property(_scope10["pathInfo"], "path"), "length")) - JS.number(1)))):
			_scope10["segmentStartX"] = JS.get_property(JS.get_property(JS.get_property(_scope10["pathInfo"], "path"), _scope10["i"]), "x")
			_scope10["segmentStartY"] = JS.get_property(JS.get_property(JS.get_property(_scope10["pathInfo"], "path"), _scope10["i"]), "y")
			_scope10["segmentEndX"] = JS.get_property(JS.get_property(JS.get_property(_scope10["pathInfo"], "path"), JS.add(_scope10["i"], 1)), "x")
			_scope10["segmentEndY"] = JS.get_property(JS.get_property(JS.get_property(_scope10["pathInfo"], "path"), JS.add(_scope10["i"], 1)), "y")
			_scope10["diffSegmentX"] = (JS.number(_scope10["segmentEndX"]) - JS.number(_scope10["segmentStartX"]))
			_scope10["diffSegmentY"] = (JS.number(_scope10["segmentEndY"]) - JS.number(_scope10["segmentStartY"]))
			_scope10["diffSegmentLength"] = JS.invoke_method("@Math", "sqrt", [JS.add((JS.number(_scope10["diffSegmentX"]) * JS.number(_scope10["diffSegmentX"])), (JS.number(_scope10["diffSegmentY"]) * JS.number(_scope10["diffSegmentY"])))])
			JS.set_property(_scope10, "diffSegmentX", (JS.number(_scope10["diffSegmentX"]) / JS.number(_scope10["diffSegmentLength"])))
			JS.set_property(_scope10, "diffSegmentY", (JS.number(_scope10["diffSegmentY"]) / JS.number(_scope10["diffSegmentLength"])))
			for _iteration0 in JS.keys(_scope10["tanks"]):
				JS.set_property(_scope10, "tankId", _iteration0)
				if JS.truthy(not JS.equal(_scope10["tankId"], JS.invoke_method(_scope10["tank"], "getPlayerId", []), true)):
					if JS.truthy(JS.invoke_method(JS.module("AIUtils"), "checkProtected", [_scope10["tankId"], _scope10["gameController"]])):
						continue
					_scope10["tankPosition"] = {"x": JS.invoke_method(JS.get_property(_scope10["tanks"], _scope10["tankId"]), "getX", []), "y": JS.invoke_method(JS.get_property(_scope10["tanks"], _scope10["tankId"]), "getY", [])}
					_scope10["diffTankX"] = (JS.number(JS.get_property(_scope10["tankPosition"], "x")) - JS.number(_scope10["segmentStartX"]))
					_scope10["diffTankY"] = (JS.number(JS.get_property(_scope10["tankPosition"], "y")) - JS.number(_scope10["segmentStartY"]))
					_scope10["t"] = JS.add((JS.number(_scope10["diffTankX"]) * JS.number(_scope10["diffSegmentX"])), (JS.number(_scope10["diffTankY"]) * JS.number(_scope10["diffSegmentY"])))
					JS.set_property(_scope10, "t", JS.invoke_method("@Math", "min", [JS.invoke_method("@Math", "max", [_scope10["t"], JS.get_property(JS.module("Constants"), "PATH_MIN_STEP_LENGTH")]), (JS.number(_scope10["diffSegmentLength"]) - JS.number(JS.get_property(JS.module("Constants"), "PATH_MIN_STEP_LENGTH")))]))
					_scope10["position"] = {"x": JS.add(_scope10["segmentStartX"], (JS.number(_scope10["t"]) * JS.number(_scope10["diffSegmentX"]))), "y": JS.add(_scope10["segmentStartY"], (JS.number(_scope10["t"]) * JS.number(_scope10["diffSegmentY"])))}
					if JS.truthy((not JS.truthy(JS.invoke_method(JS.module("B2DUtils"), "checkLineForMazeCollision", [JS.invoke_method(_scope10["gameController"], "getB2DWorld", []), _scope10["position"], _scope10["tankPosition"]])))):
						_scope10["distanceSquared"] = JS.add((JS.number((JS.number(JS.get_property(_scope10["tankPosition"], "x")) - JS.number(JS.get_property(_scope10["position"], "x")))) * JS.number((JS.number(JS.get_property(_scope10["tankPosition"], "x")) - JS.number(JS.get_property(_scope10["position"], "x"))))), (JS.number((JS.number(JS.get_property(_scope10["tankPosition"], "y")) - JS.number(JS.get_property(_scope10["position"], "y")))) * JS.number((JS.number(JS.get_property(_scope10["tankPosition"], "y")) - JS.number(JS.get_property(_scope10["position"], "y"))))))
						if JS.truthy(JS.compare("<", _scope10["distanceSquared"], _scope10["closestDistanceSquared"])):
							JS.set_property(_scope10, "result", JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "NEAR"))
							JS.set_property(_scope10, "closestDistanceSquared", _scope10["distanceSquared"])
							JS.set_property(_scope10, "target", JS.get_property(_scope10["tanks"], _scope10["tankId"]))
							JS.set_property(_scope10, "closestPathLength", JS.add(_scope10["currentPathLength"], _scope10["t"]))
			JS.set_property(_scope10, "currentPathLength", JS.add(_scope10["currentPathLength"], _scope10["diffSegmentLength"]))
			JS.increment(_scope10, "i", 1, false)
		return {"result": _scope10["result"], "target": _scope10["target"], "closestDistance": JS.invoke_method("@Math", "sqrt", [_scope10["closestDistanceSquared"]]), "pathLength": _scope10["closestPathLength"], "direction": JS.get_property(_scope10["pathInfo"], "direction")}
	return null

static func original_checkTrapLaying(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope13: Dictionary = {"tank": _arg0, "tanks": _arg1, "gameController": _arg2, "maxLength": _arg3, "weaponType": _arg4, "tankPosition": null, "closestDistanceSquared": null, "result": null, "target": null, "direction": null, "tankId": null, "otherTankPosition": null, "relativeToTank": null, "angle": null, "distanceSquared": null}
	_scope13["tankPosition"] = {"x": JS.invoke_method(_scope13["tank"], "getX", []), "y": JS.invoke_method(_scope13["tank"], "getY", [])}
	_scope13["closestDistanceSquared"] = _scope13["maxLength"]
	_scope13["result"] = JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "MISS")
	_scope13["target"] = null
	_scope13["direction"] = {"x": 0, "y": 0}
	for _iteration1 in JS.keys(_scope13["tanks"]):
		JS.set_property(_scope13, "tankId", _iteration1)
		if JS.truthy(not JS.equal(_scope13["tankId"], JS.invoke_method(_scope13["tank"], "getPlayerId", []), true)):
			_scope13["otherTankPosition"] = {"x": JS.invoke_method(JS.get_property(_scope13["tanks"], _scope13["tankId"]), "getX", []), "y": JS.invoke_method(JS.get_property(_scope13["tanks"], _scope13["tankId"]), "getY", [])}
			if JS.truthy((not JS.truthy(JS.invoke_method(JS.module("B2DUtils"), "checkLineForMazeCollision", [JS.invoke_method(_scope13["gameController"], "getB2DWorld", []), _scope13["tankPosition"], _scope13["otherTankPosition"]])))):
				_scope13["relativeToTank"] = JS.invoke_method(JS.module("B2DUtils"), "toLocalSpace", [JS.invoke_method(_scope13["tank"], "getB2DBody", []), _scope13["otherTankPosition"]])
				_scope13["angle"] = JS.invoke_method("@Math", "atan2", [JS.get_property(_scope13["relativeToTank"], "y"), JS.get_property(_scope13["relativeToTank"], "x")])
				if JS.truthy(JS.compare(">", _scope13["angle"], 0)):
					_scope13["distanceSquared"] = JS.add((JS.number((JS.number(JS.get_property(_scope13["tankPosition"], "x")) - JS.number(JS.get_property(_scope13["otherTankPosition"], "x")))) * JS.number((JS.number(JS.get_property(_scope13["tankPosition"], "x")) - JS.number(JS.get_property(_scope13["otherTankPosition"], "x"))))), (JS.number((JS.number(JS.get_property(_scope13["tankPosition"], "y")) - JS.number(JS.get_property(_scope13["otherTankPosition"], "y")))) * JS.number((JS.number(JS.get_property(_scope13["tankPosition"], "y")) - JS.number(JS.get_property(_scope13["otherTankPosition"], "y"))))))
					if JS.truthy(JS.compare("<", _scope13["distanceSquared"], _scope13["closestDistanceSquared"])):
						JS.set_property(_scope13, "result", JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "NEAR"))
						JS.set_property(_scope13, "closestDistanceSquared", _scope13["distanceSquared"])
						JS.set_property(_scope13, "target", JS.get_property(_scope13["tanks"], _scope13["tankId"]))
						JS.set_property(_scope13["direction"], "x", (JS.number(JS.get_property(_scope13["otherTankPosition"], "x")) - JS.number(JS.get_property(_scope13["tankPosition"], "x"))))
						JS.set_property(_scope13["direction"], "y", (JS.number(JS.get_property(_scope13["otherTankPosition"], "y")) - JS.number(JS.get_property(_scope13["tankPosition"], "y"))))
	return {"result": _scope13["result"], "target": _scope13["target"], "closestDistance": JS.invoke_method("@Math", "sqrt", [_scope13["closestDistanceSquared"]]), "pathLength": 0, "direction": _scope13["direction"]}
	return null

static func original_getActionsToFollowPath(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope14: Dictionary = {"path": _arg0, "tile": _arg1, "driveToTileActionType": _arg2, "driveToPositionActionType": _arg3, "dexterity": _arg4, "result": null, "i": null, "imprecision": null, "position": null}
	_scope14["result"] = []
	_scope14["i"] = 0
	while JS.truthy(JS.compare("<", _scope14["i"], JS.get_property(_scope14["path"], "length"))):
		_scope14["imprecision"] = JS.invoke_method(JS.module("MathUtils"), "randomAroundZero", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_ROTATION_IMPRECISION"), 0, _scope14["dexterity"]])])
		JS.invoke_method(_scope14["result"], "push", [{"type": _scope14["driveToTileActionType"], "position": JS.get_property(_scope14["path"], _scope14["i"]), "canReverse": JS.compare("<=", JS.get_property(_scope14["path"], "length"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PATH_LENGTH_TO_REVERSE")), "imprecision": _scope14["imprecision"]}])
		JS.increment(_scope14, "i", 1, false)
	if JS.truthy(_scope14["tile"]):
		_scope14["position"] = {"x": (JS.number(JS.add(JS.get_property(_scope14["tile"], "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), "y": (JS.number(JS.add(JS.get_property(_scope14["tile"], "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))}
		_scope14["imprecision"] = JS.invoke_method(JS.module("MathUtils"), "randomAroundZero", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_ROTATION_IMPRECISION"), 0, _scope14["dexterity"]])])
		JS.invoke_method(_scope14["result"], "push", [{"type": _scope14["driveToPositionActionType"], "position": _scope14["position"], "canReverse": JS.compare("<=", JS.get_property(_scope14["path"], "length"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PATH_LENGTH_TO_REVERSE")), "imprecision": _scope14["imprecision"]}])
	return _scope14["result"]
	return null

static func original_getInputToDriveToPosition(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope15: Dictionary = {"tank": _arg0, "targetPosition": _arg1, "canReverse": _arg2, "angleImprecision": _arg3, "forwardState": null, "backState": null, "leftState": null, "rightState": null, "fireState": null, "relativeToTank": null, "magnitude": null, "angle": null, "goInReverse": null}
	_scope15["forwardState"] = false
	_scope15["backState"] = false
	_scope15["leftState"] = false
	_scope15["rightState"] = false
	_scope15["fireState"] = false
	_scope15["relativeToTank"] = JS.invoke_method(JS.module("B2DUtils"), "toLocalSpace", [JS.invoke_method(_scope15["tank"], "getB2DBody", []), _scope15["targetPosition"]])
	_scope15["magnitude"] = JS.invoke_method(_scope15["relativeToTank"], "Length", [])
	_scope15["angle"] = JS.invoke_method("@Math", "atan2", [JS.get_property(_scope15["relativeToTank"], "y"), JS.get_property(_scope15["relativeToTank"], "x")])
	JS.set_property(_scope15, "angle", JS.add(_scope15["angle"], _scope15["angleImprecision"]))
	_scope15["goInReverse"] = false
	if JS.truthy(JS.logical("||", func():
		var _scope16: Dictionary = {}
		return JS.compare(">", _scope15["angle"], JS.add((JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5)), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "ROTATION_DEAD_ANGLE")))
		return null, func():
		var _scope17: Dictionary = {}
		return JS.compare("<", _scope15["angle"], (JS.number((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "ROTATION_DEAD_ANGLE"))))
		return null)):
		if JS.truthy(JS.logical("&&", func():
			var _scope18: Dictionary = {}
			return JS.compare(">", _scope15["angle"], 0)
			return null, func():
			var _scope19: Dictionary = {}
			return _scope15["canReverse"]
			return null)):
			JS.set_property(_scope15, "rightState", true)
			JS.set_property(_scope15, "goInReverse", true)
		else:
			JS.set_property(_scope15, "leftState", true)
	else:
		if JS.truthy(JS.logical("&&", func():
			var _scope20: Dictionary = {}
			return JS.compare(">", _scope15["angle"], JS.add((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5)), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "ROTATION_DEAD_ANGLE")))
			return null, func():
			var _scope21: Dictionary = {}
			return JS.compare("<", _scope15["angle"], (JS.number((JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "ROTATION_DEAD_ANGLE"))))
			return null)):
			if JS.truthy(JS.logical("&&", func():
				var _scope22: Dictionary = {}
				return JS.compare(">", _scope15["angle"], 0)
				return null, func():
				var _scope23: Dictionary = {}
				return _scope15["canReverse"]
				return null)):
				JS.set_property(_scope15, "leftState", true)
				JS.set_property(_scope15, "goInReverse", true)
			else:
				JS.set_property(_scope15, "rightState", true)
		else:
			if JS.truthy(JS.compare(">", _scope15["angle"], 0)):
				if JS.truthy(_scope15["canReverse"]):
					JS.set_property(_scope15, "goInReverse", true)
				else:
					if JS.truthy(JS.compare(">", _scope15["angle"], (JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5)))):
						JS.set_property(_scope15, "leftState", true)
					else:
						JS.set_property(_scope15, "rightState", true)
	if JS.truthy(JS.compare(">", _scope15["magnitude"], JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "POSITION_DEAD_DISTANCE"))):
		if JS.truthy(JS.logical("&&", func():
			var _scope24: Dictionary = {}
			return JS.logical("&&", func():
				var _scope25: Dictionary = {}
				return _scope15["goInReverse"]
				return null, func():
				var _scope26: Dictionary = {}
				return JS.compare(">", _scope15["angle"], (JS.number((JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "POSITION_DEAD_ANGLE"))))
				return null)
			return null, func():
			var _scope27: Dictionary = {}
			return JS.compare("<", _scope15["angle"], JS.add((JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5)), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "POSITION_DEAD_ANGLE")))
			return null)):
			JS.set_property(_scope15, "backState", true)
		else:
			if JS.truthy(JS.logical("&&", func():
				var _scope28: Dictionary = {}
				return JS.compare(">", _scope15["angle"], (JS.number((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "POSITION_DEAD_ANGLE"))))
				return null, func():
				var _scope29: Dictionary = {}
				return JS.compare("<", _scope15["angle"], JS.add((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5)), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "POSITION_DEAD_ANGLE")))
				return null)):
				JS.set_property(_scope15, "forwardState", true)
	return JS.invoke_method(JS.module("InputState"), "withState", [JS.invoke_method(_scope15["tank"], "getPlayerId", []), _scope15["forwardState"], _scope15["backState"], _scope15["leftState"], _scope15["rightState"], _scope15["fireState"]])
	return null

static func original_getInputToTurnToDirection(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope30: Dictionary = {"tank": _arg0, "direction": _arg1, "angleImprecision": _arg2, "forwardState": null, "backState": null, "leftState": null, "rightState": null, "fireState": null, "relativeToTank": null, "angle": null}
	_scope30["forwardState"] = false
	_scope30["backState"] = false
	_scope30["leftState"] = false
	_scope30["rightState"] = false
	_scope30["fireState"] = false
	_scope30["relativeToTank"] = JS.invoke_method(JS.module("B2DUtils"), "directionToLocalSpace", [JS.invoke_method(_scope30["tank"], "getB2DBody", []), _scope30["direction"]])
	_scope30["angle"] = JS.invoke_method("@Math", "atan2", [JS.get_property(_scope30["relativeToTank"], "y"), JS.get_property(_scope30["relativeToTank"], "x")])
	JS.set_property(_scope30, "angle", JS.add(_scope30["angle"], _scope30["angleImprecision"]))
	if JS.truthy(JS.logical("||", func():
		var _scope31: Dictionary = {}
		return JS.compare(">", _scope30["angle"], JS.add((JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5)), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "ROTATION_DEAD_ANGLE")))
		return null, func():
		var _scope32: Dictionary = {}
		return JS.compare("<", _scope30["angle"], (JS.number((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "ROTATION_DEAD_ANGLE"))))
		return null)):
		JS.set_property(_scope30, "leftState", true)
	else:
		if JS.truthy(JS.logical("&&", func():
			var _scope33: Dictionary = {}
			return JS.compare(">", _scope30["angle"], JS.add((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5)), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "ROTATION_DEAD_ANGLE")))
			return null, func():
			var _scope34: Dictionary = {}
			return JS.compare("<", _scope30["angle"], (JS.number((JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "ROTATION_DEAD_ANGLE"))))
			return null)):
			JS.set_property(_scope30, "rightState", true)
		else:
			if JS.truthy(JS.compare(">", _scope30["angle"], 0)):
				if JS.truthy(JS.compare(">", _scope30["angle"], (JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5)))):
					JS.set_property(_scope30, "leftState", true)
				else:
					JS.set_property(_scope30, "rightState", true)
	return JS.invoke_method(JS.module("InputState"), "withState", [JS.invoke_method(_scope30["tank"], "getPlayerId", []), _scope30["forwardState"], _scope30["backState"], _scope30["leftState"], _scope30["rightState"], _scope30["fireState"]])
	return null

static func original_getInputToFire(_arg0 = null, _arg1 = null):
	var _scope35: Dictionary = {"tank": _arg0, "delay": _arg1, "forwardState": null, "backState": null, "leftState": null, "rightState": null, "fireState": null}
	_scope35["forwardState"] = false
	_scope35["backState"] = false
	_scope35["leftState"] = false
	_scope35["rightState"] = false
	_scope35["fireState"] = JS.compare("<=", _scope35["delay"], 0)
	return JS.invoke_method(JS.module("InputState"), "withState", [JS.invoke_method(_scope35["tank"], "getPlayerId", []), _scope35["forwardState"], _scope35["backState"], _scope35["leftState"], _scope35["rightState"], _scope35["fireState"]])
	return null
