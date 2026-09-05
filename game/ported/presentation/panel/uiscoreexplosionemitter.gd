# 由原版 UIScoreExplosionEmitter 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/presentation/engine/phaseremitter.gd"

static var _static_UIScoreExplosionEmitter: Dictionary = {}
static var _initialized_UIScoreExplosionEmitter = false
static func initialize_original_static():
	if _initialized_UIScoreExplosionEmitter: return
	_initialized_UIScoreExplosionEmitter = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIScoreExplosionEmitter.has(key): return _static_UIScoreExplosionEmitter[key]
	return JS.get_property(JS.module("Phaser.Particles.Arcade.Emitter"), key)
static func original_static_set(key, value):
	_static_UIScoreExplosionEmitter[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0}
	super._construct_create(_scope0["game"], 0, 0, 60)
	JS.set_property(self, "particleClass", JS.module("UIScoreExplosionParticle"))
	JS.invoke_method(self, "makeParticles", ["playerpanel", ["smoke0", "smoke1", "smoke2"]])
	JS.invoke_method(JS.get_property(self, "minParticleSpeed"), "setTo", [JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MIN_X_SPEED"), JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MIN_Y_SPEED")])
	JS.invoke_method(JS.get_property(self, "maxParticleSpeed"), "setTo", [JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MAX_X_SPEED"), JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MAX_Y_SPEED")])
	JS.invoke_method(JS.get_property(self, "particleDrag"), "setTo", [JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_DRAG"), JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_DRAG")])
	JS.invoke_method(self, "setAlpha", [0.8, 1])
	JS.invoke_method(self, "setRotation", [-(100), 100])
	JS.set_property(self, "minParticleScale", 0.7)
	JS.set_property(self, "maxParticleScale", 1)
	JS.set_property(self, "gravity", 0)
	JS.invoke_method(self, "kill", [])
	JS.set_property(self, "visible", false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/panel/uiscoreexplosionemitter.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_update()
	if JS.truthy(JS.equal(JS.invoke_method(self, "countLiving", []), 0, false)):
		JS.invoke_method(self, "kill", [])
		JS.set_property(self, "visible", false)
	return null

func original_postUpdate():
	var _scope2: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope3: Dictionary = {"x": _arg0, "y": _arg1, "width": _arg2}
	JS.invoke_method(self, "revive", [])
	JS.set_property(self, "visible", true)
	JS.set_property(self, "x", _scope3["x"])
	JS.set_property(self, "y", _scope3["y"])
	JS.set_property(self, "width", _scope3["width"])
	JS.invoke_method(self, "explode", [2500, 60])
	return null

func original_retire():
	var _scope4: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	JS.set_property(self, "visible", false)
	JS.invoke_method(self, "callAll", ["retire"])
	return null
