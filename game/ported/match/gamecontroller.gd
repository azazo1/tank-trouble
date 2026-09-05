# 由原版 GameController 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var model = null
var roundController = null
var roundEventListeners = []
var gameEventListeners = []
var id = null
var localPlayerIds = []
var log = null
var ranked = false
var symmetric = false
var storm = false
var crateTypes = []
var premium = false
var gameMode = null
var betweenRoundsDuration = JS.add(JS.get_property(JS.module("Constants"), "BETWEEN_ROUNDS_DURATION"), JS.get_property(JS.module("Constants"), "CELEBRATION_DURATION"))
var celebrationDuration = 0
var celebrationStarted = true
var celebrationEnded = true
var playerAdded = false
var lastUpdate = 0
var countDownValue = JS.get_property(JS.module("Constants"), "COUNTDOWN_START_VALUE")
var countDownDuration = 0
static var _static_GameController: Dictionary = {}
static var _initialized_GameController = false
static func initialize_original_static():
	if _initialized_GameController: return
	_initialized_GameController = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_GameController.has(key): return _static_GameController[key]
	return null
static func original_static_set(key, value):
	_static_GameController[key] = value
	return value
func original_own_fields():
	return ["model","roundController","roundEventListeners","gameEventListeners","id","localPlayerIds","log","ranked","symmetric","storm","crateTypes","premium","gameMode","betweenRoundsDuration","celebrationDuration","celebrationStarted","celebrationEnded","playerAdded","lastUpdate","countDownValue","countDownDuration"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"gameMode": _arg0, "ranked": _arg1, "symmetric": _arg2, "storm": _arg3, "maxActivePlayerCount": _arg4, "crateTypes": _arg5, "premium": _arg6, "theme": _arg7}
	JS.set_property(self, "id", JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["gc"]))
	JS.set_property(self, "gameMode", _scope0["gameMode"])
	JS.set_property(self, "ranked", _scope0["ranked"])
	JS.set_property(self, "symmetric", _scope0["symmetric"])
	JS.set_property(self, "storm", _scope0["storm"])
	JS.set_property(self, "crateTypes", _scope0["crateTypes"])
	JS.set_property(self, "premium", _scope0["premium"])
	JS.invoke_method(JS.get_property(self, "gameMode"), "setGameController", [self])
	JS.invoke_method(self, "_init", [JS.invoke_method(JS.get_property(self, "gameMode"), "getMode", []), _scope0["maxActivePlayerCount"], _scope0["theme"]])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/match/gamecontroller.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7)
	return instance

func _construct_withIds(_arg0 = null, _arg1 = null):
	var _scope1: Dictionary = {"id": _arg0, "localPlayerIds": _arg1}
	JS.set_property(self, "id", _scope1["id"])
	JS.set_property(self, "localPlayerIds", _scope1["localPlayerIds"])
	JS.invoke_method(self, "_init", [null, null, null])
	return null
static func withIds(_arg0 = null, _arg1 = null):
	var instance = load("res://game/ported/match/gamecontroller.gd").new()
	instance._construct_withIds(_arg0, _arg1)
	return instance

func original__init(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope2: Dictionary = {"mode": _arg0, "maxActivePlayerCount": _arg1, "theme": _arg2}
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["GameController"]))
	JS.set_property(self, "model", JS.invoke_method(JS.module("GameModel"), "create", [JS.get_property(self, "id"), _scope2["mode"], _scope2["maxActivePlayerCount"], _scope2["theme"]]))
	if JS.truthy(JS.logical("||", func():
		var _scope3: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)
		return null, func():
		var _scope4: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "addEventListener", [JS.get_property(self, "_gameModelEventHandler"), self, JS.get_property(self, "id")])
	JS.invoke_method(JS.get_property(self, "model"), "setState", [JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS")])
	JS.invoke_method(self, "_createRoundController", [])
	return null

func original_update(_arg0 = null):
	var _scope5: Dictionary = {"time": null, "deltaTime": null, "durationToWait": null}
	_scope5["time"] = JS.construct("@Date", [])
	_scope5["deltaTime"] = (JS.number((JS.number(_scope5["time"]) - JS.number(JS.get_property(self, "lastUpdate")))) / JS.number(1000))
	JS.set_property(self, "lastUpdate", _scope5["time"])
	JS.set_property(_scope5, "deltaTime", JS.invoke_method("@Math", "min", [_scope5["deltaTime"], JS.get_property(JS.module("Constants"), "MAX_DELTA_TIME")]))
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "update", [_scope5["deltaTime"]])
	if JS.truthy(JS.logical("||", func():
		var _scope6: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)
		return null, func():
		var _scope7: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)
		return null)):
		var _switch0 = JS.invoke_method(JS.get_property(self, "model"), "getState", [])
		var _switch0_start = 3
		if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"), true): _switch0_start = 0
		elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "COUNTING_DOWN"), true): _switch0_start = 1
		elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "IN_ROUND"), true): _switch0_start = 2
		while true:
			if _switch0_start >= 0 and _switch0_start <= 0:
				if JS.truthy(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GAME_MODE_INFO"), JS.invoke_method(JS.get_property(self, "model"), "getMode", [])), "HAS_CELEBRATION")):
					if JS.truthy((not JS.truthy(JS.get_property(self, "celebrationStarted")))):
						JS.set_property(self, "celebrationDuration", JS.add(JS.get_property(self, "celebrationDuration"), _scope5["deltaTime"]))
						if JS.truthy(JS.compare(">", JS.get_property(self, "celebrationDuration"), JS.get_property(JS.module("Constants"), "BETWEEN_ROUNDS_DURATION"))):
							JS.set_property(self, "celebrationDuration", 0)
							JS.invoke_method(self, "_initializeCelebration", [])
				_scope5["durationToWait"] = JS.get_property(JS.module("Constants"), "BETWEEN_ROUNDS_DURATION")
				if JS.truthy(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GAME_MODE_INFO"), JS.invoke_method(JS.get_property(self, "model"), "getMode", [])), "HAS_CELEBRATION")):
					JS.set_property(_scope5, "durationToWait", JS.add(_scope5["durationToWait"], JS.get_property(JS.module("Constants"), "CELEBRATION_DURATION")))
				JS.set_property(self, "betweenRoundsDuration", JS.add(JS.get_property(self, "betweenRoundsDuration"), _scope5["deltaTime"]))
				if JS.truthy(JS.compare(">", JS.get_property(self, "betweenRoundsDuration"), _scope5["durationToWait"])):
					if JS.truthy((not JS.truthy(JS.get_property(self, "celebrationEnded")))):
						JS.invoke_method(self, "_endCelebration", [])
					if JS.truthy(JS.compare(">=", JS.invoke_method(JS.get_property(self, "model"), "getTotalPlayerCount", []), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GAME_MODE_INFO"), JS.invoke_method(JS.get_property(self, "model"), "getMode", [])), "MIN_PLAYERS"))):
						JS.set_property(self, "betweenRoundsDuration", 0)
						JS.set_property(self, "celebrationStarted", false)
						JS.set_property(self, "celebrationEnded", false)
						JS.invoke_method(JS.get_property(self, "log"), "debug", ["Enough players available in game to start playing"])
						JS.invoke_method(self, "_initializeRound", [])
					else:
						pass
				break
			if _switch0_start >= 0 and _switch0_start <= 1:
				JS.set_property(self, "countDownDuration", JS.add(JS.get_property(self, "countDownDuration"), _scope5["deltaTime"]))
				if JS.truthy(JS.compare(">=", JS.get_property(self, "countDownDuration"), JS.get_property(JS.module("Constants"), "COUNTDOWN_DURATION"))):
					JS.set_property(self, "countDownDuration", 0)
					if JS.truthy(JS.compare(">", JS.get_property(self, "countDownValue"), 0)):
						JS.invoke_method(self, "countDown", [JS.get_property(self, "countDownValue")])
						JS.increment(self, "countDownValue", -1, false)
					else:
						JS.set_property(self, "countDownValue", JS.get_property(JS.module("Constants"), "COUNTDOWN_START_VALUE"))
						JS.invoke_method(self, "startRound", [])
				break
			if _switch0_start >= 0 and _switch0_start <= 2:
				break
			if _switch0_start >= 0 and _switch0_start <= 3:
				JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add(JS.add("Unknown state ", JS.invoke_method(JS.get_property(self, "model"), "getState", [])), " in GameModel._gameModelStateHandler")])
			break
		if JS.truthy(JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)):
			if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getTotalPlayerCount", []), 0, false)):
				JS.invoke_method(JS.get_property(self, "model"), "setState", [JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "ENDED")])
		else:
			if JS.truthy(JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)):
				if JS.truthy(JS.compare("<=", JS.invoke_method(JS.get_property(self, "model"), "getTotalPlayerCount", []), 1)):
					JS.invoke_method(JS.get_property(self, "model"), "setState", [JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "ENDED")])
		JS.invoke_method(JS.get_property(self, "model"), "update", [])
	return null

