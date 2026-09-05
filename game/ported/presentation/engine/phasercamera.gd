# 由原版 PhaserCamera 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_PhaserCamera: Dictionary = {}
static var _initialized_PhaserCamera = false
static func initialize_original_static():
	if _initialized_PhaserCamera: return
	_initialized_PhaserCamera = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_PhaserCamera.has(key): return _static_PhaserCamera[key]
	return null
static func original_static_set(key, value):
	_static_PhaserCamera[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {}
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/engine/phasercamera.gd").new()
	instance._construct_create()
	return instance

func original_checkBounds():
	var _scope1: Dictionary = {"t": null, "e": null, "i": null, "s": null}
	JS.sequence([JS.set_property(JS.get_property(self, "atLimit"), "x", (not JS.truthy(1))), JS.set_property(JS.get_property(self, "atLimit"), "y", (not JS.truthy(1)))])
	_scope1["t"] = JS.add(JS.get_property(JS.get_property(self, "view"), "x"), JS.get_property(JS.get_property(self, "_shake"), "x"))
	_scope1["e"] = JS.add(JS.get_property(JS.get_property(self, "view"), "right"), JS.get_property(JS.get_property(self, "_shake"), "x"))
	_scope1["i"] = JS.add(JS.get_property(JS.get_property(self, "view"), "y"), JS.get_property(JS.get_property(self, "_shake"), "y"))
	_scope1["s"] = JS.add(JS.get_property(JS.get_property(self, "view"), "bottom"), JS.get_property(JS.get_property(self, "_shake"), "y"))
	JS.sequence([(JS.sequence([JS.set_property(JS.get_property(self, "atLimit"), "x", (not JS.truthy(0))), JS.set_property(JS.get_property(self, "view"), "x", (JS.number(JS.get_property(JS.get_property(self, "bounds"), "x")) * JS.number(JS.get_property(JS.get_property(self, "scale"), "x")))), JS.logical("||", func():
		var _scope2: Dictionary = {}
		return JS.get_property(JS.get_property(self, "_shake"), "shakeBounds")
		return null, func():
		var _scope3: Dictionary = {}
		return JS.set_property(JS.get_property(self, "_shake"), "x", 0)
		return null)]) if JS.truthy(JS.compare("<=", _scope1["t"], (JS.number(JS.get_property(JS.get_property(self, "bounds"), "x")) * JS.number(JS.get_property(JS.get_property(self, "scale"), "x"))))) else JS.logical("&&", func():
		var _scope4: Dictionary = {}
		return JS.compare(">=", _scope1["e"], (JS.number(JS.get_property(JS.get_property(self, "bounds"), "right")) * JS.number(JS.get_property(JS.get_property(self, "scale"), "x"))))
		return null, func():
		var _scope5: Dictionary = {}
		return JS.sequence([JS.set_property(JS.get_property(self, "atLimit"), "x", (not JS.truthy(0))), JS.set_property(JS.get_property(self, "view"), "x", (JS.number((JS.number(JS.get_property(JS.get_property(self, "bounds"), "right")) * JS.number(JS.get_property(JS.get_property(self, "scale"), "x")))) - JS.number(JS.get_property(self, "width")))), JS.logical("||", func():
			var _scope6: Dictionary = {}
			return JS.get_property(JS.get_property(self, "_shake"), "shakeBounds")
			return null, func():
			var _scope7: Dictionary = {}
			return JS.set_property(JS.get_property(self, "_shake"), "x", 0)
			return null)])
		return null)), (JS.sequence([JS.set_property(JS.get_property(self, "atLimit"), "y", (not JS.truthy(0))), JS.set_property(JS.get_property(self, "view"), "y", (JS.number(JS.get_property(JS.get_property(self, "bounds"), "top")) * JS.number(JS.get_property(JS.get_property(self, "scale"), "y")))), JS.logical("||", func():
		var _scope8: Dictionary = {}
		return JS.get_property(JS.get_property(self, "_shake"), "shakeBounds")
		return null, func():
		var _scope9: Dictionary = {}
		return JS.set_property(JS.get_property(self, "_shake"), "y", 0)
		return null)]) if JS.truthy(JS.compare("<=", _scope1["i"], (JS.number(JS.get_property(JS.get_property(self, "bounds"), "top")) * JS.number(JS.get_property(JS.get_property(self, "scale"), "y"))))) else JS.logical("&&", func():
		var _scope10: Dictionary = {}
		return JS.compare(">=", _scope1["s"], (JS.number(JS.get_property(JS.get_property(self, "bounds"), "bottom")) * JS.number(JS.get_property(JS.get_property(self, "scale"), "y"))))
		return null, func():
		var _scope11: Dictionary = {}
		return JS.sequence([JS.set_property(JS.get_property(self, "atLimit"), "y", (not JS.truthy(0))), JS.set_property(JS.get_property(self, "view"), "y", (JS.number((JS.number(JS.get_property(JS.get_property(self, "bounds"), "bottom")) * JS.number(JS.get_property(JS.get_property(self, "scale"), "y")))) - JS.number(JS.get_property(self, "height")))), JS.logical("||", func():
			var _scope12: Dictionary = {}
			return JS.get_property(JS.get_property(self, "_shake"), "shakeBounds")
			return null, func():
			var _scope13: Dictionary = {}
			return JS.set_property(JS.get_property(self, "_shake"), "y", 0)
			return null)])
		return null))])
	return null

func original_update():
	var _scope14: Dictionary = {}
	JS.sequence([JS.logical("&&", func():
		var _scope15: Dictionary = {}
		return JS.compare("<", 0, JS.get_property(self, "_fxDuration"))
		return null, func():
		var _scope16: Dictionary = {}
		return JS.invoke_method(self, "updateFX", [])
		return null), JS.logical("&&", func():
		var _scope17: Dictionary = {}
		return JS.compare("<", 0, JS.get_property(JS.get_property(self, "_shake"), "duration"))
		return null, func():
		var _scope18: Dictionary = {}
		return JS.invoke_method(self, "updateShake", [])
		return null), JS.logical("&&", func():
		var _scope19: Dictionary = {}
		return JS.get_property(self, "bounds")
		return null, func():
		var _scope20: Dictionary = {}
		return JS.invoke_method(self, "checkBounds", [])
		return null), JS.logical("&&", func():
		var _scope21: Dictionary = {}
		return JS.get_property(self, "roundPx")
		return null, func():
		var _scope22: Dictionary = {}
		return JS.sequence([JS.invoke_method(JS.get_property(self, "view"), "floor", []), JS.set_property(JS.get_property(self, "_shake"), "x", JS.invoke_method("@Math", "floor", [JS.get_property(JS.get_property(self, "_shake"), "x")])), JS.set_property(JS.get_property(self, "_shake"), "y", JS.invoke_method("@Math", "floor", [JS.get_property(JS.get_property(self, "_shake"), "y")]))])
		return null), JS.set_property(JS.get_property(JS.get_property(self, "displayObject"), "position"), "x", -(JS.get_property(JS.get_property(self, "view"), "x"))), JS.set_property(JS.get_property(JS.get_property(self, "displayObject"), "position"), "y", -(JS.get_property(JS.get_property(self, "view"), "y")))])
	return null
