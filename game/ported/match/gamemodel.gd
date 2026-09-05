# 由原版 GameModel 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var queuedPlayers = {}
var activePlayers = {}
var mode = null
var maxActivePlayerCount = 0
var theme = null
var scores = {}
var emblems = {}
var playerIdScoreIds = {}
var eventListeners = []
var addedActivePlayerIds = []
var addedQueuedPlayerIds = []
var removedPlayerIds = []
var state = null
var gameStarted = false
var log = null
static var _static_GameModel: Dictionary = {}
static var _initialized_GameModel = false
static func initialize_original_static():
	if _initialized_GameModel: return
	_initialized_GameModel = true
	_static_GameModel["_EVENTS"] = {"PLAYER_ADDED_ACTIVE": "player added to active", "PLAYER_ADDED_QUEUE": "player added to queue", "PLAYER_REMOVED": "player removed", "PLAYERS_ADDED_QUEUE": "players added to queue", "PLAYERS_ADDED_ACTIVE": "players added to active", "PLAYERS_REMOVED": "players removed", "GAME_STARTED": "game started", "COUNT_DOWN": "count down", "GAME_STATE_CHANGED": "game state changed", "GAME_ENDED": "game ended"}
	_static_GameModel["_STATES"] = {"BETWEEN_ROUNDS": "between rounds", "COUNTING_DOWN": "counting down", "IN_ROUND": "in round", "ENDED": "ended"}
static func original_static_get(key):
	initialize_original_static()
	if _static_GameModel.has(key): return _static_GameModel[key]
	return null
static func original_static_set(key, value):
	_static_GameModel[key] = value
	return value
func original_own_fields():
	return ["queuedPlayers","activePlayers","mode","maxActivePlayerCount","theme","scores","emblems","playerIdScoreIds","eventListeners","addedActivePlayerIds","addedQueuedPlayerIds","removedPlayerIds","state","gameStarted","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"controllerId": _arg0, "mode": _arg1, "maxActivePlayerCount": _arg2, "theme": _arg3}
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", [JS.add("GameModel ", _scope0["controllerId"])]))
	JS.set_property(self, "mode", _scope0["mode"])
	JS.set_property(self, "maxActivePlayerCount", _scope0["maxActivePlayerCount"])
	JS.set_property(self, "theme", _scope0["theme"])
	JS.set_property(self, "state", JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "BETWEEN_ROUNDS"))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/match/gamemodel.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3)
	return instance

func original_getGameState():
	var _scope1: Dictionary = {"gs": null, "playerStates": null, "queuedPlayerIds": null, "i": null, "queuedPlayerId": null, "queuedPlayer": null, "activePlayerIds": null, "activePlayerId": null, "activePlayer": null, "scoreStates": null, "scoreIds": null, "scoreId": null, "score": null, "emblemStates": null, "emblemIds": null, "emblemId": null, "emblem": null}
	_scope1["gs"] = JS.invoke_method(JS.module("GameState"), "create", [])
	_scope1["playerStates"] = []
	_scope1["queuedPlayerIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "queuedPlayers")])
	_scope1["i"] = 0
	while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(_scope1["queuedPlayerIds"], "length"))):
		_scope1["queuedPlayerId"] = JS.get_property(_scope1["queuedPlayerIds"], _scope1["i"])
		_scope1["queuedPlayer"] = JS.get_property(JS.get_property(self, "queuedPlayers"), _scope1["queuedPlayerId"])
		JS.invoke_method(_scope1["playerStates"], "push", [JS.invoke_method(_scope1["queuedPlayer"], "getPlayerState", [])])
		JS.increment(_scope1, "i", 1, true)
	_scope1["activePlayerIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "activePlayers")])
	_scope1["i"] = 0
	while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(_scope1["activePlayerIds"], "length"))):
		_scope1["activePlayerId"] = JS.get_property(_scope1["activePlayerIds"], _scope1["i"])
		_scope1["activePlayer"] = JS.get_property(JS.get_property(self, "activePlayers"), _scope1["activePlayerId"])
		JS.invoke_method(_scope1["playerStates"], "push", [JS.invoke_method(_scope1["activePlayer"], "getPlayerState", [])])
		JS.increment(_scope1, "i", 1, true)
	JS.invoke_method(_scope1["gs"], "setPlayerStates", [_scope1["playerStates"]])
	JS.invoke_method(_scope1["gs"], "setMode", [JS.get_property(self, "mode")])
	JS.invoke_method(_scope1["gs"], "setMaxActivePlayerCount", [JS.get_property(self, "maxActivePlayerCount")])
	JS.invoke_method(_scope1["gs"], "setTheme", [JS.get_property(self, "theme")])
	_scope1["scoreStates"] = []
	_scope1["scoreIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "scores")])
	_scope1["i"] = 0
	while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(_scope1["scoreIds"], "length"))):
		_scope1["scoreId"] = JS.get_property(_scope1["scoreIds"], _scope1["i"])
		_scope1["score"] = JS.get_property(JS.get_property(self, "scores"), _scope1["scoreId"])
		JS.invoke_method(_scope1["scoreStates"], "push", [JS.invoke_method(_scope1["score"], "getScoreState", [])])
		JS.increment(_scope1, "i", 1, true)
	JS.invoke_method(_scope1["gs"], "setScoreStates", [_scope1["scoreStates"]])
	_scope1["emblemStates"] = []
	_scope1["emblemIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "emblems")])
	_scope1["i"] = 0
	while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(_scope1["emblemIds"], "length"))):
		_scope1["emblemId"] = JS.get_property(_scope1["emblemIds"], _scope1["i"])
		_scope1["emblem"] = JS.get_property(JS.get_property(self, "emblems"), _scope1["emblemId"])
		JS.invoke_method(_scope1["emblemStates"], "push", [JS.invoke_method(_scope1["emblem"], "getEmblemState", [])])
		JS.increment(_scope1, "i", 1, true)
	JS.invoke_method(_scope1["gs"], "setEmblemStates", [_scope1["emblemStates"]])
	return _scope1["gs"]
	return null

