# 由原版 MazeMap 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var width = 0
var height = 0
var values = null
static var _static_MazeMap: Dictionary = {}
static var _initialized_MazeMap = false
static func initialize_original_static():
	if _initialized_MazeMap: return
	_initialized_MazeMap = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_MazeMap.has(key): return _static_MazeMap[key]
	return null
static func original_static_set(key, value):
	_static_MazeMap[key] = value
	return value
func original_own_fields():
	return ["width","height","values"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"width": _arg0, "height": _arg1, "initialValue": _arg2, "values": _arg3, "i": null, "j": null}
	JS.set_property(self, "width", _scope0["width"])
	JS.set_property(self, "height", _scope0["height"])
	JS.set_property(_scope0, "initialValue", (_scope0["initialValue"] if JS.truthy(not JS.equal(_scope0["initialValue"], null, true)) else 0))
	if JS.truthy(not JS.equal(_scope0["values"], null, true)):
		JS.set_property(self, "values", _scope0["values"])
	else:
		JS.set_property(self, "values", JS.construct("@Array", [JS.get_property(self, "width")]))
		_scope0["i"] = 0
		while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(self, "width"))):
			JS.set_property(JS.get_property(self, "values"), _scope0["i"], JS.construct("@Array", [JS.get_property(self, "height")]))
			_scope0["j"] = 0
			while JS.truthy(JS.compare("<", _scope0["j"], JS.get_property(self, "height"))):
				JS.set_property(JS.get_property(JS.get_property(self, "values"), _scope0["i"]), _scope0["j"], _scope0["initialValue"])
				JS.increment(_scope0, "j", 1, false)
			JS.increment(_scope0, "i", 1, false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/world/mazemap.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3)
	return instance

func original_clear(_arg0 = null):
	var _scope1: Dictionary = {"value": _arg0, "i": null, "j": null}
	_scope1["i"] = 0
	while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(self, "width"))):
		_scope1["j"] = 0
		while JS.truthy(JS.compare("<", _scope1["j"], JS.get_property(self, "height"))):
			JS.set_property(JS.get_property(JS.get_property(self, "values"), _scope1["i"]), _scope1["j"], _scope1["value"])
			JS.increment(_scope1, "j", 1, false)
		JS.increment(_scope1, "i", 1, false)
	return null

func original_get(_arg0 = null):
	var _scope2: Dictionary = {"position": _arg0}
	return JS.get_property(JS.get_property(JS.get_property(self, "values"), JS.get_property(_scope2["position"], "x")), JS.get_property(_scope2["position"], "y"))
	return null

func original_set(_arg0 = null, _arg1 = null):
	var _scope3: Dictionary = {"position": _arg0, "value": _arg1}
	JS.set_property(JS.get_property(JS.get_property(self, "values"), JS.get_property(_scope3["position"], "x")), JS.get_property(_scope3["position"], "y"), _scope3["value"])
	return null

func original_add(_arg0 = null, _arg1 = null):
	var _scope4: Dictionary = {"position": _arg0, "value": _arg1}
	JS.set_property(JS.get_property(JS.get_property(self, "values"), JS.get_property(_scope4["position"], "x")), JS.get_property(_scope4["position"], "y"), JS.add(JS.get_property(JS.get_property(JS.get_property(self, "values"), JS.get_property(_scope4["position"], "x")), JS.get_property(_scope4["position"], "y")), _scope4["value"]))
	return null

func original_data():
	var _scope5: Dictionary = {}
	return JS.get_property(self, "values")
	return null

func original_isPositionInsideMap(_arg0 = null):
	var _scope6: Dictionary = {"position": _arg0}
	return JS.logical("&&", func():
		var _scope7: Dictionary = {}
		return JS.logical("&&", func():
			var _scope8: Dictionary = {}
			return JS.logical("&&", func():
				var _scope9: Dictionary = {}
				return JS.compare(">=", JS.get_property(_scope6["position"], "x"), 0)
				return null, func():
				var _scope10: Dictionary = {}
				return JS.compare("<", JS.get_property(_scope6["position"], "x"), JS.get_property(self, "width"))
				return null)
			return null, func():
			var _scope11: Dictionary = {}
			return JS.compare(">=", JS.get_property(_scope6["position"], "y"), 0)
			return null)
		return null, func():
		var _scope12: Dictionary = {}
		return JS.compare("<", JS.get_property(_scope6["position"], "y"), JS.get_property(self, "height"))
		return null)
	return null
