# 由原版 GameState 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var data = {"playerStates": [], "mode": null, "maxActivePlayerCount": 0, "theme": null, "ranked": false, "symmetric": false, "storm": false, "premium": false, "scoreStates": [], "emblemStates": [], "id": null}
static var _static_GameState: Dictionary = {}
static var _initialized_GameState = false
static func initialize_original_static():
	if _initialized_GameState: return
	_initialized_GameState = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_GameState.has(key): return _static_GameState[key]
	return null
static func original_static_set(key, value):
	_static_GameState[key] = value
	return value
func original_own_fields():
	return ["data"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {}
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/states/gamestate.gd").new()
	instance._construct_create()
	return instance

func _construct_withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var _scope1: Dictionary = {"playerStates": _arg0, "mode": _arg1, "maxActivePlayerCount": _arg2, "theme": _arg3, "ranked": _arg4, "symmetric": _arg5, "storm": _arg6, "premium": _arg7, "scoreStates": _arg8, "emblemStates": _arg9, "id": _arg10}
	JS.set_property(JS.get_property(self, "data"), "playerStates", _scope1["playerStates"])
	JS.set_property(JS.get_property(self, "data"), "mode", _scope1["mode"])
	JS.set_property(JS.get_property(self, "data"), "maxActivePlayerCount", _scope1["maxActivePlayerCount"])
	JS.set_property(JS.get_property(self, "data"), "theme", _scope1["theme"])
	JS.set_property(JS.get_property(self, "data"), "ranked", _scope1["ranked"])
	JS.set_property(JS.get_property(self, "data"), "symmetric", _scope1["symmetric"])
	JS.set_property(JS.get_property(self, "data"), "storm", _scope1["storm"])
	JS.set_property(JS.get_property(self, "data"), "premium", _scope1["premium"])
	JS.set_property(JS.get_property(self, "data"), "scoreStates", _scope1["scoreStates"])
	JS.set_property(JS.get_property(self, "data"), "emblemStates", _scope1["emblemStates"])
	JS.set_property(JS.get_property(self, "data"), "id", _scope1["id"])
	return null
static func withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var instance = load("res://game/ported/states/gamestate.gd").new()
	instance._construct_withState(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10)
	return instance

func _construct_withObject(_arg0 = null):
	var _scope2: Dictionary = {"obj": _arg0}
	JS.set_property(self, "data", _scope2["obj"])
	return null
static func withObject(_arg0 = null):
	var instance = load("res://game/ported/states/gamestate.gd").new()
	instance._construct_withObject(_arg0)
	return instance

func original_setPlayerStates(_arg0 = null):
	var _scope3: Dictionary = {"playerStates": _arg0, "i": null}
	JS.set_property(JS.get_property(self, "data"), "playerStates", [])
	_scope3["i"] = 0
	while JS.truthy(JS.compare("<", _scope3["i"], JS.get_property(_scope3["playerStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "playerStates"), "push", [JS.invoke_method(JS.get_property(_scope3["playerStates"], _scope3["i"]), "toObj", [])])
		JS.increment(_scope3, "i", 1, false)
	return null

func original_getPlayerStates():
	var _scope4: Dictionary = {"playerStates": null, "i": null}
	_scope4["playerStates"] = []
	_scope4["i"] = 0
	while JS.truthy(JS.compare("<", _scope4["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "playerStates"), "length"))):
		JS.invoke_method(_scope4["playerStates"], "push", [JS.invoke_method(JS.module("PlayerState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "playerStates"), _scope4["i"])])])
		JS.increment(_scope4, "i", 1, false)
	return _scope4["playerStates"]
	return null

func original_setMode(_arg0 = null):
	var _scope5: Dictionary = {"mode": _arg0}
	JS.set_property(JS.get_property(self, "data"), "mode", _scope5["mode"])
	return null

func original_getMode():
	var _scope6: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "mode")
	return null

func original_setMaxActivePlayerCount(_arg0 = null):
	var _scope7: Dictionary = {"maxActivePlayerCount": _arg0}
	JS.set_property(JS.get_property(self, "data"), "maxActivePlayerCount", _scope7["maxActivePlayerCount"])
	return null

func original_getMaxActivePlayerCount():
	var _scope8: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "maxActivePlayerCount")
	return null

func original_setTheme(_arg0 = null):
	var _scope9: Dictionary = {"theme": _arg0}
	JS.set_property(JS.get_property(self, "data"), "theme", _scope9["theme"])
	return null

func original_getTheme():
	var _scope10: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "theme")
	return null

func original_setRanked(_arg0 = null):
	var _scope11: Dictionary = {"ranked": _arg0}
	JS.set_property(JS.get_property(self, "data"), "ranked", _scope11["ranked"])
	return null

func original_getRanked():
	var _scope12: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "ranked")
	return null

func original_setSymmetric(_arg0 = null):
	var _scope13: Dictionary = {"symmetric": _arg0}
	JS.set_property(JS.get_property(self, "data"), "symmetric", _scope13["symmetric"])
	return null

func original_getSymmetric():
	var _scope14: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "symmetric")
	return null

func original_setStorm(_arg0 = null):
	var _scope15: Dictionary = {"storm": _arg0}
	JS.set_property(JS.get_property(self, "data"), "storm", _scope15["storm"])
	return null

func original_getStorm():
	var _scope16: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "storm")
	return null

func original_setPremium(_arg0 = null):
	var _scope17: Dictionary = {"premium": _arg0}
	JS.set_property(JS.get_property(self, "data"), "premium", _scope17["premium"])
	return null

func original_getPremium():
	var _scope18: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "premium")
	return null

func original_setScoreStates(_arg0 = null):
	var _scope19: Dictionary = {"scoreStates": _arg0, "i": null}
	JS.set_property(JS.get_property(self, "data"), "scoreStates", [])
	_scope19["i"] = 0
	while JS.truthy(JS.compare("<", _scope19["i"], JS.get_property(_scope19["scoreStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "scoreStates"), "push", [JS.invoke_method(JS.get_property(_scope19["scoreStates"], _scope19["i"]), "toObj", [])])
		JS.increment(_scope19, "i", 1, false)
	return null

func original_getScoreStates(_arg0 = null):
	var _scope20: Dictionary = {"scoreStates": null, "i": null}
	_scope20["scoreStates"] = []
	_scope20["i"] = 0
	while JS.truthy(JS.compare("<", _scope20["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "scoreStates"), "length"))):
		JS.invoke_method(_scope20["scoreStates"], "push", [JS.invoke_method(JS.module("ScoreState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "scoreStates"), _scope20["i"])])])
		JS.increment(_scope20, "i", 1, false)
	return _scope20["scoreStates"]
	return null

func original_setEmblemStates(_arg0 = null):
	var _scope21: Dictionary = {"emblemStates": _arg0, "i": null}
	JS.set_property(JS.get_property(self, "data"), "emblemStates", [])
	_scope21["i"] = 0
	while JS.truthy(JS.compare("<", _scope21["i"], JS.get_property(_scope21["emblemStates"], "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "emblemStates"), "push", [JS.invoke_method(JS.get_property(_scope21["emblemStates"], _scope21["i"]), "toObj", [])])
		JS.increment(_scope21, "i", 1, false)
	return null

func original_getEmblemStates():
	var _scope22: Dictionary = {"emblemStates": null, "i": null}
	_scope22["emblemStates"] = []
	_scope22["i"] = 0
	while JS.truthy(JS.compare("<", _scope22["i"], JS.get_property(JS.get_property(JS.get_property(self, "data"), "emblemStates"), "length"))):
		JS.invoke_method(_scope22["emblemStates"], "push", [JS.invoke_method(JS.module("EmblemState"), "withObject", [JS.get_property(JS.get_property(JS.get_property(self, "data"), "emblemStates"), _scope22["i"])])])
		JS.increment(_scope22, "i", 1, false)
	return _scope22["emblemStates"]
	return null

func original_setId(_arg0 = null):
	var _scope23: Dictionary = {"id": _arg0}
	JS.set_property(JS.get_property(self, "data"), "id", _scope23["id"])
	return null

func original_getId():
	var _scope24: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "id")
	return null

func original_toObj():
	var _scope25: Dictionary = {}
	return JS.get_property(self, "data")
	return null
