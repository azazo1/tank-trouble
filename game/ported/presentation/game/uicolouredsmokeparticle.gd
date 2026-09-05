# 由原版 UIColouredSmokeParticle 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/particles/particle.gd"

static var _static_UIColouredSmokeParticle: Dictionary = {}
static var _initialized_UIColouredSmokeParticle = false
static func initialize_original_static():
	if _initialized_UIColouredSmokeParticle: return
	_initialized_UIColouredSmokeParticle = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIColouredSmokeParticle.has(key): return _static_UIColouredSmokeParticle[key]
	return JS.get_property(JS.module("Phaser.Particle"), key)
static func original_static_set(key, value):
	_static_UIColouredSmokeParticle[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "x": _arg1, "y": _arg2, "key": _arg3, "frame": _arg4}
	super._construct_create(_scope0["game"], _scope0["x"], _scope0["y"], _scope0["key"], _scope0["frame"])
	JS.set_property(self, "fadeSpeed", (JS.number(0.025) - JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(0.0166)))))
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uicolouredsmokeparticle.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4)
	return instance

func original_setColour(_arg0 = null):
	var _scope1: Dictionary = {"colour": _arg0}
	JS.set_property(self, "colour", _scope1["colour"])
	return null

func original_onEmit():
	var _scope2: Dictionary = {}
	JS.set_property(self, "tint", (JS.get_property(self, "colour") if JS.truthy(not JS.equal(JS.get_property(self, "colour"), null, true)) else JS.get_property(JS.get_property(self, "parent"), "smokeColour")))
	JS.set_property(JS.get_property(self, "body"), "x", JS.add(JS.get_property(JS.get_property(self, "body"), "x"), (JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "x")) * JS.number(JS.add((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(6)), 1)))) / JS.number(15))))
	JS.set_property(JS.get_property(self, "body"), "y", JS.add(JS.get_property(JS.get_property(self, "body"), "y"), (JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "y")) * JS.number(JS.add((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(6)), 1)))) / JS.number(15))))
	JS.set_property(self, "realAlpha", JS.get_property(self, "alpha"))
	JS.set_property(self, "fadeInAlpha", 0.1)
	return null

func original_update():
	var _scope3: Dictionary = {}
	JS.set_property(self, "realAlpha", (JS.number(JS.get_property(self, "realAlpha")) - JS.number(JS.get_property(self, "fadeSpeed"))))
	JS.set_property(self, "fadeInAlpha", JS.add(JS.get_property(self, "fadeInAlpha"), 0.1))
	JS.set_property(self, "alpha", JS.invoke_method("@Math", "min", [JS.get_property(self, "fadeInAlpha"), JS.get_property(self, "realAlpha")]))
	JS.set_property(JS.get_property(self, "scale"), "x", JS.add(JS.get_property(JS.get_property(self, "scale"), "x"), 0.014))
	JS.set_property(JS.get_property(self, "scale"), "y", JS.add(JS.get_property(JS.get_property(self, "scale"), "y"), 0.014))
	return null

func original_retire():
	var _scope4: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
