# 由原版 AI 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var aiId = null
var config = null
var gameController = null
var myPosition = null
var tankPositions = {}
var projectilePositions = {}
var projectilePaths = {}
var trapPositions = {}
var weaponCratePositions = []
var shieldCratePositions = []
var goldPositions = []
var diamondPositions = []
var laserAimerPaths = {}
var threatMap = null
var kills = []
var stuckNormal = null
var stuckNow = false
var stuckTime = 0
var currentAggressiveness = null
var currentGreediness = null
var goal = null
var nextGoalId = 1
var actions = []
var inputState = null
static var _static_AI: Dictionary = {}
static var _initialized_AI = false
static func initialize_original_static():
	if _initialized_AI: return
	_initialized_AI = true
	_static_AI["_TRAITS"] = {"AGGRESSIVENESS": "aggressiveness", "VENGEFULNESS": "vengefulness", "CLEVERNESS": "cleverness", "GREEDINESS": "greediness", "BOLDNESS": "boldness", "DETERMINATION": "determination", "INSANITY": "insanity", "CHATTINESS": "chattiness", "DEXTERITY": "dexterity"}
	_static_AI["_GOALS"] = {"SHOOT_AFTER": "shoot after", "LAY_TRAP": "lay trap", "PICK_UP_COLLECTIBLE": "pick up collectible", "DODGE_PROJECTILE": "dodge projectile", "GET_UNSTUCK": "get unstuck", "RUN_AWAY": "run away", "HUNT": "hunt", "IDLE": "idle"}
	_static_AI["_ACTIONS"] = {"DRIVE_TO_TILE": "drive to tile", "DRIVE_TO_POSITION": "drive to position", "TURN_TO": "turn to", "FIRE": "fire", "IDLE": "idle"}
	_static_AI["_EVENTS"] = {"GOAL_UPDATED": "goal updated"}
static func original_static_get(key):
	initialize_original_static()
	if _static_AI.has(key): return _static_AI[key]
	return null
static func original_static_set(key, value):
	_static_AI[key] = value
	return value
func original_own_fields():
	return ["aiId","config","gameController","myPosition","tankPositions","projectilePositions","projectilePaths","trapPositions","weaponCratePositions","shieldCratePositions","goldPositions","diamondPositions","laserAimerPaths","threatMap","kills","stuckNormal","stuckNow","stuckTime","currentAggressiveness","currentGreediness","goal","nextGoalId","actions","inputState"]
func original_is_weak_field(key):
	return ["gameController"].has(key) or super.original_is_weak_field(key)

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"aiId": _arg0, "config": _arg1, "gameController": _arg2}
	JS.set_property(self, "aiId", _scope0["aiId"])
	JS.set_property(self, "config", _scope0["config"])
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.invoke_method(self, "_reset", [])
	JS.set_property(self, "inputState", JS.invoke_method(JS.module("InputState"), "withState", [JS.get_property(self, "aiId"), false, false, false, false, false]))
	JS.invoke_method(JS.get_property(self, "gameController"), "addRoundEventListener", [JS.get_property(self, "_roundEventHandler"), self])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/ai/ai.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_update(_arg0 = null):
	var _scope1: Dictionary = {"deltaTime": _arg0}
	JS.invoke_method(self, "_updateState", [_scope1["deltaTime"]])
	if JS.truthy(JS.invoke_method(self, "_makeDecisionsAndUpdateGoal", [_scope1["deltaTime"]])):
		JS.invoke_method(self, "_updateActionsToAchieveGoal", [])
	JS.invoke_method(self, "_updateInputToDoAction", [])
	JS.invoke_method(self, "_updateAndRemovePerformedActions", [_scope1["deltaTime"]])
	return null

func original_shutdown():
	var _scope2: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "gameController"), "removeRoundEventListener", [JS.get_property(self, "_roundEventHandler"), self])
	return null

func original_getInputState():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "inputState")
	return null

func original__roundEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope4: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3}
	var _switch0 = _scope4["evt"]
	var _switch0_start = -1
	if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_KILLED"), true): _switch0_start = 0
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_CREATED"), true): _switch0_start = 1
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_MAZE_COLLISION"), true): _switch0_start = 2
	while true:
		if _switch0_start >= 0 and _switch0_start <= 0:
			if JS.truthy(JS.logical("||", func():
				var _scope5: Dictionary = {}
				return JS.logical("&&", func():
					var _scope6: Dictionary = {}
					return JS.equal(JS.invoke_method(_scope4["data"], "getKillerPlayerId", []), JS.get_property(_scope4["self"], "aiId"), false)
					return null, func():
					var _scope7: Dictionary = {}
					return not JS.equal(JS.invoke_method(_scope4["data"], "getVictimPlayerId", []), JS.get_property(_scope4["self"], "aiId"), true)
					return null)
				return null, func():
				var _scope8: Dictionary = {}
				return JS.logical("&&", func():
					var _scope9: Dictionary = {}
					return not JS.equal(JS.invoke_method(_scope4["data"], "getKillerPlayerId", []), JS.get_property(_scope4["self"], "aiId"), true)
					return null, func():
					var _scope10: Dictionary = {}
					return JS.equal(JS.invoke_method(_scope4["data"], "getVictimPlayerId", []), JS.get_property(_scope4["self"], "aiId"), false)
					return null)
				return null)):
				JS.invoke_method(JS.get_property(_scope4["self"], "kills"), "push", [_scope4["data"]])
				if JS.truthy(JS.compare(">", JS.get_property(JS.get_property(_scope4["self"], "kills"), "length"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "KILLS_TO_REMEMBER"))):
					JS.invoke_method(JS.get_property(_scope4["self"], "kills"), "shift", [])
			break
		if _switch0_start >= 0 and _switch0_start <= 1:
			JS.invoke_method(_scope4["self"], "_reset", [])
			break
		if _switch0_start >= 0 and _switch0_start <= 2:
			if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(_scope4["data"], "tankA"), "getPlayerId", []), JS.get_property(_scope4["self"], "aiId"), false)):
				JS.set_property(_scope4["self"], "stuckNormal", JS.get_property(_scope4["data"], "collisionNormal"))
				JS.set_property(_scope4["self"], "stuckNow", true)
			break
		break
	return null

