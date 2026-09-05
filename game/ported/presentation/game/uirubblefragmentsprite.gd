# 由原版 UIRubbleFragmentSprite 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIRubbleFragmentSprite: Dictionary = {}
static var _initialized_UIRubbleFragmentSprite = false
static func initialize_original_static():
	if _initialized_UIRubbleFragmentSprite: return
	_initialized_UIRubbleFragmentSprite = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIRubbleFragmentSprite.has(key): return _static_UIRubbleFragmentSprite[key]
	return JS.get_property(JS.module("Phaser.Sprite"), key)
static func original_static_set(key, value):
	_static_UIRubbleFragmentSprite[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "randomRubbleIndex": null}
	_scope0["randomRubbleIndex"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(3))])
	super._construct_create(_scope0["game"], 0, 0, "game", JS.add("rubble", _scope0["randomRubbleIndex"]))
	JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "enable", [self])
	JS.set_property(JS.get_property(self, "body"), "allowSleep", false)
	JS.set_property(JS.get_property(self, "body"), "damping", 0.95)
	JS.set_property(JS.get_property(self, "body"), "angularDamping", 0.95)
	JS.invoke_method(JS.get_property(JS.get_property(self, "body"), "onBeginContact"), "add", [JS.get_property(self, "_hitSomething"), self])
	JS.invoke_method(JS.get_property(self, "body"), "clearShapes", [])
	JS.invoke_method(JS.get_property(self, "body"), "loadPolygon", ["game-physics", JS.add("rubble", _scope0["randomRubbleIndex"])])
	JS.invoke_method(JS.get_property(self, "body"), "setMaterial", [JS.get_property(JS.module("UIUtils"), "fragmentMaterial")])
	JS.invoke_method(JS.get_property(self, "body"), "collides", [[JS.get_property(JS.module("UIUtils"), "wallCollisionGroup")]])
	JS.invoke_method(JS.get_property(self, "body"), "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "fragmentCollisionGroup")])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uirubblefragmentsprite.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	if JS.truthy(JS.logical("||", func():
		var _scope2: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope3: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return null
	JS.set_property(self, "timeAlive", JS.add(JS.get_property(self, "timeAlive"), (JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000))))
	if JS.truthy(JS.logical("&&", func():
		var _scope4: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "fading")))
		return null, func():
		var _scope5: Dictionary = {}
		return JS.compare(">", JS.get_property(self, "timeAlive"), JS.get_property(self, "lifetime"))
		return null)):
		JS.set_property(self, "fading", true)
	if JS.truthy(JS.get_property(self, "fading")):
		JS.set_property(self, "alpha", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "alpha")) - JS.number(0.035))]))
	if JS.truthy(JS.equal(JS.get_property(self, "alpha"), 0, false)):
		JS.invoke_method(self, "kill", [])
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope6: Dictionary = {"x": _arg0, "y": _arg1, "rotation": _arg2, "speed": _arg3, "speedX": null, "speedY": null}
	_scope6["speedX"] = (JS.number(JS.invoke_method("@Math", "sin", [_scope6["rotation"]])) * JS.number(_scope6["speed"]))
	_scope6["speedY"] = (JS.number(-(JS.invoke_method("@Math", "cos", [_scope6["rotation"]]))) * JS.number(_scope6["speed"]))
	JS.set_property(_scope6, "speedX", (JS.number(_scope6["speedX"]) * JS.number(-(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_SPEED_SCALE")))))
	JS.set_property(_scope6, "speedY", (JS.number(_scope6["speedY"]) * JS.number(-(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_SPEED_SCALE")))))
	JS.set_property(_scope6, "speedX", JS.add(_scope6["speedX"], (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_RANDOM_SPEED")))) - JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_RANDOM_SPEED")) / JS.number(2))))))
	JS.set_property(_scope6, "speedY", JS.add(_scope6["speedY"], (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_RANDOM_SPEED")))) - JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_RANDOM_SPEED")) / JS.number(2))))))
	if JS.truthy(JS.compare("<", JS.invoke_method("@Math", "random", []), 0.5)):
		JS.set_property(_scope6, "x", JS.add(_scope6["x"], (JS.number(JS.invoke_method("@Math", "cos", [_scope6["rotation"]])) * JS.number(-(JS.get_property(JS.module("UIConstants"), "RUBBLE_TREAD_OFFSET"))))))
		JS.set_property(_scope6, "y", JS.add(_scope6["y"], (JS.number(JS.invoke_method("@Math", "sin", [_scope6["rotation"]])) * JS.number(-(JS.get_property(JS.module("UIConstants"), "RUBBLE_TREAD_OFFSET"))))))
	else:
		JS.set_property(_scope6, "x", JS.add(_scope6["x"], (JS.number(JS.invoke_method("@Math", "cos", [_scope6["rotation"]])) * JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_TREAD_OFFSET")))))
		JS.set_property(_scope6, "y", JS.add(_scope6["y"], (JS.number(JS.invoke_method("@Math", "sin", [_scope6["rotation"]])) * JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_TREAD_OFFSET")))))
	JS.invoke_method(self, "reset", [_scope6["x"], _scope6["y"]])
	JS.set_property(self, "alpha", 1)
	JS.set_property(JS.get_property(self, "body"), "rotation", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property("@Math", "PI")))) * JS.number(2)))
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "x", _scope6["speedX"])
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "y", _scope6["speedY"])
	JS.set_property(JS.get_property(self, "body"), "angularVelocity", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_MAX_ROTATION_SPEED")))) - JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_MAX_ROTATION_SPEED")) / JS.number(2)))))
	JS.set_property(self, "timeAlive", 0)
	JS.set_property(self, "lifetime", JS.add(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_MIN_LIFETIME"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_MAX_LIFETIME")) - JS.number(JS.get_property(JS.module("UIConstants"), "RUBBLE_FRAGMENT_MIN_LIFETIME")))))))
	JS.set_property(self, "fading", false)
	return null

func original_retire():
	var _scope7: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null

func original__hitSomething(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope8: Dictionary = {"body": _arg0, "shapeA": _arg1, "shapeB": _arg2, "equation": _arg3}
	JS.set_property(self, "fading", true)
	return null
