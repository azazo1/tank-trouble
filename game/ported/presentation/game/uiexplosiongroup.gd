# 由原版 UIExplosionGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UIExplosionGroup: Dictionary = {}
static var _initialized_UIExplosionGroup = false
static func initialize_original_static():
	if _initialized_UIExplosionGroup: return
	_initialized_UIExplosionGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIExplosionGroup.has(key): return _static_UIExplosionGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIExplosionGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "emitter", JS.invoke_method(self, "add", [JS.construct(JS.module("UIExplosionEmitter"), [_scope0["game"]])]))
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uiexplosiongroup.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_update()
	if JS.truthy(JS.equal(JS.invoke_method(self, "countLiving", []), 0, false)):
		JS.set_property(self, "exists", false)
		JS.set_property(self, "visible", false)
	return null

func original_postUpdate():
	var _scope2: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope3: Dictionary = {"x": _arg0, "y": _arg1, "sound": _arg2, "smokeCount": _arg3}
	JS.invoke_method(_scope3["sound"], "play", [])
	JS.set_property(self, "exists", true)
	JS.set_property(self, "visible", true)
	JS.invoke_method(JS.get_property(self, "emitter"), "spawn", [_scope3["x"], _scope3["y"], _scope3["smokeCount"]])
	return null

func original_retire():
	var _scope4: Dictionary = {}
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.invoke_method(JS.get_property(self, "emitter"), "retire", [])
	return null
