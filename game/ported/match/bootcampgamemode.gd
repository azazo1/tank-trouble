# 由原版 BootCampGameMode 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/match/gamemode.gd"

var tanks = null
var tankCount = 0
var roundFinishingDuration = 0
var crateSpawnDuration = 0
static var _static_BootCampGameMode: Dictionary = {}
static var _initialized_BootCampGameMode = false
static func initialize_original_static():
	if _initialized_BootCampGameMode: return
	_initialized_BootCampGameMode = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_BootCampGameMode.has(key): return _static_BootCampGameMode[key]
	return JS.get_property(JS.module("GameMode"), key)
static func original_static_set(key, value):
	_static_BootCampGameMode[key] = value
	return value
func original_own_fields():
	return ["tanks","tankCount","roundFinishingDuration","crateSpawnDuration"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {}
	super._construct_create()
	JS.set_property(self, "mode", JS.get_property(JS.get_property(JS.module("Constants"), "GAME_MODES"), "BOOT_CAMP"))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/match/bootcampgamemode.gd").new()
	instance._construct_create()
	return instance

func original_canRemovePlayer(_arg0 = null):
	var _scope1: Dictionary = {"playerId": _arg0}
	return JS.equal(JS.invoke_method(JS.get_property(self, "roundController"), "getTank", [_scope1["playerId"]]), null, true)
	return null

func original_getScoreStates(_arg0 = null):
	var _scope2: Dictionary = {"playerId": _arg0, "result": null}
	_scope2["result"] = []
	JS.invoke_method(_scope2["result"], "push", [JS.invoke_method(JS.module("ScoreState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["s"]), _scope2["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "KILL"), 0])])
	JS.invoke_method(_scope2["result"], "push", [JS.invoke_method(JS.module("ScoreState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["s"]), _scope2["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "VICTORY"), 0])])
	return _scope2["result"]
	return null

func original_initializeRound():
	var _scope3: Dictionary = {}
	JS.set_property(self, "tanks", JS.invoke_method(JS.get_property(self, "roundController"), "getTanks", []))
	JS.set_property(self, "tankCount", JS.invoke_method("@Object", "keys", [JS.get_property(self, "tanks")]))
	JS.set_property(self, "roundFinishingDuration", JS.get_property(JS.module("Constants"), "ROUND_FINISHING_DURATION"))
	JS.set_property(self, "crateSpawnDuration", JS.add(JS.get_property(JS.module("Constants"), "CRATE_SPAWN_DURATION_MIN"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("Constants"), "CRATE_SPAWN_DURATION_VARIANCE")))))
	return null

func original_getTeam(_arg0 = null):
	var _scope4: Dictionary = {"playerId": _arg0}
	return JS.get_property(JS.get_property(JS.module("Constants"), "TEAMS"), "NO_TEAM")
	return null

func original_getMaze(_arg0 = null, _arg1 = null):
	var _scope5: Dictionary = {"playerIds": _arg0, "theme": _arg1}
	if JS.truthy(JS.get_property(self, "symmetric")):
		return JS.invoke_method(JS.module("Maze"), "createSymmetric", [JS.invoke_method("@Math", "min", [JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "MAX_WIDTH"), JS.invoke_method("@Math", "floor", [(JS.number(JS.add(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "BASE_WIDTH"), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "WIDTH_FOR_PLAYERS"), JS.get_property(_scope5["playerIds"], "length")))) * JS.number(JS.add((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "MAX_RANDOM_WIDTH_MULTIPLIER")) - JS.number(1)))), 1)))])]), JS.invoke_method("@Math", "min", [JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "MAX_HEIGHT"), JS.invoke_method("@Math", "floor", [(JS.number(JS.add(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "BASE_HEIGHT"), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "HEIGHT_FOR_PLAYERS"), JS.get_property(_scope5["playerIds"], "length")))) * JS.number(JS.add((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "MAX_RANDOM_HEIGHT_MULTIPLIER")) - JS.number(1)))), 1)))])]), _scope5["playerIds"], (JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEMES"), "STANDARD") if JS.truthy(JS.get_property(self, "ranked")) else _scope5["theme"])])
	else:
		return JS.invoke_method(JS.module("Maze"), "createRandom", [JS.invoke_method("@Math", "min", [JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "MAX_WIDTH"), JS.invoke_method("@Math", "floor", [(JS.number(JS.add(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "BASE_WIDTH"), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "WIDTH_FOR_PLAYERS"), JS.get_property(_scope5["playerIds"], "length")))) * JS.number(JS.add((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "MAX_RANDOM_WIDTH_MULTIPLIER")) - JS.number(1)))), 1)))])]), JS.invoke_method("@Math", "min", [JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "MAX_HEIGHT"), JS.invoke_method("@Math", "floor", [(JS.number(JS.add(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "BASE_HEIGHT"), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "HEIGHT_FOR_PLAYERS"), JS.get_property(_scope5["playerIds"], "length")))) * JS.number(JS.add((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "MAX_RANDOM_HEIGHT_MULTIPLIER")) - JS.number(1)))), 1)))])]), _scope5["playerIds"], (JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEMES"), "STANDARD") if JS.truthy(JS.get_property(self, "ranked")) else _scope5["theme"])])
	return null

func original_getInitialWeaponState(_arg0 = null):
	var _scope6: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(JS.module("BulletWeapon"), "createInitialWeaponState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["bw"]), _scope6["playerId"], JS.get_property(JS.module("Constants"), "BULLET_AMMO_COUNT")])
	return null

func original_getInitialUpgradeState(_arg0 = null):
	var _scope7: Dictionary = {"playerId": _arg0}
	return null
	return null

func original_getRespawnWeaponState(_arg0 = null):
	var _scope8: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(self, "getInitialWeaponState", [_scope8["playerId"]])
	return null

func original_getRespawnUpgradeState(_arg0 = null):
	var _scope9: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(self, "getInitialUpgradeState", [_scope9["playerId"]])
	return null

func original_roundEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope10: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3, "score": null}
	var _switch0 = _scope10["evt"]
	var _switch0_start = -1
	if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_ENDED"), true): _switch0_start = 0
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_KILLED"), true): _switch0_start = 1
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_DESTROYED"), true): _switch0_start = 2
	while true:
		if _switch0_start >= 0 and _switch0_start <= 0:
			_scope10["score"] = JS.invoke_method(JS.get_property(_scope10["self"], "gameController"), "getScoreByPlayerIdAndType", [JS.get_property(JS.invoke_method(_scope10["data"], "getPlayerIds", []), 0), JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "VICTORY")])
			if JS.truthy(_scope10["score"]):
				JS.invoke_method(JS.get_property(_scope10["self"], "gameController"), "adjustScore", [JS.invoke_method(_scope10["score"], "getId", []), 1])
			break
		if _switch0_start >= 0 and _switch0_start <= 1:
			JS.set_property(_scope10["self"], "roundFinishingDuration", JS.get_property(JS.module("Constants"), "ROUND_FINISHING_DURATION"))
			if JS.truthy(not JS.equal(JS.invoke_method(_scope10["data"], "getKillerPlayerId", []), JS.invoke_method(_scope10["data"], "getVictimPlayerId", []), false)):
				_scope10["score"] = JS.invoke_method(JS.get_property(_scope10["self"], "gameController"), "getScoreByPlayerIdAndType", [JS.invoke_method(_scope10["data"], "getKillerPlayerId", []), JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "KILL")])
				if JS.truthy(_scope10["score"]):
					JS.invoke_method(JS.get_property(_scope10["self"], "gameController"), "adjustScore", [JS.invoke_method(_scope10["score"], "getId", []), 1])
			break
		if _switch0_start >= 0 and _switch0_start <= 2:
			JS.set_property(_scope10["self"], "roundFinishingDuration", JS.get_property(JS.module("Constants"), "ROUND_FINISHING_DURATION"))
			break
		break
	return null

