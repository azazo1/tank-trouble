# 由原版 Player 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var id = null
var queued = false
var enqueueTime = null
var team = 0
static var _static_Player: Dictionary = {}
static var _initialized_Player = false
static func initialize_original_static():
	if _initialized_Player: return
	_initialized_Player = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Player.has(key): return _static_Player[key]
	return null
static func original_static_set(key, value):
	_static_Player[key] = value
	return value
func original_own_fields():
	return ["id","queued","enqueueTime","team"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"id": _arg0, "queued": _arg1, "enqueueTime": _arg2, "team": _arg3}
	JS.set_property(self, "id", _scope0["id"])
	JS.set_property(self, "queued", _scope0["queued"])
	JS.set_property(self, "enqueueTime", _scope0["enqueueTime"])
	JS.set_property(self, "team", _scope0["team"])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/match/player.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3)
	return instance

func original_setPlayerState(_arg0 = null):
	var _scope1: Dictionary = {"playerState": _arg0}
	JS.set_property(self, "id", JS.invoke_method(_scope1["playerState"], "getPlayerId", []))
	JS.set_property(self, "queued", JS.invoke_method(_scope1["playerState"], "getQueued", []))
	JS.set_property(self, "enqueueTime", JS.invoke_method(_scope1["playerState"], "getEnqueueTime", []))
	JS.set_property(self, "team", JS.invoke_method(_scope1["playerState"], "getTeam", []))
	return null

func original_getPlayerState():
	var _scope2: Dictionary = {"ps": null}
	_scope2["ps"] = JS.invoke_method(JS.module("PlayerState"), "withState", [JS.get_property(self, "id"), JS.get_property(self, "queued"), JS.get_property(self, "enqueueTime"), JS.get_property(self, "team")])
	return _scope2["ps"]
	return null

func original_getId():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "id")
	return null

func original_getEnqueueTime():
	var _scope4: Dictionary = {}
	return JS.get_property(self, "enqueueTime")
	return null

func original_getTeam(_arg0 = null):
	var _scope5: Dictionary = {}
	return JS.get_property(self, "team")
	return null

func original_setTeam(_arg0 = null):
	var _scope6: Dictionary = {"team": _arg0}
	JS.set_property(self, "team", _scope6["team"])
	return null
