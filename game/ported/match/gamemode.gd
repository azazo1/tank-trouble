# 由原版 GameMode 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var mode = null
var ranked = false
var symmetric = false
var storm = false
var crateTypes = []
var gameController = null
var roundController = null
var log = null
static var _static_GameMode: Dictionary = {}
static var _initialized_GameMode = false
static func initialize_original_static():
	if _initialized_GameMode: return
	_initialized_GameMode = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_GameMode.has(key): return _static_GameMode[key]
	return null
static func original_static_set(key, value):
	_static_GameMode[key] = value
	return value
func original_own_fields():
	return ["mode","ranked","symmetric","storm","crateTypes","gameController","roundController","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {}
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["GameMode"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/match/gamemode.gd").new()
	instance._construct_create()
	return instance

func original_getMode():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "mode")
	return null

func original_setRanked(_arg0 = null):
	var _scope2: Dictionary = {"ranked": _arg0}
	JS.set_property(self, "ranked", _scope2["ranked"])
	return null

func original_setSymmetric(_arg0 = null):
	var _scope3: Dictionary = {"symmetric": _arg0}
	JS.set_property(self, "symmetric", _scope3["symmetric"])
	return null

func original_setStorm(_arg0 = null):
	var _scope4: Dictionary = {"storm": _arg0}
	JS.set_property(self, "storm", _scope4["storm"])
	return null

func original_setCrateTypes(_arg0 = null):
	var _scope5: Dictionary = {"crateTypes": _arg0}
	JS.set_property(self, "crateTypes", _scope5["crateTypes"])
	return null

func original_setGameController(_arg0 = null):
	var _scope6: Dictionary = {"gameController": _arg0}
	JS.set_property(self, "gameController", _scope6["gameController"])
	return null

func original_setRoundController(_arg0 = null):
	var _scope7: Dictionary = {"roundController": _arg0}
	JS.set_property(self, "roundController", _scope7["roundController"])
	return null

func original_computeJoinPriority(_arg0 = null):
	var _scope8: Dictionary = {"numPlayersJoining": _arg0, "priority": null}
	_scope8["priority"] = 0
	if JS.truthy(JS.compare("<", JS.invoke_method(JS.get_property(self, "gameController"), "getTotalPlayerCount", []), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GAME_MODE_INFO"), JS.get_property(self, "mode")), "MIN_PLAYERS"))):
		if JS.truthy(JS.compare(">=", JS.add(JS.invoke_method(JS.get_property(self, "gameController"), "getTotalPlayerCount", []), _scope8["numPlayersJoining"]), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GAME_MODE_INFO"), JS.get_property(self, "mode")), "MIN_PLAYERS"))):
			JS.set_property(_scope8, "priority", JS.add(_scope8["priority"], JS.get_property(JS.module("Constants"), "JOIN_PRIORITY_START_GAME_WEIGHT")))
			JS.set_property(_scope8, "priority", JS.add(_scope8["priority"], JS.invoke_method(JS.get_property(self, "gameController"), "getBetweenRoundsDuration", [])))
	JS.set_property(_scope8, "priority", JS.add(_scope8["priority"], JS.add(JS.invoke_method(JS.get_property(self, "gameController"), "getTotalPlayerCount", []), _scope8["numPlayersJoining"])))
	return _scope8["priority"]
	return null

func original_canRemovePlayer(_arg0 = null):
	var _scope9: Dictionary = {"playerId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.canRemovePlayer. canRemovePlayer() must be overridden in subclasses"])
	return null

func original_getScoreStates(_arg0 = null):
	var _scope10: Dictionary = {"playerId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getScoreStates. getScoreStates() must be overridden in subclasses"])
	return null

func original_initializeRound():
	var _scope11: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.initializeRound. initializeRound() must be overridden in subclasses"])
	return null

func original_getTeam(_arg0 = null):
	var _scope12: Dictionary = {"playerId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getTeam. getTeam() must be overridden in subclasses"])
	return null

func original_getMaze(_arg0 = null, _arg1 = null):
	var _scope13: Dictionary = {"playerIds": _arg0, "theme": _arg1}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getMaze. getMaze() must be overridden in subclasses"])
	return null

func original_getInitialWeaponState(_arg0 = null):
	var _scope14: Dictionary = {"playerId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getInitialWeaponState. getInitialWeaponState() must be overridden in subclasses"])
	return null

func original_getInitialUpgradeState(_arg0 = null):
	var _scope15: Dictionary = {"playerId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getInitialUpgradeState. getInitialUpgradeState() must be overridden in subclasses"])
	return null

func original_getRespawnWeaponState(_arg0 = null):
	var _scope16: Dictionary = {"playerId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getRespawnWeaponState. getRespawnWeaponState() must be overridden in subclasses"])
	return null

func original_getRespawnUpgradeState(_arg0 = null):
	var _scope17: Dictionary = {"playerId": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getRespawnUpgradeState. getRespawnUpgradeState() must be overridden in subclasses"])
	return null

func original_update(_arg0 = null):
	var _scope18: Dictionary = {"deltaTime": _arg0}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.update. update() must be overridden in subclasses"])
	return null

func original_isRoundOver():
	var _scope19: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.isRoundOver. isRoundOver() must be overridden in subclasses"])
	return null

func original_getWinnerPlayerIds():
	var _scope20: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getWinnerPlayerIds. getWinnerPlayerIds() must be overridden in subclasses"])
	return null

func original_getVictoryExperience():
	var _scope21: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getVictoryExperience. getVictoryExperience() must be overridden in subclasses"])
	return null

func original_getKillExperience():
	var _scope22: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getKillExperience. getKillExperience() must be overridden in subclasses"])
	return null

func original_getVictoryGoldAmount():
	var _scope23: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call GameMode.getVictoryGoldAmount. getVictoryGoldAmount() must be overridden in subclasses"])
	return null

func original_gameEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope24: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3}
	return null

func original_roundEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope25: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3}
	return null
