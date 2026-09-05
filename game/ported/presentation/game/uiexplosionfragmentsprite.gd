# 由原版 UIExplosionFragmentSprite 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIExplosionFragmentSprite: Dictionary = {}
static var _initialized_UIExplosionFragmentSprite = false
static func initialize_original_static():
	if _initialized_UIExplosionFragmentSprite: return
	_initialized_UIExplosionFragmentSprite = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIExplosionFragmentSprite.has(key): return _static_UIExplosionFragmentSprite[key]
	return JS.get_property(JS.module("Phaser.Sprite"), key)
static func original_static_set(key, value):
	_static_UIExplosionFragmentSprite[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "randomFragmentIndex": null}
	_scope0["randomFragmentIndex"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(10))])
	super._construct_create(_scope0["game"], 0, 0, "game", JS.add("fragment", _scope0["randomFragmentIndex"]))
	JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "enable", [self])
	JS.set_property(JS.get_property(self, "body"), "allowSleep", false)
	JS.set_property(JS.get_property(self, "body"), "damping", 0.25)
	JS.set_property(JS.get_property(self, "body"), "angularDamping", 0.25)
	JS.invoke_method(JS.get_property(JS.get_property(self, "body"), "onBeginContact"), "add", [JS.get_property(self, "_hitSomething"), self])
	JS.invoke_method(JS.get_property(self, "body"), "clearShapes", [])
	JS.invoke_method(JS.get_property(self, "body"), "loadPolygon", ["game-physics", JS.add("fragment", _scope0["randomFragmentIndex"])])
	JS.invoke_method(JS.get_property(self, "body"), "setMaterial", [JS.get_property(JS.module("UIUtils"), "fragmentMaterial")])
	JS.invoke_method(JS.get_property(self, "body"), "clearCollision", [])
	JS.invoke_method(JS.get_property(self, "body"), "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "fragmentCollisionGroup")])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uiexplosionfragmentsprite.gd").new()
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
		return (not JS.truthy(JS.get_property(self, "colliding")))
		return null, func():
		var _scope5: Dictionary = {}
		return JS.compare(">", JS.get_property(self, "timeAlive"), JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_COLLISION_TIME"))
		return null)):
		JS.set_property(self, "colliding", true)
		JS.invoke_method(JS.get_property(self, "body"), "collides", [[JS.get_property(JS.module("UIUtils"), "wallCollisionGroup"), JS.get_property(JS.module("UIUtils"), "tankCollisionGroup"), JS.get_property(JS.module("UIUtils"), "crateCollisionGroup"), JS.get_property(JS.module("UIUtils"), "shieldCollisionGroup"), JS.get_property(JS.module("UIUtils"), "spawnCollisionGroup")]])
	if JS.truthy(JS.logical("&&", func():
		var _scope6: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "fading")))
		return null, func():
		var _scope7: Dictionary = {}
		return JS.compare(">", JS.get_property(self, "timeAlive"), JS.get_property(self, "lifetime"))
		return null)):
		JS.set_property(self, "fading", true)
	if JS.truthy(JS.get_property(self, "fading")):
		JS.set_property(self, "alpha", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "alpha")) - JS.number(0.025))]))
	if JS.truthy(JS.equal(JS.get_property(self, "alpha"), 0, false)):
		JS.invoke_method(self, "kill", [])
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope8: Dictionary = {"x": _arg0, "y": _arg1, "playerId": _arg2, "self": null, "speed": null, "direction": null, "speedX": null, "speedY": null}
	JS.set_property(self, "playerId", _scope8["playerId"])
	_scope8["self"] = self
	JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
		var _scope9: Dictionary = {"result": _arg0}
		if JS.truthy(JS.equal(JS.type_of(_scope9["result"]), "object", false)):
			if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), 0.4)):
				JS.set_property(_scope8["self"], "tint", JS.get_property(JS.invoke_method(_scope9["result"], "getBaseColour", []), "numericValue"))
			else:
				JS.set_property(_scope8["self"], "tint", JS.get_property(JS.invoke_method(_scope9["result"], "getTurretColour", []), "numericValue"))
		else:
			JS.set_property(_scope8["self"], "tint", JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_UNAVAILABLE_COLOUR"), "numericValue"))
		return null, func(_arg0 = null):
		var _scope10: Dictionary = {"result": _arg0}
		return null, func(_arg0 = null):
		var _scope11: Dictionary = {"result": _arg0}
		return null, JS.get_property(self, "playerId"), JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
	_scope8["speed"] = JS.add(JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_MIN_SPEED"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_MAX_SPEED")) - JS.number(JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_MIN_SPEED"))))))
	_scope8["direction"] = (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property("@Math", "PI")))) * JS.number(2))
	_scope8["speedX"] = (JS.number(JS.invoke_method("@Math", "cos", [_scope8["direction"]])) * JS.number(_scope8["speed"]))
	_scope8["speedY"] = (JS.number(JS.invoke_method("@Math", "sin", [_scope8["direction"]])) * JS.number(_scope8["speed"]))
	JS.set_property(_scope8, "x", JS.add(_scope8["x"], (JS.number(JS.invoke_method("@Math", "cos", [_scope8["direction"]])) * JS.number(JS.add((JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "WIDTH"), "px")))) / JS.number(4)), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "WIDTH"), "px")) / JS.number(4)))))))
	JS.set_property(_scope8, "y", JS.add(_scope8["y"], (JS.number(JS.invoke_method("@Math", "sin", [_scope8["direction"]])) * JS.number(JS.add((JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "WIDTH"), "px")))) / JS.number(4)), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "WIDTH"), "px")) / JS.number(4)))))))
	JS.invoke_method(self, "reset", [_scope8["x"], _scope8["y"]])
	JS.set_property(self, "alpha", 1)
	JS.set_property(JS.get_property(self, "body"), "rotation", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property("@Math", "PI")))) * JS.number(2)))
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "x", _scope8["speedX"])
	JS.set_property(JS.get_property(JS.get_property(self, "body"), "velocity"), "y", _scope8["speedY"])
	JS.set_property(JS.get_property(self, "body"), "angularVelocity", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_MAX_ROTATION_SPEED")))) - JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_MAX_ROTATION_SPEED")) / JS.number(2)))))
	JS.invoke_method(JS.get_property(self, "body"), "clearCollision", [false])
	JS.set_property(self, "timeAlive", 0)
	JS.set_property(self, "lifetime", JS.add(JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_MIN_LIFETIME"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_MAX_LIFETIME")) - JS.number(JS.get_property(JS.module("UIConstants"), "EXPLOSION_FRAGMENT_MIN_LIFETIME")))))))
	JS.set_property(self, "colliding", false)
	JS.set_property(self, "fading", false)
	return null

func original_retire():
	var _scope12: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null

func original__hitSomething(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope13: Dictionary = {"body": _arg0, "shapeA": _arg1, "shapeB": _arg2, "equation": _arg3}
	JS.set_property(self, "fading", true)
	return null