func original_getId():
	var _scope8: Dictionary = {}
	return JS.get_property(self, "id")
	return null

func original_getRoundId():
	var _scope9: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getId", [])
	else:
		return null
	return null

func original_getMaze(_arg0 = null, _arg1 = null):
	var _scope10: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getMaze", [])
	else:
		return null
	return null

func original_getModifier(_arg0 = null, _arg1 = null):
	var _scope11: Dictionary = {"playerId": _arg0, "modifierType": _arg1}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getModifier", [_scope11["playerId"], _scope11["modifierType"]])
	else:
		return null
	return null

func original_verifyAndCorrectTankState(_arg0 = null):
	var _scope12: Dictionary = {"tankState": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "verifyAndCorrectTankState", [_scope12["tankState"]])
	return false
	return null

func original_setTankState(_arg0 = null, _arg1 = null):
	var _scope13: Dictionary = {"tankState": _arg0}
	if JS.truthy(not JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "IN_ROUND"), false)):
		JS.invoke_method(JS.get_property(self, "log"), "warn", [JS.add(JS.add(JS.add("Player with id ", JS.invoke_method(_scope13["tankState"], "getPlayerId", [])), " attempted to set tank state with game in state "), JS.invoke_method(JS.get_property(self, "model"), "getState", []))])
		return false
	if JS.truthy((not JS.truthy(JS.invoke_method(JS.get_property(self, "model"), "isPlayerActive", [JS.invoke_method(_scope13["tankState"], "getPlayerId", [])])))):
		JS.invoke_method(JS.get_property(self, "log"), "warn", [JS.add(JS.add("Player with id ", JS.invoke_method(_scope13["tankState"], "getPlayerId", [])), " attempted to set tank state while not active in game")])
		return false
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "setTankState", [_scope13["tankState"], false])
	return null

func original_addPlayer(_arg0 = null, _arg1 = null):
	var _scope14: Dictionary = {"playerId": _arg0, "success": null, "scoreStates": null, "i": null}
	_scope14["success"] = JS.invoke_method(JS.get_property(self, "model"), "addPlayer", [_scope14["playerId"], JS.get_property(JS.get_property(JS.module("Constants"), "TEAMS"), "NO_TEAM")])
	if JS.truthy(_scope14["success"]):
		if JS.truthy(JS.logical("||", func():
			var _scope15: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)
			return null, func():
			var _scope16: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)
			return null)):
			_scope14["scoreStates"] = JS.invoke_method(JS.get_property(self, "gameMode"), "getScoreStates", [_scope14["playerId"]])
			_scope14["i"] = 0
			while JS.truthy(JS.compare("<", _scope14["i"], JS.get_property(_scope14["scoreStates"], "length"))):
				JS.invoke_method(self, "setScoreState", [JS.get_property(_scope14["scoreStates"], _scope14["i"])])
				JS.increment(_scope14, "i", 1, false)
		JS.set_property(self, "playerAdded", true)
	return _scope14["success"]
	return null

func original_removePlayer(_arg0 = null):
	var _scope17: Dictionary = {"playerId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add("Removing player ", _scope17["playerId"])])
	if JS.truthy(JS.invoke_method(JS.get_property(self, "model"), "isPlayerActive", [_scope17["playerId"]])):
		JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add(JS.add("Player ", _scope17["playerId"]), " is marked as active, so removing from round")])
		if JS.truthy(JS.logical("&&", func():
			var _scope18: Dictionary = {}
			return JS.get_property(self, "roundController")
			return null, func():
			var _scope19: Dictionary = {}
			return not JS.equal(JS.invoke_method(JS.get_property(self, "roundController"), "getTank", [_scope17["playerId"]]), null, true)
			return null)):
			JS.invoke_method(JS.get_property(self, "roundController"), "removeTank", [_scope17["playerId"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add(JS.add("Player ", _scope17["playerId"]), " not marked as active, so not removing from round")])
	return JS.invoke_method(JS.get_property(self, "model"), "removePlayer", [_scope17["playerId"]])
	return null

func original_canRemovePlayers(_arg0 = null):
	var _scope20: Dictionary = {"playerIds": _arg0, "i": null, "playerId": null}
	if JS.truthy(JS.logical("||", func():
		var _scope21: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"), true)
		return null, func():
		var _scope22: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "ENDED"), true)
		return null)):
		return true
	_scope20["i"] = 0
	while JS.truthy(JS.compare("<", _scope20["i"], JS.get_property(_scope20["playerIds"], "length"))):
		_scope20["playerId"] = JS.get_property(_scope20["playerIds"], _scope20["i"])
		if JS.truthy(JS.invoke_method(JS.get_property(self, "model"), "isPlayerActive", [_scope20["playerId"]])):
			if JS.truthy((not JS.truthy(JS.invoke_method(JS.get_property(self, "gameMode"), "canRemovePlayer", [_scope20["playerId"]])))):
				return false
		JS.increment(_scope20, "i", 1, false)
	return true
	return null