func original__updateState(_arg0 = null):
	var _scope11: Dictionary = {"deltaTime": _arg0, "self": null, "tank": null, "tanks": null, "collectibles": null, "collectible": null, "position": null, "projectiles": null, "projectile": null, "traps": null, "trap": null, "maze": null, "maxProjectileDistanceToConsider": null, "projectileBounces": null, "projectilePathLength": null, "projectileDistance": null, "pathInfo": null, "projectileSpeed": null, "maxTrapDistanceToConsider": null, "weight": null, "timeAlive": null, "maxTankDistanceToConsider": null, "firingPathBounces": null, "firingPathLength": null, "tankDistance": null, "upgrades": null, "upgradeId": null, "upgrade": null, "zones": null, "zoneId": null, "zone": null, "tiles": null, "i": null, "aggressivenessGrowth": null, "greedinessGrowth": null}
	_scope11["self"] = self
	_scope11["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "aiId")])
	if JS.truthy(JS.equal(_scope11["tank"], null, false)):
		return null
	JS.set_property(self, "myPosition", {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope11["tank"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope11["tank"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])})
	_scope11["tanks"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTanks", [])
	JS.set_property(self, "tankPositions", {})
	for _iteration1 in JS.keys(_scope11["tanks"]):
		JS.set_property(_scope11, "tank", _iteration1)
		JS.set_property(JS.get_property(self, "tankPositions"), _scope11["tank"], {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope11["tanks"], _scope11["tank"]), "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope11["tanks"], _scope11["tank"]), "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])})
	_scope11["collectibles"] = JS.invoke_method(JS.get_property(self, "gameController"), "getCollectibles", [])
	JS.set_property(self, "weaponCratePositions", [])
	JS.set_property(self, "shieldCratePositions", [])
	JS.set_property(self, "goldPositions", [])
	JS.set_property(self, "diamondPositions", [])
	for _iteration2 in JS.keys(_scope11["collectibles"]):
		JS.set_property(_scope11, "collectible", _iteration2)
		_scope11["position"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope11["collectibles"], _scope11["collectible"]), "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope11["collectibles"], _scope11["collectible"]), "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
		var _switch3 = JS.invoke_method(JS.get_property(_scope11["collectibles"], _scope11["collectible"]), "getType", [])
		var _switch3_start = -1
		if JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_LASER"), true): _switch3_start = 0
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_DOUBLE_BARREL"), true): _switch3_start = 1
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SHOTGUN"), true): _switch3_start = 2
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_HOMING_MISSILE"), true): _switch3_start = 3
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_MINE"), true): _switch3_start = 4
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_GATLING_GUN"), true): _switch3_start = 5
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SHIELD"), true): _switch3_start = 6
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "GOLD"), true): _switch3_start = 7
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "DIAMOND"), true): _switch3_start = 8
		while true:
			if _switch3_start >= 0 and _switch3_start <= 5:
				JS.invoke_method(JS.get_property(self, "weaponCratePositions"), "push", [_scope11["position"]])
				break
			if _switch3_start >= 0 and _switch3_start <= 6:
				JS.invoke_method(JS.get_property(self, "shieldCratePositions"), "push", [_scope11["position"]])
				break
			if _switch3_start >= 0 and _switch3_start <= 7:
				JS.invoke_method(JS.get_property(self, "goldPositions"), "push", [_scope11["position"]])
				break
			if _switch3_start >= 0 and _switch3_start <= 8:
				JS.invoke_method(JS.get_property(self, "diamondPositions"), "push", [_scope11["position"]])
				break
			break
	_scope11["projectiles"] = JS.invoke_method(JS.get_property(self, "gameController"), "getProjectiles", [])
	JS.set_property(self, "projectilePositions", {})
	JS.set_property(self, "projectilePaths", {})
	JS.set_property(self, "trapPositions", {})
	JS.set_property(self, "laserAimerPaths", {})
	for _iteration4 in JS.keys(_scope11["projectiles"]):
		JS.set_property(_scope11, "projectile", _iteration4)
		JS.set_property(JS.get_property(self, "projectilePositions"), _scope11["projectile"], {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope11["projectiles"], _scope11["projectile"]), "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope11["projectiles"], _scope11["projectile"]), "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])})
	_scope11["traps"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTraps", [])
	for _iteration5 in JS.keys(_scope11["traps"]):
		JS.set_property(_scope11, "trap", _iteration5)
		JS.set_property(JS.get_property(self, "trapPositions"), _scope11["trap"], {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope11["traps"], _scope11["trap"]), "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(JS.get_property(_scope11["traps"], _scope11["trap"]), "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])})
	_scope11["maze"] = JS.invoke_method(JS.get_property(self, "gameController"), "getMaze", [])
	if JS.truthy(_scope11["maze"]):
		if JS.truthy(JS.get_property(self, "threatMap")):
			JS.invoke_method(JS.get_property(self, "threatMap"), "clear", [0])
		else:
			JS.set_property(self, "threatMap", JS.invoke_method(JS.module("MazeMap"), "create", [JS.invoke_method(_scope11["maze"], "getWidth", []), JS.invoke_method(_scope11["maze"], "getHeight", []), 0]))
		_scope11["maxProjectileDistanceToConsider"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_PROJECTILE_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PROJECTILE_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
		_scope11["projectileBounces"] = JS.invoke_method("@Math", "ceil", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_PROJECTILE_BOUNCES"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PROJECTILE_BOUNCES"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])])
		_scope11["projectilePathLength"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_PROJECTILE_PATH_LENGTH"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PROJECTILE_PATH_LENGTH"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
		_scope11["projectiles"] = JS.invoke_method(JS.get_property(self, "gameController"), "getProjectiles", [])
		for _iteration6 in JS.keys(_scope11["projectiles"]):
			JS.set_property(_scope11, "projectile", _iteration6)
			_scope11["projectileDistance"] = JS.invoke_method(_scope11["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "projectilePositions"), _scope11["projectile"])])
			if JS.truthy(JS.logical("&&", func():
				var _scope12: Dictionary = {}
				return not JS.equal(_scope11["projectileDistance"], false, true)
				return null, func():
				var _scope13: Dictionary = {}
				return JS.compare("<=", _scope11["projectileDistance"], _scope11["maxProjectileDistanceToConsider"])
				return null)):
				_scope11["pathInfo"] = JS.invoke_method(JS.module("B2DUtils"), "calculateProjectilePath", [JS.invoke_method(JS.get_property(self, "gameController"), "getB2DWorld", []), JS.get_property(_scope11["projectiles"], _scope11["projectile"]), _scope11["projectileBounces"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope11["projectilePathLength"])), false])
				JS.set_property(JS.get_property(self, "projectilePaths"), _scope11["projectile"], JS.get_property(_scope11["pathInfo"], "path"))
				_scope11["projectileSpeed"] = JS.invoke_method("@Math", "sqrt", [JS.add((JS.number(JS.invoke_method(JS.get_property(_scope11["projectiles"], _scope11["projectile"]), "getSpeedX", [])) * JS.number(JS.invoke_method(JS.get_property(_scope11["projectiles"], _scope11["projectile"]), "getSpeedX", []))), (JS.number(JS.invoke_method(JS.get_property(_scope11["projectiles"], _scope11["projectile"]), "getSpeedY", [])) * JS.number(JS.invoke_method(JS.get_property(_scope11["projectiles"], _scope11["projectile"]), "getSpeedY", []))))])
				JS.invoke_method(JS.module("B2DUtils"), "splatPathUntoMazeMap", [JS.get_property(self, "threatMap"), JS.get_property(_scope11["pathInfo"], "path"), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "PATH_STEP_SIZE"))), func(_arg0 = null, _arg1 = null, _arg2 = null):
					var _scope14: Dictionary = {"tile": _arg0, "length": _arg1, "stepSize": _arg2, "distance": null, "projectileTimeToHere": null, "tankTimeToHere": null}
					_scope14["distance"] = JS.invoke_method(_scope11["maze"], "getDistanceBetweenPositions", [_scope14["tile"], JS.get_property(_scope11["self"], "myPosition")])
					if JS.truthy(JS.equal(_scope14["distance"], false, true)):
						return 0
					_scope14["projectileTimeToHere"] = (JS.number(_scope14["length"]) / JS.number(_scope11["projectileSpeed"]))
					_scope14["tankTimeToHere"] = (JS.number((JS.number(_scope14["distance"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) / JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "FORWARD_SPEED"), "m")))
					return (JS.number((JS.number(JS.invoke_method("@Math", "min", [1, JS.invoke_method("@Math", "max", [0, (JS.number(1) - JS.number((JS.number(JS.invoke_method("@Math", "abs", [(JS.number(_scope14["projectileTimeToHere"]) - JS.number(_scope14["tankTimeToHere"]))])) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "PROJECTILE_THREAT_TIME_FALLOFF")))))])])) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "PROJECTILE_THREAT_WEIGHT")))) * JS.number(_scope14["stepSize"]))
					return null])
		_scope11["maxTrapDistanceToConsider"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_TRAP_THREAT_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_TRAP_THREAT_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
		_scope11["traps"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTraps", [])
		for _iteration7 in JS.keys(_scope11["traps"]):
			JS.set_property(_scope11, "trap", _iteration7)
			_scope11["weight"] = JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "TRAP_THREAT_WEIGHT")
			var _switch8 = JS.invoke_method(JS.get_property(_scope11["traps"], _scope11["trap"]), "getType", [])
			var _switch8_start = -1
			if JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch8_start = 0
			while true:
				if _switch8_start >= 0 and _switch8_start <= 0:
					_scope11["timeAlive"] = JS.invoke_method(JS.get_property(_scope11["traps"], _scope11["trap"]), "getTimeAlive", [])
					if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(_scope11["traps"], _scope11["trap"]), "getPlayerId", []), JS.get_property(self, "aiId"), false)):
						JS.set_property(_scope11, "timeAlive", (JS.number(_scope11["timeAlive"]) * JS.number(JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "OWN_MINE_THREAT_MAX_TIME_MODIFIER"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "OWN_MINE_THREAT_MIN_TIME_MODIFIER"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))]))))
					JS.set_property(_scope11, "weight", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MINE_INITIAL_THREAT_WEIGHT")) - JS.number((JS.number(_scope11["timeAlive"]) * JS.number(JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MINE_THREAT_MAX_TIME_FALLOFF"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MINE_THREAT_MIN_TIME_FALLOFF"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])))))]))
					break
				break
			JS.invoke_method(_scope11["maze"], "traverseCloseTiles", [JS.get_property(JS.get_property(self, "trapPositions"), _scope11["trap"]), 1, func(_arg0 = null):
				var _scope15: Dictionary = {"current": _arg0}
				JS.invoke_method(JS.get_property(_scope11["self"], "threatMap"), "add", [_scope15["current"], (JS.number(_scope11["weight"]) / JS.number(JS.add(JS.get_property(_scope15["current"], "distance"), 1)))])
				return null])
		_scope11["maxTankDistanceToConsider"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_TANK_THREAT_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_TANK_THREAT_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
		_scope11["firingPathBounces"] = JS.invoke_method("@Math", "ceil", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_FIRING_THREAT_PATH_BOUNCES"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_FIRING_THREAT_PATH_BOUNCES"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])])
		_scope11["firingPathLength"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_FIRING_THREAT_PATH_LENGTH"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_FIRING_THREAT_PATH_LENGTH"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
		for _iteration9 in JS.keys(_scope11["tanks"]):
			JS.set_property(_scope11, "tank", _iteration9)
			if JS.truthy(not JS.equal(_scope11["tank"], JS.get_property(self, "aiId"), true)):
				_scope11["tankDistance"] = JS.invoke_method(_scope11["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "tankPositions"), _scope11["tank"])])
				if JS.truthy(JS.logical("&&", func():
					var _scope16: Dictionary = {}
					return not JS.equal(_scope11["tankDistance"], false, true)
					return null, func():
					var _scope17: Dictionary = {}
					return JS.compare("<=", _scope11["tankDistance"], _scope11["maxTankDistanceToConsider"])
					return null)):
					_scope11["pathInfo"] = JS.invoke_method(JS.module("B2DUtils"), "calculateFiringPath", [JS.invoke_method(JS.get_property(self, "gameController"), "getB2DWorld", []), JS.get_property(_scope11["tanks"], _scope11["tank"]), 0, _scope11["firingPathBounces"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope11["firingPathLength"])), false])
					JS.invoke_method(JS.module("B2DUtils"), "splatPathUntoMazeMap", [JS.get_property(self, "threatMap"), JS.get_property(_scope11["pathInfo"], "path"), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "PATH_STEP_SIZE"))), func(_arg0 = null, _arg1 = null, _arg2 = null):
						var _scope18: Dictionary = {"tile": _arg0, "length": _arg1, "stepSize": _arg2}
						return (JS.number((JS.number((JS.number(1) - JS.number((JS.number(_scope18["length"]) / JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope11["firingPathLength"]))))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "FIRING_PATH_THREAT_WEIGHT")))) * JS.number(_scope18["stepSize"]))
						return null])
					JS.invoke_method(_scope11["maze"], "traverseCloseTiles", [JS.get_property(JS.get_property(self, "tankPositions"), _scope11["tank"]), 1, func(_arg0 = null):
						var _scope19: Dictionary = {"current": _arg0}
						JS.invoke_method(JS.get_property(_scope11["self"], "threatMap"), "add", [_scope19["current"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "TANK_THREAT_WEIGHT")) / JS.number(JS.add(JS.get_property(_scope19["current"], "distance"), 1)))])
						return null])
		_scope11["upgrades"] = JS.invoke_method(JS.get_property(self, "gameController"), "getUpgrades", [])
		for _iteration10 in JS.keys(_scope11["upgrades"]):
			JS.set_property(_scope11, "upgradeId", _iteration10)
			_scope11["upgrade"] = JS.get_property(_scope11["upgrades"], _scope11["upgradeId"])
			if JS.truthy(not JS.equal(JS.invoke_method(_scope11["upgrade"], "getPlayerId", []), JS.get_property(self, "aiId"), true)):
				var _switch11 = JS.invoke_method(_scope11["upgrade"], "getType", [])
				var _switch11_start = -1
				if JS.equal(_switch11, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "LASER_AIMER"), true): _switch11_start = 0
				while true:
					if _switch11_start >= 0 and _switch11_start <= 0:
						_scope11["pathInfo"] = JS.invoke_method(JS.module("B2DUtils"), "calculateFiringPath", [JS.invoke_method(JS.get_property(self, "gameController"), "getB2DWorld", []), JS.get_property(_scope11["tanks"], JS.invoke_method(_scope11["upgrade"], "getPlayerId", [])), 0, JS.get_property("@Number", "MAX_VALUE"), JS.invoke_method(_scope11["upgrade"], "getField", ["length"]), true])
						JS.set_property(JS.get_property(self, "laserAimerPaths"), _scope11["upgradeId"], JS.get_property(_scope11["pathInfo"], "path"))
						JS.invoke_method(JS.module("B2DUtils"), "splatPathUntoMazeMap", [JS.get_property(self, "threatMap"), JS.get_property(_scope11["pathInfo"], "path"), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "PATH_STEP_SIZE"))), func(_arg0 = null, _arg1 = null, _arg2 = null):
							var _scope20: Dictionary = {"tile": _arg0, "length": _arg1, "stepSize": _arg2}
							return (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "LASER_AIMER_THREAT_WEIGHT")) * JS.number(_scope20["stepSize"]))
							return null])
					break
		_scope11["zones"] = JS.invoke_method(JS.get_property(self, "gameController"), "getZones", [])
		for _iteration12 in JS.keys(_scope11["zones"]):
			JS.set_property(_scope11, "zoneId", _iteration12)
			_scope11["zone"] = JS.get_property(_scope11["zones"], _scope11["zoneId"])
			var _switch13 = JS.invoke_method(_scope11["zone"], "getType", [])
			var _switch13_start = -1
			if JS.equal(_switch13, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "SPAWN"), true): _switch13_start = 0
			elif JS.equal(_switch13, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "STORM"), true): _switch13_start = 1
			while true:
				if _switch13_start >= 0 and _switch13_start <= 0:
					_scope11["tiles"] = JS.invoke_method(_scope11["zone"], "getTiles", [])
					_scope11["i"] = 0
					while JS.truthy(JS.compare("<", _scope11["i"], JS.get_property(_scope11["tiles"], "length"))):
						JS.invoke_method(JS.get_property(self, "threatMap"), "add", [JS.get_property(_scope11["tiles"], _scope11["i"]), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "SPAWN_ZONE_THREAT_WEIGHT")])
						JS.increment(_scope11, "i", 1, false)
					break
				if _switch13_start >= 0 and _switch13_start <= 1:
					_scope11["tiles"] = JS.invoke_method(_scope11["zone"], "getTiles", [])
					_scope11["i"] = 0
					while JS.truthy(JS.compare("<", _scope11["i"], JS.get_property(_scope11["tiles"], "length"))):
						JS.invoke_method(JS.get_property(self, "threatMap"), "add", [JS.get_property(_scope11["tiles"], _scope11["i"]), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "STORM_ZONE_THREAT_WEIGHT")])
						JS.increment(_scope11, "i", 1, false)
					break
				break
	if JS.truthy(JS.get_property(self, "stuckNow")):
		JS.set_property(self, "stuckTime", JS.add(JS.get_property(self, "stuckTime"), _scope11["deltaTime"]))
	else:
		JS.set_property(self, "stuckTime", 0)
	JS.set_property(self, "stuckNow", false)
	_scope11["aggressivenessGrowth"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_AGGRESSIVENESS_GROWTH"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_AGGRESSIVENESS_GROWTH"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "AGGRESSIVENESS"))])
	JS.set_property(self, "currentAggressiveness", JS.invoke_method("@Math", "min", [JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "AGGRESSIVENESS")), JS.add(JS.get_property(self, "currentAggressiveness"), (JS.number(_scope11["aggressivenessGrowth"]) * JS.number(_scope11["deltaTime"])))]))
	_scope11["greedinessGrowth"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_GREEDINESS_GROWTH"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_GREEDINESS_GROWTH"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "GREEDINESS"))])
	JS.set_property(self, "currentGreediness", JS.invoke_method("@Math", "min", [JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "GREEDINESS")), JS.add(JS.get_property(self, "currentGreediness"), (JS.number(_scope11["greedinessGrowth"]) * JS.number(_scope11["deltaTime"])))]))
	return null

func original__reset():
	var _scope21: Dictionary = {}
	JS.set_property(self, "goal", {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "IDLE"), "priority": JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "IDLE_PRIORITY"), "id": 0, "period": 0})
	JS.set_property(self, "nextGoalId", 1)
	JS.set_property(self, "stuckNow", false)
	JS.set_property(self, "stuckTime", 0)
	JS.set_property(self, "stuckNormal", null)
	JS.set_property(self, "threatMap", null)
	return null

