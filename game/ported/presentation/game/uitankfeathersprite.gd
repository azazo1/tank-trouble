# 由原版 UITankFeatherSprite 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UITankFeatherSprite: Dictionary = {}
static var _initialized_UITankFeatherSprite = false
static func initialize_original_static():
	if _initialized_UITankFeatherSprite: return
	_initialized_UITankFeatherSprite = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UITankFeatherSprite.has(key): return _static_UITankFeatherSprite[key]
	return JS.get_property(JS.module("Phaser.Sprite"), key)
static func original_static_set(key, value):
	_static_UITankFeatherSprite[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0}
	super._construct_create(_scope0["game"], 0, 0, "game", JS.add("feather", JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(4))])))
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uitankfeathersprite.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_spawn(_arg0 = null, _arg1 = null):
	var _scope1: Dictionary = {"x": _arg0, "y": _arg1, "speed": null, "direction": null}
	JS.invoke_method(self, "reset", [_scope1["x"], _scope1["y"]])
	JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "enable", [self])
	JS.set_property(JS.get_property(self, "body"), "allowSleep", false)
	JS.set_property(JS.get_property(self, "body"), "dynamic", true)
	JS.set_property(JS.get_property(self, "body"), "fixedRotation", false)
	JS.set_property(JS.get_property(self, "body"), "damping", 0.94)
	JS.set_property(JS.get_property(self, "body"), "angularDamping", 0.8)
	JS.set_property(self, "alpha", 1)
	JS.invoke_method(JS.get_property(self, "scale"), "set", [(JS.number(JS.add(1, (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(0.2)))) * JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")))])
	JS.invoke_method(JS.get_property(self, "body"), "setRectangle", [(JS.number(JS.get_property(self, "width")) * JS.number(0.4)), JS.get_property(self, "height")])
	JS.invoke_method(JS.get_property(self, "body"), "setMaterial", [JS.get_property(JS.module("UIUtils"), "puffMaterial")])
	JS.invoke_method(JS.get_property(self, "body"), "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "puffCollisionGroup")])
	JS.invoke_method(JS.get_property(self, "body"), "collides", [JS.get_property(JS.module("UIUtils"), "wallCollisionGroup")])
	_scope1["speed"] = (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(400))) - JS.number(200))
	_scope1["direction"] = (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(2))) * JS.number(JS.get_property("@Math", "PI")))
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "x", (JS.number(JS.invoke_method("@Math", "cos", [_scope1["direction"]])) * JS.number(_scope1["speed"])))
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "y", (JS.number(JS.invoke_method("@Math", "sin", [_scope1["direction"]])) * JS.number(_scope1["speed"])))
	JS.set_property(JS.get_property(self, "body"), "rotation", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(2))) * JS.number(JS.get_property("@Math", "PI"))))
	JS.set_property(JS.get_property(self, "body"), "angularVelocity", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(10))) - JS.number(5)))
	return null

func original_update():
	var _scope2: Dictionary = {}
	if JS.truthy(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")):
		return null
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_update()
	if JS.truthy(JS.logical("&&", func():
		var _scope3: Dictionary = {}
		return JS.compare("<", JS.invoke_method("@Math", "abs", [JS.get_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "x")]), 0.1)
		return null, func():
		var _scope4: Dictionary = {}
		return JS.compare("<", JS.invoke_method("@Math", "abs", [JS.get_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "y")]), 0.1)
		return null)):
		JS.set_property(self, "alpha", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "alpha")) - JS.number((JS.number(0.03) - JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(0.0083))))))]))
	if JS.truthy(JS.equal(JS.get_property(self, "alpha"), 0, false)):
		JS.invoke_method(self, "kill", [])
	return null

func original_retire():
	var _scope5: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