func original_setScore(_arg0 = null, _arg1 = null):
	var _scope23: Dictionary = {"scoreId": _arg0, "value": _arg1, "score": null, "scoreState": null}
	_scope23["score"] = JS.invoke_method(self, "getScore", [_scope23["scoreId"]])
	if JS.truthy(_scope23["score"]):
		_scope23["scoreState"] = JS.invoke_method(JS.module("ScoreState"), "withState", [JS.invoke_method(_scope23["score"], "getId", []), JS.invoke_method(_scope23["score"], "getPlayerId", []), JS.invoke_method(_scope23["score"], "getType", []), _scope23["value"]])
		JS.invoke_method(self, "setScoreState", [_scope23["scoreState"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempted to set non-existing score"])
	return null

func original_adjustScore(_arg0 = null, _arg1 = null):
	var _scope24: Dictionary = {"scoreId": _arg0, "adjustment": _arg1, "score": null, "scoreState": null}
	_scope24["score"] = JS.invoke_method(self, "getScore", [_scope24["scoreId"]])
	if JS.truthy(_scope24["score"]):
		_scope24["scoreState"] = JS.invoke_method(JS.module("ScoreState"), "withState", [JS.invoke_method(_scope24["score"], "getId", []), JS.invoke_method(_scope24["score"], "getPlayerId", []), JS.invoke_method(_scope24["score"], "getType", []), JS.add(JS.invoke_method(_scope24["score"], "getValue", []), _scope24["adjustment"])])
		JS.invoke_method(self, "setScoreState", [_scope24["scoreState"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempted to adjust non-existing score"])
	return null

func original_removeScore(_arg0 = null):
	var _scope25: Dictionary = {"scoreId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add("Removing score ", _scope25["scoreId"])])
	return JS.invoke_method(JS.get_property(self, "model"), "removeScore", [_scope25["scoreId"]])
	return null

func original_addEmblem(_arg0 = null, _arg1 = null):
	var _scope26: Dictionary = {"playerId": _arg0, "type": _arg1, "emblemState": null}
	_scope26["emblemState"] = JS.invoke_method(JS.module("EmblemState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["e"]), _scope26["playerId"], _scope26["type"]])
	JS.invoke_method(self, "setEmblemState", [_scope26["emblemState"]])
	return null

func original_removeEmblem(_arg0 = null):
	var _scope27: Dictionary = {"emblemId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add("Removing emblem ", _scope27["emblemId"])])
	return JS.invoke_method(JS.get_property(self, "model"), "removeEmblem", [_scope27["emblemId"]])
	return null

func original_getTotalPlayerCount():
	var _scope28: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getTotalPlayerCount", [])
	return null

func original_getQueuedPlayerCount():
	var _scope29: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getQueuedPlayerCount", [])
	return null

func original_getActivePlayerCount():
	var _scope30: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getActivePlayerCount", [])
	return null

func original_getQueuedPlayerIds():
	var _scope31: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getQueuedPlayerIds", [])
	return null

func original_getActivePlayerIds():
	var _scope32: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getActivePlayerIds", [])
	return null

func original_getAllPlayerIds():
	var _scope33: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getAllPlayerIds", [])
	return null

func original_setGameState(_arg0 = null):
	var _scope34: Dictionary = {"gameState": _arg0, "playerStates": null, "i": null, "activePlayers": null, "player": null, "playerId": null, "playerFound": null, "scoreStates": null, "scores": null, "score": null, "scoreId": null, "scoreFound": null, "emblemStates": null, "emblems": null, "emblem": null, "emblemId": null, "emblemFound": null}
	_scope34["playerStates"] = JS.invoke_method(_scope34["gameState"], "getPlayerStates", [])
	_scope34["i"] = 0
	while JS.truthy(JS.compare("<", _scope34["i"], JS.get_property(_scope34["playerStates"], "length"))):
		JS.invoke_method(self, "setPlayerState", [JS.get_property(_scope34["playerStates"], _scope34["i"])])
		JS.increment(_scope34, "i", 1, true)
	_scope34["activePlayers"] = JS.invoke_method(JS.get_property(self, "model"), "getActivePlayers", [])
	for _iteration1 in JS.keys(_scope34["activePlayers"]):
		JS.set_property(_scope34, "player", _iteration1)
		_scope34["playerId"] = JS.invoke_method(JS.get_property(_scope34["activePlayers"], _scope34["player"]), "getId", [])
		_scope34["playerFound"] = false
		_scope34["i"] = 0
		while JS.truthy(JS.compare("<", _scope34["i"], JS.get_property(_scope34["playerStates"], "length"))):
			if JS.truthy(JS.equal(_scope34["playerId"], JS.invoke_method(JS.get_property(_scope34["playerStates"], _scope34["i"]), "getPlayerId", []), false)):
				JS.set_property(_scope34, "playerFound", true)
				break
			JS.increment(_scope34, "i", 1, true)
		if JS.truthy((not JS.truthy(_scope34["playerFound"]))):
			JS.invoke_method(self, "removePlayer", [_scope34["playerId"]])
	JS.invoke_method(self, "setMode", [JS.invoke_method(_scope34["gameState"], "getMode", [])])
	JS.invoke_method(self, "setMaxActivePlayerCount", [JS.invoke_method(_scope34["gameState"], "getMaxActivePlayerCount", [])])
	JS.invoke_method(self, "setTheme", [JS.invoke_method(_scope34["gameState"], "getTheme", [])])
	JS.invoke_method(self, "setRanked", [JS.invoke_method(_scope34["gameState"], "getRanked", [])])
	JS.invoke_method(self, "setSymmetric", [JS.invoke_method(_scope34["gameState"], "getSymmetric", [])])
	JS.invoke_method(self, "setStorm", [JS.invoke_method(_scope34["gameState"], "getStorm", [])])
	JS.invoke_method(self, "setPremium", [JS.invoke_method(_scope34["gameState"], "getPremium", [])])
	_scope34["scoreStates"] = JS.invoke_method(_scope34["gameState"], "getScoreStates", [])
	_scope34["i"] = 0
	while JS.truthy(JS.compare("<", _scope34["i"], JS.get_property(_scope34["scoreStates"], "length"))):
		JS.invoke_method(self, "setScoreState", [JS.get_property(_scope34["scoreStates"], _scope34["i"])])
		JS.increment(_scope34, "i", 1, true)
	_scope34["scores"] = JS.invoke_method(JS.get_property(self, "model"), "getScores", [])
	for _iteration2 in JS.keys(_scope34["scores"]):
		JS.set_property(_scope34, "score", _iteration2)
		_scope34["scoreId"] = JS.invoke_method(JS.get_property(_scope34["scores"], _scope34["score"]), "getId", [])
		_scope34["scoreFound"] = false
		_scope34["i"] = 0
		while JS.truthy(JS.compare("<", _scope34["i"], JS.get_property(_scope34["scoreStates"], "length"))):
			if JS.truthy(JS.equal(_scope34["scoreId"], JS.invoke_method(JS.get_property(_scope34["scoreStates"], _scope34["i"]), "getId", []), false)):
				JS.set_property(_scope34, "scoreFound", true)
				break
			JS.increment(_scope34, "i", 1, true)
	if JS.truthy((not JS.truthy(_scope34["scoreFound"]))):
		JS.invoke_method(self, "removeScore", [_scope34["scoreId"]])
	_scope34["emblemStates"] = JS.invoke_method(_scope34["gameState"], "getEmblemStates", [])
	_scope34["i"] = 0
	while JS.truthy(JS.compare("<", _scope34["i"], JS.get_property(_scope34["emblemStates"], "length"))):
		JS.invoke_method(self, "setEmblemState", [JS.get_property(_scope34["emblemStates"], _scope34["i"])])
		JS.increment(_scope34, "i", 1, true)
	_scope34["emblems"] = JS.invoke_method(JS.get_property(self, "model"), "getEmblems", [])
	for _iteration3 in JS.keys(_scope34["emblems"]):
		JS.set_property(_scope34, "emblem", _iteration3)
		_scope34["emblemId"] = JS.invoke_method(JS.get_property(_scope34["emblems"], _scope34["emblem"]), "getId", [])
		_scope34["emblemFound"] = false
		_scope34["i"] = 0
		while JS.truthy(JS.compare("<", _scope34["i"], JS.get_property(_scope34["emblemStates"], "length"))):
			if JS.truthy(JS.equal(_scope34["emblemId"], JS.invoke_method(JS.get_property(_scope34["emblemStates"], _scope34["i"]), "getId", []), false)):
				JS.set_property(_scope34, "emblemFound", true)
				break
			JS.increment(_scope34, "i", 1, true)
		if JS.truthy((not JS.truthy(_scope34["emblemFound"]))):
			JS.invoke_method(self, "removeEmblem", [_scope34["emblemId"]])
	JS.invoke_method(JS.get_property(self, "model"), "emitGameState", [_scope34["gameState"]])
	return null

func original_setPlayerState(_arg0 = null):
	var _scope35: Dictionary = {"playerState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setPlayerState", [_scope35["playerState"]])
	return null

func original_setMode(_arg0 = null):
	var _scope36: Dictionary = {"mode": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setMode", [_scope36["mode"]])
	return null

func original_getMode():
	var _scope37: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getMode", [])
	return null

func original_setMaxActivePlayerCount(_arg0 = null):
	var _scope38: Dictionary = {"maxActivePlayerCount": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setMaxActivePlayerCount", [_scope38["maxActivePlayerCount"]])
	return null

func original_getMaxActivePlayerCount():
	var _scope39: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getMaxActivePlayerCount", [])
	return null

func original_setTheme(_arg0 = null):
	var _scope40: Dictionary = {"theme": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setTheme", [_scope40["theme"]])
	return null

func original_getTheme():
	var _scope41: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getTheme", [])
	return null

func original_setScoreState(_arg0 = null):
	var _scope42: Dictionary = {"scoreState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setScoreState", [_scope42["scoreState"]])
	return null

func original_setEmblemState(_arg0 = null):
	var _scope43: Dictionary = {"emblemState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setEmblemState", [_scope43["emblemState"]])
	return null

func original_getState():
	var _scope44: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getState", [])
	return null

func original_getGameState():
	var _scope45: Dictionary = {"gameState": null}
	_scope45["gameState"] = JS.invoke_method(JS.get_property(self, "model"), "getGameState", [])
	JS.invoke_method(_scope45["gameState"], "setId", [JS.get_property(self, "id")])
	JS.invoke_method(_scope45["gameState"], "setRanked", [JS.get_property(self, "ranked")])
	JS.invoke_method(_scope45["gameState"], "setSymmetric", [JS.get_property(self, "symmetric")])
	JS.invoke_method(_scope45["gameState"], "setStorm", [JS.get_property(self, "storm")])
	JS.invoke_method(_scope45["gameState"], "setPremium", [JS.get_property(self, "premium")])
	return _scope45["gameState"]
	return null

func original_getRoundState(_arg0 = null):
	var _scope46: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getRoundState", [JS.get_property(self, "playerAdded")])
	else:
		return null
	return null

func original_getGameMode():
	var _scope47: Dictionary = {}
	return JS.get_property(self, "gameMode")
	return null

func original_setRanked(_arg0 = null):
	var _scope48: Dictionary = {"ranked": _arg0}
	JS.set_property(self, "ranked", _scope48["ranked"])
	return null

func original_getRanked():
	var _scope49: Dictionary = {}
	return JS.get_property(self, "ranked")
	return null

func original_setSymmetric(_arg0 = null):
	var _scope50: Dictionary = {"symmetric": _arg0}
	JS.set_property(self, "symmetric", _scope50["symmetric"])
	return null

func original_getSymmetric():
	var _scope51: Dictionary = {}
	return JS.get_property(self, "symmetric")
	return null

func original_setStorm(_arg0 = null):
	var _scope52: Dictionary = {"storm": _arg0}
	JS.set_property(self, "storm", _scope52["storm"])
	return null

func original_getStorm():
	var _scope53: Dictionary = {}
	return JS.get_property(self, "storm")
	return null

func original_setPremium(_arg0 = null):
	var _scope54: Dictionary = {"premium": _arg0}
	JS.set_property(self, "premium", _scope54["premium"])
	return null

func original_getPremium():
	var _scope55: Dictionary = {}
	return JS.get_property(self, "premium")
	return null

func original_setVictoryGoldAmount(_arg0 = null):
	var _scope56: Dictionary = {"victoryGoldAmount": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "setVictoryGoldAmount", [_scope56["victoryGoldAmount"]])
	return null

func original_setStakes(_arg0 = null):
	var _scope57: Dictionary = {"stakes": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "setStakes", [_scope57["stakes"]])
	return null

func original_getStake(_arg0 = null):
	var _scope58: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getStake", [_scope58["playerId"]])
	else:
		return null
	return null

func original_clearExpandedRoundStateBits():
	var _scope59: Dictionary = {}
	JS.set_property(self, "playerAdded", false)
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "clearExpandedRoundStateBits", [])
	return null

func original_getInitialRoundStateReceived():
	var _scope60: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getInitialRoundStateReceived", [])
	else:
		return false
	return null

func original_setRoundState(_arg0 = null):
	var _scope61: Dictionary = {"roundState": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "setRoundState", [_scope61["roundState"]])
	return null

func original_setInputState(_arg0 = null):
	var _scope62: Dictionary = {"inputState": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "setInputState", [_scope62["inputState"]])
	return null

func original__createRoundController():
	var _scope63: Dictionary = {"i": null}
	JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add(JS.add(JS.add("Game id: ", JS.get_property(self, "id")), ". Queued player count: "), JS.invoke_method(self, "getQueuedPlayerCount", []))])
	JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add(JS.add(JS.add("Game id: ", JS.get_property(self, "id")), ". Active player count: "), JS.invoke_method(self, "getActivePlayerCount", []))])
	if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"), true)):
		JS.set_property(self, "roundController", null)
		JS.set_property(self, "roundController", JS.invoke_method(JS.module("RoundController"), "create", [JS.get_property(self, "localPlayerIds"), JS.get_property(self, "gameMode"), JS.get_property(self, "id")]))
		if JS.truthy(JS.logical("||", func():
			var _scope64: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)
			return null, func():
			var _scope65: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)
			return null)):
			JS.invoke_method(JS.get_property(self, "roundController"), "addEventListener", [JS.get_property(self, "_roundModelEventHandler"), self, JS.get_property(self, "id")])
		_scope63["i"] = 0
		while JS.truthy(JS.compare("<", _scope63["i"], JS.get_property(JS.get_property(self, "roundEventListeners"), "length"))):
			JS.invoke_method(JS.get_property(self, "roundController"), "addEventListener", [JS.get_property(JS.get_property(JS.get_property(self, "roundEventListeners"), _scope63["i"]), "cb"), JS.get_property(JS.get_property(JS.get_property(self, "roundEventListeners"), _scope63["i"]), "ctxt"), JS.get_property(self, "id")])
			JS.increment(_scope63, "i", 1, true)
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Attempt to create round in game which is currently in state ", JS.invoke_method(JS.get_property(self, "model"), "getState", []))])
	return null

func original_setMaze(_arg0 = null):
	var _scope66: Dictionary = {"maze": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope67: Dictionary = {}
		return JS.logical("||", func():
			var _scope68: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"), true)
			return null, func():
			var _scope69: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "COUNTING_DOWN"), true)
			return null)
		return null, func():
		var _scope70: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "IN_ROUND"), true)
		return null)):
		JS.invoke_method(JS.get_property(self, "roundController"), "setMaze", [_scope66["maze"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Attempt to set maze in game which is currently in state ", JS.invoke_method(JS.get_property(self, "model"), "getState", []))])
	return null

func original_spawnGold():
	var _scope71: Dictionary = {}
	if JS.truthy(JS.logical("&&", func():
		var _scope72: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)
		return null, func():
		var _scope73: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "IN_ROUND"), true)
		return null)):
		if JS.truthy(JS.get_property(self, "roundController")):
			JS.invoke_method(JS.get_property(self, "roundController"), "spawnGold", [])
	return null

func original_spawnDiamond():
	var _scope74: Dictionary = {}
	if JS.truthy(JS.logical("&&", func():
		var _scope75: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), false)
		return null, func():
		var _scope76: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "IN_ROUND"), false)
		return null)):
		if JS.truthy(JS.get_property(self, "roundController")):
			JS.invoke_method(JS.get_property(self, "roundController"), "spawnDiamond", [])
	return null

