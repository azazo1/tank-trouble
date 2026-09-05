# 由原版 UpgradeState 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var data = {}
static var _static_UpgradeState: Dictionary = {}
static var _initialized_UpgradeState = false
static func initialize_original_static():
	if _initialized_UpgradeState: return
	_initialized_UpgradeState = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UpgradeState.has(key): return _static_UpgradeState[key]
	return null
static func original_static_set(key, value):
	_static_UpgradeState[key] = value
	return value
func original_own_fields():
	return ["data"]

func _construct_withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var _scope0: Dictionary = {"id": _arg0, "playerId": _arg1, "type": _arg2, "fieldsJSON": _arg3}
	JS.set_property(JS.get_property(self, "data"), "id", _scope0["id"])
	JS.set_property(JS.get_property(self, "data"), "playerId", _scope0["playerId"])
	JS.set_property(JS.get_property(self, "data"), "type", _scope0["type"])
	JS.set_property(JS.get_property(self, "data"), "fieldsJSON", _scope0["fieldsJSON"])
	return null
static func withState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null):
	var instance = load("res://game/ported/states/upgradestate.gd").new()
	instance._construct_withState(_arg0, _arg1, _arg2, _arg3)
	return instance

func _construct_withObject(_arg0 = null):
	var _scope1: Dictionary = {"obj": _arg0}
	JS.set_property(self, "data", _scope1["obj"])
	return null
static func withObject(_arg0 = null):
	var instance = load("res://game/ported/states/upgradestate.gd").new()
	instance._construct_withObject(_arg0)
	return instance

func original_getId():
	var _scope2: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "id")
	return null

func original_getPlayerId():
	var _scope3: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "playerId")
	return null

func original_getType():
	var _scope4: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "type")
	return null

func original_getFields():
	var _scope5: Dictionary = {}
	return JS.invoke_method("@JSON", "parse", [JS.get_property(JS.get_property(self, "data"), "fieldsJSON")])
	return null

func original_toObj():
	var _scope6: Dictionary = {}
	return JS.get_property(self, "data")
	return null
