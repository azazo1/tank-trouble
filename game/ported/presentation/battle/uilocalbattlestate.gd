# 由原版 UILocalBattleState 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/presentation/battle/uibattleentities.gd"

static var _static_UILocalBattleState: Dictionary = {}
static var _initialized_UILocalBattleState = false
static func initialize_original_static():
	if _initialized_UILocalBattleState: return
	_initialized_UILocalBattleState = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UILocalBattleState.has(key): return _static_UILocalBattleState[key]
	return JS.get_property(JS.module("UIBattleEntities"), key)
static func original_static_set(key, value):
	_static_UILocalBattleState[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {}
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/battle/uilocalbattlestate.gd").new()
	instance._construct_create()
	return instance

func original_init(_arg0 = null):
	var _scope1: Dictionary = {"gameController": _arg0}
	JS.set_property(self, "gameController", _scope1["gameController"])
	return null

func original_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope2: Dictionary = {"i": null, "dustEmitter": null, "missileLaunchEmitter": null, "missile": null, "missileSmokeEmitter": null}
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UIGameState"]))
	JS.invoke_method(JS.module("UIUtils"), "initUIGamePhysics", [JS.get_property(self, "game")])
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "COUNT_DOWN_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "countDownSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("countDown", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "EMPTY_BARREL_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "emptyBarrelSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("emptyBarrel", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "FIRE_BULLET_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "fireBulletSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("fireBullet", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "BULLET_BOUNCE_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "bulletBounceSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("bulletBounce", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "SHIELD_IMPACT_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "shieldImpactSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("shieldImpact", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	JS.set_property(self, "fireLaserSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["fireLaser", 0.5]))
	JS.set_property(self, "fireShotgunSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["fireShotgun"]))
	JS.set_property(self, "fireMissileSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["fireMissile"]))
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "TANK_POOL_SIZE"))):
		JS.set_property(JS.get_property(self, "chargeGatlingGunSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["chargeGatlingGun"]))
		JS.set_property(JS.get_property(self, "holdGatlingGunSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["holdGatlingGun"]))
		JS.set_property(JS.get_property(self, "dischargeGatlingGunSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["dischargeGatlingGun"]))
		JS.increment(_scope2, "i", 1, false)
	JS.set_property(self, "homingMissileTargetChangeSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["homingMissileTargetChange"]))
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "MISSILE_TARGETING_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "homingMissileTargetingSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("homingMissileTargeting", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	JS.set_property(self, "fireMineSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["fireMine"]))
	JS.set_property(self, "mineActivateSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["mineActivate"]))
	JS.set_property(self, "mineTripSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["mineTrip"]))
	JS.set_property(self, "mineDetonateSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["mineDetonate"]))
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "MINE_EXPLOSION_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "mineExplosionSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("mineExplosion", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "SHRAPNEL_HIT_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "shrapnelHitSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("shrapnelHit", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	JS.set_property(self, "laserPickupSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["laserPickup"]))
	JS.set_property(self, "doubleBarrelPickupSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["doubleBarrelPickup"]))
	JS.set_property(self, "shotgunPickupSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["shotgunPickup"]))
	JS.set_property(self, "missilePickupSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["missilePickup"]))
	JS.set_property(self, "minePickupSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["minePickup"]))
	JS.set_property(self, "gatlingGunPickupSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["gatlingGunPickup"]))
	JS.set_property(self, "shieldPickupSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["shieldPickup"]))
	JS.set_property(self, "weaponLoadSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["weaponLoad"]))
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "TANK_EXPLOSION_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "tankExplosionSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("tankExplosion", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "BULLET_PUFF_AUDIO_COUNT"))):
		JS.set_property(JS.get_property(self, "bulletPuffSounds"), _scope2["i"], JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", [JS.add("bulletPuff", _scope2["i"])]))
		JS.increment(_scope2, "i", 1, false)
	JS.set_property(self, "chickenOutSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["chickenOut"]))
	JS.set_property(self, "shieldActivateSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["shieldActivate"]))
	JS.set_property(self, "shieldWeakenedSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["shieldWeakened"]))
	JS.set_property(self, "shieldEndSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["shieldEnd"]))
	JS.set_property(self, "spawnZoneTearingSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["spawnZoneTear"]))
	JS.set_property(self, "spawnZoneOpenSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["spawnZoneOpen"]))
	JS.set_property(self, "spawnZoneUnstableSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["spawnZoneUnstable"]))
	JS.set_property(self, "spawnZoneCollapseSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["spawnZoneCollapse"]))
	JS.set_property(self, "winnerCelebrationSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["winnerCelebration"]))
	JS.set_property(self, "tieSound", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "audio", ["poop"]))
	JS.set_property(self, "gameGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", []))
	JS.set_property(self, "overlayGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", []))
	JS.set_property(JS.get_property(self, "overlayGroup"), "fixedToCamera", true)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "COUNTER_TIMER_POOL_SIZE"))):
		JS.increment(_scope2, "i", 1, false)
	JS.set_property(self, "roundTitleGroup", JS.invoke_method(JS.get_property(self, "overlayGroup"), "add", [JS.construct(JS.module("UIRoundTitleGroup"), [JS.get_property(self, "game")])]))
	JS.set_property(self, "countDownGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "overlayGroup")]))
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "COUNT_DOWN_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "countDownGroup"), "add", [JS.construct(JS.module("UICountDownImage"), [JS.get_property(self, "game")])])
		JS.increment(_scope2, "i", 1, false)
	JS.set_property(self, "leaveGameGroup", JS.invoke_method(JS.get_property(self, "overlayGroup"), "add", [JS.construct(JS.module("UIButtonGroup"), [JS.get_property(self, "game"), (JS.number(JS.get_property(JS.get_property(self, "game"), "width")) - JS.number(JS.get_property(JS.module("UIConstants"), "LEAVE_GAME_MARGIN"))), JS.get_property(JS.module("UIConstants"), "LEAVE_GAME_MARGIN"), "Warning", JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"), "X", func():
		var _scope3: Dictionary = {}
		JS.invoke_method(JS.get_property(JS.callback_receiver(self), "gameController"), "endGame", [])
		return null, self, 0, JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "ESC")])]))
	JS.invoke_method(JS.get_property(self, "leaveGameGroup"), "spawn", [])
	JS.set_property(self, "mazeFloorGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "rubbleGroup", JS.invoke_method(JS.get_property(self, "gameGroup"), "add", [JS.construct(JS.module("UIRubbleGroup"), [JS.get_property(self, "game")])]))
	JS.set_property(self, "dustGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "crateGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "mineGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "tankGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "projectileGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "shrapnelGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "missileSmokeGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "missileGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "aimerGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "laserGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "mazeWallGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "tankExplosionGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "bulletPuffGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "missileLaunchGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "explosionGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "tankFeatherGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "mazeWallDecorationGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "shieldGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "shieldSparkGroup", JS.invoke_method(JS.get_property(self, "gameGroup"), "add", [JS.construct(JS.module("UIShieldSparkGroup"), [JS.get_property(self, "game")])]))
	JS.set_property(self, "tankNameGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	JS.set_property(self, "weaponSymbolGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [JS.get_property(self, "gameGroup")]))
	_scope2["dustEmitter"] = JS.invoke_method(JS.get_property(self, "dustGroup"), "add", [JS.construct(JS.module("UIDustEmitter"), [JS.get_property(self, "game")])])
	_scope2["missileLaunchEmitter"] = JS.invoke_method(JS.get_property(self, "missileLaunchGroup"), "add", [JS.construct(JS.module("UIMissileLaunchEmitter"), [JS.get_property(self, "game")])])
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "SPAWN_ZONE_POOL_SIZE"))):
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "CRATE_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "crateGroup"), "add", [JS.construct(JS.module("UICrateSprite"), [JS.get_property(self, "game"), JS.get_property(self, "gameController"), _scope2["dustEmitter"]])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "GOLD_POOL_SIZE"))):
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "DIAMOND_SHINE_POOL_SIZE"))):
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "DIAMOND_POOL_SIZE"))):
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "SPARKLE_POOL_SIZE"))):
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "PROJECTILE_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "projectileGroup"), "add", [JS.construct(JS.module("UIProjectileImage"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "SHRAPNEL_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "shrapnelGroup"), "add", [JS.construct(JS.module("UIShrapnelImage"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "MISSILE_POOL_SIZE"))):
		_scope2["missile"] = JS.invoke_method(JS.get_property(self, "missileGroup"), "add", [JS.construct(JS.module("UIMissileImage"), [JS.get_property(self, "game"), JS.get_property(self, "gameController"), JS.get_property(self, "homingMissileTargetingSounds")])])
		_scope2["missileSmokeEmitter"] = JS.invoke_method(JS.get_property(self, "missileSmokeGroup"), "add", [JS.construct(JS.module("UIColouredSmokeEmitter"), [JS.get_property(self, "game"), _scope2["missile"], JS.get_property(JS.module("UIConstants"), "MISSILE_SMOKE_COLOUR")])])
		JS.invoke_method(_scope2["missile"], "setSmokeEmitter", [_scope2["missileSmokeEmitter"]])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "MINE_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "mineGroup"), "add", [JS.construct(JS.module("UIMineSprite"), [JS.get_property(self, "game"), JS.get_property(self, "gameController"), JS.get_property(self, "mineActivateSound"), JS.get_property(self, "mineTripSound"), JS.get_property(self, "mineDetonateSound")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "AIMER_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "aimerGroup"), "add", [JS.construct(JS.module("UIAimerGraphics"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "LASER_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "laserGroup"), "add", [JS.construct(JS.module("UILaserGraphics"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "TANK_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "tankGroup"), "add", [JS.construct(JS.module("UITankSprite"), [JS.get_property(self, "game"), JS.get_property(self, "gameController"), JS.get_property(self, "emptyBarrelSounds"), JS.get_property(self, "fireBulletSounds"), JS.get_property(self, "fireLaserSound"), JS.get_property(self, "fireShotgunSound"), JS.get_property(self, "fireMissileSound"), JS.get_property(self, "fireMineSound"), JS.get_property(JS.get_property(self, "chargeGatlingGunSounds"), _scope2["i"]), JS.get_property(JS.get_property(self, "holdGatlingGunSounds"), _scope2["i"]), JS.get_property(JS.get_property(self, "dischargeGatlingGunSounds"), _scope2["i"]), JS.get_property(self, "laserPickupSound"), JS.get_property(self, "doubleBarrelPickupSound"), JS.get_property(self, "shotgunPickupSound"), JS.get_property(self, "missilePickupSound"), JS.get_property(self, "minePickupSound"), JS.get_property(self, "gatlingGunPickupSound"), JS.get_property(self, "shieldPickupSound"), JS.get_property(self, "weaponLoadSound"), _scope2["dustEmitter"], _scope2["missileLaunchEmitter"]])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "TANK_EXPLOSION_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "tankExplosionGroup"), "add", [JS.construct(JS.module("UITankExplosionGroup"), [JS.get_property(self, "game"), JS.get_property(self, "tankExplosionSounds")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "BULLET_PUFF_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "bulletPuffGroup"), "add", [JS.construct(JS.module("UIPuffSprite"), [JS.get_property(self, "game")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "EXPLOSION_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "explosionGroup"), "add", [JS.construct(JS.module("UIExplosionGroup"), [JS.get_property(self, "game")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "TANK_FEATHER_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "tankFeatherGroup"), "add", [JS.construct(JS.module("UITankFeatherSprite"), [JS.get_property(self, "game")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "SHIELD_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "shieldGroup"), "add", [JS.construct(JS.module("UIShieldSprite"), [JS.get_property(self, "game"), JS.get_property(self, "gameController"), JS.get_property(self, "shieldActivateSound"), JS.get_property(self, "shieldWeakenedSound"), JS.get_property(self, "shieldEndSound")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "TANK_NAME_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "tankNameGroup"), "add", [JS.construct(JS.module("UITankNameGroup"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])])
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "CHAT_SYMBOL_POOL_SIZE"))):
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.module("UIConstants"), "WEAPON_SYMBOL_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "weaponSymbolGroup"), "add", [JS.construct(JS.module("UIWeaponSymbolGroup"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])])
		JS.increment(_scope2, "i", 1, false)
	JS.invoke_method(JS.module("QualityManager"), "reset", [])
	JS.invoke_method(JS.module("GameManager"), "setGameController", [JS.get_property(self, "gameController")])
	JS.invoke_method(JS.get_property(self, "gameController"), "addGameEventListener", [JS.get_property(self, "_gameEventHandler"), self])
	JS.invoke_method(JS.get_property(self, "gameController"), "addRoundEventListener", [JS.get_property(self, "_roundEventHandler"), self])
	JS.set_property(self, "waitingTime", 0)
	JS.set_property(self, "betweenRoundsDuration", 0)
	JS.set_property(self, "roundEnded", false)
	JS.set_property(self, "celebrationDuration", JS.get_property(JS.module("UIConstants"), "WAITING_FOR_CELEBRATION_TIME"))
	JS.set_property(self, "roundTitleDelayDuration", 0)
	JS.set_property(self, "roundTitleShown", false)
	JS.set_property(self, "nextVictoryAward", null)
	JS.set_property(self, "cameraShake", 0)
	return null

func original_shutdown():
	var _scope4: Dictionary = {}
	JS.invoke_method(self, "_retireUI", [])
	JS.invoke_method(JS.get_property(self, "gameController"), "removeGameEventListener", [JS.get_property(self, "_gameEventHandler"), self])
	JS.invoke_method(JS.get_property(self, "gameController"), "removeRoundEventListener", [JS.get_property(self, "_roundEventHandler"), self])
	JS.invoke_method(JS.module("AIs"), "removeAllAIManagers", [])
	return null

func original__onSizeChangeHandler():
	var _scope5: Dictionary = {"localBounds": null, "unscaledMazeWidth": null, "unscaledMazeHeight": null, "unscaledMazeOffsetX": null, "unscaledMazeOffsetY": null, "gameScale": null}
	JS.invoke_method(JS.get_property(self, "log"), "debug", ["SIZE CHANGE!"])
	_scope5["localBounds"] = JS.invoke_method(JS.get_property(self, "gameGroup"), "getLocalBounds", [])
	_scope5["unscaledMazeWidth"] = JS.get_property(_scope5["localBounds"], "width")
	_scope5["unscaledMazeHeight"] = JS.get_property(_scope5["localBounds"], "height")
	_scope5["unscaledMazeOffsetX"] = -(JS.get_property(_scope5["localBounds"], "x"))
	_scope5["unscaledMazeOffsetY"] = -(JS.get_property(_scope5["localBounds"], "y"))
	_scope5["gameScale"] = JS.invoke_method("@Math", "min", [2, JS.invoke_method("@Math", "min", [(JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "width")) - JS.number(JS.get_property(JS.module("UIConstants"), "MAZE_SIDE_MARGIN")))) / JS.number(_scope5["unscaledMazeWidth"])), (JS.number((JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "height")) - JS.number(JS.get_property(JS.module("UIConstants"), "MAZE_BOTTOM_MARGIN")))) - JS.number(JS.get_property(JS.module("UIConstants"), "MAZE_TOP_MARGIN")))) / JS.number(_scope5["unscaledMazeHeight"]))])])
	JS.set_property(_scope5, "gameScale", (JS.number(JS.invoke_method("@Math", "floor", [(JS.number(_scope5["gameScale"]) * JS.number(100))])) / JS.number(100)))
	JS.invoke_method(JS.get_property(JS.get_property(self, "gameGroup"), "scale"), "set", [_scope5["gameScale"], _scope5["gameScale"]])
	JS.invoke_method(JS.get_property(JS.get_property(self, "gameGroup"), "position"), "set", [JS.invoke_method("@Math", "ceil", [JS.add((JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "width")) - JS.number(JS.get_property(JS.get_property(self, "gameGroup"), "width")))) * JS.number(0.5)), (JS.number(_scope5["unscaledMazeOffsetX"]) * JS.number(_scope5["gameScale"])))]), JS.invoke_method("@Math", "ceil", [JS.add(JS.get_property(JS.module("UIConstants"), "MAZE_TOP_MARGIN"), (JS.number(_scope5["unscaledMazeOffsetY"]) * JS.number(_scope5["gameScale"])))])])
	JS.invoke_method(JS.get_property(JS.get_property(self, "roundTitleGroup"), "position"), "set", [(JS.number(JS.get_property(JS.get_property(self, "game"), "width")) / JS.number(2)), JS.add((JS.number(JS.get_property(JS.get_property(self, "game"), "height")) / JS.number(2)), JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_OFFSET"))])
	JS.invoke_method(JS.get_property(JS.get_property(self, "countDownGroup"), "position"), "set", [(JS.number(JS.get_property(JS.get_property(self, "game"), "width")) / JS.number(2)), (JS.number(JS.get_property(JS.get_property(self, "game"), "height")) / JS.number(2))])
	JS.set_property(JS.get_property(JS.get_property(self, "leaveGameGroup"), "position"), "x", (JS.number(JS.get_property(JS.get_property(self, "game"), "width")) - JS.number(JS.get_property(JS.module("UIConstants"), "LEAVE_GAME_MARGIN"))))
	return null

func original_update():
	var _scope6: Dictionary = {"shakeX": null, "shakeY": null, "tanks": null, "tank": null}
	JS.invoke_method(JS.module("QualityManager"), "update", [])
	JS.invoke_method(JS.module("Inputs"), "update", [])
	JS.invoke_method(JS.module("AIs"), "update", [JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")])
	JS.invoke_method(JS.get_property(self, "gameController"), "update", [])
	if JS.truthy(JS.compare(">=", JS.get_property(self, "cameraShake"), 0)):
		_scope6["shakeX"] = (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(self, "cameraShake")))) - JS.number((JS.number(JS.get_property(self, "cameraShake")) / JS.number(2))))
		_scope6["shakeY"] = (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(self, "cameraShake")))) - JS.number((JS.number(JS.get_property(self, "cameraShake")) / JS.number(2))))
		JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "world"), "setBounds", [_scope6["shakeX"], _scope6["shakeY"], JS.add(JS.get_property(JS.get_property(self, "game"), "width"), _scope6["shakeX"]), JS.add(JS.get_property(JS.get_property(self, "game"), "height"), _scope6["shakeY"])])
		JS.set_property(self, "cameraShake", (JS.number(JS.get_property(self, "cameraShake")) - JS.number(JS.get_property(JS.module("UIConstants"), "CAMERA_SHAKE_FADE"))))
	_scope6["tanks"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTanks", [])
	for _iteration0 in JS.keys(_scope6["tanks"]):
		JS.set_property(_scope6, "tank", _iteration0)
		if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "INVERSE_RUBBLE_SPAWN_PROBABILITY_IN_THE_OPEN"))):
			JS.invoke_method(self, "_spawnRubble", [JS.get_property(_scope6["tanks"], _scope6["tank"])])
	return null

func original__retireUI():
	var _scope7: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "leaveGameGroup"), "retire", [])
	JS.invoke_method(self, "_cleanUp", [])
	return null

