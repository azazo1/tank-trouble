# 由原版 UIShieldSprite 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIShieldSprite: Dictionary = {}
static var _initialized_UIShieldSprite = false
static func initialize_original_static():
	if _initialized_UIShieldSprite: return
	_initialized_UIShieldSprite = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIShieldSprite.has(key): return _static_UIShieldSprite[key]
	return JS.get_property(JS.module("Phaser.Sprite"), key)
static func original_static_set(key, value):
	_static_UIShieldSprite[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1, "activateSound": _arg2, "weakenedSound": _arg3, "endSound": _arg4, "boltFrames": null, "i": null, "bolt": null}
	super._construct_create(_scope0["game"], 0, 0)
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.set_property(self, "activateSound", _scope0["activateSound"])
	JS.set_property(self, "weakenedSound", _scope0["weakenedSound"])
	JS.set_property(self, "endSound", _scope0["endSound"])
	JS.set_property(self, "layer1Shield", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Image"), [_scope0["game"], 0, 0, "game", "shield"])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "layer1Shield"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "layer2Shield", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Image"), [_scope0["game"], 0, 0, "game", "shield"])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "layer2Shield"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "bolts", [])
	JS.set_property(self, "boltRotationSpeeds", [])
	_scope0["boltFrames"] = ["shieldBolt0", "shieldBolt1", "shieldBolt2"]
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.module("UIConstants"), "SHIELD_NUM_BOLTS"))):
		_scope0["bolt"] = JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Image"), [_scope0["game"], 0, 0, "game", "shieldBolt0"])])
		JS.invoke_method(JS.get_property(_scope0["bolt"], "anchor"), "setTo", [0.5, 1])
		JS.invoke_method(JS.module("ArrayUtils"), "shuffle", [_scope0["boltFrames"]])
		JS.invoke_method(JS.get_property(JS.invoke_method(JS.get_property(_scope0["bolt"], "animations"), "add", ["buzz", _scope0["boltFrames"], 6, false]), "onComplete"), "add", [func():
			var _scope1: Dictionary = {}
			JS.invoke_method(JS.callback_receiver(self), "kill", [])
			return null, _scope0["bolt"]])
		JS.invoke_method(_scope0["bolt"], "kill", [])
		JS.invoke_method(JS.get_property(self, "boltRotationSpeeds"), "push", [(JS.number((1 if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5)) else -(1))) * JS.number(JS.add((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "SHIELD_BOLT_MAX_ROTATION_SPEED")) - JS.number(JS.get_property(JS.module("UIConstants"), "SHIELD_BOLT_MIN_ROTATION_SPEED"))))), JS.get_property(JS.module("UIConstants"), "SHIELD_BOLT_MIN_ROTATION_SPEED"))))])
		JS.invoke_method(JS.get_property(self, "bolts"), "push", [_scope0["bolt"]])
		JS.increment(_scope0, "i", 1, false)
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "enable", [self])
	JS.set_property(JS.get_property(self, "body"), "allowSleep", false)
	JS.set_property(JS.get_property(self, "body"), "static", true)
	JS.invoke_method(JS.get_property(self, "body"), "setCircle", [JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHIELD"), "RADIUS"), "px")])
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uishieldsprite.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4)
	return instance

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope2: Dictionary = {"playerId": _arg0, "weakened": _arg1, "animate": _arg2, "tank": null}
	JS.invoke_method(self, "revive", [])
	JS.set_property(self, "playerId", _scope2["playerId"])
	JS.set_property(self, "weakened", _scope2["weakened"])
	JS.invoke_method(JS.get_property(self, "body"), "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "shieldCollisionGroup")])
	JS.invoke_method(JS.get_property(self, "body"), "collides", [[JS.get_property(JS.module("UIUtils"), "fragmentCollisionGroup"), JS.get_property(JS.module("UIUtils"), "rayCollisionGroup")]])
	JS.set_property(self, "alpha", 1)
	if JS.truthy(_scope2["animate"]):
		JS.invoke_method(JS.get_property(self, "scale"), "setTo", [0, 0])
		JS.set_property(self, "spawnTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), "y": JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")}, JS.get_property(JS.module("UIConstants"), "SHIELD_SPAWN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true]))
		JS.invoke_method(JS.get_property(self, "activateSound"), "play", [])
	else:
		JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	if JS.truthy(JS.get_property(self, "weakened")):
		JS.invoke_method(JS.get_property(self, "weakenedSound"), "play", ["", 0, 0.5, true])
	_scope2["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope2["tank"]):
		JS.set_property(JS.get_property(self, "body"), "x", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope2["tank"], "getX", [])]))
		JS.set_property(JS.get_property(self, "body"), "y", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope2["tank"], "getY", [])]))
	return null