func original_emitGameState(_arg0 = null):
	var _scope2: Dictionary = {"gameState": _arg0}
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_STATE_CHANGED"), _scope2["gameState"]])
	return null

func original_activatePlayer(_arg0 = null):
	var _scope3: Dictionary = {"playerId": _arg0, "playerTeam": null}
	if JS.truthy(JS.has_property(JS.get_property(self, "queuedPlayers"), _scope3["playerId"])):
		_scope3["playerTeam"] = JS.invoke_method(JS.get_property(JS.get_property(self, "queuedPlayers"), _scope3["playerId"]), "getTeam", [])
		JS.invoke_method(self, "_removePlayerFromQueue", [_scope3["playerId"], false])
		JS.invoke_method(self, "_addPlayerToActive", [_scope3["playerId"], _scope3["playerTeam"], true])
		return true
	else:
		return false
	return null

func original_setPlayerState(_arg0 = null):
	var _scope4: Dictionary = {"playerState": _arg0, "playerAlreadyQueued": null, "playerAlreadyActive": null, "playerTeam": null}
	_scope4["playerAlreadyQueued"] = JS.has_property(JS.get_property(self, "queuedPlayers"), JS.invoke_method(_scope4["playerState"], "getPlayerId", []))
	_scope4["playerAlreadyActive"] = JS.has_property(JS.get_property(self, "activePlayers"), JS.invoke_method(_scope4["playerState"], "getPlayerId", []))
	_scope4["playerTeam"] = JS.invoke_method(_scope4["playerState"], "getTeam", [])
	if JS.truthy(JS.logical("&&", func():
		var _scope5: Dictionary = {}
		return (not JS.truthy(_scope4["playerAlreadyQueued"]))
		return null, func():
		var _scope6: Dictionary = {}
		return (not JS.truthy(_scope4["playerAlreadyActive"]))
		return null)):
		JS.set_property(JS.get_property(self, "playerIdScoreIds"), JS.invoke_method(_scope4["playerState"], "getPlayerId", []), [])
		if JS.truthy(JS.invoke_method(_scope4["playerState"], "getQueued", [])):
			JS.invoke_method(self, "_addPlayerToQueue", [JS.invoke_method(_scope4["playerState"], "getPlayerId", []), _scope4["playerTeam"], true])
		else:
			JS.invoke_method(self, "_addPlayerToActive", [JS.invoke_method(_scope4["playerState"], "getPlayerId", []), _scope4["playerTeam"], true])
	else:
		if JS.truthy(_scope4["playerAlreadyQueued"]):
			if JS.truthy(JS.invoke_method(_scope4["playerState"], "getQueued", [])):
				pass
			else:
				JS.invoke_method(self, "_removePlayerFromQueue", [JS.invoke_method(_scope4["playerState"], "getPlayerId", []), false])
				JS.invoke_method(self, "_addPlayerToActive", [JS.invoke_method(_scope4["playerState"], "getPlayerId", []), _scope4["playerTeam"], true])
		else:
			if JS.truthy(_scope4["playerAlreadyActive"]):
				if JS.truthy(JS.invoke_method(_scope4["playerState"], "getQueued", [])):
					JS.invoke_method(self, "_removePlayerFromActive", [JS.invoke_method(_scope4["playerState"], "getPlayerId", []), false])
					JS.invoke_method(self, "_addPlayerToQueue", [JS.invoke_method(_scope4["playerState"], "getPlayerId", []), _scope4["playerTeam"], true])
				else:
					pass
	return null

