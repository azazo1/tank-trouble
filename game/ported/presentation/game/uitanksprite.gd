# 由原版 UITankSprite 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UITankSprite: Dictionary = {}
static var _initialized_UITankSprite = false
static func initialize_original_static():
	if _initialized_UITankSprite: return
	_initialized_UITankSprite = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UITankSprite.has(key): return _static_UITankSprite[key]
	return JS.get_property(JS.module("Phaser.Sprite"), key)
static func original_static_set(key, value):
	_static_UITankSprite[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1, "emptyBarrelSounds": _arg2, "fireBulletSounds": _arg3, "fireLaserSound": _arg4, "fireShotgunSound": _arg5, "fireMissileSound": _arg6, "fireMineSound": _arg7, "chargeGatlingGunSound": _arg8, "holdGatlingGunSound": _arg9, "dischargeGatlingGunSound": _arg10, "pickupLaserSound": _arg11, "pickupDoubleBarrelSound": _arg12, "pickupShotgunSound": _arg13, "pickupMissileSound": _arg14, "pickupMineSound": _arg15, "pickupGatlingGunSound": _arg16, "pickupShieldSound": _arg17, "loadWeaponSound": _arg18, "dustEmitter": _arg19, "launchEmitter": _arg20}
	super._construct_create(_scope0["game"], 0, 0, "game", "base")
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.set_property(self, "emptyBarrelSounds", _scope0["emptyBarrelSounds"])
	JS.set_property(self, "fireBulletSounds", _scope0["fireBulletSounds"])
	JS.set_property(self, "fireLaserSound", _scope0["fireLaserSound"])
	JS.set_property(self, "fireShotgunSound", _scope0["fireShotgunSound"])
	JS.set_property(self, "fireMissileSound", _scope0["fireMissileSound"])
	JS.set_property(self, "fireMineSound", _scope0["fireMineSound"])
	JS.set_property(self, "chargeGatlingGunSound", _scope0["chargeGatlingGunSound"])
	JS.set_property(self, "holdGatlingGunSound", _scope0["holdGatlingGunSound"])
	JS.set_property(self, "dischargeGatlingGunSound", _scope0["dischargeGatlingGunSound"])
	JS.set_property(self, "pickupLaserSound", _scope0["pickupLaserSound"])
	JS.set_property(self, "pickupDoubleBarrelSound", _scope0["pickupDoubleBarrelSound"])
	JS.set_property(self, "pickupShotgunSound", _scope0["pickupShotgunSound"])
	JS.set_property(self, "pickupMissileSound", _scope0["pickupMissileSound"])
	JS.set_property(self, "pickupMineSound", _scope0["pickupMineSound"])
	JS.set_property(self, "pickupGatlingGunSound", _scope0["pickupGatlingGunSound"])
	JS.set_property(self, "pickupShieldSound", _scope0["pickupShieldSound"])
	JS.set_property(self, "loadWeaponSound", _scope0["loadWeaponSound"])
	JS.set_property(self, "dustEmitter", _scope0["dustEmitter"])
	JS.set_property(self, "launchEmitter", _scope0["launchEmitter"])
	JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "enable", [self])
	JS.set_property(JS.get_property(self, "body"), "allowSleep", false)
	JS.set_property(JS.get_property(self, "body"), "kinematic", true)
	JS.invoke_method(JS.get_property(self, "body"), "setRectangle", [JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "WIDTH"), "px"), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "HEIGHT"), "px")])
	JS.invoke_method(JS.get_property(self, "body"), "addRectangle", [JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "WIDTH"), "px"), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "HEIGHT"), "px"), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_X"), "px"), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_Y"), "px")])
	JS.invoke_method(JS.get_property(self, "body"), "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "tankCollisionGroup")])
	JS.invoke_method(JS.get_property(self, "body"), "collides", [[JS.get_property(JS.module("UIUtils"), "fragmentCollisionGroup"), JS.get_property(JS.module("UIUtils"), "rayCollisionGroup")]])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.set_property(self, "leftTread", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Image"), [_scope0["game"], JS.get_property(JS.module("UIConstants"), "TANK_LEFT_TREAD_X"), 0, "game", "tread"])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "leftTread"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "leftTreadShade", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Image"), [_scope0["game"], JS.get_property(JS.module("UIConstants"), "TANK_LEFT_TREAD_X"), 0, "game", "treadShade0"])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "leftTreadShade"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "rightTread", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Image"), [_scope0["game"], JS.get_property(JS.module("UIConstants"), "TANK_RIGHT_TREAD_X"), 0, "game", "tread"])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "rightTread"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "rightTreadShade", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Image"), [_scope0["game"], JS.get_property(JS.module("UIConstants"), "TANK_RIGHT_TREAD_X"), 0, "game", "treadShade0"])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "rightTreadShade"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "turret", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Image"), [_scope0["game"], 0, JS.get_property(JS.module("UIConstants"), "TANK_TURRET_Y"), "game", "turret0"])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["idleBullet", ["turret0"], 24, false])
	JS.invoke_method(JS.get_property(JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["fireBullet", ["turret1", "turret2"], 24, false]), "onComplete"), "add", [func():
		var _scope1: Dictionary = {}
		JS.invoke_method(JS.get_property(JS.get_property(JS.callback_receiver(self), "turret"), "animations"), "play", ["idleBullet"])
		return null, self])
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["idleLaser", ["turret3"], 24, false])
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["idleDoubleBarrel", ["turret4"], 24, false])
	JS.invoke_method(JS.get_property(JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["fireDoubleBarrelLeft", ["turret5", "turret6"], 24, false]), "onComplete"), "add", [func():
		var _scope2: Dictionary = {}
		JS.invoke_method(JS.get_property(JS.get_property(JS.callback_receiver(self), "turret"), "animations"), "play", ["idleDoubleBarrel"])
		return null, self])
	JS.invoke_method(JS.get_property(JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["fireDoubleBarrelRight", ["turret7", "turret8"], 24, false]), "onComplete"), "add", [func():
		var _scope3: Dictionary = {}
		JS.invoke_method(JS.get_property(JS.get_property(JS.callback_receiver(self), "turret"), "animations"), "play", ["idleDoubleBarrel"])
		return null, self])
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["idleShotgun", ["turret9"], 24, false])
	JS.invoke_method(JS.get_property(JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["fireShotgun", ["turret9", "turret9", "turret9", "turret9", "turret9", "turret9", "turret9", "turret9", "turret9", "turret9", "turret9", "turret10", "turret11", "turret11", "turret11", "turret11", "turret11", "turret11", "turret10", "turret9", "turret9", "turret9", "turret9"], 24, false]), "onComplete"), "add", [func():
		var _scope4: Dictionary = {}
		JS.invoke_method(JS.get_property(JS.get_property(JS.callback_receiver(self), "turret"), "animations"), "play", ["idleShotgun"])
		return null, self])
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["idleHomingMissile", ["turret12"], 24, false])
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["fireHomingMissile", ["turret13"], 24, false])
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["idleMine", ["turret14"], 24, false])
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["idleGatlingGun", ["turret15"], 24, false])
	JS.invoke_method(JS.get_property(JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "add", ["fireGatlingGun", ["turret15", "turret16"], 24, false]), "onComplete"), "add", [func():
		var _scope5: Dictionary = {"activeWeapon": null, "frameRate": null}
		_scope5["activeWeapon"] = JS.invoke_method(JS.get_property(JS.callback_receiver(self), "gameController"), "getActiveWeapon", [JS.get_property(JS.callback_receiver(self), "playerId")])
		if JS.truthy(_scope5["activeWeapon"]):
			_scope5["frameRate"] = JS.add(JS.get_property(JS.module("UIConstants"), "GATLING_GUN_MIN_ANIMATION_SPEED"), JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(JS.module("UIConstants"), "GATLING_GUN_ANIMATION_SPEED_RANGE")) * JS.number(JS.invoke_method(_scope5["activeWeapon"], "getField", ["weaponCharge"])))]))
			JS.invoke_method(JS.get_property(JS.get_property(JS.callback_receiver(self), "turret"), "animations"), "play", ["fireGatlingGun", _scope5["frameRate"]])
		return null, self])
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "anchor"), "setTo", [0.5, 0.5])
	JS.set_property(self, "leftTreadPosition", 0)
	JS.set_property(self, "rightTreadPosition", 0)
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uitanksprite.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20)
	return instance