func original_update():
	var _scope3: Dictionary = {"inverseBoltProbability": null, "i": null, "bolt": null, "tank": null}
	if JS.truthy(JS.logical("||", func():
		var _scope4: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope5: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return null
	JS.set_property(JS.get_property(self, "layer1Shield"), "rotation", JS.add(JS.get_property(JS.get_property(self, "layer1Shield"), "rotation"), (JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "SHIELD_LAYER_1_ROTATION_SPEED")) * JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")))) / JS.number(1000))))
	JS.set_property(JS.get_property(self, "layer2Shield"), "rotation", JS.add(JS.get_property(JS.get_property(self, "layer2Shield"), "rotation"), (JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "SHIELD_LAYER_2_ROTATION_SPEED")) * JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")))) / JS.number(1000))))
	_scope3["inverseBoltProbability"] = JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "SHIELD_INVERSE_BOLT_PROBABILITY")])
	_scope3["i"] = 0
	while JS.truthy(JS.compare("<", _scope3["i"], JS.get_property(JS.get_property(self, "bolts"), "length"))):
		_scope3["bolt"] = JS.get_property(JS.get_property(self, "bolts"), _scope3["i"])
		JS.set_property(_scope3["bolt"], "rotation", JS.add(JS.get_property(_scope3["bolt"], "rotation"), (JS.number((JS.number(JS.get_property(JS.get_property(self, "boltRotationSpeeds"), _scope3["i"])) * JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")))) / JS.number(1000))))
		if JS.truthy((not JS.truthy(JS.get_property(_scope3["bolt"], "exists")))):
			if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), _scope3["inverseBoltProbability"])):
				JS.invoke_method(_scope3["bolt"], "revive", [])
				JS.set_property(_scope3["bolt"], "rotation", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(2))) * JS.number(JS.get_property("@Math", "PI"))))
				JS.invoke_method(JS.get_property(_scope3["bolt"], "animations"), "play", ["buzz"])
		JS.increment(_scope3, "i", 1, false)
	if JS.truthy(JS.logical("&&", func():
		var _scope6: Dictionary = {}
		return JS.get_property(self, "weakened")
		return null, func():
		var _scope7: Dictionary = {}
		return JS.compare(">", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "INVERSE_SHIELD_WEAKENED_FLICKER_PROBABILITY"))
		return null)):
		JS.set_property(self, "alpha", JS.add(JS.get_property(JS.module("UIConstants"), "SHIELD_WEAKENED_FLICKER_ALPHA_MIN"), (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "SHIELD_WEAKENED_FLICKER_ALPHA_MAX")) - JS.number(JS.get_property(JS.module("UIConstants"), "SHIELD_WEAKENED_FLICKER_ALPHA_MIN")))))))
	_scope3["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope3["tank"]):
		JS.set_property(JS.get_property(self, "body"), "x", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope3["tank"], "getX", [])]))
		JS.set_property(JS.get_property(self, "body"), "y", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope3["tank"], "getY", [])]))
	return null

func original_getPlayerId():
	var _scope8: Dictionary = {}
	return JS.get_property(self, "playerId")
	return null

func original_activate():
	var _scope9: Dictionary = {}
	return null

func original_weaken():
	var _scope10: Dictionary = {}
	JS.set_property(self, "weakened", true)
	JS.invoke_method(JS.get_property(self, "weakenedSound"), "play", ["", 0, 1, true])
	return null

func original_strengthen():
	var _scope11: Dictionary = {}
	JS.set_property(self, "weakened", false)
	JS.invoke_method(JS.get_property(self, "weakenedSound"), "stop", [])
	JS.set_property(self, "alpha", 1)
	return null

func original_remove():
	var _scope12: Dictionary = {}
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
		JS.set_property(self, "spawnTween", null)
	JS.invoke_method(JS.get_property(self, "body"), "clearCollision", [])
	JS.invoke_method(JS.get_property(self, "weakenedSound"), "stop", [])
	JS.invoke_method(JS.get_property(self, "endSound"), "play", [])
	JS.invoke_method(JS.get_property(JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"alpha": 0}, JS.get_property(JS.module("UIConstants"), "SHIELD_BREAK_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]), "onComplete"), "add", [func():
		var _scope13: Dictionary = {}
		JS.invoke_method(JS.get_property(JS.callback_receiver(self), "weakenedSound"), "stop", [])
		JS.invoke_method(JS.callback_receiver(self), "kill", [])
		return null, self])
	return null

func original_retire():
	var _scope14: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "weakenedSound"), "stop", [])
	JS.invoke_method(self, "kill", [])
	return null