func original_createRound(_arg0 = null):
	var _scope77: Dictionary = {"ranked": _arg0}
	if JS.truthy(JS.logical("&&", func():
		var _scope78: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null, func():
		var _scope79: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"), false)
		return null)):
		JS.set_property(self, "ranked", _scope77["ranked"])
		JS.invoke_method(self, "_createRoundController", [])
		if JS.truthy(JS.get_property(self, "roundController")):
			JS.invoke_method(JS.get_property(self, "roundController"), "createRound", [_scope77["ranked"]])
	return null

func original_startRound():
	var _scope80: Dictionary = {}
	if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "COUNTING_DOWN"), false)):
		if JS.truthy(JS.get_property(self, "roundController")):
			JS.invoke_method(JS.get_property(self, "roundController"), "startRound", [])
		JS.invoke_method(JS.get_property(self, "model"), "setState", [JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "IN_ROUND")])
	else:
		if JS.truthy(JS.logical("&&", func():
			var _scope81: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"), false)
			return null, func():
			var _scope82: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
			return null)):
			if JS.truthy(JS.get_property(self, "roundController")):
				JS.invoke_method(JS.get_property(self, "roundController"), "startRound", [])
			JS.invoke_method(JS.get_property(self, "log"), "debug", ["In state BETWEEN_ROUNDS when round started. Player is spectating and joined after last countdown message."])
		else:
			JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Attempt to start round in game which is currently in state ", JS.invoke_method(JS.get_property(self, "model"), "getState", []))])
	return null

