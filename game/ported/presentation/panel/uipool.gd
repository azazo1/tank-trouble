# 由原版 UIPool 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var items = []
static var _static_UIPool: Dictionary = {}
static var _initialized_UIPool = false
static func initialize_original_static():
	if _initialized_UIPool: return
	_initialized_UIPool = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIPool.has(key): return _static_UIPool[key]
	return null
static func original_static_set(key, value):
	_static_UIPool[key] = value
	return value
func original_own_fields():
	return ["items"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/panel/uipool.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

func original_add(_arg0 = null):
	var _scope0: Dictionary = {"item": _arg0}
	JS.invoke_method(JS.get_property(self, "items"), "push", [_scope0["item"]])
	return null

func original_getFirstExists(_arg0 = null):
	var _scope1: Dictionary = {"exists": _arg0, "i": null}
	_scope1["i"] = 0
	while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(JS.get_property(self, "items"), "length"))):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "items"), _scope1["i"]), "exists"), _scope1["exists"], true)):
			return JS.get_property(JS.get_property(self, "items"), _scope1["i"])
		JS.increment(_scope1, "i", 1, true)
	return null
	return null
