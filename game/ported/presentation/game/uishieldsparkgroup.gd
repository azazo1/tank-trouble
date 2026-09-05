# 由原版 UIShieldSparkGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UIShieldSparkGroup: Dictionary = {}
static var _initialized_UIShieldSparkGroup = false
static func initialize_original_static():
	if _initialized_UIShieldSparkGroup: return
	_initialized_UIShieldSparkGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIShieldSparkGroup.has(key): return _static_UIShieldSparkGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIShieldSparkGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "i": null}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "boltGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [self]))
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.module("UIConstants"), "SHIELD_SPARK_BOLT_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "boltGroup"), "add", [JS.construct(JS.module("UIShieldSparkBoltImage"), [_scope0["game"]])])
		JS.increment(_scope0, "i", 1, false)
	JS.set_property(self, "emitter", JS.invoke_method(self, "add", [JS.construct(JS.module("UIShieldSparkEmitter"), [_scope0["game"]])]))
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UIShieldSparkGroup"]))
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uishieldsparkgroup.gd").new()
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
		return JS.equal(JS.invoke_method(JS.get_property(self, "boltGroup"), "countLiving", []), 0, false)
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

func original_emit(_arg0 = null, _arg1 = null):
	var _scope5: Dictionary = {"tank": _arg0, "position": _arg1, "boltImage": null, "rotation": null}
	JS.set_property(self, "exists", true)
	JS.set_property(self, "visible", true)
	_scope5["boltImage"] = JS.invoke_method(JS.get_property(self, "boltGroup"), "getFirstExists", [false])
	_scope5["rotation"] = JS.invoke_method(JS.get_property(JS.module("Phaser"), "Math"), "angleBetween", [JS.invoke_method(_scope5["tank"], "getX", []), JS.invoke_method(_scope5["tank"], "getY", []), JS.get_property(_scope5["position"], "x"), JS.get_property(_scope5["position"], "y")])
	if JS.truthy(_scope5["boltImage"]):
		JS.invoke_method(_scope5["boltImage"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope5["position"], "x")]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope5["position"], "y")]), _scope5["rotation"]])
	else:
		pass
	JS.invoke_method(JS.get_property(self, "emitter"), "emit", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope5["position"], "x")]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope5["position"], "y")]), _scope5["rotation"]])
	return null

func original_retire():
	var _scope6: Dictionary = {}
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.invoke_method(JS.get_property(self, "emitter"), "retire", [])
	JS.invoke_method(JS.get_property(self, "boltGroup"), "callAll", ["retire"])
	return null