func original__getPreferredTarget(_arg0 = null, _arg1 = null):
	var _scope22: Dictionary = {"gameMode": _arg0, "tanks": _arg1, "target": null, "priority": null, "killsToBeBlindedByRevenge": null, "revengeTarget": null, "revengePriority": null, "highestKillCount": null, "tank": null, "killCount": null, "i": null, "kill": null, "revengeWeight": null, "winTarget": null, "winPriority": null, "highestScore": null, "score": null}
	_scope22["target"] = null
	_scope22["priority"] = 0
	_scope22["killsToBeBlindedByRevenge"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_KILLS_TO_BE_BLINDED_BY_REVENGE"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_KILLS_TO_BE_BLINDED_BY_REVENGE"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "VENGEFULNESS"))])
	_scope22["revengeTarget"] = null
	_scope22["revengePriority"] = 0
	_scope22["highestKillCount"] = 0
	for _iteration14 in JS.keys(_scope22["tanks"]):
		JS.set_property(_scope22, "tank", _iteration14)
		_scope22["killCount"] = 0
		_scope22["i"] = 0
		while JS.truthy(JS.compare("<", _scope22["i"], JS.get_property(JS.get_property(self, "kills"), "length"))):
			_scope22["kill"] = JS.get_property(JS.get_property(self, "kills"), _scope22["i"])
			if JS.truthy(JS.logical("&&", func():
				var _scope23: Dictionary = {}
				return JS.equal(JS.invoke_method(_scope22["kill"], "getKillerPlayerId", []), _scope22["tank"], false)
				return null, func():
				var _scope24: Dictionary = {}
				return JS.equal(JS.invoke_method(_scope22["kill"], "getVictimPlayerId", []), JS.get_property(self, "aiId"), false)
				return null)):
				JS.increment(_scope22, "killCount", 1, false)
			JS.increment(_scope22, "i", 1, false)
		if JS.truthy(JS.compare(">", _scope22["killCount"], _scope22["highestKillCount"])):
			JS.set_property(_scope22, "revengeTarget", _scope22["tank"])
			JS.set_property(_scope22, "highestKillCount", _scope22["killCount"])
	if JS.truthy(_scope22["revengeTarget"]):
		_scope22["revengeWeight"] = JS.invoke_method("@Math", "min", [1, (JS.number(_scope22["highestKillCount"]) / JS.number(_scope22["killsToBeBlindedByRevenge"]))])
		JS.set_property(_scope22, "revengePriority", JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_REVENGE_PRIORITY"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_REVENGE_PRIORITY"), _scope22["revengeWeight"]]))
		if JS.truthy(JS.compare(">", _scope22["revengePriority"], _scope22["priority"])):
			JS.set_property(_scope22, "target", _scope22["revengeTarget"])
			JS.set_property(_scope22, "priority", _scope22["revengePriority"])
	_scope22["winTarget"] = null
	_scope22["winPriority"] = 0
	var _switch15 = _scope22["gameMode"]
	var _switch15_start = -1
	if JS.equal(_switch15, JS.get_property(JS.get_property(JS.module("Constants"), "GAME_MODES"), "DEATHMATCH"), true): _switch15_start = 0
	while true:
		if _switch15_start >= 0 and _switch15_start <= 0:
			_scope22["highestScore"] = 0
			for _iteration16 in JS.keys(_scope22["tanks"]):
				JS.set_property(_scope22, "tank", _iteration16)
				_scope22["score"] = JS.invoke_method(JS.get_property(self, "gameController"), "getScoreByPlayerIdAndType", [_scope22["tank"], JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "KILL")])
				if JS.truthy(_scope22["score"]):
					if JS.truthy(JS.compare(">", JS.invoke_method(_scope22["score"], "getValue", []), _scope22["highestScore"])):
						JS.set_property(_scope22, "winTarget", _scope22["tank"])
						JS.set_property(_scope22, "highestScore", JS.invoke_method(_scope22["score"], "getValue", []))
			break
		break
	if JS.truthy(_scope22["winTarget"]):
		JS.set_property(_scope22, "winPriority", JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_WIN_PRIORITY"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_WIN_PRIORITY"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))]))
		if JS.truthy(JS.compare(">", _scope22["winPriority"], _scope22["priority"])):
			JS.set_property(_scope22, "target", _scope22["winTarget"])
			JS.set_property(_scope22, "priority", _scope22["winPriority"])
	return {"target": _scope22["target"], "priority": _scope22["priority"]}
	return null