func original_startCelebration():
	var _scope83: Dictionary = {}
	if JS.truthy(JS.logical("&&", func():
		var _scope84: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null, func():
		var _scope85: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"), false)
		return null)):
		if JS.truthy(JS.get_property(self, "roundController")):
			JS.invoke_method(JS.get_property(self, "roundController"), "startCelebration", [])
	return null

func original__initializeCelebration():
	var _scope86: Dictionary = {}
	JS.set_property(self, "celebrationStarted", true)
	JS.invoke_method(JS.get_property(self, "roundController"), "startCelebration", [])
	return null

func original__endCelebration():
	var _scope87: Dictionary = {}
	JS.set_property(self, "celebrationEnded", true)
	JS.invoke_method(JS.get_property(self, "roundController"), "endCelebration", [])
	return null

func original__initializeRound():
	var _scope88: Dictionary = {"nextQueuedPlayerId": null, "maze": null, "tankPositions": null, "i": null}
	_scope88["nextQueuedPlayerId"] = JS.invoke_method(JS.get_property(self, "model"), "getNextQueuedPlayerId", [])
	while JS.truthy(JS.logical("&&", func():
		var _scope89: Dictionary = {}
		return JS.compare("<", JS.invoke_method(JS.get_property(self, "model"), "getActivePlayerCount", []), JS.invoke_method(JS.get_property(self, "model"), "getMaxActivePlayerCount", []))
		return null, func():
		var _scope90: Dictionary = {}
		return not JS.equal(_scope88["nextQueuedPlayerId"], null, false)
		return null)):
		JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add("Activating player ", _scope88["nextQueuedPlayerId"])])
		JS.invoke_method(JS.get_property(self, "model"), "activatePlayer", [_scope88["nextQueuedPlayerId"]])
		JS.set_property(_scope88, "nextQueuedPlayerId", JS.invoke_method(JS.get_property(self, "model"), "getNextQueuedPlayerId", []))
	JS.invoke_method(JS.get_property(self, "gameMode"), "setRanked", [JS.get_property(self, "ranked")])
	JS.invoke_method(JS.get_property(self, "gameMode"), "setSymmetric", [JS.get_property(self, "symmetric")])
	JS.invoke_method(JS.get_property(self, "gameMode"), "setStorm", [JS.get_property(self, "storm")])
	JS.invoke_method(JS.get_property(self, "gameMode"), "setCrateTypes", [JS.get_property(self, "crateTypes")])
	JS.invoke_method(self, "_createRoundController", [])
	JS.invoke_method(JS.get_property(self, "roundController"), "createRound", [JS.get_property(self, "ranked")])
	_scope88["maze"] = JS.invoke_method(JS.get_property(self, "gameMode"), "getMaze", [JS.invoke_method(self, "getActivePlayerIds", []), (JS.invoke_method(JS.get_property(self, "model"), "getTheme", []) if JS.truthy(not JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getTheme", []), JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEMES"), "RANDOM"), true)) else JS.invoke_method(JS.module("MazeThemeManager"), "getRandomActiveTheme", []))])
	JS.invoke_method(self, "setMaze", [_scope88["maze"]])
	_scope88["tankPositions"] = JS.invoke_method(_scope88["maze"], "getTankPositions", [])
	_scope88["i"] = 0
	while JS.truthy(JS.compare("<", _scope88["i"], JS.get_property(_scope88["tankPositions"], "length"))):
		JS.invoke_method(JS.get_property(self, "roundController"), "spawnTank", [JS.get_property(JS.get_property(_scope88["tankPositions"], _scope88["i"]), "playerId"), JS.get_property(_scope88["tankPositions"], _scope88["i"]), false])
		JS.increment(_scope88, "i", 1, false)
	JS.invoke_method(JS.get_property(self, "gameMode"), "initializeRound", [])
	JS.invoke_method(JS.get_property(self, "model"), "setState", [JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "COUNTING_DOWN")])
	return null

