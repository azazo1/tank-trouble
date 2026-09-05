# 由原版 UIScoreExplosionFragmentSprite 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIScoreExplosionFragmentSprite: Dictionary = {}
static var _initialized_UIScoreExplosionFragmentSprite = false
static func initialize_original_static():
	if _initialized_UIScoreExplosionFragmentSprite: return
	_initialized_UIScoreExplosionFragmentSprite = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIScoreExplosionFragmentSprite.has(key): return _static_UIScoreExplosionFragmentSprite[key]
	return JS.get_property(JS.module("Phaser.Sprite"), key)
static func original_static_set(key, value):
	_static_UIScoreExplosionFragmentSprite[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "randomFragmentIndex": null}
	_scope0["randomFragmentIndex"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(9))])
	super._construct_create(_scope0["game"], 0, 0, "playerpanel", JS.add("fragment", _scope0["randomFragmentIndex"]))
	JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "enable", [self])
	JS.set_property(JS.get_property(self, "body"), "allowSleep", false)
	JS.invoke_method(JS.get_property(JS.get_property(self, "body"), "onBeginContact"), "add", [JS.get_property(self, "_hitSomething"), self])
	JS.invoke_method(JS.get_property(self, "body"), "clearShapes", [])
	JS.invoke_method(JS.get_property(self, "body"), "loadPolygon", ["playerpanel-physics", JS.add("fragment", _scope0["randomFragmentIndex"])])
	JS.invoke_method(JS.get_property(self, "body"), "setMaterial", [JS.get_property(JS.module("UIUtils"), "scoreFragmentMaterial")])
	JS.invoke_method(JS.get_property(self, "body"), "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "scoreFragmentCollisionGroup")])
	JS.invoke_method(JS.get_property(self, "body"), "collides", [[JS.get_property(JS.module("UIUtils"), "playerPanelFloorCollisionGroup")]])
	JS.set_property(JS.get_property(self, "body"), "collideWorldBounds", false)
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/panel/uiscoreexplosionfragmentsprite.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_update():
	var _scope1: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	if JS.truthy(JS.get_property(self, "fading")):
		JS.set_property(self, "alpha", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "alpha")) - JS.number(0.025))]))
	if JS.truthy(JS.equal(JS.get_property(self, "alpha"), 0, false)):
		JS.invoke_method(self, "kill", [])
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope2: Dictionary = {"x": _arg0, "y": _arg1, "width": _arg2, "speed": null, "direction": null, "speedX": null, "speedY": null}
	_scope2["speed"] = JS.add(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MIN_SPEED"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MAX_SPEED")) - JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MIN_SPEED"))))))
	_scope2["direction"] = JS.add(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MIN_ANGLE"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MAX_ANGLE")) - JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MIN_ANGLE"))))))
	_scope2["speedX"] = (JS.number(JS.invoke_method("@Math", "cos", [_scope2["direction"]])) * JS.number(_scope2["speed"]))
	_scope2["speedY"] = (JS.number(JS.invoke_method("@Math", "sin", [_scope2["direction"]])) * JS.number(_scope2["speed"]))
	JS.set_property(_scope2, "x", JS.add(_scope2["x"], (JS.number((JS.number(_scope2["width"]) * JS.number(JS.invoke_method("@Math", "random", [])))) - JS.number((JS.number(_scope2["width"]) / JS.number(2))))))
	JS.set_property(_scope2, "y", JS.add(_scope2["y"], (JS.number(_scope2["speedY"]) * JS.number(0.1))))
	JS.invoke_method(self, "reset", [_scope2["x"], _scope2["y"]])
	JS.set_property(self, "alpha", 1)
	JS.set_property(JS.get_property(self, "body"), "rotation", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property("@Math", "PI")))) * JS.number(2)))
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "x", _scope2["speedX"])
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "y", _scope2["speedY"])
	JS.set_property(JS.get_property(self, "body"), "angularVelocity", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MAX_ROTATION_SPEED")))) - JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MAX_ROTATION_SPEED")) / JS.number(2)))))
	JS.set_property(self, "fading", false)
	return null

func original_retire():
	var _scope3: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null

func original__hitSomething(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope4: Dictionary = {"body": _arg0, "shapeA": _arg1, "shapeB": _arg2, "equation": _arg3}
	JS.set_property(self, "fading", true)
	return null