func original_update():
	var _scope6: Dictionary = {"tank": null, "deltaTime": null, "ratio": null, "activeWeapon": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	_scope6["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope6["tank"]):
		JS.set_property(self, "smoothedX", (JS.number(JS.add((JS.number(JS.get_property(JS.get_property(self, "body"), "x")) * JS.number(JS.get_property(self, "smoothing"))), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope6["tank"], "getX", [])]))) / JS.number(JS.add(JS.get_property(self, "smoothing"), 1))))
		JS.set_property(self, "smoothedY", (JS.number(JS.add((JS.number(JS.get_property(JS.get_property(self, "body"), "y")) * JS.number(JS.get_property(self, "smoothing"))), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope6["tank"], "getY", [])]))) / JS.number(JS.add(JS.get_property(self, "smoothing"), 1))))
		JS.set_property(self, "smoothedRotation", (JS.number(JS.add((JS.number(JS.get_property(JS.get_property(self, "body"), "rotation")) * JS.number(JS.get_property(self, "smoothing"))), JS.invoke_method(_scope6["tank"], "getRotation", []))) / JS.number(JS.add(JS.get_property(self, "smoothing"), 1))))
		_scope6["deltaTime"] = JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")
		if JS.truthy(JS.compare(">", JS.invoke_method(_scope6["tank"], "getSpeed", []), 0)):
			_scope6["ratio"] = (JS.number(JS.invoke_method(_scope6["tank"], "getSpeed", [])) / JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "FORWARD_SPEED"), "m")))
			if JS.truthy(JS.compare("<", JS.invoke_method(_scope6["tank"], "getRotationSpeed", []), 0)):
				JS.set_property(self, "leftTreadPosition", JS.add(JS.get_property(self, "leftTreadPosition"), (JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_INNER_FORWARD_SPEED")))))
				JS.set_property(self, "rightTreadPosition", JS.add(JS.get_property(self, "rightTreadPosition"), (JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_FORWARD_SPEED")))))
			else:
				if JS.truthy(JS.compare(">", JS.invoke_method(_scope6["tank"], "getRotationSpeed", []), 0)):
					JS.set_property(self, "leftTreadPosition", JS.add(JS.get_property(self, "leftTreadPosition"), (JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_FORWARD_SPEED")))))
					JS.set_property(self, "rightTreadPosition", JS.add(JS.get_property(self, "rightTreadPosition"), (JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_INNER_FORWARD_SPEED")))))
				else:
					JS.set_property(self, "leftTreadPosition", JS.add(JS.get_property(self, "leftTreadPosition"), (JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_FORWARD_SPEED")))))
					JS.set_property(self, "rightTreadPosition", JS.add(JS.get_property(self, "rightTreadPosition"), (JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_FORWARD_SPEED")))))
		else:
			if JS.truthy(JS.compare("<", JS.invoke_method(_scope6["tank"], "getSpeed", []), 0)):
				_scope6["ratio"] = (JS.number(-(JS.invoke_method(_scope6["tank"], "getSpeed", []))) / JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "BACK_SPEED"), "m")))
				if JS.truthy(JS.compare("<", JS.invoke_method(_scope6["tank"], "getRotationSpeed", []), 0)):
					JS.set_property(self, "leftTreadPosition", (JS.number(JS.get_property(self, "leftTreadPosition")) - JS.number((JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_INNER_BACK_SPEED"))))))
					JS.set_property(self, "rightTreadPosition", (JS.number(JS.get_property(self, "rightTreadPosition")) - JS.number((JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_BACK_SPEED"))))))
				else:
					if JS.truthy(JS.compare(">", JS.invoke_method(_scope6["tank"], "getRotationSpeed", []), 0)):
						JS.set_property(self, "leftTreadPosition", (JS.number(JS.get_property(self, "leftTreadPosition")) - JS.number((JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_BACK_SPEED"))))))
						JS.set_property(self, "rightTreadPosition", (JS.number(JS.get_property(self, "rightTreadPosition")) - JS.number((JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_INNER_BACK_SPEED"))))))
					else:
						JS.set_property(self, "leftTreadPosition", (JS.number(JS.get_property(self, "leftTreadPosition")) - JS.number((JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_BACK_SPEED"))))))
						JS.set_property(self, "rightTreadPosition", (JS.number(JS.get_property(self, "rightTreadPosition")) - JS.number((JS.number((JS.number(_scope6["deltaTime"]) * JS.number(_scope6["ratio"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_BACK_SPEED"))))))
			else:
				if JS.truthy(JS.compare("<", JS.invoke_method(_scope6["tank"], "getRotationSpeed", []), 0)):
					JS.set_property(self, "leftTreadPosition", (JS.number(JS.get_property(self, "leftTreadPosition")) - JS.number((JS.number(_scope6["deltaTime"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_TURN_SPEED"))))))
					JS.set_property(self, "rightTreadPosition", JS.add(JS.get_property(self, "rightTreadPosition"), (JS.number(_scope6["deltaTime"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_TURN_SPEED")))))
				else:
					if JS.truthy(JS.compare(">", JS.invoke_method(_scope6["tank"], "getRotationSpeed", []), 0)):
						JS.set_property(self, "leftTreadPosition", JS.add(JS.get_property(self, "leftTreadPosition"), (JS.number(_scope6["deltaTime"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_TURN_SPEED")))))
						JS.set_property(self, "rightTreadPosition", (JS.number(JS.get_property(self, "rightTreadPosition")) - JS.number((JS.number(_scope6["deltaTime"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TREAD_TURN_SPEED"))))))
		JS.set_property(self, "leftTreadPosition", fmod(JS.add(fmod(JS.get_property(self, "leftTreadPosition"), 12), 12), 12))
		JS.set_property(self, "rightTreadPosition", fmod(JS.add(fmod(JS.get_property(self, "rightTreadPosition"), 12), 12), 12))
		JS.set_property(JS.get_property(self, "leftTreadShade"), "frameName", JS.add("treadShade", JS.invoke_method("@Math", "floor", [JS.get_property(self, "leftTreadPosition")])))
		JS.set_property(JS.get_property(self, "rightTreadShade"), "frameName", JS.add("treadShade", JS.invoke_method("@Math", "floor", [JS.get_property(self, "rightTreadPosition")])))
		_scope6["activeWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getActiveWeapon", [JS.get_property(self, "playerId")])
		if JS.truthy(_scope6["activeWeapon"]):
			var _switch0 = JS.invoke_method(_scope6["activeWeapon"], "getType", [])
			var _switch0_start = -1
			if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch0_start = 0
			while true:
				if _switch0_start >= 0 and _switch0_start <= 0:
					JS.invoke_method(self, "_updateTurret", [_scope6["activeWeapon"]])
					JS.invoke_method(self, "_updateWeaponSound", [_scope6["activeWeapon"]])
					break
				break
	JS.set_property(JS.get_property(self, "body"), "x", JS.get_property(self, "smoothedX"))
	JS.set_property(JS.get_property(self, "body"), "y", JS.get_property(self, "smoothedY"))
	JS.set_property(JS.get_property(self, "body"), "rotation", JS.get_property(self, "smoothedRotation"))
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope7: Dictionary = {"x": _arg0, "y": _arg1, "rotation": _arg2, "playerId": _arg3, "animate": _arg4, "smoothing": _arg5, "self": null}
	JS.invoke_method(self, "reset", [_scope7["x"], _scope7["y"]])
	JS.set_property(JS.get_property(self, "body"), "rotation", _scope7["rotation"])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.set_property(self, "smoothedX", _scope7["x"])
	JS.set_property(self, "smoothedY", _scope7["y"])
	JS.set_property(self, "smoothedRotation", _scope7["rotation"])
	JS.set_property(self, "smoothing", _scope7["smoothing"])
	JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["idleBullet"])
	if JS.truthy(_scope7["animate"]):
		JS.invoke_method(JS.get_property(self, "scale"), "setTo", [0.01, 0.01])
		JS.set_property(self, "spawnTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), "y": JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")}, JS.get_property(JS.module("UIConstants"), "CRATE_SPAWN_TIME"), JS.invoke_method(JS.module("UIUtils"), "easingCubicBezier", [0.01, 1.5, 1.5, 1]), true]))
		JS.invoke_method(JS.get_property(JS.get_property(self, "spawnTween"), "onComplete"), "add", [func():
			var _scope8: Dictionary = {}
			JS.invoke_method(JS.get_property(JS.get_property(JS.callback_receiver(self), "game"), "sound"), "play", ["tankLand", 0.6])
			JS.invoke_method(JS.get_property(JS.callback_receiver(self), "dustEmitter"), "spawn", [JS.get_property(JS.callback_receiver(self), "x"), JS.get_property(JS.callback_receiver(self), "y")])
			return null, self])
	JS.set_property(self, "playerId", _scope7["playerId"])
	_scope7["self"] = self
	JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
		var _scope9: Dictionary = {"result": _arg0}
		if JS.truthy(JS.equal(JS.type_of(_scope9["result"]), "object", false)):
			JS.set_property(_scope7["self"], "tint", JS.get_property(JS.invoke_method(_scope9["result"], "getBaseColour", []), "numericValue"))
			JS.set_property(JS.get_property(_scope7["self"], "turret"), "tint", JS.get_property(JS.invoke_method(_scope9["result"], "getTurretColour", []), "numericValue"))
			JS.set_property(JS.get_property(_scope7["self"], "leftTread"), "tint", JS.get_property(JS.invoke_method(_scope9["result"], "getTreadColour", []), "numericValue"))
			JS.set_property(JS.get_property(_scope7["self"], "rightTread"), "tint", JS.get_property(JS.invoke_method(_scope9["result"], "getTreadColour", []), "numericValue"))
		else:
			JS.set_property(_scope7["self"], "tint", JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_UNAVAILABLE_COLOUR"), "numericValue"))
			JS.set_property(JS.get_property(_scope7["self"], "turret"), "tint", JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_UNAVAILABLE_COLOUR"), "numericValue"))
			JS.set_property(JS.get_property(_scope7["self"], "leftTread"), "tint", JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_UNAVAILABLE_COLOUR"), "numericValue"))
			JS.set_property(JS.get_property(_scope7["self"], "rightTread"), "tint", JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_UNAVAILABLE_COLOUR"), "numericValue"))
		return null, func(_arg0 = null):
		var _scope10: Dictionary = {"result": _arg0}
		return null, func(_arg0 = null):
		var _scope11: Dictionary = {"result": _arg0}
		return null, JS.get_property(self, "playerId"), JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
	return null

func original_addWeapon(_arg0 = null, _arg1 = null):
	var _scope12: Dictionary = {"weapon": _arg0, "animate": _arg1, "activeWeapon": null, "defaultWeapon": null, "queuedWeapons": null}
	_scope12["activeWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getActiveWeapon", [JS.get_property(self, "playerId")])
	_scope12["defaultWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getDefaultWeapon", [JS.get_property(self, "playerId")])
	_scope12["queuedWeapons"] = JS.invoke_method(JS.get_property(self, "gameController"), "getQueuedWeapons", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope12["activeWeapon"]):
		if JS.truthy(_scope12["animate"]):
			if JS.truthy(JS.logical("||", func():
				var _scope13: Dictionary = {}
				return JS.logical("&&", func():
					var _scope14: Dictionary = {}
					return _scope12["defaultWeapon"]
					return null, func():
					var _scope15: Dictionary = {}
					return not JS.equal(JS.invoke_method(_scope12["weapon"], "getId", []), JS.invoke_method(_scope12["defaultWeapon"], "getId", []), true)
					return null)
				return null, func():
				var _scope16: Dictionary = {}
				return JS.compare(">", JS.get_property(_scope12["queuedWeapons"], "length"), 0)
				return null)):
				var _switch1 = JS.invoke_method(_scope12["weapon"], "getType", [])
				var _switch1_start = -1
				if JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch1_start = 0
				elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch1_start = 1
				elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch1_start = 2
				elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch1_start = 3
				elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch1_start = 4
				elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch1_start = 5
				while true:
					if _switch1_start >= 0 and _switch1_start <= 0:
						JS.invoke_method(JS.get_property(self, "pickupLaserSound"), "play", [])
						break
					if _switch1_start >= 0 and _switch1_start <= 1:
						JS.invoke_method(JS.get_property(self, "pickupDoubleBarrelSound"), "play", [])
						break
					if _switch1_start >= 0 and _switch1_start <= 2:
						JS.invoke_method(JS.get_property(self, "pickupShotgunSound"), "play", [])
						break
					if _switch1_start >= 0 and _switch1_start <= 3:
						JS.invoke_method(JS.get_property(self, "pickupMissileSound"), "play", [])
						break
					if _switch1_start >= 0 and _switch1_start <= 4:
						JS.invoke_method(JS.get_property(self, "pickupMineSound"), "play", [])
						break
					if _switch1_start >= 0 and _switch1_start <= 5:
						JS.invoke_method(JS.get_property(self, "pickupGatlingGunSound"), "play", [])
						break
					break
		if JS.truthy(JS.equal(JS.invoke_method(_scope12["weapon"], "getId", []), JS.invoke_method(_scope12["activeWeapon"], "getId", []), true)):
			JS.invoke_method(self, "_updateTurret", [_scope12["activeWeapon"]])
	return null

func original_removeWeapon():
	var _scope17: Dictionary = {"activeWeapon": null, "defaultWeapon": null}
	_scope17["activeWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getActiveWeapon", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope17["activeWeapon"]):
		_scope17["defaultWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getDefaultWeapon", [JS.get_property(self, "playerId")])
		if JS.truthy(not JS.equal(_scope17["activeWeapon"], _scope17["defaultWeapon"], true)):
			JS.invoke_method(JS.get_property(self, "loadWeaponSound"), "play", [])
		JS.invoke_method(self, "_updateTurret", [_scope17["activeWeapon"]])
	return null

func original_addUpgrade(_arg0 = null, _arg1 = null):
	var _scope18: Dictionary = {"upgrade": _arg0, "animate": _arg1}
	if JS.truthy(_scope18["animate"]):
		var _switch2 = JS.invoke_method(_scope18["upgrade"], "getType", [])
		var _switch2_start = -1
		if JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SHIELD"), true): _switch2_start = 0
		while true:
			if _switch2_start >= 0 and _switch2_start <= 0:
				JS.invoke_method(JS.get_property(self, "pickupShieldSound"), "play", [])
				break
			break
	return null

func original_fire():
	var _scope19: Dictionary = {"activeWeapon": null}
	_scope19["activeWeapon"] = JS.invoke_method(JS.get_property(self, "gameController"), "getActiveWeapon", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope19["activeWeapon"]):
		var _switch3 = JS.invoke_method(_scope19["activeWeapon"], "getType", [])
		var _switch3_start = -1
		if JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch3_start = 0
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch3_start = 1
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch3_start = 2
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch3_start = 3
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch3_start = 4
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch3_start = 5
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch3_start = 6
		while true:
			if _switch3_start >= 0 and _switch3_start <= 0:
				JS.invoke_method(JS.get_property(JS.get_property(self, "fireBulletSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "FIRE_BULLET_AUDIO_COUNT")))])), "play", [])
				JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["fireBullet"])
				break
			if _switch3_start >= 0 and _switch3_start <= 1:
				JS.invoke_method(JS.get_property(self, "fireLaserSound"), "play", [])
				break
			if _switch3_start >= 0 and _switch3_start <= 2:
				JS.invoke_method(JS.get_property(JS.get_property(self, "fireBulletSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "FIRE_BULLET_AUDIO_COUNT")))])), "play", [])
				if JS.truthy(JS.invoke_method(_scope19["activeWeapon"], "getField", ["leftBarrel"])):
					JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["fireDoubleBarrelLeft"])
				else:
					JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["fireDoubleBarrelRight"])
				break
			if _switch3_start >= 0 and _switch3_start <= 3:
				JS.invoke_method(JS.get_property(self, "fireShotgunSound"), "play", [])
				JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["fireShotgun"])
				break
			if _switch3_start >= 0 and _switch3_start <= 4:
				JS.invoke_method(JS.get_property(self, "fireMissileSound"), "play", [])
				JS.invoke_method(JS.get_property(self, "launchEmitter"), "spawn", [JS.get_property(self, "x"), JS.get_property(self, "y"), JS.get_property(self, "rotation")])
				JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["fireHomingMissile"])
				break
			if _switch3_start >= 0 and _switch3_start <= 5:
				JS.invoke_method(JS.get_property(self, "fireMineSound"), "play", [])
				break
			if _switch3_start >= 0 and _switch3_start <= 6:
				JS.invoke_method(JS.get_property(JS.get_property(self, "fireBulletSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "FIRE_BULLET_AUDIO_COUNT")))])), "play", [])
				break
			break
	return null

func original_emptyBarrel():
	var _scope20: Dictionary = {}
	JS.invoke_method(JS.get_property(JS.get_property(self, "emptyBarrelSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "EMPTY_BARREL_AUDIO_COUNT")))])), "play", [])
	return null

func original_remove():
	var _scope21: Dictionary = {}
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
	JS.invoke_method(JS.get_property(self, "holdGatlingGunSound"), "stop", [])
	JS.invoke_method(JS.get_property(self, "dischargeGatlingGunSound"), "stop", [])
	JS.invoke_method(self, "kill", [])
	return null

func original_retire():
	var _scope22: Dictionary = {}
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
	JS.invoke_method(JS.get_property(self, "holdGatlingGunSound"), "stop", [])
	JS.invoke_method(JS.get_property(self, "dischargeGatlingGunSound"), "stop", [])
	JS.invoke_method(self, "kill", [])
	return null

func original__updateTurret(_arg0 = null):
	var _scope23: Dictionary = {"weapon": _arg0, "weaponCharge": null, "frameRate": null}
	var _switch4 = JS.invoke_method(_scope23["weapon"], "getType", [])
	var _switch4_start = -1
	if JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch4_start = 0
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch4_start = 1
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch4_start = 2
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch4_start = 3
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch4_start = 4
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch4_start = 5
	elif JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch4_start = 6
	while true:
		if _switch4_start >= 0 and _switch4_start <= 0:
			JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["idleBullet"])
			break
		if _switch4_start >= 0 and _switch4_start <= 1:
			JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["idleLaser"])
			break
		if _switch4_start >= 0 and _switch4_start <= 2:
			JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["idleDoubleBarrel"])
			break
		if _switch4_start >= 0 and _switch4_start <= 3:
			JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["idleShotgun"])
			break
		if _switch4_start >= 0 and _switch4_start <= 4:
			if JS.truthy((not JS.truthy(JS.invoke_method(_scope23["weapon"], "getField", ["launched"])))):
				JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["idleHomingMissile"])
			else:
				JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["fireHomingMissile"])
			break
		if _switch4_start >= 0 and _switch4_start <= 5:
			JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["idleMine"])
			break
		if _switch4_start >= 0 and _switch4_start <= 6:
			_scope23["weaponCharge"] = JS.invoke_method(_scope23["weapon"], "getField", ["weaponCharge"])
			if JS.truthy(JS.compare(">", _scope23["weaponCharge"], 0)):
				_scope23["frameRate"] = JS.add(JS.get_property(JS.module("UIConstants"), "GATLING_GUN_MIN_ANIMATION_SPEED"), JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(JS.module("UIConstants"), "GATLING_GUN_ANIMATION_SPEED_RANGE")) * JS.number(_scope23["weaponCharge"]))]))
				JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["fireGatlingGun", _scope23["frameRate"]])
			else:
				JS.invoke_method(JS.get_property(JS.get_property(self, "turret"), "animations"), "play", ["idleGatlingGun"])
			break
		break
	return null

func original__updateWeaponSound(_arg0 = null):
	var _scope24: Dictionary = {"weapon": _arg0, "weaponCharge": null, "startPosition": null}
	var _switch5 = JS.invoke_method(_scope24["weapon"], "getType", [])
	var _switch5_start = -1
	if JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch5_start = 0
	while true:
		if _switch5_start >= 0 and _switch5_start <= 0:
			_scope24["weaponCharge"] = JS.invoke_method(_scope24["weapon"], "getField", ["weaponCharge"])
			if JS.truthy(JS.invoke_method(_scope24["weapon"], "getField", ["triggerPulled"])):
				if JS.truthy(JS.compare("<", _scope24["weaponCharge"], 1)):
					_scope24["startPosition"] = (JS.number(_scope24["weaponCharge"]) * JS.number(0.6))
					JS.invoke_method(JS.get_property(self, "chargeGatlingGunSound"), "play", ["", _scope24["startPosition"], 0.6, false, false])
					JS.invoke_method(JS.get_property(self, "holdGatlingGunSound"), "stop", [])
					JS.invoke_method(JS.get_property(self, "dischargeGatlingGunSound"), "stop", [])
				else:
					JS.invoke_method(JS.get_property(self, "chargeGatlingGunSound"), "stop", [])
					JS.invoke_method(JS.get_property(self, "holdGatlingGunSound"), "play", ["", 0, 0.6, true, false])
					JS.invoke_method(JS.get_property(self, "dischargeGatlingGunSound"), "stop", [])
			else:
				if JS.truthy(JS.compare(">", _scope24["weaponCharge"], 0)):
					_scope24["startPosition"] = JS.add((JS.number((JS.number(1) - JS.number(_scope24["weaponCharge"]))) * JS.number(2)), 0.1)
					JS.invoke_method(JS.get_property(self, "chargeGatlingGunSound"), "stop", [])
					JS.invoke_method(JS.get_property(self, "holdGatlingGunSound"), "stop", [])
					JS.invoke_method(JS.get_property(self, "dischargeGatlingGunSound"), "play", ["", _scope24["startPosition"], 0.6, false, false])
			break
		break
	return null