func original_setMode(_arg0 = null):
	var _scope7: Dictionary = {"mode": _arg0}
	JS.set_property(self, "mode", _scope7["mode"])
	return null

func original_getMode():
	var _scope8: Dictionary = {}
	return JS.get_property(self, "mode")
	return null

func original_setMaxActivePlayerCount(_arg0 = null):
	var _scope9: Dictionary = {"maxActivePlayerCount": _arg0}
	JS.set_property(self, "maxActivePlayerCount", _scope9["maxActivePlayerCount"])
	return null

func original_getMaxActivePlayerCount():
	var _scope10: Dictionary = {}
	return JS.get_property(self, "maxActivePlayerCount")
	return null

func original_setTheme(_arg0 = null):
	var _scope11: Dictionary = {"theme": _arg0}
	JS.set_property(self, "theme", _scope11["theme"])
	return null

func original_getTheme():
	var _scope12: Dictionary = {}
	return JS.get_property(self, "theme")
	return null

func original_setScoreState(_arg0 = null):
	var _scope13: Dictionary = {"scoreState": _arg0, "score": null}
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "scores"), JS.invoke_method(_scope13["scoreState"], "getId", []))))):
		_scope13["score"] = JS.invoke_method(JS.module("Score"), "create", [_scope13["scoreState"]])
		JS.invoke_method(JS.get_property(JS.get_property(self, "playerIdScoreIds"), JS.invoke_method(_scope13["scoreState"], "getPlayerId", [])), "push", [JS.invoke_method(_scope13["score"], "getId", [])])
		JS.set_property(JS.get_property(self, "scores"), JS.invoke_method(_scope13["scoreState"], "getId", []), _scope13["score"])
	else:
		JS.invoke_method(JS.get_property(JS.get_property(self, "scores"), JS.invoke_method(_scope13["scoreState"], "getId", [])), "setScoreState", [_scope13["scoreState"]])
	return null

func original_setEmblemState(_arg0 = null):
	var _scope14: Dictionary = {"emblemState": _arg0, "emblem": null}
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "emblems"), JS.invoke_method(_scope14["emblemState"], "getId", []))))):
		_scope14["emblem"] = JS.invoke_method(JS.module("Emblem"), "create", [_scope14["emblemState"]])
		JS.set_property(JS.get_property(self, "emblems"), JS.invoke_method(_scope14["emblemState"], "getId", []), _scope14["emblem"])
	else:
		JS.invoke_method(JS.get_property(JS.get_property(self, "emblems"), JS.invoke_method(_scope14["emblemState"], "getId", [])), "setEmblemState", [_scope14["emblemState"]])
	return null

func original_addPlayer(_arg0 = null, _arg1 = null):
	var _scope15: Dictionary = {"playerId": _arg0, "playerTeam": _arg1}
	if JS.truthy(JS.logical("||", func():
		var _scope16: Dictionary = {}
		return JS.has_property(JS.get_property(self, "queuedPlayers"), _scope15["playerId"])
		return null, func():
		var _scope17: Dictionary = {}
		return JS.has_property(JS.get_property(self, "activePlayers"), _scope15["playerId"])
		return null)):
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to add player which was already in game. This should not happen!"])
		return false
	else:
		JS.set_property(JS.get_property(self, "playerIdScoreIds"), _scope15["playerId"], [])
		JS.invoke_method(self, "_addPlayerToQueue", [_scope15["playerId"], _scope15["playerTeam"], true])
		return true
	return null

