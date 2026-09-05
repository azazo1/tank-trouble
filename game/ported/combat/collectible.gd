# 由原版 Collectible 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var id = null
var type = 0
var x = 0
var y = 0
var rotation = 0
var b2dbody = null
var log = null
static var _static_Collectible: Dictionary = {}
static var _initialized_Collectible = false
static func initialize_original_static():
	if _initialized_Collectible: return
	_initialized_Collectible = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_Collectible.has(key): return _static_Collectible[key]
	return null
static func original_static_set(key, value):
	_static_Collectible[key] = value
	return value
func original_own_fields():
	return ["id","type","x","y","rotation","b2dbody","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"collectibleState": _arg0}
	JS.invoke_method(self, "setCollectibleState", [_scope0["collectibleState"]])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", [JS.add("Collectible ", JS.get_property(self, "id"))]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/combat/collectible.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_getId():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "id")
	return null

func original_getType():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "type")
	return null

func original_setX(_arg0 = null):
	var _scope3: Dictionary = {"x": _arg0}
	JS.set_property(self, "x", _scope3["x"])
	return null

func original_getX():
	var _scope4: Dictionary = {}
	return JS.get_property(self, "x")
	return null

func original_setY(_arg0 = null):
	var _scope5: Dictionary = {"y": _arg0}
	JS.set_property(self, "y", _scope5["y"])
	return null

func original_getY():
	var _scope6: Dictionary = {}
	return JS.get_property(self, "y")
	return null

func original_setRotation(_arg0 = null):
	var _scope7: Dictionary = {"rotation": _arg0}
	JS.set_property(self, "rotation", _scope7["rotation"])
	return null

func original_getRotation():
	var _scope8: Dictionary = {}
	return JS.get_property(self, "rotation")
	return null

func original_setB2DBody(_arg0 = null):
	var _scope9: Dictionary = {"b2dbody": _arg0}
	JS.set_property(self, "b2dbody", _scope9["b2dbody"])
	return null

func original_getB2DBody():
	var _scope10: Dictionary = {}
	return JS.get_property(self, "b2dbody")
	return null

func original_setCollectibleState(_arg0 = null):
	var _scope11: Dictionary = {"collectibleState": _arg0}
	JS.set_property(self, "id", JS.invoke_method(_scope11["collectibleState"], "getId", []))
	JS.set_property(self, "x", JS.invoke_method(_scope11["collectibleState"], "getX", []))
	JS.set_property(self, "y", JS.invoke_method(_scope11["collectibleState"], "getY", []))
	JS.set_property(self, "rotation", JS.invoke_method(_scope11["collectibleState"], "getRotation", []))
	JS.set_property(self, "type", JS.invoke_method(_scope11["collectibleState"], "getType", []))
	if JS.truthy(JS.get_property(self, "b2dbody")):
		JS.invoke_method(JS.get_property(self, "b2dbody"), "SetPositionAndAngle", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(self, "x"), JS.get_property(self, "y")]), JS.get_property(self, "rotation")])
	return null

func original_getCollectibleState():
	var _scope12: Dictionary = {"cs": null}
	_scope12["cs"] = JS.invoke_method(JS.module("CollectibleState"), "withState", [JS.get_property(self, "id"), JS.get_property(self, "type"), JS.get_property(self, "x"), JS.get_property(self, "y"), JS.get_property(self, "rotation")])
	return _scope12["cs"]
	return null

func original_update(_arg0 = null):
	var _scope13: Dictionary = {"deltaTime": _arg0}
	JS.set_property(self, "x", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "x"))
	JS.set_property(self, "y", JS.get_property(JS.invoke_method(JS.get_property(self, "b2dbody"), "GetPosition", []), "y"))
	JS.set_property(self, "rotation", JS.invoke_method(JS.get_property(self, "b2dbody"), "GetAngle", []))
	return null