func original__makeDecisionsAndUpdateGoal(_arg0 = null):
	var _scope25: Dictionary = {"deltaTime": _arg0, "tank": null, "maze": null, "tanks": null, "projectiles": null, "traps": null, "upgrades": null, "currentGoal": null, "defaultGoalPeriod": null, "preferredTargetInfo": null, "maxCrateDistanceToConsider": null, "crateDistanceFalloff": null, "cratePriorityOffset": null, "numQueuedWeapons": null, "i": null, "crateDistance": null, "cratePriority": null, "crateGoal": null, "maxCurrencyDistanceToConsider": null, "currencyDistanceFalloff": null, "goldDistance": null, "goldPriorityOffset": null, "goldPriority": null, "diamondDistance": null, "diamondPriorityOffset": null, "diamondPriority": null, "scaryProjectileDistance": null, "maxDodgeProjectileDistance": null, "projectilePath": null, "dodgeInfo": null, "dodgeProjectilePriority": null, "dodgeGoal": null, "activeWeapon": null, "defaultWeapon": null, "laserAimerDistance": null, "laserAimerPath": null, "allProtected": null, "getUnstuckPriority": null, "maxTankDistanceToConsider": null, "tankDistance": null, "targetPriorityOffset": null, "huntPriority": null, "huntGoal": null}
	if JS.truthy(JS.compare(">", JS.get_property(JS.get_property(self, "goal"), "period"), 0)):
		JS.set_property(JS.get_property(self, "goal"), "period", (JS.number(JS.get_property(JS.get_property(self, "goal"), "period")) - JS.number(_scope25["deltaTime"])))
		return false
	JS.set_property(JS.get_property(self, "goal"), "priority", (JS.number(JS.get_property(JS.get_property(self, "goal"), "priority")) - JS.number((JS.number(JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PRIORITY_DECREASE"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_PRIORITY_DECREASE"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DETERMINATION"))])) * JS.number(_scope25["deltaTime"])))))
	_scope25["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "aiId")])
	if JS.truthy(JS.equal(_scope25["tank"], null, true)):
		return false
	_scope25["maze"] = JS.invoke_method(JS.get_property(self, "gameController"), "getMaze", [])
	if JS.truthy(JS.equal(_scope25["maze"], null, true)):
		return false
	_scope25["tanks"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTanks", [])
	_scope25["projectiles"] = JS.invoke_method(JS.get_property(self, "gameController"), "getProjectiles", [])
	_scope25["traps"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTraps", [])
	_scope25["upgrades"] = JS.invoke_method(JS.get_property(self, "gameController"), "getUpgrades", [])
	_scope25["currentGoal"] = JS.get_property(self, "goal")
	_scope25["defaultGoalPeriod"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_GOAL_PERIOD"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_GOAL_PERIOD"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
	_scope25["preferredTargetInfo"] = JS.invoke_method(self, "_getPreferredTarget", [JS.invoke_method(JS.get_property(self, "gameController"), "getMode", []), _scope25["tanks"]])
	_scope25["maxCrateDistanceToConsider"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_CRATE_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_CRATE_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
	_scope25["crateDistanceFalloff"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_CRATE_DISTANCE_FALLOFF"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_CRATE_DISTANCE_FALLOFF"), JS.get_property(self, "currentGreediness")])
	_scope25["cratePriorityOffset"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_CRATE_PRIORITY_OFFSET"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_CRATE_PRIORITY_OFFSET"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
	_scope25["numQueuedWeapons"] = JS.get_property(JS.invoke_method(JS.get_property(self, "gameController"), "getQueuedWeapons", [JS.get_property(self, "aiId")]), "length")
	if JS.truthy(JS.compare("<", _scope25["numQueuedWeapons"], JS.get_property(JS.module("Constants"), "MAX_WEAPON_QUEUE"))):
		_scope25["i"] = 0
		while JS.truthy(JS.compare("<", _scope25["i"], JS.get_property(JS.get_property(self, "weaponCratePositions"), "length"))):
			_scope25["crateDistance"] = JS.invoke_method(_scope25["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "weaponCratePositions"), _scope25["i"])])
			if JS.truthy(JS.logical("&&", func():
				var _scope26: Dictionary = {}
				return not JS.equal(_scope25["crateDistance"], false, true)
				return null, func():
				var _scope27: Dictionary = {}
				return JS.compare("<=", _scope25["crateDistance"], _scope25["maxCrateDistanceToConsider"])
				return null)):
				_scope25["cratePriority"] = (JS.number(JS.add(JS.invoke_method("@Math", "max", [0, (JS.number(1) - JS.number((JS.number(_scope25["crateDistance"]) * JS.number(_scope25["crateDistanceFalloff"]))))]), _scope25["cratePriorityOffset"])) / JS.number(JS.add(1, _scope25["cratePriorityOffset"])))
				_scope25["crateGoal"] = {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "PICK_UP_COLLECTIBLE"), "priority": _scope25["cratePriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope25["defaultGoalPeriod"], "position": JS.get_property(JS.get_property(self, "weaponCratePositions"), _scope25["i"])}
				JS.invoke_method(self, "_updateGoal", [_scope25["crateGoal"]])
			JS.increment(_scope25, "i", 1, false)
	_scope25["i"] = 0
	while JS.truthy(JS.compare("<", _scope25["i"], JS.get_property(JS.get_property(self, "shieldCratePositions"), "length"))):
		_scope25["crateDistance"] = JS.invoke_method(_scope25["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "shieldCratePositions"), _scope25["i"])])
		if JS.truthy(JS.logical("&&", func():
			var _scope28: Dictionary = {}
			return not JS.equal(_scope25["crateDistance"], false, true)
			return null, func():
			var _scope29: Dictionary = {}
			return JS.compare("<=", _scope25["crateDistance"], _scope25["maxCrateDistanceToConsider"])
			return null)):
			_scope25["cratePriority"] = (JS.number(JS.add(JS.invoke_method("@Math", "max", [0, (JS.number(1) - JS.number((JS.number(_scope25["crateDistance"]) * JS.number(_scope25["crateDistanceFalloff"]))))]), _scope25["cratePriorityOffset"])) / JS.number(JS.add(1, _scope25["cratePriorityOffset"])))
			_scope25["crateGoal"] = {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "PICK_UP_COLLECTIBLE"), "priority": _scope25["cratePriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope25["defaultGoalPeriod"], "position": JS.get_property(JS.get_property(self, "shieldCratePositions"), _scope25["i"])}
			JS.invoke_method(self, "_updateGoal", [_scope25["crateGoal"]])
		JS.increment(_scope25, "i", 1, false)
	_scope25["maxCurrencyDistanceToConsider"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_CURRENCY_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_CURRENCY_DISTANCE_TO_CONSIDER"), JS.get_property(self, "currentGreediness")])
	_scope25["currencyDistanceFalloff"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_CURRENCY_DISTANCE_FALLOFF"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_CURRENCY_DISTANCE_FALLOFF"), JS.get_property(self, "currentGreediness")])
	_scope25["i"] = 0
	while JS.truthy(JS.compare("<", _scope25["i"], JS.get_property(JS.get_property(self, "goldPositions"), "length"))):
		_scope25["goldDistance"] = JS.invoke_method(_scope25["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "goldPositions"), _scope25["i"])])
		if JS.truthy(JS.logical("&&", func():
			var _scope30: Dictionary = {}
			return not JS.equal(_scope25["goldDistance"], false, true)
			return null, func():
			var _scope31: Dictionary = {}
			return JS.compare("<=", _scope25["goldDistance"], _scope25["maxCurrencyDistanceToConsider"])
			return null)):
			_scope25["goldPriorityOffset"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_GOLD_PRIORITY_OFFSET"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_GOLD_PRIORITY_OFFSET"), JS.get_property(self, "currentGreediness")])
			_scope25["goldPriority"] = (JS.number(JS.add(JS.invoke_method("@Math", "max", [0, (JS.number(1) - JS.number((JS.number(_scope25["goldDistance"]) * JS.number(_scope25["currencyDistanceFalloff"]))))]), _scope25["goldPriorityOffset"])) / JS.number(JS.add(1, _scope25["goldPriorityOffset"])))
			_scope25["crateGoal"] = {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "PICK_UP_COLLECTIBLE"), "priority": _scope25["goldPriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope25["defaultGoalPeriod"], "position": JS.get_property(JS.get_property(self, "goldPositions"), _scope25["i"])}
			JS.invoke_method(self, "_updateGoal", [_scope25["crateGoal"]])
		JS.increment(_scope25, "i", 1, false)
	_scope25["i"] = 0
	while JS.truthy(JS.compare("<", _scope25["i"], JS.get_property(JS.get_property(self, "diamondPositions"), "length"))):
		_scope25["diamondDistance"] = JS.invoke_method(_scope25["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "diamondPositions"), _scope25["i"])])
		if JS.truthy(JS.logical("&&", func():
			var _scope32: Dictionary = {}
			return not JS.equal(_scope25["diamondDistance"], false, true)
			return null, func():
			var _scope33: Dictionary = {}
			return JS.compare("<=", _scope25["diamondDistance"], _scope25["maxCurrencyDistanceToConsider"])
			return null)):
			_scope25["diamondPriorityOffset"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_DIAMOND_PRIORITY_OFFSET"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_DIAMOND_PRIORITY_OFFSET"), JS.get_property(self, "currentGreediness")])
			_scope25["diamondPriority"] = (JS.number(JS.add(JS.invoke_method("@Math", "max", [0, (JS.number(1) - JS.number((JS.number(_scope25["diamondDistance"]) * JS.number(_scope25["currencyDistanceFalloff"]))))]), _scope25["diamondPriorityOffset"])) / JS.number(JS.add(1, _scope25["diamondPriorityOffset"])))
			_scope25["crateGoal"] = {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "PICK_UP_COLLECTIBLE"), "priority": _scope25["diamondPriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope25["defaultGoalPeriod"], "position": JS.get_property(JS.get_property(self, "diamondPositions"), _scope25["i"])}
			JS.invoke_method(self, "_updateGoal", [_scope25["crateGoal"]])
		JS.increment(_scope25, "i", 1, false)
	_scope25["scaryProjectileDistance"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_SCARY_PROJECTILE_DISTANCE"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_SCARY_PROJECTILE_DISTANCE"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "BOLDNESS"))])
	_scope25["maxDodgeProjectileDistance"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_DODGE_PROJECTILE_DISTANCE"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_DODGE_PROJECTILE_DISTANCE"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "BOLDNESS"))])
	for _iteration17 in JS.keys(JS.get_property(self, "projectilePaths")):
		JS.set_property(_scope25, "projectilePath", _iteration17)
		if JS.truthy(JS.invoke_method(JS.module("AIUtils"), "checkProtected", [JS.get_property(self, "aiId"), JS.get_property(self, "gameController")])):
			continue
		_scope25["dodgeInfo"] = JS.invoke_method(JS.module("AIUtils"), "checkProjectilePathForDodging", [_scope25["tank"], JS.get_property(JS.get_property(self, "projectilePaths"), _scope25["projectilePath"]), JS.get_property(_scope25["projectiles"], _scope25["projectilePath"]), JS.invoke_method(JS.get_property(self, "gameController"), "getB2DWorld", []), (JS.number(_scope25["scaryProjectileDistance"]) * JS.number(_scope25["scaryProjectileDistance"]))])
		_scope25["dodgeProjectilePriority"] = (JS.number(JS.add((JS.number((JS.number(_scope25["maxDodgeProjectileDistance"]) - JS.number(JS.get_property(_scope25["dodgeInfo"], "closestDistance")))) / JS.number(_scope25["maxDodgeProjectileDistance"])), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "DODGE_PRIORITY_OFFSET"))) / JS.number(JS.add(1, JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "DODGE_PRIORITY_OFFSET"))))
		_scope25["dodgeGoal"] = {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "DODGE_PROJECTILE"), "priority": _scope25["dodgeProjectilePriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope25["defaultGoalPeriod"], "dodgeInfo": _scope25["dodgeInfo"]}
		JS.invoke_method(self, "_updateGoal", [_scope25["dodgeGoal"]])
	_scope25["activeWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getActiveWeapon", [JS.get_property(self, "aiId")])
	if JS.truthy(_scope25["activeWeapon"]):
		var _switch18 = JS.invoke_method(_scope25["activeWeapon"], "getType", [])
		var _switch18_start = -1
		if JS.equal(_switch18, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch18_start = 0
		elif JS.equal(_switch18, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch18_start = 1
		elif JS.equal(_switch18, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch18_start = 2
		elif JS.equal(_switch18, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch18_start = 3
		elif JS.equal(_switch18, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch18_start = 4
		elif JS.equal(_switch18, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch18_start = 5
		while true:
			if _switch18_start >= 0 and _switch18_start <= 0:
				if JS.truthy(JS.compare("<", JS.invoke_method(_scope25["activeWeapon"], "getField", ["bulletsFired"]), JS.invoke_method(_scope25["activeWeapon"], "getField", ["numBullets"]))):
					JS.invoke_method(self, "_updateStandardShootAfterGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"], JS.invoke_method(_scope25["activeWeapon"], "getType", []), _scope25["preferredTargetInfo"]])
				break
			if _switch18_start >= 0 and _switch18_start <= 2:
				JS.invoke_method(self, "_updateStandardShootAfterGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"], JS.invoke_method(_scope25["activeWeapon"], "getType", []), _scope25["preferredTargetInfo"]])
				break
			if _switch18_start >= 0 and _switch18_start <= 3:
				if JS.truthy(JS.compare("<=", JS.invoke_method(_scope25["activeWeapon"], "getField", ["reloadTime"]), 0)):
					JS.invoke_method(self, "_updateStandardShootAfterGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"], JS.invoke_method(_scope25["activeWeapon"], "getType", []), _scope25["preferredTargetInfo"]])
				break
			if _switch18_start >= 0 and _switch18_start <= 4:
				if JS.truthy((not JS.truthy(JS.invoke_method(_scope25["activeWeapon"], "getField", ["launched"])))):
					JS.invoke_method(self, "_updateStandardShootAfterGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"], JS.invoke_method(_scope25["activeWeapon"], "getType", []), _scope25["preferredTargetInfo"]])
				break
			if _switch18_start >= 0 and _switch18_start <= 5:
				if JS.truthy(JS.compare(">", JS.invoke_method(_scope25["activeWeapon"], "getField", ["numBullets"]), 0)):
					JS.invoke_method(self, "_updateStandardShootAfterGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"], JS.invoke_method(_scope25["activeWeapon"], "getType", []), _scope25["preferredTargetInfo"]])
				break
			break
	if JS.truthy(_scope25["activeWeapon"]):
		var _switch19 = JS.invoke_method(_scope25["activeWeapon"], "getType", [])
		var _switch19_start = -1
		if JS.equal(_switch19, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch19_start = 0
		while true:
			if _switch19_start >= 0 and _switch19_start <= 0:
				if JS.truthy(JS.compare(">", JS.invoke_method(_scope25["activeWeapon"], "getField", ["numMines"]), 0)):
					JS.invoke_method(self, "_updateStandardLayTrapGoal", [_scope25["tanks"], _scope25["traps"], _scope25["maze"], _scope25["defaultGoalPeriod"], JS.invoke_method(_scope25["activeWeapon"], "getType", [])])
				break
			break
	if JS.truthy((not JS.truthy(JS.invoke_method(JS.module("AIUtils"), "checkProtected", [JS.get_property(self, "aiId"), JS.get_property(self, "gameController")])))):
		_scope25["defaultWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getDefaultWeapon", [JS.get_property(self, "aiId")])
		if JS.truthy(JS.logical("&&", func():
			var _scope34: Dictionary = {}
			return _scope25["activeWeapon"]
			return null, func():
			var _scope35: Dictionary = {}
			return _scope25["defaultWeapon"]
			return null)):
			if JS.truthy(JS.equal(_scope25["activeWeapon"], _scope25["defaultWeapon"], false)):
				var _switch20 = JS.invoke_method(_scope25["activeWeapon"], "getType", [])
				var _switch20_start = -1
				if JS.equal(_switch20, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch20_start = 0
				elif JS.equal(_switch20, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch20_start = 1
				elif JS.equal(_switch20, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch20_start = 2
				elif JS.equal(_switch20, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch20_start = 3
				elif JS.equal(_switch20, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch20_start = 4
				elif JS.equal(_switch20, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch20_start = 5
				elif JS.equal(_switch20, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch20_start = 6
				while true:
					if _switch20_start >= 0 and _switch20_start <= 0:
						if JS.truthy(JS.equal(JS.invoke_method(_scope25["activeWeapon"], "getField", ["bulletsFired"]), JS.invoke_method(_scope25["activeWeapon"], "getField", ["numBullets"]), false)):
							JS.invoke_method(self, "_updateStandardRunAwayGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"]])
						break
					if _switch20_start >= 0 and _switch20_start <= 1:
						if JS.truthy(JS.invoke_method(_scope25["activeWeapon"], "getField", ["fired"])):
							JS.invoke_method(self, "_updateStandardRunAwayGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"]])
						break
					if _switch20_start >= 0 and _switch20_start <= 4:
						if JS.truthy(JS.equal(JS.invoke_method(_scope25["activeWeapon"], "getField", ["numBullets"]), 0, false)):
							JS.invoke_method(self, "_updateStandardRunAwayGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"]])
						break
					if _switch20_start >= 0 and _switch20_start <= 5:
						if JS.truthy((not JS.truthy(JS.invoke_method(_scope25["activeWeapon"], "getField", ["launched"])))):
							JS.invoke_method(self, "_updateStandardRunAwayGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"]])
						break
					if _switch20_start >= 0 and _switch20_start <= 6:
						if JS.truthy(JS.equal(JS.invoke_method(_scope25["activeWeapon"], "getField", ["numMines"]), 0, false)):
							JS.invoke_method(self, "_updateStandardRunAwayGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"]])
						break
					break
		_scope25["laserAimerDistance"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_LASER_AIMER_DISTANCE"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_LASER_AIMER_DISTANCE"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "BOLDNESS"))])
		for _iteration21 in JS.keys(JS.get_property(self, "laserAimerPaths")):
			JS.set_property(_scope25, "laserAimerPath", _iteration21)
			_scope25["dodgeInfo"] = JS.invoke_method(JS.module("AIUtils"), "checkAimerPathForDodging", [_scope25["tank"], JS.get_property(JS.get_property(self, "laserAimerPaths"), _scope25["laserAimerPath"]), JS.get_property(_scope25["upgrades"], _scope25["laserAimerPath"]), JS.invoke_method(JS.get_property(self, "gameController"), "getB2DWorld", [])])
			if JS.truthy(JS.compare("<", JS.get_property(_scope25["dodgeInfo"], "closestDistance"), _scope25["laserAimerDistance"])):
				JS.invoke_method(self, "_updateStandardRunAwayGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"]])
		_scope25["allProtected"] = true
		for _iteration22 in JS.keys(_scope25["tanks"]):
			JS.set_property(_scope25, "tank", _iteration22)
			if JS.truthy(not JS.equal(_scope25["tank"], JS.get_property(self, "aiId"), true)):
				if JS.truthy((not JS.truthy(JS.invoke_method(JS.module("AIUtils"), "checkProtected", [_scope25["tank"], JS.get_property(self, "gameController")])))):
					JS.set_property(_scope25, "allProtected", false)
					break
		if JS.truthy(_scope25["allProtected"]):
			JS.invoke_method(self, "_updateStandardRunAwayGoal", [_scope25["tanks"], _scope25["maze"], _scope25["defaultGoalPeriod"]])
	_scope25["getUnstuckPriority"] = JS.invoke_method("@Math", "min", [(JS.number(JS.get_property(self, "stuckTime")) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_STUCK_TIME"))), 1])
	JS.invoke_method(self, "_updateGoal", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "GET_UNSTUCK"), "priority": _scope25["getUnstuckPriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "GET_UNSTUCK_GOAL_PERIOD"), "normal": JS.get_property(self, "stuckNormal")}])
	_scope25["maxTankDistanceToConsider"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_TANK_HUNT_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_TANK_HUNT_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
	for _iteration23 in JS.keys(_scope25["tanks"]):
		JS.set_property(_scope25, "tank", _iteration23)
		if JS.truthy(not JS.equal(_scope25["tank"], JS.get_property(self, "aiId"), true)):
			if JS.truthy(JS.invoke_method(JS.module("AIUtils"), "checkProtected", [_scope25["tank"], JS.get_property(self, "gameController")])):
				continue
			_scope25["tankDistance"] = JS.invoke_method(_scope25["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "tankPositions"), _scope25["tank"])])
			if JS.truthy(not JS.equal(_scope25["tankDistance"], false, true)):
				_scope25["targetPriorityOffset"] = (JS.get_property(_scope25["preferredTargetInfo"], "priority") if JS.truthy(JS.equal(_scope25["tank"], JS.get_property(_scope25["preferredTargetInfo"], "target"), false)) else 0)
				_scope25["huntPriority"] = (JS.number((JS.number(JS.add((JS.number((JS.number(_scope25["maxTankDistanceToConsider"]) - JS.number(_scope25["tankDistance"]))) / JS.number(_scope25["maxTankDistanceToConsider"])), _scope25["targetPriorityOffset"])) / JS.number(JS.add(1, _scope25["targetPriorityOffset"])))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_HUNT_PRIORITY")))
				_scope25["huntGoal"] = {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "HUNT"), "priority": _scope25["huntPriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope25["defaultGoalPeriod"], "position": JS.get_property(JS.get_property(self, "tankPositions"), _scope25["tank"])}
				JS.invoke_method(self, "_updateGoal", [_scope25["huntGoal"]])
	JS.invoke_method(self, "_updateGoal", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "IDLE"), "priority": JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "IDLE_PRIORITY"), "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope25["defaultGoalPeriod"]}])
	if JS.truthy(not JS.equal(JS.get_property(_scope25["currentGoal"], "id"), JS.get_property(JS.get_property(self, "goal"), "id"), true)):
		return true
	return false
	return null

func original__updateGoal(_arg0 = null):
	var _scope36: Dictionary = {"potentialNewGoal": _arg0}
	if JS.truthy(JS.compare(">", JS.get_property(_scope36["potentialNewGoal"], "priority"), JS.get_property(JS.get_property(self, "goal"), "priority"))):
		JS.set_property(self, "goal", _scope36["potentialNewGoal"])
	return null

func original__updateStandardShootAfterGoal(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope37: Dictionary = {"tanks": _arg0, "maze": _arg1, "period": _arg2, "weaponType": _arg3, "preferredTargetInfo": _arg4, "maxTankDistanceToConsider": null, "shootAfterPriorityOffset": null, "tank": null, "tankDistance": null, "targetPriorityOffset": null, "shootAfterPriority": null, "shootAfterGoal": null}
	_scope37["maxTankDistanceToConsider"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_TANK_TARGET_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_TANK_TARGET_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
	_scope37["shootAfterPriorityOffset"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_SHOOT_AFTER_PRIORITY_OFFSET"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_SHOOT_AFTER_PRIORITY_OFFSET"), JS.get_property(self, "currentAggressiveness")])
	for _iteration24 in JS.keys(_scope37["tanks"]):
		JS.set_property(_scope37, "tank", _iteration24)
		if JS.truthy(not JS.equal(_scope37["tank"], JS.get_property(self, "aiId"), true)):
			if JS.truthy(JS.invoke_method(JS.module("AIUtils"), "checkProtected", [_scope37["tank"], JS.get_property(self, "gameController")])):
				continue
			_scope37["tankDistance"] = JS.invoke_method(_scope37["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "tankPositions"), _scope37["tank"])])
			if JS.truthy(JS.logical("&&", func():
				var _scope38: Dictionary = {}
				return not JS.equal(_scope37["tankDistance"], false, true)
				return null, func():
				var _scope39: Dictionary = {}
				return JS.compare("<", _scope37["tankDistance"], _scope37["maxTankDistanceToConsider"])
				return null)):
				_scope37["targetPriorityOffset"] = (JS.get_property(_scope37["preferredTargetInfo"], "priority") if JS.truthy(JS.equal(_scope37["tank"], JS.get_property(_scope37["preferredTargetInfo"], "target"), false)) else 0)
				_scope37["shootAfterPriority"] = (JS.number(JS.add(JS.add((JS.number((JS.number(_scope37["maxTankDistanceToConsider"]) - JS.number(_scope37["tankDistance"]))) / JS.number(_scope37["maxTankDistanceToConsider"])), _scope37["shootAfterPriorityOffset"]), _scope37["targetPriorityOffset"])) / JS.number(JS.add(JS.add(1, _scope37["shootAfterPriorityOffset"]), _scope37["targetPriorityOffset"])))
				_scope37["shootAfterGoal"] = {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "SHOOT_AFTER"), "priority": _scope37["shootAfterPriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope37["period"], "target": _scope37["tank"], "weaponType": _scope37["weaponType"], "preferredTargetInfo": _scope37["preferredTargetInfo"]}
				JS.invoke_method(self, "_updateGoal", [_scope37["shootAfterGoal"]])
	return null

func original__updateStandardLayTrapGoal(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope40: Dictionary = {"tanks": _arg0, "traps": _arg1, "maze": _arg2, "period": _arg3, "weaponType": _arg4, "tank": null, "layTrapPriorityOffset": null, "minTrapDistance": null, "trap": null, "deadEndPenalty": null, "myTank": null, "directionX": null, "directionY": null, "closestAxis": null, "facingPosition": null, "distance": null, "facingDeadEndPenalty": null, "layTrapPriority": null, "layTrapGoal": null}
	for _iteration25 in JS.keys(_scope40["tanks"]):
		JS.set_property(_scope40, "tank", _iteration25)
		if JS.truthy(not JS.equal(_scope40["tank"], JS.get_property(self, "aiId"), true)):
			_scope40["layTrapPriorityOffset"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_LAY_TRAP_PRIORITY_OFFSET"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_LAY_TRAP_PRIORITY_OFFSET"), JS.get_property(self, "currentAggressiveness")])
			_scope40["minTrapDistance"] = JS.get_property("@Number", "MAX_VALUE")
			for _iteration26 in JS.keys(_scope40["traps"]):
				JS.set_property(_scope40, "trap", _iteration26)
				if JS.truthy(JS.equal(JS.get_property(self, "aiId"), JS.invoke_method(JS.get_property(_scope40["traps"], _scope40["trap"]), "getPlayerId", []), false)):
					JS.set_property(_scope40, "minTrapDistance", JS.invoke_method("@Math", "min", [_scope40["minTrapDistance"], JS.invoke_method(_scope40["maze"], "getDistanceBetweenPositions", [JS.get_property(JS.get_property(self, "trapPositions"), _scope40["trap"]), JS.get_property(self, "myPosition")])]))
			if JS.truthy(JS.compare(">=", _scope40["minTrapDistance"], JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "OWN_TRAP_MIN_DISTANCE"))):
				_scope40["deadEndPenalty"] = JS.invoke_method(_scope40["maze"], "getDeadEndPenalty", [JS.get_property(self, "myPosition")])
				_scope40["myTank"] = JS.get_property(_scope40["tanks"], JS.get_property(self, "aiId"))
				_scope40["directionX"] = JS.invoke_method("@Math", "sin", [JS.invoke_method(_scope40["myTank"], "getRotation", [])])
				_scope40["directionY"] = -(JS.invoke_method("@Math", "cos", [JS.invoke_method(_scope40["myTank"], "getRotation", [])]))
				_scope40["closestAxis"] = JS.invoke_method(JS.module("MathUtils"), "getClosestAxis", [{"x": _scope40["directionX"], "y": _scope40["directionY"]}])
				_scope40["facingPosition"] = {"x": JS.add(JS.get_property(JS.get_property(self, "myPosition"), "x"), JS.get_property(_scope40["closestAxis"], "x")), "y": JS.add(JS.get_property(JS.get_property(self, "myPosition"), "y"), JS.get_property(_scope40["closestAxis"], "y"))}
				if JS.truthy(JS.invoke_method(_scope40["maze"], "isPositionInsideMaze", [_scope40["facingPosition"]])):
					_scope40["distance"] = JS.invoke_method(_scope40["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), _scope40["facingPosition"]])
					if JS.truthy(JS.compare("<=", _scope40["distance"], 1)):
						_scope40["facingDeadEndPenalty"] = JS.invoke_method(_scope40["maze"], "getDeadEndPenalty", [_scope40["facingPosition"]])
						if JS.truthy(JS.compare("<=", _scope40["facingDeadEndPenalty"], _scope40["deadEndPenalty"])):
							_scope40["layTrapPriority"] = (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("Constants"), "MAZE_MAX_DEAD_END_PENALTY")) - JS.number(_scope40["deadEndPenalty"]))) / JS.number(JS.get_property(JS.module("Constants"), "MAZE_MAX_DEAD_END_PENALTY"))), _scope40["layTrapPriorityOffset"])) / JS.number(JS.add(1, _scope40["layTrapPriorityOffset"])))
							_scope40["layTrapGoal"] = {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "LAY_TRAP"), "priority": _scope40["layTrapPriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope40["period"], "weaponType": _scope40["weaponType"]}
							JS.invoke_method(self, "_updateGoal", [_scope40["layTrapGoal"]])
							return null
	return null

func original__updateStandardRunAwayGoal(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope41: Dictionary = {"tanks": _arg0, "maze": _arg1, "period": _arg2, "distances": null, "avgDistance": null, "tank": null, "tankDistance": null, "maxDistanceToConsider": null, "runAwayPriorityOffset": null, "runAwayPriority": null, "runAwayGoal": null}
	_scope41["distances"] = []
	_scope41["avgDistance"] = 0
	for _iteration27 in JS.keys(_scope41["tanks"]):
		JS.set_property(_scope41, "tank", _iteration27)
		if JS.truthy(not JS.equal(_scope41["tank"], JS.get_property(self, "aiId"), true)):
			_scope41["tankDistance"] = JS.invoke_method(_scope41["maze"], "getDistanceBetweenPositions", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "tankPositions"), _scope41["tank"])])
			if JS.truthy(not JS.equal(_scope41["tankDistance"], false, true)):
				JS.invoke_method(_scope41["distances"], "push", [JS.invoke_method(_scope41["maze"], "getDistancesFromPosition", [JS.get_property(JS.get_property(self, "tankPositions"), _scope41["tank"])])])
				JS.set_property(_scope41, "avgDistance", JS.add(_scope41["avgDistance"], _scope41["tankDistance"]))
	if JS.truthy(JS.compare(">", JS.get_property(_scope41["distances"], "length"), 0)):
		JS.set_property(_scope41, "avgDistance", (JS.number(_scope41["avgDistance"]) / JS.number(JS.get_property(_scope41["distances"], "length"))))
		_scope41["maxDistanceToConsider"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_RUN_AWAY_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_RUN_AWAY_DISTANCE_TO_CONSIDER"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
		_scope41["runAwayPriorityOffset"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_RUN_AWAY_PRIORITY_OFFSET"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_RUN_AWAY_PRIORITY_OFFSET"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "BOLDNESS"))])
		_scope41["runAwayPriority"] = (JS.number(JS.add((JS.number((JS.number(_scope41["maxDistanceToConsider"]) - JS.number(_scope41["avgDistance"]))) / JS.number(_scope41["maxDistanceToConsider"])), _scope41["runAwayPriorityOffset"])) / JS.number(JS.add(1, _scope41["runAwayPriorityOffset"])))
		_scope41["runAwayGoal"] = {"type": JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "RUN_AWAY"), "priority": _scope41["runAwayPriority"], "id": JS.increment(self, "nextGoalId", 1, true), "period": _scope41["period"], "distances": _scope41["distances"]}
		JS.invoke_method(self, "_updateGoal", [_scope41["runAwayGoal"]])
	return null

func original__tryToRetaliate(_arg0 = null):
	var _scope42: Dictionary = {"tank": _arg0, "activeWeapon": null, "tanks": null, "firingPathBounces": null, "firingPathLength": null, "closestDistanceToRetaliate": null, "reactionDelay": null, "duration": null, "firingInfo": null}
	_scope42["activeWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getActiveWeapon", [JS.get_property(self, "aiId")])
	_scope42["tanks"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTanks", [])
	if JS.truthy(_scope42["activeWeapon"]):
		_scope42["firingPathBounces"] = JS.invoke_method("@Math", "ceil", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_FIRING_PATH_BOUNCES"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_FIRING_PATH_BOUNCES"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])])
		_scope42["firingPathLength"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_FIRING_PATH_LENGTH"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_FIRING_PATH_LENGTH"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
		_scope42["closestDistanceToRetaliate"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_DISTANCE_TO_RETALIATE"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_DISTANCE_TO_RETALIATE"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "AGGRESSIVENESS"))])
		_scope42["reactionDelay"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_RETALIATE_DELAY"), 0, JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))])
		_scope42["duration"] = JS.invoke_method(self, "_getFireActionDuration", [_scope42["activeWeapon"]])
		_scope42["firingInfo"] = null
		var _switch28 = JS.invoke_method(_scope42["activeWeapon"], "getType", [])
		var _switch28_start = -1
		if JS.equal(_switch28, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch28_start = 0
		elif JS.equal(_switch28, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch28_start = 1
		elif JS.equal(_switch28, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch28_start = 2
		elif JS.equal(_switch28, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch28_start = 3
		elif JS.equal(_switch28, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch28_start = 4
		elif JS.equal(_switch28, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch28_start = 5
		elif JS.equal(_switch28, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch28_start = 6
		while true:
			if _switch28_start >= 0 and _switch28_start <= 0:
				if JS.truthy(JS.compare("<", JS.invoke_method(_scope42["activeWeapon"], "getField", ["bulletsFired"]), JS.invoke_method(_scope42["activeWeapon"], "getField", ["numBullets"]))):
					JS.set_property(_scope42, "firingInfo", JS.invoke_method(JS.module("AIUtils"), "checkFiringPath", [_scope42["tank"], _scope42["tanks"], JS.get_property(self, "gameController"), 0, _scope42["firingPathBounces"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope42["firingPathLength"])), JS.invoke_method(_scope42["activeWeapon"], "getType", [])]))
				break
			if _switch28_start >= 0 and _switch28_start <= 2:
				JS.set_property(_scope42, "firingInfo", JS.invoke_method(JS.module("AIUtils"), "checkFiringPath", [_scope42["tank"], _scope42["tanks"], JS.get_property(self, "gameController"), 0, _scope42["firingPathBounces"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope42["firingPathLength"])), JS.invoke_method(_scope42["activeWeapon"], "getType", [])]))
				break
			if _switch28_start >= 0 and _switch28_start <= 3:
				if JS.truthy(JS.compare("<=", JS.invoke_method(_scope42["activeWeapon"], "getField", ["reloadTime"]), 0)):
					JS.set_property(_scope42, "firingInfo", JS.invoke_method(JS.module("AIUtils"), "checkFiringPath", [_scope42["tank"], _scope42["tanks"], JS.get_property(self, "gameController"), 0, _scope42["firingPathBounces"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope42["firingPathLength"])), JS.invoke_method(_scope42["activeWeapon"], "getType", [])]))
				break
			if _switch28_start >= 0 and _switch28_start <= 4:
				if JS.truthy((not JS.truthy(JS.invoke_method(_scope42["activeWeapon"], "getField", ["launched"])))):
					JS.set_property(_scope42, "firingInfo", JS.invoke_method(JS.module("AIUtils"), "checkFiringPath", [_scope42["tank"], _scope42["tanks"], JS.get_property(self, "gameController"), 0, _scope42["firingPathBounces"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope42["firingPathLength"])), JS.invoke_method(_scope42["activeWeapon"], "getType", [])]))
				break
			if _switch28_start >= 0 and _switch28_start <= 5:
				if JS.truthy(JS.compare(">", JS.invoke_method(_scope42["activeWeapon"], "getField", ["numMines"]), 0)):
					JS.set_property(_scope42, "firingInfo", JS.invoke_method(JS.module("AIUtils"), "checkTrapLaying", [_scope42["tank"], _scope42["tanks"], JS.get_property(self, "gameController"), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope42["firingPathLength"])), JS.invoke_method(_scope42["activeWeapon"], "getType", [])]))
				break
			if _switch28_start >= 0 and _switch28_start <= 6:
				if JS.truthy(JS.compare(">", JS.invoke_method(_scope42["activeWeapon"], "getField", ["numBullets"]), 0)):
					JS.set_property(_scope42, "firingInfo", JS.invoke_method(JS.module("AIUtils"), "checkFiringPath", [_scope42["tank"], _scope42["tanks"], JS.get_property(self, "gameController"), 0, _scope42["firingPathBounces"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope42["firingPathLength"])), JS.invoke_method(_scope42["activeWeapon"], "getType", [])]))
				break
			break
		if JS.truthy(_scope42["firingInfo"]):
			if JS.truthy(JS.equal(JS.get_property(_scope42["firingInfo"], "result"), JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "HIT"), true)):
				JS.invoke_method(JS.get_property(self, "actions"), "unshift", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "FIRE"), "duration": _scope42["duration"], "delay": _scope42["reactionDelay"]}])
				JS.set_property(self, "currentAggressiveness", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "currentAggressiveness")) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AGGRESSIVENESS_RETALIATE_SHRINKAGE")))]))
			else:
				if JS.truthy(JS.equal(JS.get_property(_scope42["firingInfo"], "result"), JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "NEAR"), true)):
					if JS.truthy(JS.compare("<", JS.get_property(_scope42["firingInfo"], "closestDistance"), _scope42["closestDistanceToRetaliate"])):
						JS.invoke_method(JS.get_property(self, "actions"), "unshift", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "FIRE"), "duration": _scope42["duration"], "delay": _scope42["reactionDelay"]}])
						JS.set_property(self, "currentAggressiveness", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "currentAggressiveness")) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AGGRESSIVENESS_RETALIATE_SHRINKAGE")))]))
	return null