func original_update(_arg0 = null):
	var _scope11: Dictionary = {"deltaTime": _arg0, "cratePosition": null, "randomCrateType": null}
	if JS.truthy(JS.compare(">", JS.get_property(JS.get_property(self, "crateTypes"), "length"), 0)):
		if JS.truthy(JS.compare("<", JS.invoke_method(JS.get_property(self, "roundController"), "getCrateCount", []), JS.get_property(JS.module("Constants"), "MAX_CRATES"))):
			JS.set_property(self, "crateSpawnDuration", (JS.number(JS.get_property(self, "crateSpawnDuration")) - JS.number(_scope11["deltaTime"])))
			if JS.truthy(JS.compare("<", JS.get_property(self, "crateSpawnDuration"), 0)):
				_scope11["cratePosition"] = null
				if JS.truthy(JS.get_property(self, "symmetric")):
					JS.set_property(_scope11, "cratePosition", JS.invoke_method(JS.invoke_method(JS.get_property(self, "roundController"), "getMaze", []), "getCrateSpawnPosition", [JS.invoke_method(JS.get_property(self, "roundController"), "getRoundState", [true])]))
				else:
					JS.set_property(_scope11, "cratePosition", JS.invoke_method(JS.invoke_method(JS.get_property(self, "roundController"), "getMaze", []), "getRandomUnusedPosition", [JS.invoke_method(JS.get_property(self, "roundController"), "getRoundState", [true]), JS.get_property(JS.module("Constants"), "CRATE_MINIMUM_TILES_TO_TANKS")]))
				if JS.truthy(_scope11["cratePosition"]):
					_scope11["randomCrateType"] = JS.get_property(JS.get_property(self, "crateTypes"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.get_property(self, "crateTypes"), "length")))]))
					JS.invoke_method(JS.get_property(self, "roundController"), "spawnCrate", [_scope11["randomCrateType"], _scope11["cratePosition"]])
				JS.set_property(self, "crateSpawnDuration", JS.add(JS.get_property(JS.module("Constants"), "CRATE_SPAWN_DURATION_MIN"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("Constants"), "CRATE_SPAWN_DURATION_VARIANCE")))))
	JS.set_property(self, "tanks", JS.invoke_method(JS.get_property(self, "roundController"), "getTanks", []))
	JS.set_property(self, "tankCount", JS.get_property(JS.invoke_method("@Object", "keys", [JS.get_property(self, "tanks")]), "length"))
	if JS.truthy(JS.compare("<=", JS.get_property(self, "tankCount"), 1)):
		JS.set_property(self, "roundFinishingDuration", (JS.number(JS.get_property(self, "roundFinishingDuration")) - JS.number(_scope11["deltaTime"])))
	return null

func original_isRoundOver():
	var _scope12: Dictionary = {}
	return JS.compare("<=", JS.get_property(self, "roundFinishingDuration"), 0)
	return null

func original_getWinnerPlayerIds():
	var _scope13: Dictionary = {}
	if JS.truthy(JS.equal(JS.get_property(self, "tankCount"), 1, false)):
		return [JS.invoke_method(JS.get_property(JS.get_property(self, "tanks"), JS.get_property(JS.invoke_method("@Object", "keys", [JS.get_property(self, "tanks")]), 0)), "getPlayerId", [])]
	else:
		return []
	return null

func original_getVictoryExperience():
	var _scope14: Dictionary = {}
	return 0
	return null

func original_getKillExperience():
	var _scope15: Dictionary = {}
	return 0
	return null

func original_getVictoryGoldAmount():
	var _scope16: Dictionary = {}
	return 0
	return null