func original_countDown(_arg0 = null):
	var _scope18: Dictionary = {"value": _arg0}
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "COUNT_DOWN"), _scope18["value"]])
	return null

func original_getNextQueuedPlayerId():
	var _scope19: Dictionary = {"queuedPlayerIds": null, "nextQueuedPlayerId": null, "lowestEnqueueTime": null, "i": null, "queuedPlayerId": null}
	_scope19["queuedPlayerIds"] = JS.invoke_method(self, "getQueuedPlayerIds", [])
	_scope19["nextQueuedPlayerId"] = null
	_scope19["lowestEnqueueTime"] = null
	_scope19["i"] = 0
	while JS.truthy(JS.compare("<", _scope19["i"], JS.get_property(_scope19["queuedPlayerIds"], "length"))):
		_scope19["queuedPlayerId"] = JS.get_property(_scope19["queuedPlayerIds"], _scope19["i"])
		if JS.truthy((not JS.truthy(_scope19["lowestEnqueueTime"]))):
			JS.set_property(_scope19, "lowestEnqueueTime", JS.invoke_method(JS.get_property(JS.get_property(self, "queuedPlayers"), _scope19["queuedPlayerId"]), "getEnqueueTime", []))
			JS.set_property(_scope19, "nextQueuedPlayerId", _scope19["queuedPlayerId"])
		else:
			if JS.truthy(JS.compare(">", _scope19["lowestEnqueueTime"], JS.invoke_method(JS.get_property(JS.get_property(self, "queuedPlayers"), _scope19["queuedPlayerId"]), "getEnqueueTime", []))):
				JS.set_property(_scope19, "lowestEnqueueTime", JS.invoke_method(JS.get_property(JS.get_property(self, "queuedPlayers"), _scope19["queuedPlayerId"]), "getEnqueueTime", []))
				JS.set_property(_scope19, "nextQueuedPlayerId", _scope19["queuedPlayerId"])
			else:
				pass
		JS.increment(_scope19, "i", 1, true)
	return _scope19["nextQueuedPlayerId"]
	return null

func original_removePlayer(_arg0 = null):
	var _scope20: Dictionary = {"playerId": _arg0, "i": null}
	JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add("Removing player ", _scope20["playerId"])])
	if JS.truthy(JS.has_property(JS.get_property(self, "queuedPlayers"), _scope20["playerId"])):
		JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add(JS.add("Removing player ", _scope20["playerId"]), " from queue")])
		_scope20["i"] = 0
		while JS.truthy(JS.compare("<", _scope20["i"], JS.get_property(JS.get_property(JS.get_property(self, "playerIdScoreIds"), _scope20["playerId"]), "length"))):
			JS.delete_property(JS.get_property(self, "scores"), JS.get_property(JS.get_property(JS.get_property(self, "playerIdScoreIds"), _scope20["playerId"]), _scope20["i"]))
			JS.increment(_scope20, "i", 1, false)
		JS.delete_property(JS.get_property(self, "playerIdScoreIds"), _scope20["playerId"])
		JS.invoke_method(self, "_removePlayerFromQueue", [_scope20["playerId"], true])
		return true
	if JS.truthy(JS.has_property(JS.get_property(self, "activePlayers"), _scope20["playerId"])):
		JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add(JS.add("Removing player ", _scope20["playerId"]), " from list of active players")])
		_scope20["i"] = 0
		while JS.truthy(JS.compare("<", _scope20["i"], JS.get_property(JS.get_property(JS.get_property(self, "playerIdScoreIds"), _scope20["playerId"]), "length"))):
			JS.delete_property(JS.get_property(self, "scores"), JS.get_property(JS.get_property(JS.get_property(self, "playerIdScoreIds"), _scope20["playerId"]), _scope20["i"]))
			JS.increment(_scope20, "i", 1, false)
		JS.delete_property(JS.get_property(self, "playerIdScoreIds"), _scope20["playerId"])
		JS.invoke_method(self, "_removePlayerFromActive", [_scope20["playerId"], true])
		return true
	JS.invoke_method(JS.get_property(self, "log"), "warn", ["Failed to remove player ", _scope20["playerId"], " from game. Player does not appear to be in the game."])
	return false
	return null

