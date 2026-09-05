# 由原版 UIRubbleGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UIRubbleGroup: Dictionary = {}
static var _initialized_UIRubbleGroup = false
static func initialize_original_static():
	if _initialized_UIRubbleGroup: return
	_initialized_UIRubbleGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIRubbleGroup.has(key): return _static_UIRubbleGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIRubbleGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "i": null}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "fragmentGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [self]))
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "fragmentGroup"), "add", [JS.construct(JS.module("UIRubbleFragmentSprite"), [_scope0["game"]])])
		JS.increment(_scope0, "i", 1, false)
	JS.set_property(self, "emitter", JS.invoke_method(self, "add", [JS.construct(JS.module("UIRubbleEmitter"), [_scope0["game"]])]))
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UIRubbleGroup"]))
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uirubblegroup.gd").new()
	instance._construct_create(_arg0)
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

func original_emit(_arg0 = null):
	var _scope4: Dictionary = {"tank": _arg0, "rubbleFragmentSprite": null}
	if JS.truthy(not JS.equal(JS.invoke_method(JS.module("QualityManager"), "getQuality", []), JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_SETTINGS"), "LOW"), true)):
		if JS.truthy(JS.logical("||", func():
			var _scope5: Dictionary = {}
			return not JS.equal(JS.invoke_method(_scope4["tank"], "getSpeed", []), 0, false)
			return null, func():
			var _scope6: Dictionary = {}
			return not JS.equal(JS.invoke_method(_scope4["tank"], "getRotationSpeed", []), 0, false)
			return null)):
			JS.set_property(self, "exists", true)
			JS.set_property(self, "visible", true)
			_scope4["rubbleFragmentSprite"] = JS.invoke_method(JS.get_property(self, "fragmentGroup"), "getFirstExists", [false])
			if JS.truthy(_scope4["rubbleFragmentSprite"]):
				JS.invoke_method(_scope4["rubbleFragmentSprite"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope4["tank"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope4["tank"], "getY", [])]), JS.invoke_method(_scope4["tank"], "getRotation", []), JS.invoke_method(_scope4["tank"], "getSpeed", [])])
			else:
				pass
			JS.invoke_method(JS.get_property(self, "emitter"), "emit", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope4["tank"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope4["tank"], "getY", [])]), JS.invoke_method(_scope4["tank"], "getRotation", []), JS.invoke_method(_scope4["tank"], "getSpeed", [])])
	return null

func original_retire():
	var _scope7: Dictionary = {}
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.invoke_method(JS.get_property(self, "emitter"), "retire", [])
	JS.invoke_method(JS.get_property(self, "fragmentGroup"), "callAll", ["retire"])
	return null
