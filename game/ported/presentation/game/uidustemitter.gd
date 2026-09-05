# 由原版 UIDustEmitter 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/presentation/engine/phaseremitter.gd"

static var _static_UIDustEmitter: Dictionary = {}
static var _initialized_UIDustEmitter = false
static func initialize_original_static():
	if _initialized_UIDustEmitter: return
	_initialized_UIDustEmitter = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIDustEmitter.has(key): return _static_UIDustEmitter[key]
	return JS.get_property(JS.module("Phaser.Particles.Arcade.Emitter"), key)
static func original_static_set(key, value):
	_static_UIDustEmitter[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0}
	super._construct_create(_scope0["game"], 0, 0, 40)
	JS.set_property(self, "particleClass", JS.module("UIDustParticle"))
	JS.invoke_method(self, "makeParticles", ["game", ["dust0", "dust1", "dust2"]])
	JS.invoke_method(JS.get_property(self, "minParticleSpeed"), "setTo", [-(95), -(95)])
	JS.invoke_method(JS.get_property(self, "maxParticleSpeed"), "setTo", [95, 95])
	JS.invoke_method(JS.get_property(self, "particleDrag"), "setTo", [50, 50])
	JS.invoke_method(self, "setAlpha", [0.8, 1])
	JS.invoke_method(self, "setRotation", [0, 0])
	JS.set_property(self, "minParticleScale", (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number(0.8)))
	JS.set_property(self, "maxParticleScale", (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number(1)))
	JS.set_property(self, "gravity", 0)
	JS.invoke_method(self, "kill", [])
	JS.set_property(self, "visible", false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uidustemitter.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_preUpdate():
	var _scope1: Dictionary = {}
	if JS.truthy(JS.logical("||", func():
		var _scope2: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope3: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return false
	return super.original_preUpdate()
	return null

func original_update():
	var _scope4: Dictionary = {}
	if JS.truthy(JS.logical("||", func():
		var _scope5: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope6: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return null
	super.original_update()
	if JS.truthy(JS.equal(JS.invoke_method(self, "countLiving", []), 0, false)):
		JS.invoke_method(self, "kill", [])
		JS.set_property(self, "visible", false)
	return null

func original_postUpdate():
	var _scope7: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null, _arg1 = null):
	var _scope8: Dictionary = {"x": _arg0, "y": _arg1}
	JS.invoke_method(self, "revive", [])
	JS.set_property(self, "visible", true)
	JS.set_property(self, "x", _scope8["x"])
	JS.set_property(self, "y", _scope8["y"])
	JS.invoke_method(self, "explode", [2000, JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "CRATE_LAND_DUST_COUNT")])])
	return null

func original_retire():
	var _scope9: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	JS.set_property(self, "visible", false)
	JS.invoke_method(self, "callAll", ["retire"])
	return null
