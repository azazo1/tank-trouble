# 由原版 AIManager 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var aiId = null
var gameController = null
var ai = null
var storedStates = {}
static var _static_AIManager: Dictionary = {}
static var _initialized_AIManager = false
static func initialize_original_static():
	if _initialized_AIManager: return
	_initialized_AIManager = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_AIManager.has(key): return _static_AIManager[key]
	return null
static func original_static_set(key, value):
	_static_AIManager[key] = value
	return value
func original_own_fields():
	return ["aiId","gameController","ai","storedStates"]
func original_is_weak_field(key):
	return ["gameController"].has(key) or super.original_is_weak_field(key)

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"aiId": _arg0, "config": _arg1, "gameController": _arg2}
	JS.set_property(self, "aiId", _scope0["aiId"])
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.set_property(self, "ai", JS.invoke_method(JS.module("AI"), "create", [_scope0["aiId"], _scope0["config"], _scope0["gameController"]]))
	JS.invoke_method(self, "reset", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/ai/aimanager.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_getAIId():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "aiId")
	return null

func original_getGameId():
	var _scope2: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "gameController"), "getId", [])
	return null

func original_update(_arg0 = null):
	var _scope3: Dictionary = {"deltaTime": _arg0, "newInputState": null, "stateChanged": null}
	JS.invoke_method(JS.get_property(self, "ai"), "update", [_scope3["deltaTime"]])
	_scope3["newInputState"] = JS.invoke_method(JS.get_property(self, "ai"), "getInputState", [])
	_scope3["stateChanged"] = false
	JS.set_property(_scope3, "stateChanged", JS.bitwise("|", _scope3["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "forward"), JS.invoke_method(_scope3["newInputState"], "getForward", []), true)))
	JS.set_property(_scope3, "stateChanged", JS.bitwise("|", _scope3["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "back"), JS.invoke_method(_scope3["newInputState"], "getBack", []), true)))
	JS.set_property(_scope3, "stateChanged", JS.bitwise("|", _scope3["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "left"), JS.invoke_method(_scope3["newInputState"], "getLeft", []), true)))
	JS.set_property(_scope3, "stateChanged", JS.bitwise("|", _scope3["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "right"), JS.invoke_method(_scope3["newInputState"], "getRight", []), true)))
	JS.set_property(_scope3, "stateChanged", JS.bitwise("|", _scope3["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "fire"), JS.invoke_method(_scope3["newInputState"], "getFire", []), true)))
	if JS.truthy(_scope3["stateChanged"]):
		JS.invoke_method(JS.get_property(self, "gameController"), "setInputState", [_scope3["newInputState"]])
	JS.set_property(JS.get_property(self, "storedStates"), "forward", JS.invoke_method(_scope3["newInputState"], "getForward", []))
	JS.set_property(JS.get_property(self, "storedStates"), "back", JS.invoke_method(_scope3["newInputState"], "getBack", []))
	JS.set_property(JS.get_property(self, "storedStates"), "left", JS.invoke_method(_scope3["newInputState"], "getLeft", []))
	JS.set_property(JS.get_property(self, "storedStates"), "right", JS.invoke_method(_scope3["newInputState"], "getRight", []))
	JS.set_property(JS.get_property(self, "storedStates"), "fire", JS.invoke_method(_scope3["newInputState"], "getFire", []))
	return null

func original_shutdown():
	var _scope4: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "ai"), "shutdown", [])
	return null

func original_reset():
	var _scope5: Dictionary = {}
	JS.set_property(JS.get_property(self, "storedStates"), "forward", false)
	JS.set_property(JS.get_property(self, "storedStates"), "back", false)
	JS.set_property(JS.get_property(self, "storedStates"), "left", false)
	JS.set_property(JS.get_property(self, "storedStates"), "right", false)
	JS.set_property(JS.get_property(self, "storedStates"), "fire", false)
	return null