func original__gameEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope8: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3}
	JS.invoke_method(JS.get_property(_scope8["self"], "log"), "debug", [JS.add(JS.add(JS.add(JS.add(JS.add("Game ", _scope8["id"]), ": "), _scope8["evt"]), ": "), _scope8["data"])])
	var _switch1 = _scope8["evt"]
	var _switch1_start = -1
	if JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "COUNT_DOWN"), true): _switch1_start = 0
	elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_ENDED"), true): _switch1_start = 1
	while true:
		if _switch1_start >= 0 and _switch1_start <= 0:
			if JS.truthy(JS.equal(_scope8["data"], JS.get_property(JS.module("Constants"), "COUNTDOWN_START_VALUE"), true)):
				JS.invoke_method(_scope8["self"], "_spawnRoundTitle", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "GAME_MODE_NAME_INFO"), JS.invoke_method(JS.get_property(_scope8["self"], "gameController"), "getMode", [])), "NAME"), JS.invoke_method(JS.get_property(_scope8["self"], "gameController"), "getRanked", [])])
			JS.invoke_method(_scope8["self"], "_spawnCountDown", [_scope8["data"]])
			break
		if _switch1_start >= 0 and _switch1_start <= 1:
			JS.invoke_method(_scope8["self"], "_leaveState", [])
			break
		break
	return null