func original__updateActionsToAchieveGoal():
	var _scope43: Dictionary = {"tank": null, "target": null, "tankPosition": null, "targetPosition": null, "imprecision": null, "reactionDelay": null, "activeWeapon": null, "duration": null, "direction": null, "tanks": null, "firingPathBounces": null, "firingPathLength": null, "numFiringPathsToCheck": null, "firingPathSpread": null, "minAngle": null, "angleStep": null, "closestDistance": null, "shortestLength": null, "targetDirection": null, "preferredClosestDistance": null, "preferredShortestLength": null, "preferredTargetDirection": null, "i": null, "angle": null, "firingInfo": null, "closestPreferredDistanceOffset": null, "closestDistanceToFire": null, "directionX": null, "directionY": null, "position": null, "escapePathLength": null, "deadEndWeight": null, "threatWeight": null, "maze": null, "escapePath": null, "closestDirection": null, "closestPosition": null, "directionLength": null, "tangent": null, "closestPlusTangent": null, "closestMinusTangent": null, "distancePlusSquared": null, "distanceMinusSquared": null, "relativeToTank": null, "path": null, "stuckNormal": null, "distances": null, "randomAction": null}
	JS.set_property(self, "actions", [])
	_scope43["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "aiId")])
	if JS.truthy((not JS.truthy(_scope43["tank"]))):
		return null
	var _switch29 = JS.get_property(JS.get_property(self, "goal"), "type")
	var _switch29_start = -1
	if JS.equal(_switch29, JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "SHOOT_AFTER"), true): _switch29_start = 0
	elif JS.equal(_switch29, JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "LAY_TRAP"), true): _switch29_start = 1
	elif JS.equal(_switch29, JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "DODGE_PROJECTILE"), true): _switch29_start = 2
	elif JS.equal(_switch29, JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "PICK_UP_COLLECTIBLE"), true): _switch29_start = 3
	elif JS.equal(_switch29, JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "GET_UNSTUCK"), true): _switch29_start = 4
	elif JS.equal(_switch29, JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "RUN_AWAY"), true): _switch29_start = 5
	elif JS.equal(_switch29, JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "HUNT"), true): _switch29_start = 6
	elif JS.equal(_switch29, JS.get_property(JS.get_property(JS.module("AI"), "_GOALS"), "IDLE"), true): _switch29_start = 7
	while true:
		if _switch29_start >= 0 and _switch29_start <= 0:
			JS.set_property(self, "currentAggressiveness", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "currentAggressiveness")) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AGGRESSIVENESS_SHOOT_AFTER_SHRINKAGE")))]))
			_scope43["target"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(JS.get_property(self, "goal"), "target")])
			if JS.truthy(_scope43["target"]):
				_scope43["tankPosition"] = {"x": JS.invoke_method(_scope43["tank"], "getX", []), "y": JS.invoke_method(_scope43["tank"], "getY", [])}
				_scope43["targetPosition"] = {"x": JS.invoke_method(_scope43["target"], "getX", []), "y": JS.invoke_method(_scope43["target"], "getY", [])}
				_scope43["imprecision"] = JS.invoke_method(JS.module("MathUtils"), "randomAroundZero", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_ROTATION_IMPRECISION"), 0, JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))])])
				_scope43["reactionDelay"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_FIRE_DELAY"), 0, JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))])
				_scope43["activeWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getActiveWeapon", [JS.get_property(self, "aiId")])
				_scope43["duration"] = JS.invoke_method(self, "_getFireActionDuration", [_scope43["activeWeapon"]])
				if JS.truthy((not JS.truthy(JS.invoke_method(JS.module("B2DUtils"), "checkLineForMazeCollision", [JS.invoke_method(JS.get_property(self, "gameController"), "getB2DWorld", []), _scope43["tankPosition"], _scope43["targetPosition"]])))):
					_scope43["direction"] = {"x": (JS.number(JS.get_property(_scope43["targetPosition"], "x")) - JS.number(JS.get_property(_scope43["tankPosition"], "x"))), "y": (JS.number(JS.get_property(_scope43["targetPosition"], "y")) - JS.number(JS.get_property(_scope43["tankPosition"], "y")))}
					JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "TURN_TO"), "direction": _scope43["direction"], "imprecision": _scope43["imprecision"]}])
					JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "FIRE"), "duration": _scope43["duration"], "delay": _scope43["reactionDelay"]}])
				else:
					_scope43["tanks"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTanks", [])
					_scope43["firingPathBounces"] = JS.invoke_method("@Math", "ceil", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_FIRING_PATH_BOUNCES"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_FIRING_PATH_BOUNCES"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])])
					_scope43["firingPathLength"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_FIRING_PATH_LENGTH"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_FIRING_PATH_LENGTH"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
					_scope43["numFiringPathsToCheck"] = JS.invoke_method("@Math", "ceil", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_NUM_FIRING_PATHS"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_NUM_FIRING_PATHS"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])])
					JS.set_property(_scope43, "numFiringPathsToCheck", JS.add(_scope43["numFiringPathsToCheck"], fmod(JS.add(_scope43["numFiringPathsToCheck"], 1), 2)))
					_scope43["firingPathSpread"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_FIRING_PATH_SPREAD"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_FIRING_PATH_SPREAD"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "AGGRESSIVENESS"))])
					_scope43["minAngle"] = (JS.number(-(_scope43["firingPathSpread"])) * JS.number(0.5))
					_scope43["angleStep"] = (JS.number(_scope43["firingPathSpread"]) / JS.number((JS.number(_scope43["numFiringPathsToCheck"]) - JS.number(1))))
					_scope43["closestDistance"] = JS.get_property("@Number", "MAX_VALUE")
					_scope43["shortestLength"] = JS.get_property("@Number", "MAX_VALUE")
					_scope43["targetDirection"] = null
					_scope43["preferredClosestDistance"] = JS.get_property("@Number", "MAX_VALUE")
					_scope43["preferredShortestLength"] = JS.get_property("@Number", "MAX_VALUE")
					_scope43["preferredTargetDirection"] = null
					_scope43["i"] = 0
					while JS.truthy(JS.compare("<", _scope43["i"], _scope43["numFiringPathsToCheck"])):
						_scope43["angle"] = JS.add(JS.add(_scope43["minAngle"], (JS.number(_scope43["i"]) * JS.number(_scope43["angleStep"]))), JS.invoke_method(JS.module("MathUtils"), "randomAroundZero", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "FIRING_PATH_RANDOM_OFFSET")]))
						_scope43["firingInfo"] = JS.invoke_method(JS.module("AIUtils"), "checkFiringPath", [_scope43["tank"], _scope43["tanks"], JS.get_property(self, "gameController"), _scope43["angle"], _scope43["firingPathBounces"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")) * JS.number(_scope43["firingPathLength"])), JS.get_property(JS.get_property(self, "goal"), "weaponType")])
						if JS.truthy(JS.equal(JS.get_property(_scope43["firingInfo"], "result"), JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "HIT"), true)):
							if JS.truthy(JS.compare("<", JS.get_property(_scope43["firingInfo"], "pathLength"), _scope43["shortestLength"])):
								JS.set_property(_scope43, "shortestLength", JS.get_property(_scope43["firingInfo"], "pathLength"))
								JS.set_property(_scope43, "closestDistance", 0)
								JS.set_property(_scope43, "targetDirection", JS.get_property(_scope43["firingInfo"], "direction"))
							if JS.truthy(JS.get_property(JS.get_property(JS.get_property(self, "goal"), "preferredTargetInfo"), "target")):
								if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "goal"), "preferredTargetInfo"), "target"), JS.get_property(_scope43["firingInfo"], "target"), true)):
									if JS.truthy(JS.compare("<", JS.get_property(_scope43["firingInfo"], "pathLength"), _scope43["preferredShortestLength"])):
										JS.set_property(_scope43, "preferredShortestLength", JS.get_property(_scope43["firingInfo"], "pathLength"))
										JS.set_property(_scope43, "preferredClosestDistance", 0)
										JS.set_property(_scope43, "preferredTargetDirection", JS.get_property(_scope43["firingInfo"], "direction"))
						else:
							if JS.truthy(JS.equal(JS.get_property(_scope43["firingInfo"], "result"), JS.get_property(JS.get_property(JS.module("AIUtils"), "_FIRING_RESULTS"), "NEAR"), true)):
								if JS.truthy(JS.compare("<", JS.get_property(_scope43["firingInfo"], "closestDistance"), _scope43["closestDistance"])):
									JS.set_property(_scope43, "closestDistance", JS.get_property(_scope43["firingInfo"], "closestDistance"))
									JS.set_property(_scope43, "targetDirection", JS.get_property(_scope43["firingInfo"], "direction"))
								if JS.truthy(JS.get_property(JS.get_property(JS.get_property(self, "goal"), "preferredTargetInfo"), "target")):
									if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "goal"), "preferredTargetInfo"), "target"), JS.get_property(_scope43["firingInfo"], "target"), true)):
										if JS.truthy(JS.compare("<", JS.get_property(_scope43["firingInfo"], "closestDistance"), _scope43["preferredClosestDistance"])):
											JS.set_property(_scope43, "preferredClosestDistance", JS.get_property(_scope43["firingInfo"], "closestDistance"))
											JS.set_property(_scope43, "preferredTargetDirection", JS.get_property(_scope43["firingInfo"], "direction"))
						JS.increment(_scope43, "i", 1, false)
					_scope43["closestPreferredDistanceOffset"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_PREFERRED_CLOSEST_DISTANCE_OFFSET"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PREFERRED_CLOSEST_DISTANCE_OFFSET"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
					if JS.truthy(JS.compare("<=", (JS.number(_scope43["preferredClosestDistance"]) - JS.number(_scope43["closestPreferredDistanceOffset"])), _scope43["closestDistance"])):
						JS.set_property(_scope43, "closestDistance", _scope43["preferredClosestDistance"])
						JS.set_property(_scope43, "targetDirection", _scope43["preferredTargetDirection"])
					_scope43["closestDistanceToFire"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_DISTANCE_TO_FIRE"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_DISTANCE_TO_FIRE"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "AGGRESSIVENESS"))])
					if JS.truthy(JS.compare("<", _scope43["closestDistance"], _scope43["closestDistanceToFire"])):
						JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "TURN_TO"), "direction": _scope43["targetDirection"], "imprecision": _scope43["imprecision"]}])
						JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "FIRE"), "duration": _scope43["duration"], "delay": _scope43["reactionDelay"]}])
					else:
						if JS.truthy(_scope43["targetDirection"]):
							JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "TURN_TO"), "direction": _scope43["targetDirection"], "imprecision": _scope43["imprecision"]}])
						else:
							_scope43["angle"] = JS.invoke_method(JS.module("MathUtils"), "randomSign", [JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_TURN_AROUND_ANGLE"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_TURN_AROUND_ANGLE")])])
							_scope43["directionX"] = JS.invoke_method("@Math", "sin", [JS.add(JS.invoke_method(_scope43["tank"], "getRotation", []), _scope43["angle"])])
							_scope43["directionY"] = -(JS.invoke_method("@Math", "cos", [JS.add(JS.invoke_method(_scope43["tank"], "getRotation", []), _scope43["angle"])]))
							JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "TURN_TO"), "direction": {"x": _scope43["directionX"], "y": _scope43["directionY"]}, "imprecision": _scope43["imprecision"]}])
			break
		if _switch29_start >= 0 and _switch29_start <= 1:
			JS.set_property(self, "currentAggressiveness", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "currentAggressiveness")) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AGGRESSIVENESS_LAY_TRAP_SHRINKAGE")))]))
			_scope43["imprecision"] = JS.invoke_method(JS.module("MathUtils"), "randomAroundZero", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_ROTATION_IMPRECISION"), 0, JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))])])
			_scope43["reactionDelay"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_FIRE_DELAY"), 0, JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))])
			JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "FIRE"), "duration": 1, "delay": _scope43["reactionDelay"]}])
			_scope43["directionX"] = JS.invoke_method("@Math", "sin", [JS.invoke_method(_scope43["tank"], "getRotation", [])])
			_scope43["directionY"] = -(JS.invoke_method("@Math", "cos", [JS.invoke_method(_scope43["tank"], "getRotation", [])]))
			_scope43["position"] = {"x": JS.add(JS.invoke_method(_scope43["tank"], "getX", []), (JS.number((JS.number(_scope43["directionX"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "LAY_TRAP_DRIVE_FORWARD_DISTANCE")))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))), "y": JS.add(JS.invoke_method(_scope43["tank"], "getY", []), (JS.number((JS.number(_scope43["directionY"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "LAY_TRAP_DRIVE_FORWARD_DISTANCE")))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))))}
			JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), "position": _scope43["position"], "canReverse": false, "imprecision": _scope43["imprecision"]}])
			break
		if _switch29_start >= 0 and _switch29_start <= 2:
			_scope43["escapePathLength"] = JS.invoke_method("@Math", "ceil", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_ESCAPE_PATH_LENGTH"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_ESCAPE_PATH_LENGTH"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])])
			_scope43["deadEndWeight"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_PATH_DEAD_END_WEIGHT"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PATH_DEAD_END_WEIGHT"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
			_scope43["threatWeight"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PATH_THREAT_WEIGHT"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_PATH_THREAT_WEIGHT"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "BOLDNESS"))])
			if JS.truthy(JS.logical("&&", func():
				var _scope44: Dictionary = {}
				return JS.get_property(self, "myPosition")
				return null, func():
				var _scope45: Dictionary = {}
				return JS.get_property(JS.get_property(self, "projectilePositions"), JS.get_property(JS.get_property(JS.get_property(self, "goal"), "dodgeInfo"), "closestId"))
				return null)):
				_scope43["maze"] = JS.invoke_method(JS.get_property(self, "gameController"), "getMaze", [])
				_scope43["escapePath"] = JS.invoke_method(_scope43["maze"], "getPathAwayFromWithThreats", [JS.get_property(self, "myPosition"), JS.get_property(JS.get_property(self, "projectilePositions"), JS.get_property(JS.get_property(JS.get_property(self, "goal"), "dodgeInfo"), "closestId")), _scope43["escapePathLength"], _scope43["deadEndWeight"], JS.get_property(self, "threatMap"), _scope43["threatWeight"]])
				if JS.truthy(JS.logical("||", func():
					var _scope46: Dictionary = {}
					return JS.logical("&&", func():
						var _scope47: Dictionary = {}
						return JS.compare("<", JS.get_property(JS.get_property(JS.get_property(self, "goal"), "dodgeInfo"), "closestTime"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "TIME_TO_DODGE"))
						return null, func():
						var _scope48: Dictionary = {}
						return JS.compare("<", JS.get_property(JS.get_property(JS.get_property(self, "goal"), "dodgeInfo"), "closestDistance"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "DISTANCE_TO_DODGE"))
						return null)
					return null, func():
					var _scope49: Dictionary = {}
					return JS.equal(JS.get_property(_scope43["escapePath"], "length"), 0, false)
					return null)):
					_scope43["closestDirection"] = JS.get_property(JS.get_property(JS.get_property(self, "goal"), "dodgeInfo"), "closestDirection")
					_scope43["closestPosition"] = JS.get_property(JS.get_property(JS.get_property(self, "goal"), "dodgeInfo"), "closestPosition")
					_scope43["imprecision"] = JS.invoke_method(JS.module("MathUtils"), "randomAroundZero", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_ROTATION_IMPRECISION"), 0, JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))])])
					if JS.truthy(JS.compare("<", JS.get_property(JS.get_property(JS.get_property(self, "goal"), "dodgeInfo"), "closestDistance"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AMOUNT_TO_DODGE"))):
						_scope43["directionLength"] = JS.invoke_method("@Math", "sqrt", [JS.add((JS.number(JS.get_property(_scope43["closestDirection"], "x")) * JS.number(JS.get_property(_scope43["closestDirection"], "x"))), (JS.number(JS.get_property(_scope43["closestDirection"], "y")) * JS.number(JS.get_property(_scope43["closestDirection"], "y"))))])
						_scope43["tangent"] = {"x": (JS.number((JS.number(-(JS.get_property(_scope43["closestDirection"], "y"))) / JS.number(_scope43["directionLength"]))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AMOUNT_TO_DODGE"))), "y": (JS.number((JS.number(JS.get_property(_scope43["closestDirection"], "x")) / JS.number(_scope43["directionLength"]))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AMOUNT_TO_DODGE")))}
						_scope43["closestPlusTangent"] = {"x": JS.add(JS.get_property(_scope43["closestPosition"], "x"), JS.get_property(_scope43["tangent"], "x")), "y": JS.add(JS.get_property(_scope43["closestPosition"], "y"), JS.get_property(_scope43["tangent"], "y"))}
						_scope43["closestMinusTangent"] = {"x": (JS.number(JS.get_property(_scope43["closestPosition"], "x")) - JS.number(JS.get_property(_scope43["tangent"], "x"))), "y": (JS.number(JS.get_property(_scope43["closestPosition"], "y")) - JS.number(JS.get_property(_scope43["tangent"], "y")))}
						_scope43["distancePlusSquared"] = JS.add(JS.add((JS.number((JS.number(JS.invoke_method(_scope43["tank"], "getX", [])) - JS.number(JS.get_property(_scope43["closestPlusTangent"], "x")))) * JS.number((JS.number(JS.invoke_method(_scope43["tank"], "getX", [])) - JS.number(JS.get_property(_scope43["closestPlusTangent"], "x"))))), (JS.number(JS.invoke_method(_scope43["tank"], "getY", [])) - JS.number(JS.get_property(_scope43["closestPlusTangent"], "y")))), (JS.number(JS.invoke_method(_scope43["tank"], "getY", [])) - JS.number(JS.get_property(_scope43["closestPlusTangent"], "y"))))
						_scope43["distanceMinusSquared"] = JS.add(JS.add((JS.number((JS.number(JS.invoke_method(_scope43["tank"], "getX", [])) - JS.number(JS.get_property(_scope43["closestMinusTangent"], "x")))) * JS.number((JS.number(JS.invoke_method(_scope43["tank"], "getX", [])) - JS.number(JS.get_property(_scope43["closestMinusTangent"], "x"))))), (JS.number(JS.invoke_method(_scope43["tank"], "getY", [])) - JS.number(JS.get_property(_scope43["closestMinusTangent"], "y")))), (JS.number(JS.invoke_method(_scope43["tank"], "getY", [])) - JS.number(JS.get_property(_scope43["closestMinusTangent"], "y"))))
						_scope43["tankPosition"] = {"x": JS.invoke_method(_scope43["tank"], "getX", []), "y": JS.invoke_method(_scope43["tank"], "getY", [])}
						if JS.truthy(JS.invoke_method(JS.module("B2DUtils"), "checkLineForMazeCollision", [JS.invoke_method(JS.get_property(self, "gameController"), "getB2DWorld", []), _scope43["tankPosition"], _scope43["closestPlusTangent"]])):
							JS.set_property(_scope43, "distancePlusSquared", JS.add(_scope43["distancePlusSquared"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AMOUNT_TO_DODGE")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AMOUNT_TO_DODGE")))))
						if JS.truthy(JS.invoke_method(JS.module("B2DUtils"), "checkLineForMazeCollision", [JS.invoke_method(JS.get_property(self, "gameController"), "getB2DWorld", []), _scope43["tankPosition"], _scope43["closestMinusTangent"]])):
							JS.set_property(_scope43, "distanceMinusSquared", JS.add(_scope43["distanceMinusSquared"], (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AMOUNT_TO_DODGE")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "AMOUNT_TO_DODGE")))))
						if JS.truthy(JS.compare("<", _scope43["distancePlusSquared"], _scope43["distanceMinusSquared"])):
							JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), "position": _scope43["closestPlusTangent"], "canReverse": true, "imprecision": _scope43["imprecision"]}])
						else:
							JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), "position": _scope43["closestMinusTangent"], "canReverse": true, "imprecision": _scope43["imprecision"]}])
					_scope43["relativeToTank"] = JS.invoke_method(JS.module("B2DUtils"), "directionToLocalSpace", [JS.invoke_method(_scope43["tank"], "getB2DBody", []), _scope43["closestDirection"]])
					if JS.truthy(JS.compare("<", JS.get_property(_scope43["relativeToTank"], "y"), 0)):
						JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "TURN_TO"), "direction": _scope43["closestDirection"], "imprecision": _scope43["imprecision"]}])
					else:
						JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "TURN_TO"), "direction": {"x": -(JS.get_property(_scope43["closestDirection"], "x")), "y": -(JS.get_property(_scope43["closestDirection"], "y"))}, "imprecision": _scope43["imprecision"]}])
				else:
					JS.set_property(self, "actions", JS.invoke_method(JS.module("AIUtils"), "getActionsToFollowPath", [_scope43["escapePath"], null, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_TILE"), JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))]))
				JS.invoke_method(self, "_tryToRetaliate", [_scope43["tank"]])
			break
		if _switch29_start >= 0 and _switch29_start <= 3:
			JS.set_property(self, "currentGreediness", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "currentGreediness")) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "GREEDINESS_PICK_UP_COLLECTIBLE_SHRINKAGE")))]))
			_scope43["targetPosition"] = JS.get_property(JS.get_property(self, "goal"), "position")
			if JS.truthy(JS.logical("&&", func():
				var _scope50: Dictionary = {}
				return JS.get_property(self, "myPosition")
				return null, func():
				var _scope51: Dictionary = {}
				return _scope43["targetPosition"]
				return null)):
				_scope43["maze"] = JS.invoke_method(JS.get_property(self, "gameController"), "getMaze", [])
				_scope43["path"] = JS.invoke_method(_scope43["maze"], "getShortestPathWithGraph", [JS.get_property(self, "myPosition"), _scope43["targetPosition"], JS.invoke_method(JS.get_property(self, "threatMap"), "data", []), 0.1])
				JS.set_property(self, "actions", JS.invoke_method(JS.module("AIUtils"), "getActionsToFollowPath", [_scope43["path"], _scope43["targetPosition"], JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_TILE"), JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))]))
			break
		if _switch29_start >= 0 and _switch29_start <= 4:
			_scope43["stuckNormal"] = JS.get_property(JS.get_property(self, "goal"), "normal")
			_scope43["targetPosition"] = {"x": (JS.number(JS.invoke_method(_scope43["tank"], "getX", [])) - JS.number((JS.number(JS.get_property(_scope43["stuckNormal"], "x")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "GET_UNSTUCK_DISTANCE"))))), "y": (JS.number(JS.invoke_method(_scope43["tank"], "getY", [])) - JS.number((JS.number(JS.get_property(_scope43["stuckNormal"], "y")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "GET_UNSTUCK_DISTANCE")))))}
			_scope43["imprecision"] = JS.invoke_method(JS.module("MathUtils"), "randomAroundZero", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_ROTATION_IMPRECISION"), 0, JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))])])
			JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), "position": _scope43["targetPosition"], "canReverse": true, "imprecision": _scope43["imprecision"]}])
			break
		if _switch29_start >= 0 and _switch29_start <= 5:
			_scope43["distances"] = JS.get_property(JS.get_property(self, "goal"), "distances")
			_scope43["escapePathLength"] = JS.invoke_method("@Math", "ceil", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_ESCAPE_PATH_LENGTH"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_ESCAPE_PATH_LENGTH"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])])
			_scope43["deadEndWeight"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_PATH_DEAD_END_WEIGHT"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PATH_DEAD_END_WEIGHT"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "CLEVERNESS"))])
			_scope43["threatWeight"] = JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_PATH_THREAT_WEIGHT"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_PATH_THREAT_WEIGHT"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "BOLDNESS"))])
			_scope43["maze"] = JS.invoke_method(JS.get_property(self, "gameController"), "getMaze", [])
			if JS.truthy(JS.get_property(self, "myPosition")):
				_scope43["path"] = JS.invoke_method(_scope43["maze"], "getPathAwayWithMultipleDistancesAndThreats", [JS.get_property(self, "myPosition"), _scope43["escapePathLength"], _scope43["deadEndWeight"], _scope43["distances"], JS.get_property(self, "threatMap"), _scope43["threatWeight"]])
				JS.set_property(self, "actions", JS.invoke_method(JS.module("AIUtils"), "getActionsToFollowPath", [_scope43["path"], null, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_TILE"), JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))]))
			JS.invoke_method(self, "_tryToRetaliate", [_scope43["tank"]])
			break
		if _switch29_start >= 0 and _switch29_start <= 6:
			_scope43["targetPosition"] = JS.get_property(JS.get_property(self, "goal"), "position")
			if JS.truthy(JS.logical("&&", func():
				var _scope52: Dictionary = {}
				return JS.get_property(self, "myPosition")
				return null, func():
				var _scope53: Dictionary = {}
				return _scope43["targetPosition"]
				return null)):
				_scope43["maze"] = JS.invoke_method(JS.get_property(self, "gameController"), "getMaze", [])
				_scope43["path"] = JS.invoke_method(_scope43["maze"], "getShortestPathWithGraph", [JS.get_property(self, "myPosition"), _scope43["targetPosition"], JS.invoke_method(JS.get_property(self, "threatMap"), "data", []), 0.1])
				JS.set_property(self, "actions", JS.invoke_method(JS.module("AIUtils"), "getActionsToFollowPath", [_scope43["path"], _scope43["targetPosition"], JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_TILE"), JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))]))
			break
		if _switch29_start >= 0 and _switch29_start <= 7:
			_scope43["randomAction"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(3))])
			var _switch30 = _scope43["randomAction"]
			var _switch30_start = -1
			if JS.equal(_switch30, 0, true): _switch30_start = 0
			elif JS.equal(_switch30, 1, true): _switch30_start = 1
			elif JS.equal(_switch30, 2, true): _switch30_start = 2
			while true:
				if _switch30_start >= 0 and _switch30_start <= 0:
					JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "IDLE"), "duration": JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_IDLE_DURATION"), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_IDLE_DURATION")])}])
					break
				if _switch30_start >= 0 and _switch30_start <= 1:
					_scope43["angle"] = JS.invoke_method(JS.module("MathUtils"), "randomRange", [0, (JS.number(2) * JS.number(JS.get_property("@Math", "PI")))])
					_scope43["directionX"] = JS.invoke_method("@Math", "sin", [_scope43["angle"]])
					_scope43["directionY"] = -(JS.invoke_method("@Math", "cos", [_scope43["angle"]]))
					_scope43["imprecision"] = JS.invoke_method(JS.module("MathUtils"), "randomAroundZero", [JS.invoke_method(JS.module("MathUtils"), "linearInterpolation", [JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MAX_ROTATION_IMPRECISION"), 0, JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))])])
					JS.invoke_method(JS.get_property(self, "actions"), "push", [{"type": JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "TURN_TO"), "direction": {"x": _scope43["directionX"], "y": _scope43["directionY"]}, "imprecision": _scope43["imprecision"]}])
					break
				if _switch30_start >= 0 and _switch30_start <= 2:
					_scope43["maze"] = JS.invoke_method(JS.get_property(self, "gameController"), "getMaze", [])
					_scope43["targetPosition"] = JS.invoke_method(_scope43["maze"], "getRandomUnusedPosition", [JS.invoke_method(JS.get_property(self, "gameController"), "getRoundState", []), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "MIN_IDLE_DISTANCE")])
					if JS.truthy(JS.logical("&&", func():
						var _scope54: Dictionary = {}
						return JS.get_property(self, "myPosition")
						return null, func():
						var _scope55: Dictionary = {}
						return _scope43["targetPosition"]
						return null)):
						JS.set_property(_scope43["targetPosition"], "x", JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(_scope43["targetPosition"], "x")) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]))
						JS.set_property(_scope43["targetPosition"], "y", JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(_scope43["targetPosition"], "y")) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]))
						_scope43["path"] = JS.invoke_method(_scope43["maze"], "getShortestPathWithGraph", [JS.get_property(self, "myPosition"), _scope43["targetPosition"], JS.invoke_method(JS.get_property(self, "threatMap"), "data", []), 0.1])
						JS.set_property(self, "actions", JS.invoke_method(JS.module("AIUtils"), "getActionsToFollowPath", [_scope43["path"], _scope43["targetPosition"], JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_TILE"), JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), JS.get_property(JS.get_property(self, "config"), JS.get_property(JS.get_property(JS.module("AI"), "_TRAITS"), "DEXTERITY"))]))
					break
				break
		break
	return null

func original__updateInputToDoAction():
	var _scope56: Dictionary = {"tank": null, "action": null, "targetPosition": null}
	JS.set_property(self, "inputState", JS.invoke_method(JS.module("InputState"), "withState", [JS.get_property(self, "aiId"), false, false, false, false, false]))
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(self, "actions"), "length"), 0, false)):
		return null
	_scope56["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "aiId")])
	if JS.truthy((not JS.truthy(_scope56["tank"]))):
		return null
	_scope56["action"] = JS.get_property(JS.get_property(self, "actions"), 0)
	var _switch31 = JS.get_property(_scope56["action"], "type")
	var _switch31_start = 5
	if JS.equal(_switch31, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_TILE"), true): _switch31_start = 0
	elif JS.equal(_switch31, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), true): _switch31_start = 1
	elif JS.equal(_switch31, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "TURN_TO"), true): _switch31_start = 2
	elif JS.equal(_switch31, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "FIRE"), true): _switch31_start = 3
	elif JS.equal(_switch31, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "IDLE"), true): _switch31_start = 4
	while true:
		if _switch31_start >= 0 and _switch31_start <= 0:
			_scope56["targetPosition"] = {"x": (JS.number(JS.add(JS.get_property(JS.get_property(_scope56["action"], "position"), "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), "y": (JS.number(JS.add(JS.get_property(JS.get_property(_scope56["action"], "position"), "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))}
			JS.set_property(self, "inputState", JS.invoke_method(JS.module("AIUtils"), "getInputToDriveToPosition", [_scope56["tank"], _scope56["targetPosition"], JS.get_property(_scope56["action"], "canReverse"), JS.get_property(_scope56["action"], "imprecision")]))
			break
		if _switch31_start >= 0 and _switch31_start <= 1:
			JS.set_property(self, "inputState", JS.invoke_method(JS.module("AIUtils"), "getInputToDriveToPosition", [_scope56["tank"], JS.get_property(_scope56["action"], "position"), JS.get_property(_scope56["action"], "canReverse"), JS.get_property(_scope56["action"], "imprecision")]))
			break
		if _switch31_start >= 0 and _switch31_start <= 2:
			JS.set_property(self, "inputState", JS.invoke_method(JS.module("AIUtils"), "getInputToTurnToDirection", [_scope56["tank"], JS.get_property(_scope56["action"], "direction"), JS.get_property(_scope56["action"], "imprecision")]))
			break
		if _switch31_start >= 0 and _switch31_start <= 3:
			JS.set_property(self, "inputState", JS.invoke_method(JS.module("AIUtils"), "getInputToFire", [_scope56["tank"], JS.get_property(_scope56["action"], "delay")]))
			break
		if _switch31_start >= 0 and _switch31_start <= 5:
			break
		break
	return null

func original__updateAndRemovePerformedActions(_arg0 = null):
	var _scope57: Dictionary = {"deltaTime": _arg0, "tank": null, "action": null, "targetPosition": null, "diffSqr": null, "relativeToTank": null}
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(self, "actions"), "length"), 0, false)):
		return null
	_scope57["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "aiId")])
	if JS.truthy((not JS.truthy(_scope57["tank"]))):
		return null
	_scope57["action"] = JS.get_property(JS.get_property(self, "actions"), 0)
	var _switch32 = JS.get_property(_scope57["action"], "type")
	var _switch32_start = 5
	if JS.equal(_switch32, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_TILE"), true): _switch32_start = 0
	elif JS.equal(_switch32, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "DRIVE_TO_POSITION"), true): _switch32_start = 1
	elif JS.equal(_switch32, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "TURN_TO"), true): _switch32_start = 2
	elif JS.equal(_switch32, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "FIRE"), true): _switch32_start = 3
	elif JS.equal(_switch32, JS.get_property(JS.get_property(JS.module("AI"), "_ACTIONS"), "IDLE"), true): _switch32_start = 4
	while true:
		if _switch32_start >= 0 and _switch32_start <= 0:
			_scope57["targetPosition"] = {"x": (JS.number(JS.add(JS.get_property(JS.get_property(_scope57["action"], "position"), "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), "y": (JS.number(JS.add(JS.get_property(JS.get_property(_scope57["action"], "position"), "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))}
			_scope57["diffSqr"] = JS.add((JS.number((JS.number(JS.invoke_method(_scope57["tank"], "getX", [])) - JS.number(JS.get_property(_scope57["targetPosition"], "x")))) * JS.number((JS.number(JS.invoke_method(_scope57["tank"], "getX", [])) - JS.number(JS.get_property(_scope57["targetPosition"], "x"))))), (JS.number((JS.number(JS.invoke_method(_scope57["tank"], "getY", [])) - JS.number(JS.get_property(_scope57["targetPosition"], "y")))) * JS.number((JS.number(JS.invoke_method(_scope57["tank"], "getY", [])) - JS.number(JS.get_property(_scope57["targetPosition"], "y"))))))
			if JS.truthy(JS.compare("<", _scope57["diffSqr"], JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "DRIVE_TO_TILE_DISTANCE_SQUARED"))):
				JS.invoke_method(JS.get_property(self, "actions"), "shift", [])
			break
		if _switch32_start >= 0 and _switch32_start <= 1:
			_scope57["diffSqr"] = JS.add((JS.number((JS.number(JS.invoke_method(_scope57["tank"], "getX", [])) - JS.number(JS.get_property(JS.get_property(_scope57["action"], "position"), "x")))) * JS.number((JS.number(JS.invoke_method(_scope57["tank"], "getX", [])) - JS.number(JS.get_property(JS.get_property(_scope57["action"], "position"), "x"))))), (JS.number((JS.number(JS.invoke_method(_scope57["tank"], "getY", [])) - JS.number(JS.get_property(JS.get_property(_scope57["action"], "position"), "y")))) * JS.number((JS.number(JS.invoke_method(_scope57["tank"], "getY", [])) - JS.number(JS.get_property(JS.get_property(_scope57["action"], "position"), "y"))))))
			if JS.truthy(JS.compare("<", _scope57["diffSqr"], JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "DRIVE_TO_POSITION_DISTANCE_SQUARED"))):
				JS.invoke_method(JS.get_property(self, "actions"), "shift", [])
			break
		if _switch32_start >= 0 and _switch32_start <= 2:
			_scope57["relativeToTank"] = JS.invoke_method(JS.module("B2DUtils"), "directionToLocalSpace", [JS.invoke_method(_scope57["tank"], "getB2DBody", []), JS.get_property(_scope57["action"], "direction")])
			if JS.truthy(JS.compare("<", JS.invoke_method("@Math", "abs", [JS.add(JS.add(JS.invoke_method("@Math", "atan2", [JS.get_property(_scope57["relativeToTank"], "y"), JS.get_property(_scope57["relativeToTank"], "x")]), (JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5))), JS.get_property(_scope57["action"], "imprecision"))]), JS.get_property(JS.get_property(JS.module("Constants"), "AI"), "TURN_TO_DIFFERENCE"))):
				JS.invoke_method(JS.get_property(self, "actions"), "shift", [])
			break
		if _switch32_start >= 0 and _switch32_start <= 3:
			if JS.truthy(JS.compare("<=", JS.get_property(_scope57["action"], "delay"), 0)):
				if JS.truthy(JS.compare("<=", JS.get_property(_scope57["action"], "duration"), 0)):
					JS.invoke_method(JS.get_property(self, "actions"), "shift", [])
				JS.set_property(_scope57["action"], "duration", (JS.number(JS.get_property(_scope57["action"], "duration")) - JS.number(_scope57["deltaTime"])))
			JS.set_property(_scope57["action"], "delay", (JS.number(JS.get_property(_scope57["action"], "delay")) - JS.number(_scope57["deltaTime"])))
			break
		if _switch32_start >= 0 and _switch32_start <= 4:
			if JS.truthy(JS.compare("<=", JS.get_property(_scope57["action"], "duration"), 0)):
				JS.invoke_method(JS.get_property(self, "actions"), "shift", [])
			JS.set_property(_scope57["action"], "duration", (JS.number(JS.get_property(_scope57["action"], "duration")) - JS.number(_scope57["deltaTime"])))
			break
		if _switch32_start >= 0 and _switch32_start <= 5:
			break
		break
	return null

func original__getFireActionDuration(_arg0 = null):
	var _scope58: Dictionary = {"weapon": _arg0}
	var _switch33 = JS.invoke_method(_scope58["weapon"], "getType", [])
	var _switch33_start = 1
	if JS.equal(_switch33, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch33_start = 0
	while true:
		if _switch33_start >= 0 and _switch33_start <= 0:
			return (JS.number(JS.add(JS.get_property(JS.module("Constants"), "GATLING_GUN_CHARGE_TIME"), (JS.number(JS.get_property(JS.module("Constants"), "GATLING_GUN_FIRE_RATE")) * JS.number(JS.invoke_method(_scope58["weapon"], "getField", ["numBullets"]))))) * JS.number(1000))
		if _switch33_start >= 0 and _switch33_start <= 1:
			return 1
		break
	return null