func original_countDown(_arg0 = null):
	var _scope91: Dictionary = {"value": _arg0}
	if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"), false)):
		JS.invoke_method(JS.get_property(self, "model"), "countDown", [_scope91["value"]])
		JS.invoke_method(JS.get_property(self, "model"), "setState", [JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "COUNTING_DOWN")])
	else:
		if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "COUNTING_DOWN"), false)):
			JS.invoke_method(JS.get_property(self, "model"), "countDown", [_scope91["value"]])
		else:
			JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Attempt to count down in game which is currently in state ", JS.invoke_method(JS.get_property(self, "model"), "getState", []))])
	return null

func original_endRound(_arg0 = null):
	var _scope92: Dictionary = {"victoryAward": _arg0}
	if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "IN_ROUND"), false)):
		JS.invoke_method(JS.get_property(self, "roundController"), "endRound", [_scope92["victoryAward"]])
		JS.invoke_method(JS.get_property(self, "model"), "setState", [JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS")])
	else:
		if JS.truthy(JS.logical("&&", func():
			var _scope93: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.get_property(self, "model"), "getState", []), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"), false)
			return null, func():
			var _scope94: Dictionary = {}
			return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
			return null)):
			JS.invoke_method(JS.get_property(self, "roundController"), "endRound", [_scope92["victoryAward"]])
			JS.invoke_method(JS.get_property(self, "log"), "debug", ["In state BETWEEN_ROUNDS when round ended. Player was spectating and joined after last countdown message."])
		else:
			JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Attempt to end round in game which is currently in state ", JS.invoke_method(JS.get_property(self, "model"), "getState", []))])
	return null

func original_endGame():
	var _scope95: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "model"), "setState", [JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "ENDED")])
	return null

func original_getBetweenRoundsDuration():
	var _scope96: Dictionary = {}
	return JS.get_property(self, "betweenRoundsDuration")
	return null

func original_getQueuedPlayer(_arg0 = null):
	var _scope97: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getQueuedPlayer", [_scope97["playerId"]])
	return null

func original_getActivePlayer(_arg0 = null):
	var _scope98: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getActivePlayer", [_scope98["playerId"]])
	return null

func original_getScore(_arg0 = null):
	var _scope99: Dictionary = {"scoreId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getScore", [_scope99["scoreId"]])
	return null

func original_getScores():
	var _scope100: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getScores", [])
	return null

func original_getScoreByPlayerIdAndType(_arg0 = null, _arg1 = null):
	var _scope101: Dictionary = {"playerId": _arg0, "type": _arg1}
	return JS.invoke_method(JS.get_property(self, "model"), "getScoreByPlayerIdAndType", [_scope101["playerId"], _scope101["type"]])
	return null

func original_getEmblem(_arg0 = null):
	var _scope102: Dictionary = {"emblemId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getEmblem", [_scope102["emblemId"]])
	return null

func original_getEmblems():
	var _scope103: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getEmblems", [])
	return null

func original_getEmblemByPlayerIdAndType(_arg0 = null, _arg1 = null):
	var _scope104: Dictionary = {"playerId": _arg0, "type": _arg1}
	return JS.invoke_method(JS.get_property(self, "model"), "getEmblemByPlayerIdAndType", [_scope104["playerId"], _scope104["type"]])
	return null

func original_getTank(_arg0 = null):
	var _scope105: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getTank", [_scope105["playerId"]])
	return null

func original_getTanks():
	var _scope106: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getTanks", [])
	return null

func original_getProjectile(_arg0 = null):
	var _scope107: Dictionary = {"projectileId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getProjectile", [_scope107["projectileId"]])
	return null

func original_getProjectiles():
	var _scope108: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getProjectiles", [])
	return null