func original__roundEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope9: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3, "i": null, "playerId": null, "smoothing": null, "tankPosition": null, "projectileIds": null, "trapIds": null, "trap": null, "shieldedTank": null, "shieldedTankA": null, "shieldedTankB": null}
	JS.invoke_method(JS.get_property(_scope9["self"], "log"), "debug", [JS.add(JS.add(JS.add(JS.add(JS.add("Round ", _scope9["id"]), ": "), _scope9["evt"]), ": "), _scope9["data"])])
	var _switch2 = _scope9["evt"]
	var _switch2_start = -1
	if JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_CREATED"), true): _switch2_start = 0
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_STARTED"), true): _switch2_start = 1
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_ENDED"), true): _switch2_start = 2
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "MAZE_SET"), true): _switch2_start = 3
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CHANGED"), true): _switch2_start = 4
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CREATED"), true): _switch2_start = 5
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_DESTROYED"), true): _switch2_start = 6
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_KILLED"), true): _switch2_start = 7
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CHICKENED_OUT"), true): _switch2_start = 8
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_CREATED"), true): _switch2_start = 9
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_DESTROYED"), true): _switch2_start = 10
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_TIMEOUT"), true): _switch2_start = 11
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_CREATED"), true): _switch2_start = 12
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_DESTROYED"), true): _switch2_start = 13
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COLLECTIBLE_CREATED"), true): _switch2_start = 14
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COLLECTIBLE_DESTROYED"), true): _switch2_start = 15
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_SHIELD_COLLISION"), true): _switch2_start = 16
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_SHIELD_COLLISION"), true): _switch2_start = 17
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_ZONE_COLLISION"), true): _switch2_start = 18
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "SHIELD_SHIELD_COLLISION"), true): _switch2_start = 19
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "SHIELD_ZONE_COLLISION"), true): _switch2_start = 20
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_MAZE_COLLISION"), true): _switch2_start = 21
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_MAZE_COLLISION"), true): _switch2_start = 22
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TANK_COLLISION"), true): _switch2_start = 23
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_ZONE_COLLISION"), true): _switch2_start = 24
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "WEAPON_CREATED"), true): _switch2_start = 25
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "WEAPON_DESTROYED"), true): _switch2_start = 26
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_CREATED"), true): _switch2_start = 27
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_DESTROYED"), true): _switch2_start = 28
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_FIRED"), true): _switch2_start = 29
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_DELAYED_FIRE"), true): _switch2_start = 30
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_EMPTY"), true): _switch2_start = 31
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "HOMING_MISSILE_TARGET_CHANGED"), true): _switch2_start = 32
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_ACTIVATED"), true): _switch2_start = 33
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_TRIPPED"), true): _switch2_start = 34
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_DETONATED"), true): _switch2_start = 35
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_ACTIVATED"), true): _switch2_start = 36
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_WEAKENED"), true): _switch2_start = 37
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_STRENGTHENED"), true): _switch2_start = 38
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Zone"), "_EVENTS"), "ZONE_ENTERED"), true): _switch2_start = 39
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Zone"), "_EVENTS"), "ZONE_LEFT"), true): _switch2_start = 40
	while true:
		if _switch2_start >= 0 and _switch2_start <= 0:
			JS.invoke_method(_scope9["self"], "_cleanUp", [])
			JS.set_property(_scope9["self"], "roundEnded", false)
			JS.set_property(_scope9["self"], "nextVictoryAward", null)
			break
		if _switch2_start >= 0 and _switch2_start <= 1:
			JS.invoke_method(JS.module("Inputs"), "reset", [])
			JS.invoke_method(JS.module("AIs"), "reset", [])
			JS.invoke_method(_scope9["self"], "_spawnCountDown", [0])
			break
		if _switch2_start >= 0 and _switch2_start <= 2:
			JS.set_property(_scope9["self"], "roundEnded", true)
			if JS.truthy(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GAME_MODE_INFO"), JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getMode", [])), "HAS_CELEBRATION")):
				JS.set_property(_scope9["self"], "nextVictoryAward", _scope9["data"])
			else:
				_scope9["i"] = 0
				while JS.truthy(JS.compare("<", _scope9["i"], JS.get_property(JS.invoke_method(_scope9["data"], "getPlayerIds", []), "length"))):
					_scope9["playerId"] = JS.get_property(JS.invoke_method(_scope9["data"], "getPlayerIds", []), _scope9["i"])
					JS.increment(_scope9, "i", 1, false)
			JS.set_property(JS.get_property(JS.get_property(JS.get_property(_scope9["self"], "game"), "physics"), "arcade"), "isPaused", true)
			JS.set_property(JS.get_property(JS.get_property(JS.get_property(_scope9["self"], "game"), "physics"), "p2"), "paused", true)
			JS.invoke_method(JS.get_property(JS.get_property(_scope9["self"], "game"), "tweens"), "removeAll", [])
			JS.invoke_method(JS.get_property(JS.get_property(_scope9["self"], "game"), "sound"), "stopAll", [])
			break
		if _switch2_start >= 0 and _switch2_start <= 3:
			if JS.truthy((not JS.truthy(JS.get_property(_scope9["self"], "maze")))):
				JS.set_property(_scope9["self"], "maze", _scope9["data"])
				JS.invoke_method(_scope9["self"], "_createMaze", [_scope9["data"]])
				JS.invoke_method(_scope9["self"], "_updateTheme", [JS.invoke_method(_scope9["data"], "getTheme", [])])
				JS.invoke_method(_scope9["self"], "_onSizeChangeHandler", [])
			else:
				JS.invoke_method(JS.get_property(_scope9["self"], "log"), "debug", ["Attempt to set new maze when maze was already set."])
			break
		if _switch2_start >= 0 and _switch2_start <= 4:
			break
		if _switch2_start >= 0 and _switch2_start <= 5:
			_scope9["smoothing"] = (JS.get_property(JS.module("UIConstants"), "TANK_LOCAL_SMOOTHING") if JS.truthy(JS.logical("||", func():
				var _scope10: Dictionary = {}
				return true
				return null, func():
				var _scope11: Dictionary = {}
				return true
				return null)) else JS.get_property(JS.module("UIConstants"), "TANK_ONLINE_SMOOTHING"))
			JS.invoke_method(_scope9["self"], "_createTank", [_scope9["data"], JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getInitialRoundStateReceived", []), _scope9["smoothing"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 6:
			if JS.truthy(JS.invoke_method(_scope9["self"], "_removeTank", [_scope9["data"]])):
				JS.invoke_method(_scope9["self"], "_spawnTankExplosion", [_scope9["data"]])
				JS.invoke_method(_scope9["self"], "_addCameraShake", [JS.get_property(JS.module("UIConstants"), "TANK_EXPLOSION_CAMERA_SHAKE")])
			break
		if _switch2_start >= 0 and _switch2_start <= 7:
			if JS.truthy(JS.invoke_method(_scope9["self"], "_removeTank", [JS.invoke_method(_scope9["data"], "getVictimPlayerId", [])])):
				JS.invoke_method(_scope9["self"], "_spawnTankExplosion", [JS.invoke_method(_scope9["data"], "getVictimPlayerId", [])])
				JS.invoke_method(_scope9["self"], "_addCameraShake", [JS.get_property(JS.module("UIConstants"), "TANK_EXPLOSION_CAMERA_SHAKE")])
			break
		if _switch2_start >= 0 and _switch2_start <= 8:
			_scope9["tankPosition"] = JS.invoke_method(_scope9["self"], "_getTankPosition", [JS.invoke_method(_scope9["data"], "getPlayerId", [])])
			if JS.truthy(JS.invoke_method(_scope9["self"], "_removeTank", [JS.invoke_method(_scope9["data"], "getPlayerId", [])])):
				JS.invoke_method(_scope9["self"], "_spawnTankFeathers", [JS.invoke_method(_scope9["data"], "getPlayerId", []), _scope9["tankPosition"]])
			_scope9["projectileIds"] = JS.invoke_method(_scope9["data"], "getProjectileIds", [])
			_scope9["i"] = 0
			while JS.truthy(JS.compare("<", _scope9["i"], JS.get_property(_scope9["projectileIds"], "length"))):
				JS.invoke_method(_scope9["self"], "_removeProjectile", [JS.get_property(_scope9["projectileIds"], _scope9["i"])])
				JS.increment(_scope9, "i", 1, false)
			_scope9["trapIds"] = JS.invoke_method(_scope9["data"], "getTrapIds", [])
			_scope9["i"] = 0
			while JS.truthy(JS.compare("<", _scope9["i"], JS.get_property(_scope9["trapIds"], "length"))):
				JS.invoke_method(_scope9["self"], "_removeTrap", [JS.get_property(_scope9["trapIds"], _scope9["i"])])
				JS.increment(_scope9, "i", 1, false)
			break
		if _switch2_start >= 0 and _switch2_start <= 9:
			JS.invoke_method(_scope9["self"], "_createProjectile", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 10:
			JS.invoke_method(_scope9["self"], "_removeProjectile", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 11:
			JS.invoke_method(_scope9["self"], "_removeProjectile", [_scope9["data"]])
			JS.invoke_method(_scope9["self"], "_spawnProjectilePuffs", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 12:
			JS.invoke_method(_scope9["self"], "_createTrap", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 13:
			_scope9["trap"] = JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getTrap", [_scope9["data"]])
			if JS.truthy(_scope9["trap"]):
				if JS.truthy(JS.invoke_method(_scope9["trap"], "released", [])):
					JS.invoke_method(_scope9["self"], "_releaseTrap", [_scope9["trap"]])
			JS.invoke_method(_scope9["self"], "_removeTrap", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 14:
			JS.invoke_method(_scope9["self"], "_createCollectible", [_scope9["data"], JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getInitialRoundStateReceived", [])])
			break
		if _switch2_start >= 0 and _switch2_start <= 15:
			JS.invoke_method(_scope9["self"], "_removeCollectible", [JS.invoke_method(_scope9["data"], "getCollectibleId", [])])
			break
		if _switch2_start >= 0 and _switch2_start <= 16:
			_scope9["shieldedTank"] = JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getTank", [JS.invoke_method(JS.get_property(_scope9["data"], "shieldA"), "getPlayerId", [])])
			if JS.truthy(_scope9["shieldedTank"]):
				if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "INVERSE_SHIELD_SPARK_PROBABILITY_IN_COLLISION"))):
					JS.invoke_method(_scope9["self"], "_bounceTankOnShield", [JS.get_property(_scope9["data"], "tankA"), _scope9["shieldedTank"], JS.get_property(_scope9["data"], "collisionPoint"), true])
				if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "INVERSE_RUBBLE_SPAWN_PROBABILITY_IN_COLLISION"))):
					JS.invoke_method(_scope9["self"], "_spawnRubble", [JS.get_property(_scope9["data"], "tankA")])
			break
		if _switch2_start >= 0 and _switch2_start <= 17:
			_scope9["shieldedTank"] = JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getTank", [JS.invoke_method(JS.get_property(_scope9["data"], "shieldA"), "getPlayerId", [])])
			if JS.truthy(_scope9["shieldedTank"]):
				JS.invoke_method(_scope9["self"], "_bounceProjectileOnShield", [JS.get_property(_scope9["data"], "projectile"), _scope9["shieldedTank"], JS.get_property(_scope9["data"], "collisionPoint")])
			break
		if _switch2_start >= 0 and _switch2_start <= 18:
			break
		if _switch2_start >= 0 and _switch2_start <= 19:
			_scope9["shieldedTankA"] = JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getTank", [JS.invoke_method(JS.get_property(_scope9["data"], "shieldA"), "getPlayerId", [])])
			_scope9["shieldedTankB"] = JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getTank", [JS.invoke_method(JS.get_property(_scope9["data"], "shieldB"), "getPlayerId", [])])
			if JS.truthy(JS.logical("&&", func():
				var _scope12: Dictionary = {}
				return _scope9["shieldedTankA"]
				return null, func():
				var _scope13: Dictionary = {}
				return _scope9["shieldedTankB"]
				return null)):
				if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "INVERSE_SHIELD_SPARK_PROBABILITY_IN_COLLISION"))):
					if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5)):
						JS.invoke_method(_scope9["self"], "_bounceTankOnShield", [_scope9["shieldedTankA"], _scope9["shieldedTankB"], JS.get_property(_scope9["data"], "collisionPoint"), false])
					else:
						JS.invoke_method(_scope9["self"], "_bounceTankOnShield", [_scope9["shieldedTankB"], _scope9["shieldedTankA"], JS.get_property(_scope9["data"], "collisionPoint"), false])
				if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "INVERSE_RUBBLE_SPAWN_PROBABILITY_IN_COLLISION"))):
					JS.invoke_method(_scope9["self"], "_spawnRubble", [_scope9["shieldedTankA"]])
					JS.invoke_method(_scope9["self"], "_spawnRubble", [_scope9["shieldedTankB"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 20:
			break
		if _switch2_start >= 0 and _switch2_start <= 21:
			JS.invoke_method(_scope9["self"], "_bounceProjectileOnMaze", [JS.get_property(_scope9["data"], "projectile"), JS.get_property(_scope9["data"], "collisionPoint")])
			break
		if _switch2_start >= 0 and _switch2_start <= 22:
			if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "INVERSE_RUBBLE_SPAWN_PROBABILITY_IN_COLLISION"))):
				JS.invoke_method(_scope9["self"], "_spawnRubble", [JS.get_property(_scope9["data"], "tankA")])
			break
		if _switch2_start >= 0 and _switch2_start <= 23:
			if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "INVERSE_RUBBLE_SPAWN_PROBABILITY_IN_COLLISION"))):
				JS.invoke_method(_scope9["self"], "_spawnRubble", [JS.get_property(_scope9["data"], "tankA")])
				JS.invoke_method(_scope9["self"], "_spawnRubble", [JS.get_property(_scope9["data"], "tankB")])
			break
		if _switch2_start >= 0 and _switch2_start <= 24:
			break
		if _switch2_start >= 0 and _switch2_start <= 25:
			JS.invoke_method(_scope9["self"], "_createWeapon", [_scope9["data"], JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getInitialRoundStateReceived", [])])
			JS.invoke_method(_scope9["self"], "_showWeaponSymbol", [JS.invoke_method(_scope9["data"], "getPlayerId", [])])
			break
		if _switch2_start >= 0 and _switch2_start <= 26:
			JS.invoke_method(_scope9["self"], "_removeWeapon", [JS.invoke_method(_scope9["data"], "getPlayerId", [])])
			JS.invoke_method(_scope9["self"], "_showWeaponSymbol", [JS.invoke_method(_scope9["data"], "getPlayerId", [])])
			break
		if _switch2_start >= 0 and _switch2_start <= 27:
			JS.invoke_method(_scope9["self"], "_createUpgrade", [_scope9["data"], JS.invoke_method(JS.get_property(_scope9["self"], "gameController"), "getInitialRoundStateReceived", [])])
			break
		if _switch2_start >= 0 and _switch2_start <= 28:
			JS.invoke_method(_scope9["self"], "_removeUpgrade", [JS.invoke_method(_scope9["data"], "getUpgradeId", [])])
			break
		if _switch2_start >= 0 and _switch2_start <= 29:
			JS.invoke_method(_scope9["self"], "_fireWeapon", [JS.invoke_method(_scope9["data"], "getPlayerId", [])])
			break
		if _switch2_start >= 0 and _switch2_start <= 30:
			JS.invoke_method(_scope9["self"], "_fireWeapon", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 31:
			JS.invoke_method(_scope9["self"], "_emptyWeapon", [JS.invoke_method(_scope9["data"], "getPlayerId", [])])
			break
		if _switch2_start >= 0 and _switch2_start <= 32:
			JS.invoke_method(_scope9["self"], "_updateHomingMissileTarget", [JS.invoke_method(_scope9["data"], "getProjectileId", []), JS.invoke_method(_scope9["data"], "getTargetId", [])])
			break
		if _switch2_start >= 0 and _switch2_start <= 33:
			JS.invoke_method(_scope9["self"], "_activateMine", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 34:
			JS.invoke_method(_scope9["self"], "_tripMine", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 35:
			JS.invoke_method(_scope9["self"], "_detonateMine", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 36:
			JS.invoke_method(_scope9["self"], "_activateUpgrade", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 37:
			JS.invoke_method(_scope9["self"], "_weakenUpgrade", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 38:
			JS.invoke_method(_scope9["self"], "_strengthenUpgrade", [_scope9["data"]])
			break
		if _switch2_start >= 0 and _switch2_start <= 40:
			break
		break
	return null

func original__cleanUp():
	var _scope14: Dictionary = {"bodies": null, "i": null}
	JS.invoke_method(JS.get_property(self, "mazeFloorGroup"), "removeAll", [true])
	JS.invoke_method(JS.get_property(self, "mazeWallGroup"), "removeAll", [true])
	JS.invoke_method(JS.get_property(self, "mazeWallDecorationGroup"), "removeAll", [true])
	JS.set_property(self, "maze", null)
	JS.invoke_method(JS.get_property(self, "tankGroup"), "callAll", ["retire"])
	JS.set_property(self, "tankSprites", {})
	JS.set_property(self, "projectiles", {})
	JS.invoke_method(JS.get_property(self, "projectileGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "shrapnelGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "missileGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "missileSmokeGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "laserGroup"), "callAll", ["retire"])
	JS.set_property(self, "traps", {})
	JS.invoke_method(JS.get_property(self, "mineGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "rubbleGroup"), "retire", [])
	JS.invoke_method(JS.get_property(self, "dustGroup"), "callAll", ["retire"])
	JS.set_property(self, "collectibles", {})
	JS.invoke_method(JS.get_property(self, "crateGroup"), "callAll", ["retire"])
	JS.set_property(self, "upgrades", {})
	JS.invoke_method(JS.get_property(self, "aimerGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "shieldGroup"), "callAll", ["retire"])
	JS.set_property(self, "counters", {})
	JS.set_property(self, "zones", {})
	JS.invoke_method(JS.get_property(self, "tankExplosionGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "explosionGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "tankFeatherGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "bulletPuffGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "missileLaunchGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "shieldSparkGroup"), "retire", [])
	JS.invoke_method(JS.get_property(self, "roundTitleGroup"), "retire", [])
	JS.invoke_method(JS.get_property(self, "countDownGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "tankNameGroup"), "callAll", ["retire"])
	JS.invoke_method(JS.get_property(self, "weaponSymbolGroup"), "callAll", ["retire"])
	JS.set_property(self, "weaponSymbolGroups", {})
	_scope14["bodies"] = JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "getBodies", [])
	_scope14["i"] = 0
	while JS.truthy(JS.compare("<", _scope14["i"], JS.get_property(_scope14["bodies"], "length"))):
		if JS.truthy(JS.get_property(_scope14["bodies"], _scope14["i"])):
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "removeBody", [JS.get_property(_scope14["bodies"], _scope14["i"])])
		JS.increment(_scope14, "i", 1, false)
	JS.set_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused", false)
	JS.set_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "paused", false)
	return null
