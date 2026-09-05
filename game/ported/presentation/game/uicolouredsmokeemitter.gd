# 由原版 UIColouredSmokeEmitter 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/presentation/engine/phaseremitter.gd"

static var _static_UIColouredSmokeEmitter: Dictionary = {}
static var _initialized_UIColouredSmokeEmitter = false
static func initialize_original_static():
	if _initialized_UIColouredSmokeEmitter: return
	_initialized_UIColouredSmokeEmitter = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIColouredSmokeEmitter.has(key): return _static_UIColouredSmokeEmitter[key]
	return JS.get_property(JS.module("Phaser.Particles.Arcade.Emitter"), key)
static func original_static_set(key, value):
	_static_UIColouredSmokeEmitter[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "targetSprite": _arg1, "colour": _arg2, "i": null}
	super._construct_create(_scope0["game"], 0, 0, 45)
	JS.set_property(self, "targetSprite", _scope0["targetSprite"])
	JS.set_property(self, "particleClass", JS.module("UIColouredSmokeParticle"))
	JS.invoke_method(self, "makeParticles", ["game", ["steam0", "steam1", "steam2"]])
	JS.invoke_method(JS.get_property(self, "minParticleSpeed"), "setTo", [-(40), -(40)])
	JS.invoke_method(JS.get_property(self, "maxParticleSpeed"), "setTo", [40, 40])
	JS.invoke_method(JS.get_property(self, "particleDrag"), "setTo", [50, 50])
	JS.invoke_method(self, "setAlpha", [0.85, 1])
	JS.invoke_method(self, "setRotation", [0, 0])
	JS.set_property(self, "minParticleScale", (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number(0.66)))
	JS.set_property(self, "maxParticleScale", (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number(1)))
	JS.set_property(self, "gravity", 0)
	JS.set_property(self, "smokeColour", _scope0["colour"])
	_scope0["i"] = 0
	JS.invoke_method(self, "forEach", [func(_arg0 = null):
		var _scope1: Dictionary = {"particle": _arg0}
		if JS.truthy(JS.equal(fmod(JS.increment(_scope0, "i", 1, true), 3), 0, false)):
			JS.invoke_method(_scope1["particle"], "setColour", [_scope0["colour"]])
		return null])
	JS.invoke_method(self, "kill", [])
	JS.set_property(self, "visible", false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uicolouredsmokeemitter.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_setSmokeColour(_arg0 = null):
	var _scope2: Dictionary = {"colour": _arg0}
	JS.set_property(self, "smokeColour", _scope2["colour"])
	return null

func original_preUpdate():
	var _scope3: Dictionary = {}
	if JS.truthy(JS.logical("||", func():
		var _scope4: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope5: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return false
	return super.original_preUpdate()
	return null

func original_update():
	var _scope6: Dictionary = {}
	if JS.truthy(JS.logical("||", func():
		var _scope7: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope8: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return null
	super.original_update()
	JS.set_property(self, "x", JS.get_property(JS.get_property(self, "targetSprite"), "x"))
	JS.set_property(self, "y", JS.get_property(JS.get_property(self, "targetSprite"), "y"))
	if JS.truthy(JS.logical("&&", func():
		var _scope9: Dictionary = {}
		return JS.get_property(self, "on")
		return null, func():
		var _scope10: Dictionary = {}
		return (not JS.truthy(JS.get_property(JS.get_property(self, "targetSprite"), "exists")))
		return null)):
		JS.set_property(self, "on", false)
	else:
		if JS.truthy(JS.logical("&&", func():
			var _scope11: Dictionary = {}
			return JS.logical("&&", func():
				var _scope12: Dictionary = {}
				return JS.get_property(self, "on")
				return null, func():
				var _scope13: Dictionary = {}
				return JS.get_property(JS.get_property(self, "targetSprite"), "exists")
				return null)
			return null, func():
			var _scope14: Dictionary = {}
			return JS.compare("<", JS.get_property(JS.get_property(self, "targetSprite"), "alpha"), 1)
			return null)):
			JS.invoke_method(self, "setAlpha", [(JS.number(0.85) * JS.number(JS.get_property(JS.get_property(self, "targetSprite"), "alpha"))), (JS.number(1) * JS.number(JS.get_property(JS.get_property(self, "targetSprite"), "alpha")))])
	if JS.truthy(JS.equal(JS.invoke_method(self, "countLiving", []), 0, false)):
		JS.invoke_method(self, "kill", [])
		JS.set_property(self, "visible", false)
	return null

func original_postUpdate():
	var _scope15: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope16: Dictionary = {"x": _arg0, "y": _arg1, "frequency": _arg2, "colour": _arg3}
	JS.set_property(self, "smokeColour", _scope16["colour"])
	JS.invoke_method(self, "revive", [])
	JS.set_property(self, "visible", true)
	JS.set_property(self, "x", _scope16["x"])
	JS.set_property(self, "y", _scope16["y"])
	JS.invoke_method(self, "setAlpha", [0.85, 1])
	JS.invoke_method(self, "explode", [2000, 1])
	JS.invoke_method(self, "start", [false, 2000, _scope16["frequency"], 0, false])
	return null

func original_retire():
	var _scope17: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	JS.set_property(self, "visible", false)
	JS.invoke_method(self, "callAll", ["retire"])
	return null