func original_getTrap(_arg0 = null):
	var _scope109: Dictionary = {"trapId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getTrap", [_scope109["trapId"]])
	return null

func original_getTraps():
	var _scope110: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getTraps", [])
	return null

func original_getCollectible(_arg0 = null):
	var _scope111: Dictionary = {"collectibleId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getCollectible", [_scope111["collectibleId"]])
	return null

func original_getCollectibles():
	var _scope112: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getCollectibles", [])
	return null

func original_getActiveWeapon(_arg0 = null):
	var _scope113: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getActiveWeapon", [_scope113["playerId"]])
	return null

func original_getDefaultWeapon(_arg0 = null):
	var _scope114: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getDefaultWeapon", [_scope114["playerId"]])
	return null

func original_getQueuedWeapons(_arg0 = null):
	var _scope115: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getQueuedWeapons", [_scope115["playerId"]])
	return null

func original_getUpgrades():
	var _scope116: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getUpgrades", [])
	return null

func original_getUpgrade(_arg0 = null):
	var _scope117: Dictionary = {"upgradeId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getUpgrade", [_scope117["upgradeId"]])
	return null

func original_getUpgradeByPlayerIdAndType(_arg0 = null, _arg1 = null):
	var _scope118: Dictionary = {"playerId": _arg0, "type": _arg1}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getUpgradeByPlayerIdAndType", [_scope118["playerId"], _scope118["type"]])
	return null

func original_getCounters():
	var _scope119: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getCounters", [])
	return null

func original_getCounter(_arg0 = null):
	var _scope120: Dictionary = {"counterId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getCounter", [_scope120["counterId"]])
	return null

func original_getZones():
	var _scope121: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getZones", [])
	return null

func original_getZone(_arg0 = null):
	var _scope122: Dictionary = {"zoneId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getZone", [_scope122["zoneId"]])
	return null

func original_killTank(_arg0 = null):
	var _scope123: Dictionary = {"kill": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "killTank", [_scope123["kill"]])
	return null

func original_destroyTank(_arg0 = null):
	var _scope124: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "destroyTank", [_scope124["playerId"]])
	return null

func original_timeoutProjectile(_arg0 = null):
	var _scope125: Dictionary = {"projectileId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "timeoutProjectile", [_scope125["projectileId"]])
	return null

func original_destroyProjectile(_arg0 = null):
	var _scope126: Dictionary = {"projectileId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "destroyProjectile", [_scope126["projectileId"]])
	return null

func original_tripTrap(_arg0 = null):
	var _scope127: Dictionary = {"trip": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "tripTrap", [_scope127["trip"]])
	return null

func original_destroyTrap(_arg0 = null):
	var _scope128: Dictionary = {"trapId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "destroyTrap", [_scope128["trapId"]])
	return null

func original_destroyCollectible(_arg0 = null):
	var _scope129: Dictionary = {"pickup": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "destroyCollectible", [_scope129["pickup"]])
	return null

func original_destroyWeapon(_arg0 = null):
	var _scope130: Dictionary = {"weaponDeactivation": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "destroyWeapon", [_scope130["weaponDeactivation"]])
	return null

func original_destroyUpgrade(_arg0 = null):
	var _scope131: Dictionary = {"upgradeUpdate": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "destroyUpgrade", [_scope131["upgradeUpdate"]])
	return null

func original_destroyCounter(_arg0 = null):
	var _scope132: Dictionary = {"counterId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "destroyCounter", [_scope132["counterId"]])
	return null

func original_destroyZone(_arg0 = null):
	var _scope133: Dictionary = {"zoneId": _arg0}
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "destroyZone", [_scope133["zoneId"]])
	return null

func original_addGameEventListener(_arg0 = null, _arg1 = null):
	var _scope134: Dictionary = {"callback": _arg0, "context": _arg1}
	JS.invoke_method(JS.get_property(self, "model"), "addEventListener", [_scope134["callback"], _scope134["context"], JS.get_property(self, "id")])
	return null

func original_removeGameEventListener(_arg0 = null, _arg1 = null):
	var _scope135: Dictionary = {"callback": _arg0, "context": _arg1}
	JS.invoke_method(JS.get_property(self, "model"), "removeEventListener", [_scope135["callback"], _scope135["context"]])
	return null

func original_addRoundEventListener(_arg0 = null, _arg1 = null):
	var _scope136: Dictionary = {"callback": _arg0, "context": _arg1}
	JS.invoke_method(JS.get_property(self, "roundEventListeners"), "push", [{"cb": _scope136["callback"], "ctxt": JS.weak(_scope136["context"])}])
	if JS.truthy(JS.get_property(self, "roundController")):
		JS.invoke_method(JS.get_property(self, "roundController"), "addEventListener", [_scope136["callback"], _scope136["context"], JS.get_property(self, "id")])
	return null

func original_removeRoundEventListener(_arg0 = null, _arg1 = null):
	var _scope137: Dictionary = {"callback": _arg0, "context": _arg1, "i": null}
	_scope137["i"] = 0
	while JS.truthy(JS.compare("<", _scope137["i"], JS.get_property(JS.get_property(self, "roundEventListeners"), "length"))):
		if JS.truthy(JS.logical("&&", func():
			var _scope138: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "roundEventListeners"), _scope137["i"]), "cb"), _scope137["callback"], true)
			return null, func():
			var _scope139: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "roundEventListeners"), _scope137["i"]), "ctxt"), _scope137["context"], true)
			return null)):
			JS.invoke_method(JS.get_property(self, "roundEventListeners"), "splice", [_scope137["i"], 1])
			return null
		JS.increment(_scope137, "i", 1, true)
	return null

