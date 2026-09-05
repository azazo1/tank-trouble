# 由原版 InputManager 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var playerId = null
var log = null
static var _static_InputManager: Dictionary = {}
static var _initialized_InputManager = false
static func initialize_original_static():
	if _initialized_InputManager: return
	_initialized_InputManager = true
	_static_InputManager["chatKey"] = JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "ENTER")
static func original_static_get(key):
	initialize_original_static()
	if _static_InputManager.has(key): return _static_InputManager[key]
	return null
static func original_static_set(key, value):
	_static_InputManager[key] = value
	return value
func original_own_fields():
	return ["playerId","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"playerId": _arg0}
	JS.set_property(self, "playerId", _scope0["playerId"])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["InputManager"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/input/inputmanager.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	return null

func original_getPlayerId():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "playerId")
	return null

func original_reset():
	var _scope3: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to call InputManager.reset. reset() must be overridden in subclasses"])
	return null

static func original_setChatKey(_arg0 = null):
	var _scope4: Dictionary = {"chatKey": _arg0}
	JS.set_property(JS.module("InputManager"), "chatKey", _scope4["chatKey"])
	return null
