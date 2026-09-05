# 由原版 UIDustParticle 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/particles/particle.gd"

static var _static_UIDustParticle: Dictionary = {}
static var _initialized_UIDustParticle = false
static func initialize_original_static():
	if _initialized_UIDustParticle: return
	_initialized_UIDustParticle = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIDustParticle.has(key): return _static_UIDustParticle[key]
	return JS.get_property(JS.module("Phaser.Particle"), key)
static func original_static_set(key, value):
	_static_UIDustParticle[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "x": _arg1, "y": _arg2, "key": _arg3, "frame": _arg4}
	super._construct_create(_scope0["game"], _scope0["x"], _scope0["y"], _scope0["key"], _scope0["frame"])
	JS.set_property(self, "fadeSpeed", (JS.number(0.018) - JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(0.009)))))
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uidustparticle.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4)
	return instance

func original_onEmit():
	var _scope1: Dictionary = {}
	JS.set_property(JS.get_property(self, "body"), "x", JS.add(JS.get_property(JS.get_property(self, "body"), "x"), (JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "x")) * JS.number(JS.add((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(6)), 1)))) / JS.number(15))))
	JS.set_property(JS.get_property(self, "body"), "y", JS.add(JS.get_property(JS.get_property(self, "body"), "y"), (JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "y")) * JS.number(JS.add((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(6)), 1)))) / JS.number(15))))
	return null

func original_update():
	var _scope2: Dictionary = {}
	JS.set_property(self, "alpha", (JS.number(JS.get_property(self, "alpha")) - JS.number(JS.get_property(self, "fadeSpeed"))))
	JS.set_property(JS.get_property(self, "scale"), "x", JS.add(JS.get_property(JS.get_property(self, "scale"), "x"), 0.0083))
	JS.set_property(JS.get_property(self, "scale"), "y", JS.add(JS.get_property(JS.get_property(self, "scale"), "y"), 0.0083))
	return null

func original_retire():
	var _scope3: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