func original__gameModelEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope140: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3, "player": null}
	JS.invoke_method(JS.get_property(_scope140["self"], "log"), "debug", [JS.add(JS.add(JS.add(JS.add(_scope140["evt"], (JS.add(" ", _scope140["data"]) if JS.truthy(_scope140["data"]) else "")), " (game id "), _scope140["id"]), ")")])
	var _switch4 = _scope140["evt"]
	var _switch4_start = 10
	if JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYER_ADDED_QUEUE"), true): _switch4_start = 0
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYER_ADDED_ACTIVE"), true): _switch4_start = 1
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYER_REMOVED"), true): _switch4_start = 2
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYERS_ADDED_ACTIVE"), true): _switch4_start = 3
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYERS_ADDED_QUEUE"), true): _switch4_start = 4
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYERS_REMOVED"), true): _switch4_start = 5
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_STARTED"), true): _switch4_start = 6
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "COUNT_DOWN"), true): _switch4_start = 7
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_STATE_CHANGED"), true): _switch4_start = 8
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_ENDED"), true): _switch4_start = 9
	while true:
		if _switch4_start >= 0 and _switch4_start <= 0:
			_scope140["player"] = JS.invoke_method(JS.get_property(_scope140["self"], "model"), "getQueuedPlayer", [_scope140["data"]])
			if JS.truthy(_scope140["player"]):
				JS.invoke_method(_scope140["player"], "setTeam", [JS.invoke_method(JS.get_property(_scope140["self"], "gameMode"), "getTeam", [_scope140["data"]])])
			break
		if _switch4_start >= 0 and _switch4_start <= 1:
			_scope140["player"] = JS.invoke_method(JS.get_property(_scope140["self"], "model"), "getActivePlayer", [_scope140["data"]])
			if JS.truthy(_scope140["player"]):
				JS.invoke_method(_scope140["player"], "setTeam", [JS.invoke_method(JS.get_property(_scope140["self"], "gameMode"), "getTeam", [_scope140["data"]])])
			break
		if _switch4_start >= 0 and _switch4_start <= 9:
			break
		if _switch4_start >= 0 and _switch4_start <= 10:
			JS.invoke_method(JS.get_property(_scope140["self"], "log"), "error", [JS.add(JS.add("Unknown event ", _scope140["evt"]), " received in GameController._gameModelEventHandler")])
		break
	JS.invoke_method(JS.get_property(_scope140["self"], "gameMode"), "gameEventHandler", [JS.get_property(_scope140["self"], "gameMode"), _scope140["id"], _scope140["evt"], _scope140["data"]])
	return null

func original__roundModelEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope141: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3}
	JS.invoke_method(JS.get_property(_scope141["self"], "gameMode"), "roundEventHandler", [JS.get_property(_scope141["self"], "gameMode"), _scope141["id"], _scope141["evt"], _scope141["data"]])
	var _switch5 = _scope141["evt"]
	var _switch5_start = 54
	if JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_ENDED"), true): _switch5_start = 0
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_DESTROYED"), true): _switch5_start = 1
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_KILLED"), true): _switch5_start = 2
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "MAZE_SET"), true): _switch5_start = 3
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CREATED"), true): _switch5_start = 4
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CHANGED"), true): _switch5_start = 5
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CHICKENED_OUT"), true): _switch5_start = 6
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_CREATED"), true): _switch5_start = 7
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_DESTROYED"), true): _switch5_start = 8
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_TIMEOUT"), true): _switch5_start = 9
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_CREATED"), true): _switch5_start = 10
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_TRIPPED"), true): _switch5_start = 11
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_DESTROYED"), true): _switch5_start = 12
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COLLECTIBLE_CREATED"), true): _switch5_start = 13
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COLLECTIBLE_DESTROYED"), true): _switch5_start = 14
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "WEAPON_CREATED"), true): _switch5_start = 15
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "WEAPON_DESTROYED"), true): _switch5_start = 16
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_CREATED"), true): _switch5_start = 17
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_DESTROYED"), true): _switch5_start = 18
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COUNTER_CREATED"), true): _switch5_start = 19
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COUNTER_DESTROYED"), true): _switch5_start = 20
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ZONE_CREATED"), true): _switch5_start = 21
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ZONE_DESTROYED"), true): _switch5_start = 22
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_MAZE_COLLISION"), true): _switch5_start = 23
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_SHIELD_COLLISION"), true): _switch5_start = 24
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_ZONE_COLLISION"), true): _switch5_start = 25
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TANK_COLLISION"), true): _switch5_start = 26
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_MAZE_COLLISION"), true): _switch5_start = 27
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_COLLECTIBLE_COLLISION"), true): _switch5_start = 28
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_DEADLY_COLLISION"), true): _switch5_start = 29
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TRAP_COLLISION"), true): _switch5_start = 30
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TRAP_END_COLLISION"), true): _switch5_start = 31
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_SHIELD_COLLISION"), true): _switch5_start = 32
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_ZONE_COLLISION"), true): _switch5_start = 33
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "SHIELD_SHIELD_COLLISION"), true): _switch5_start = 34
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "SHIELD_ZONE_COLLISION"), true): _switch5_start = 35
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_ZONE_COLLISION"), true): _switch5_start = 36
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_CREATED"), true): _switch5_start = 37
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_STARTED"), true): _switch5_start = 38
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "CELEBRATION_STARTED"), true): _switch5_start = 39
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "CELEBRATION_ENDED"), true): _switch5_start = 40
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_FIRED"), true): _switch5_start = 41
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_DELAYED_FIRE"), true): _switch5_start = 42
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_EMPTY"), true): _switch5_start = 43
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "HOMING_MISSILE_TARGET_CHANGED"), true): _switch5_start = 44
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_ACTIVATED"), true): _switch5_start = 45
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_TRIPPED"), true): _switch5_start = 46
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_DETONATED"), true): _switch5_start = 47
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_ACTIVATED"), true): _switch5_start = 48
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_WEAKENED"), true): _switch5_start = 49
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_STRENGTHENED"), true): _switch5_start = 50
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Zone"), "_EVENTS"), "ZONE_ENTERED"), true): _switch5_start = 51
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Zone"), "_EVENTS"), "ZONE_LEFT"), true): _switch5_start = 52
	elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Zone"), "_EVENTS"), "ZONE_DESTABILIZED"), true): _switch5_start = 53
	while true:
		if _switch5_start >= 0 and _switch5_start <= 0:
			JS.invoke_method(JS.get_property(_scope141["self"], "model"), "emitGameState", [JS.invoke_method(_scope141["self"], "getGameState", [])])
			JS.invoke_method(JS.get_property(_scope141["self"], "log"), "debug", ["Round ended"])
			JS.invoke_method(JS.get_property(_scope141["self"], "model"), "setState", [JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS")])
			break
		if _switch5_start >= 0 and _switch5_start <= 2:
			JS.invoke_method(JS.get_property(_scope141["self"], "model"), "emitGameState", [JS.invoke_method(_scope141["self"], "getGameState", [])])
			break
		if _switch5_start >= 0 and _switch5_start <= 53:
			break
		if _switch5_start >= 0 and _switch5_start <= 54:
			JS.invoke_method(JS.get_property(_scope141["self"], "log"), "error", [JS.add(JS.add("Unknown event ", _scope141["evt"]), " received in GameController._roundModelEventHandler")])
		break
	return null

func original_getB2DWorld():
	var _scope142: Dictionary = {}
	if JS.truthy(JS.get_property(self, "roundController")):
		return JS.invoke_method(JS.get_property(self, "roundController"), "getB2DWorld", [])
	return null
