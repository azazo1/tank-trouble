# 由原版 PhaserRandom 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var c = 0
var s0 = 0
var s1 = 0
var s2 = 0
static var _static_PhaserRandom: Dictionary = {}
static var _initialized_PhaserRandom = false
static func initialize_original_static():
	if _initialized_PhaserRandom: return
	_initialized_PhaserRandom = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_PhaserRandom.has(key): return _static_PhaserRandom[key]
	return null
static func original_static_set(key, value):
	_static_PhaserRandom[key] = value
	return value
func original_own_fields():
	return ["c","s0","s1","s2"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"t": _arg0}
	JS.sequence([JS.logical("&&", func():
		var _scope1: Dictionary = {}
		return JS.equal(null, _scope0["t"], true)
		return null, func():
		var _scope2: Dictionary = {}
		return JS.set_property(_scope0, "t", [])
		return null), JS.set_property(self, "c", 1), JS.set_property(self, "s0", 0), JS.set_property(self, "s1", 0), JS.set_property(self, "s2", 0), (JS.invoke_method(self, "state", [_scope0["t"]]) if JS.truthy(JS.equal("string", JS.type_of(_scope0["t"]), false)) else JS.invoke_method(self, "sow", [_scope0["t"]]))])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/engine/phaserrandom.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_sow(_arg0 = null):
	var _scope3: Dictionary = {"t": _arg0, "e": null, "i": null}
	if JS.truthy(JS.sequence([JS.set_property(self, "s0", JS.invoke_method(self, "hash", [" "])), JS.set_property(self, "s1", JS.invoke_method(self, "hash", [JS.get_property(self, "s0")])), JS.set_property(self, "s2", JS.invoke_method(self, "hash", [JS.get_property(self, "s1")])), JS.set_property(self, "c", 1), _scope3["t"]])):
		_scope3["e"] = 0
		while JS.truthy(JS.logical("&&", func():
			var _scope4: Dictionary = {}
			return JS.compare("<", _scope3["e"], JS.get_property(_scope3["t"], "length"))
			return null, func():
			var _scope5: Dictionary = {}
			return not JS.equal(null, JS.get_property(_scope3["t"], _scope3["e"]), false)
			return null)):
			_scope3["i"] = JS.get_property(_scope3["t"], _scope3["e"])
			JS.sequence([JS.set_property(self, "s0", (JS.number(JS.get_property(self, "s0")) - JS.number(JS.invoke_method(self, "hash", [_scope3["i"]])))), JS.set_property(self, "s0", JS.add(JS.get_property(self, "s0"), JS.bitwise("^", JS.bitwise("^", JS.compare("<", JS.get_property(self, "s0"), 0), -1), -1))), JS.set_property(self, "s1", (JS.number(JS.get_property(self, "s1")) - JS.number(JS.invoke_method(self, "hash", [_scope3["i"]])))), JS.set_property(self, "s1", JS.add(JS.get_property(self, "s1"), JS.bitwise("^", JS.bitwise("^", JS.compare("<", JS.get_property(self, "s1"), 0), -1), -1))), JS.set_property(self, "s2", (JS.number(JS.get_property(self, "s2")) - JS.number(JS.invoke_method(self, "hash", [_scope3["i"]])))), JS.set_property(self, "s2", JS.add(JS.get_property(self, "s2"), JS.bitwise("^", JS.bitwise("^", JS.compare("<", JS.get_property(self, "s2"), 0), -1), -1)))])
			JS.increment(_scope3, "e", 1, true)
	return null

func original_hash(_arg0 = null):
	var _scope6: Dictionary = {"t": _arg0, "e": null, "i": null, "s": null}
	JS.sequence([JS.set_property(_scope6, "s", 4022871197), JS.set_property(_scope6, "t", JS.invoke_method(_scope6["t"], "toString", [])), JS.set_property(_scope6, "i", 0)])
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["t"], "length"))):
		JS.sequence([JS.set_property(_scope6, "e", (JS.number(0.02519603282416938) * JS.number(JS.set_property(_scope6, "s", JS.add(_scope6["s"], JS.invoke_method(_scope6["t"], "charCodeAt", [_scope6["i"]])))))), JS.set_property(_scope6, "e", (JS.number(_scope6["e"]) - JS.number(JS.set_property(_scope6, "s", JS.bitwise(">>>", _scope6["e"], 0))))), JS.set_property(_scope6, "s", JS.bitwise(">>>", JS.set_property(_scope6, "e", (JS.number(_scope6["e"]) * JS.number(_scope6["s"]))), 0)), JS.set_property(_scope6, "s", JS.add(_scope6["s"], (JS.number(4294967296) * JS.number(JS.set_property(_scope6, "e", (JS.number(_scope6["e"]) - JS.number(_scope6["s"])))))))])
		JS.increment(_scope6, "i", 1, true)
	return (JS.number(2.3283064365386963e-10) * JS.number(JS.bitwise(">>>", _scope6["s"], 0)))
	return null

func original_rnd():
	var _scope7: Dictionary = {"t": null}
	_scope7["t"] = JS.add((JS.number(2091639) * JS.number(JS.get_property(self, "s0"))), (JS.number(2.3283064365386963e-10) * JS.number(JS.get_property(self, "c"))))
	return JS.sequence([JS.set_property(self, "c", JS.bitwise("|", 0, _scope7["t"])), JS.set_property(self, "s0", JS.get_property(self, "s1")), JS.set_property(self, "s1", JS.get_property(self, "s2")), JS.set_property(self, "s2", (JS.number(_scope7["t"]) - JS.number(JS.get_property(self, "c")))), JS.get_property(self, "s2")])
	return null

func original_frac():
	var _scope8: Dictionary = {}
	return JS.add(JS.invoke_method(JS.get_property(self, "rnd"), "apply", [self]), (JS.number(1.1102230246251565e-16) * JS.number(JS.bitwise("|", (JS.number(2097152) * JS.number(JS.invoke_method(JS.get_property(self, "rnd"), "apply", [self]))), 0))))
	return null

func original_integer():
	var _scope9: Dictionary = {}
	return (JS.number(4294967296) * JS.number(JS.invoke_method(JS.get_property(self, "rnd"), "apply", [self])))
	return null

func original_integerInRange(_arg0 = null, _arg1 = null):
	var _scope10: Dictionary = {"t": _arg0, "e": _arg1}
	return JS.invoke_method("@Math", "floor", [JS.add(JS.invoke_method(self, "realInRange", [0, JS.add((JS.number(_scope10["e"]) - JS.number(_scope10["t"])), 1)]), _scope10["t"])])
	return null

func original_realInRange(_arg0 = null, _arg1 = null):
	var _scope11: Dictionary = {"t": _arg0, "e": _arg1}
	return JS.add((JS.number(JS.invoke_method(self, "frac", [])) * JS.number((JS.number(_scope11["e"]) - JS.number(_scope11["t"])))), _scope11["t"])
	return null

func original_between(_arg0 = null, _arg1 = null):
	var _scope12: Dictionary = {"t": _arg0, "e": _arg1}
	return JS.invoke_method(self, "integerInRange", [_scope12["t"], _scope12["e"]])
	return null

func original_pick(_arg0 = null):
	var _scope13: Dictionary = {"t": _arg0}
	return JS.get_property(_scope13["t"], JS.invoke_method(self, "integerInRange", [0, (JS.number(JS.get_property(_scope13["t"], "length")) - JS.number(1))]))
	return null