func original_removeScore(_arg0 = null):
	var _scope21: Dictionary = {"scoreId": _arg0, "score": null, "scoreIds": null, "i": null}
	_scope21["score"] = JS.get_property(JS.get_property(self, "scores"), _scope21["scoreId"])
	if JS.truthy(_scope21["score"]):
		JS.delete_property(JS.get_property(self, "scores"), _scope21["scoreId"])
		_scope21["scoreIds"] = JS.get_property(JS.get_property(self, "playerIdScoreIds"), JS.invoke_method(_scope21["score"], "getPlayerId", []))
		_scope21["i"] = 0
		while JS.truthy(JS.compare("<", _scope21["i"], JS.get_property(_scope21["scoreIds"], "length"))):
			if JS.truthy(JS.equal(JS.get_property(_scope21["scoreIds"], _scope21["i"]), _scope21["scoreId"], true)):
				JS.invoke_method(_scope21["scoreIds"], "splice", [_scope21["i"], 1])
				break
			JS.increment(_scope21, "i", 1, false)
	return null

func original_removeEmblem(_arg0 = null):
	var _scope22: Dictionary = {"emblemId": _arg0, "emblem": null}
	_scope22["emblem"] = JS.get_property(JS.get_property(self, "emblems"), _scope22["emblemId"])
	if JS.truthy(_scope22["emblem"]):
		JS.delete_property(JS.get_property(self, "emblems"), _scope22["emblemId"])
	return null

func original_getTotalPlayerCount():
	var _scope23: Dictionary = {}
	return JS.add(JS.invoke_method(self, "getQueuedPlayerCount", []), JS.invoke_method(self, "getActivePlayerCount", []))
	return null

func original_getQueuedPlayerCount():
	var _scope24: Dictionary = {}
	return JS.get_property(JS.invoke_method("@Object", "keys", [JS.get_property(self, "queuedPlayers")]), "length")
	return null

func original_getActivePlayerCount():
	var _scope25: Dictionary = {}
	return JS.get_property(JS.invoke_method("@Object", "keys", [JS.get_property(self, "activePlayers")]), "length")
	return null

func original_getQueuedPlayer(_arg0 = null):
	var _scope26: Dictionary = {"playerId": _arg0}
	return JS.get_property(JS.get_property(self, "queuedPlayers"), _scope26["playerId"])
	return null

func original_getActivePlayer(_arg0 = null):
	var _scope27: Dictionary = {"playerId": _arg0}
	return JS.get_property(JS.get_property(self, "activePlayers"), _scope27["playerId"])
	return null

func original_getActivePlayers():
	var _scope28: Dictionary = {}
	return JS.get_property(self, "activePlayers")
	return null

func original_isPlayerActive(_arg0 = null):
	var _scope29: Dictionary = {"playerId": _arg0}
	return JS.has_property(JS.get_property(self, "activePlayers"), _scope29["playerId"])
	return null

func original_getActivePlayerIds():
	var _scope30: Dictionary = {}
	return JS.invoke_method("@Object", "keys", [JS.get_property(self, "activePlayers")])
	return null

func original_getQueuedPlayerIds():
	var _scope31: Dictionary = {}
	return JS.invoke_method("@Object", "keys", [JS.get_property(self, "queuedPlayers")])
	return null

func original_getAllPlayerIds():
	var _scope32: Dictionary = {}
	return JS.invoke_method(JS.invoke_method("@Object", "keys", [JS.get_property(self, "activePlayers")]), "concat", [JS.invoke_method("@Object", "keys", [JS.get_property(self, "queuedPlayers")])])
	return null

func original_getScores():
	var _scope33: Dictionary = {}
	return JS.get_property(self, "scores")
	return null

func original_getScore(_arg0 = null):
	var _scope34: Dictionary = {"scoreId": _arg0}
	return JS.get_property(JS.get_property(self, "scores"), _scope34["scoreId"])
	return null

