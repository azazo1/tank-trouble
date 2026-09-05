# 由原版 ArrayUtils 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_ArrayUtils: Dictionary = {}
static var _initialized_ArrayUtils = false
static func initialize_original_static():
	if _initialized_ArrayUtils: return
	_initialized_ArrayUtils = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_ArrayUtils.has(key): return _static_ArrayUtils[key]
	return null
static func original_static_set(key, value):
	_static_ArrayUtils[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/world/arrayutils.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

static func original_shuffle(_arg0 = null):
	var _scope0: Dictionary = {"array": _arg0, "currentIndex": null, "temporaryValue": null, "randomIndex": null}
	_scope0["currentIndex"] = JS.get_property(_scope0["array"], "length")
	while JS.truthy(not JS.equal(0, _scope0["currentIndex"], true)):
		JS.set_property(_scope0, "randomIndex", JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(_scope0["currentIndex"]))]))
		JS.set_property(_scope0, "currentIndex", (JS.number(_scope0["currentIndex"]) - JS.number(1)))
		JS.set_property(_scope0, "temporaryValue", JS.get_property(_scope0["array"], _scope0["currentIndex"]))
		JS.set_property(_scope0["array"], _scope0["currentIndex"], JS.get_property(_scope0["array"], _scope0["randomIndex"]))
		JS.set_property(_scope0["array"], _scope0["randomIndex"], _scope0["temporaryValue"])
	return _scope0["array"]
	return null

static func original_unique(_arg0 = null):
	var _scope1: Dictionary = {"array": _arg0, "seen": null, "filtered": null, "i": null}
	_scope1["seen"] = {}
	_scope1["filtered"] = JS.invoke_method(_scope1["array"], "filter", [func(_arg0 = null):
		var _scope2: Dictionary = {"item": _arg0}
		return (false if JS.truthy(JS.invoke_method(_scope1["seen"], "hasOwnProperty", [_scope2["item"]])) else JS.set_property(_scope1["seen"], _scope2["item"], true))
		return null])
	JS.set_property(_scope1["array"], "length", 0)
	for _iteration0 in JS.keys(_scope1["filtered"]):
		JS.set_property(_scope1, "i", _iteration0)
		JS.invoke_method(_scope1["array"], "push", [JS.get_property(_scope1["filtered"], _scope1["i"])])
	return _scope1["array"]
	return null

static func original_indexOf(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope3: Dictionary = {"array": _arg0, "item": _arg1, "comparisonFn": _arg2, "i": null}
	_scope3["i"] = 0
	while JS.truthy(JS.compare("<", _scope3["i"], JS.get_property(_scope3["array"], "length"))):
		if JS.truthy(JS.invoke(_scope3["comparisonFn"], [JS.get_property(_scope3["array"], _scope3["i"]), _scope3["item"]])):
			return _scope3["i"]
		JS.increment(_scope3, "i", 1, false)
	return -(1)
	return null

static func original_containsDuplicates(_arg0 = null):
	var _scope4: Dictionary = {"array": _arg0}
	return not JS.equal(JS.get_property(JS.construct("@Set", [_scope4["array"]]), "size"), JS.get_property(_scope4["array"], "length"), false)
	return null

static func original_containsSome(_arg0 = null, _arg1 = null):
	var _scope5: Dictionary = {"firstArray": _arg0, "secondArray": _arg1}
	return JS.invoke_method(_scope5["secondArray"], "some", [func(_arg0 = null):
		var _scope6: Dictionary = {"value": _arg0}
		return JS.compare(">=", JS.invoke_method(_scope5["firstArray"], "indexOf", [_scope6["value"]]), 0)
		return null])
	return null

static func original_containsAll(_arg0 = null, _arg1 = null):
	var _scope7: Dictionary = {"firstArray": _arg0, "secondArray": _arg1}
	return JS.invoke_method(_scope7["secondArray"], "every", [func(_arg0 = null):
		var _scope8: Dictionary = {"value": _arg0}
		return JS.compare(">=", JS.invoke_method(_scope7["firstArray"], "indexOf", [_scope8["value"]]), 0)
		return null])
	return null

static func original_containsSame(_arg0 = null, _arg1 = null):
	var _scope9: Dictionary = {"firstArray": _arg0, "secondArray": _arg1}
	return JS.logical("&&", func():
		var _scope10: Dictionary = {}
		return JS.invoke_method(JS.module("ArrayUtils"), "containsAll", [_scope9["firstArray"], _scope9["secondArray"]])
		return null, func():
		var _scope11: Dictionary = {}
		return JS.invoke_method(JS.module("ArrayUtils"), "containsAll", [_scope9["secondArray"], _scope9["firstArray"]])
		return null)
	return null
