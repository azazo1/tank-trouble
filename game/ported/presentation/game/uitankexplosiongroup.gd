# 由原版 UITankExplosionGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UITankExplosionGroup: Dictionary = {}
static var _initialized_UITankExplosionGroup = false
static func initialize_original_static():
	if _initialized_UITankExplosionGroup: return
	_initialized_UITankExplosionGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UITankExplosionGroup.has(key): return _static_UITankExplosionGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UITankExplosionGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "tankExplosionSounds": _arg1, "i": null, "fragmentSprite": null}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "tankExplosionSounds", _scope0["tankExplosionSounds"])
	JS.set_property(self, "fragmentGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [self]))
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_COUNT"))):
		_scope0["fragmentSprite"] = JS.construct(JS.module("UIExplosionFragmentSprite"), [_scope0["game"]])
		JS.invoke_method(JS.get_property(self, "fragmentGroup"), "add", [_scope0["fragmentSprite"]])
		if JS.truthy(fmod(_scope0["i"], 2)):
			JS.invoke_method(JS.get_property(self, "fragmentGroup"), "add", [JS.construct(JS.module("UISmokeEmitter"), [_scope0["game"], _scope0["fragmentSprite"]])])
		JS.increment(_scope0, "i", 1, false)
	JS.set_property(self, "emitter", JS.invoke_method(self, "add", [JS.construct(JS.module("UIExplosionEmitter"), [_scope0["game"]])]))
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uitankexplosiongroup.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_update()
	if JS.truthy(JS.logical("&&", func():
		var _scope2: Dictionary = {}
		return JS.compare("<=", JS.invoke_method(self, "countLiving", []), 1)
		return null, func():
		var _scope3: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.get_property(self, "fragmentGroup"), "countLiving", []), 0, false)
		return null)):
		JS.set_property(self, "exists", false)
		JS.set_property(self, "visible", false)
	return null

func original_postUpdate():
	var _scope4: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope5: Dictionary = {"x": _arg0, "y": _arg1, "playerId": _arg2, "numFragments": null, "i": null}
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankExplosionSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_EXPLOSION_AUDIO_COUNT")))])), "play", [])
	JS.set_property(self, "exists", true)
	JS.set_property(self, "visible", true)
	JS.invoke_method(JS.get_property(self, "emitter"), "spawn", [_scope5["x"], _scope5["y"], JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "TANK_EXPLOSION_SMOKE_COUNT")])])
	_scope5["numFragments"] = JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "TANK_EXPLOSION_FRAGMENT_COUNT")])
	_scope5["i"] = 0
	while JS.truthy(JS.compare("<", _scope5["i"], _scope5["numFragments"])):
		JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "fragmentGroup"), "children"), _scope5["i"]), "spawn", [_scope5["x"], _scope5["y"], _scope5["playerId"]])
		JS.increment(_scope5, "i", 1, false)
	return null

func original_retire():
	var _scope6: Dictionary = {}
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.invoke_method(JS.get_property(self, "emitter"), "retire", [])
	JS.invoke_method(JS.get_property(self, "fragmentGroup"), "callAll", ["retire"])
	return null