func original_getScoreByPlayerIdAndType(_arg0 = null, _arg1 = null):
	var _scope35: Dictionary = {"playerId": _arg0, "type": _arg1, "score": null}
	for _iteration0 in JS.keys(JS.get_property(self, "scores")):
		JS.set_property(JS.global_fields, "scoreId", _iteration0)
		_scope35["score"] = JS.get_property(JS.get_property(self, "scores"), JS.get_property(JS.global_fields, "scoreId"))
		if JS.truthy(JS.logical("&&", func():
			var _scope36: Dictionary = {}
			return JS.equal(JS.invoke_method(_scope35["score"], "getPlayerId", []), _scope35["playerId"], true)
			return null, func():
			var _scope37: Dictionary = {}
			return JS.equal(JS.invoke_method(_scope35["score"], "getType", []), _scope35["type"], true)
			return null)):
			return _scope35["score"]
	return null
	return null

func original_getEmblems():
	var _scope38: Dictionary = {}
	return JS.get_property(self, "emblems")
	return null

func original_getEmblem(_arg0 = null):
	var _scope39: Dictionary = {"emblemId": _arg0}
	return JS.get_property(JS.get_property(self, "emblems"), _scope39["emblemId"])
	return null

func original_getEmblemByPlayerIdAndType(_arg0 = null, _arg1 = null):
	var _scope40: Dictionary = {"playerId": _arg0, "type": _arg1, "emblem": null}
	for _iteration1 in JS.keys(JS.get_property(self, "emblems")):
		JS.set_property(JS.global_fields, "emblemId", _iteration1)
		_scope40["emblem"] = JS.get_property(JS.get_property(self, "emblems"), JS.get_property(JS.global_fields, "emblemId"))
		if JS.truthy(JS.logical("&&", func():
			var _scope41: Dictionary = {}
			return JS.equal(JS.invoke_method(_scope40["emblem"], "getPlayerId", []), _scope40["playerId"], true)
			return null, func():
			var _scope42: Dictionary = {}
			return JS.equal(JS.invoke_method(_scope40["emblem"], "getType", []), _scope40["type"], true)
			return null)):
			return _scope40["emblem"]
	return null
	return null

func original_getState():
	var _scope43: Dictionary = {}
	return JS.get_property(self, "state")
	return null

func original_setState(_arg0 = null):
	var _scope44: Dictionary = {"state": _arg0}
	JS.set_property(self, "state", _scope44["state"])
	if JS.truthy(JS.equal(JS.get_property(self, "state"), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "ENDED"), true)):
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_ENDED")])
	else:
		if JS.truthy(JS.logical("&&", func():
			var _scope45: Dictionary = {}
			return JS.equal(JS.get_property(self, "state"), JS.get_property(JS.get_property(JS.module("GameModel"), "_STATES"), "COUNTING_DOWN"), false)
			return null, func():
			var _scope46: Dictionary = {}
			return (not JS.truthy(JS.get_property(self, "gameStarted")))
			return null)):
			JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_STARTED")])
			JS.set_property(self, "gameStarted", true)
	return null

func original__addPlayerToQueue(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope47: Dictionary = {"playerId": _arg0, "playerTeam": _arg1, "emitEvent": _arg2, "player": null}
	_scope47["player"] = JS.invoke_method(JS.module("Player"), "create", [_scope47["playerId"], true, JS.construct("@Date", []), _scope47["playerTeam"]])
	JS.set_property(JS.get_property(self, "queuedPlayers"), _scope47["playerId"], _scope47["player"])
	if JS.truthy(_scope47["emitEvent"]):
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYER_ADDED_QUEUE"), _scope47["playerId"]])
		JS.invoke_method(JS.get_property(self, "addedQueuedPlayerIds"), "push", [_scope47["playerId"]])
	return null

func original__removePlayerFromQueue(_arg0 = null, _arg1 = null):
	var _scope48: Dictionary = {"playerId": _arg0, "emitEvent": _arg1}
	JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add(JS.add("Removing queued player ", _scope48["playerId"]), " from game")])
	JS.delete_property(JS.get_property(self, "queuedPlayers"), _scope48["playerId"])
	if JS.truthy(_scope48["emitEvent"]):
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYER_REMOVED"), _scope48["playerId"]])
		JS.invoke_method(JS.get_property(self, "removedPlayerIds"), "push", [_scope48["playerId"]])
	return null

func original__addPlayerToActive(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope49: Dictionary = {"playerId": _arg0, "playerTeam": _arg1, "emitEvent": _arg2, "player": null}
	_scope49["player"] = JS.invoke_method(JS.module("Player"), "create", [_scope49["playerId"], false, JS.construct("@Date", []), _scope49["playerTeam"]])
	JS.set_property(JS.get_property(self, "activePlayers"), _scope49["playerId"], _scope49["player"])
	if JS.truthy(_scope49["emitEvent"]):
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYER_ADDED_ACTIVE"), _scope49["playerId"]])
		JS.invoke_method(JS.get_property(self, "addedActivePlayerIds"), "push", [_scope49["playerId"]])
	return null

func original__removePlayerFromActive(_arg0 = null, _arg1 = null):
	var _scope50: Dictionary = {"playerId": _arg0, "emitEvent": _arg1}
	JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add(JS.add("Removing active player ", _scope50["playerId"]), " from game")])
	JS.delete_property(JS.get_property(self, "activePlayers"), _scope50["playerId"])
	if JS.truthy(_scope50["emitEvent"]):
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYER_REMOVED"), _scope50["playerId"]])
		JS.invoke_method(JS.get_property(self, "removedPlayerIds"), "push", [_scope50["playerId"]])
	return null

func original_addEventListener(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope51: Dictionary = {"callback": _arg0, "context": _arg1, "gameId": _arg2}
	JS.invoke_method(JS.get_property(self, "eventListeners"), "push", [{"cb": _scope51["callback"], "ctxt": _scope51["context"], "gameId": _scope51["gameId"]}])
	return null

func original_removeEventListener(_arg0 = null, _arg1 = null):
	var _scope52: Dictionary = {"callback": _arg0, "context": _arg1, "i": null}
	_scope52["i"] = 0
	while JS.truthy(JS.compare("<", _scope52["i"], JS.get_property(JS.get_property(self, "eventListeners"), "length"))):
		if JS.truthy(JS.logical("&&", func():
			var _scope53: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "eventListeners"), _scope52["i"]), "cb"), _scope52["callback"], true)
			return null, func():
			var _scope54: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "eventListeners"), _scope52["i"]), "ctxt"), _scope52["context"], true)
			return null)):
			JS.invoke_method(JS.get_property(self, "eventListeners"), "splice", [_scope52["i"], 1])
			return null
		JS.increment(_scope52, "i", 1, true)
	return null

func original__notifyEventListeners(_arg0 = null, _arg1 = null):
	var _scope55: Dictionary = {"evt": _arg0, "data": _arg1, "i": null}
	_scope55["i"] = 0
	while JS.truthy(JS.compare("<", _scope55["i"], JS.get_property(JS.get_property(self, "eventListeners"), "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "eventListeners"), _scope55["i"]), "cb", [JS.get_property(JS.get_property(JS.get_property(self, "eventListeners"), _scope55["i"]), "ctxt"), JS.get_property(JS.get_property(JS.get_property(self, "eventListeners"), _scope55["i"]), "gameId"), _scope55["evt"], _scope55["data"]])
		JS.increment(_scope55, "i", 1, true)
	return null

func original_update(_arg0 = null):
	var _scope56: Dictionary = {"gameStateChanged": null}
	_scope56["gameStateChanged"] = false
	if JS.truthy(JS.compare(">", JS.get_property(JS.get_property(self, "addedQueuedPlayerIds"), "length"), 0)):
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYERS_ADDED_QUEUE"), JS.get_property(self, "addedQueuedPlayerIds")])
		JS.set_property(_scope56, "gameStateChanged", true)
		JS.set_property(self, "addedQueuedPlayerIds", [])
	if JS.truthy(JS.compare(">", JS.get_property(JS.get_property(self, "addedActivePlayerIds"), "length"), 0)):
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYERS_ADDED_ACTIVE"), JS.get_property(self, "addedActivePlayerIds")])
		JS.set_property(_scope56, "gameStateChanged", true)
		JS.set_property(self, "addedActivePlayerIds", [])
	if JS.truthy(JS.compare(">", JS.get_property(JS.get_property(self, "removedPlayerIds"), "length"), 0)):
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "PLAYERS_REMOVED"), JS.get_property(self, "removedPlayerIds")])
		JS.set_property(_scope56, "gameStateChanged", true)
		JS.set_property(self, "removedPlayerIds", [])
	if JS.truthy(_scope56["gameStateChanged"]):
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_STATE_CHANGED"), JS.invoke_method(self, "getGameState", [])])
	return null
