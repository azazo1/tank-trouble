# 由原版 UIBattleEntities 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

var gameController = null
var gameGroup = null
var mazeFloorGroup = null
var rubbleGroup = null
var dustGroup = null
var crateGroup = null
var mineGroup = null
var projectileGroup = null
var shrapnelGroup = null
var missileGroup = null
var missileSmokeGroup = null
var aimerGroup = null
var laserGroup = null
var tankGroup = null
var mazeWallGroup = null
var tankExplosionGroup = null
var tankFeatherGroup = null
var bulletPuffGroup = null
var missileLaunchGroup = null
var explosionGroup = null
var mazeWallDecorationGroup = null
var shieldGroup = null
var shieldSparkGroup = null
var tankSprites = {}
var collectibles = {}
var projectiles = {}
var traps = {}
var upgrades = {}
var counters = {}
var zones = {}
var overlayGroup = null
var countDownGroup = null
var tankNameGroup = null
var weaponSymbolGroup = null
var leaveGameGroup = null
var weaponSymbolGroups = {}
var countDownSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "COUNT_DOWN_AUDIO_COUNT")])
var emptyBarrelSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "EMPTY_BARREL_AUDIO_COUNT")])
var fireBulletSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "FIRE_BULLET_AUDIO_COUNT")])
var bulletBounceSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "BULLET_BOUNCE_AUDIO_COUNT")])
var shieldImpactSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "SHIELD_IMPACT_AUDIO_COUNT")])
var fireLaserSound = null
var fireShotgunSound = null
var fireMissileSound = null
var homingMissileTargetChangeSound = null
var homingMissileTargetingSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "MISSILE_TARGETING_AUDIO_COUNT")])
var fireMineSound = null
var chargeGatlingGunSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "TANK_POOL_SIZE")])
var holdGatlingGunSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "TANK_POOL_SIZE")])
var dischargeGatlingGunSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "TANK_POOL_SIZE")])
var mineActivateSound = null
var mineTripSound = null
var mineDetonateSound = null
var mineExplosionSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "MINE_EXPLOSION_AUDIO_COUNT")])
var shrapnelHitSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "SHRAPNEL_HIT_AUDIO_COUNT")])
var laserPickupSound = null
var doubleBarrelPickupSound = null
var shotgunPickupSound = null
var missilePickupSound = null
var minePickupSound = null
var gatlingGunPickupSound = null
var shieldPickupSound = null
var weaponLoadSound = null
var tankExplosionSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "TANK_EXPLOSION_AUDIO_COUNT")])
var bulletPuffSounds = JS.construct("@Array", [JS.get_property(JS.module("UIConstants"), "BULLET_PUFF_AUDIO_COUNT")])
var chickenOutSound = null
var shieldActivateSound = null
var shieldWeakenedSound = null
var shieldEndSound = null
var spawnZoneTearingSound = null
var spawnZoneOpenSound = null
var spawnZoneUnstableSound = null
var spawnZoneCollapseSound = null
var winnerCelebrationSound = null
var maze = null
var roundEnded = false
var celebrationDuration = 0
var roundTitleDelayDuration = 0
var roundTitleShown = false
var nextVictoryAward = null
var waitingTime = 0
var roundTitleGroup = null
var betweenRoundsDuration = 0
var cameraShake = 0
var log = null
static var _static_UIBattleEntities: Dictionary = {}
static var _initialized_UIBattleEntities = false
static func initialize_original_static():
	if _initialized_UIBattleEntities: return
	_initialized_UIBattleEntities = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIBattleEntities.has(key): return _static_UIBattleEntities[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIBattleEntities[key] = value
	return value
func original_own_fields():
	return ["gameController","gameGroup","mazeFloorGroup","rubbleGroup","dustGroup","crateGroup","mineGroup","projectileGroup","shrapnelGroup","missileGroup","missileSmokeGroup","aimerGroup","laserGroup","tankGroup","mazeWallGroup","tankExplosionGroup","tankFeatherGroup","bulletPuffGroup","missileLaunchGroup","explosionGroup","mazeWallDecorationGroup","shieldGroup","shieldSparkGroup","tankSprites","collectibles","projectiles","traps","upgrades","counters","zones","overlayGroup","countDownGroup","tankNameGroup","weaponSymbolGroup","leaveGameGroup","weaponSymbolGroups","countDownSounds","emptyBarrelSounds","fireBulletSounds","bulletBounceSounds","shieldImpactSounds","fireLaserSound","fireShotgunSound","fireMissileSound","homingMissileTargetChangeSound","homingMissileTargetingSounds","fireMineSound","chargeGatlingGunSounds","holdGatlingGunSounds","dischargeGatlingGunSounds","mineActivateSound","mineTripSound","mineDetonateSound","mineExplosionSounds","shrapnelHitSounds","laserPickupSound","doubleBarrelPickupSound","shotgunPickupSound","missilePickupSound","minePickupSound","gatlingGunPickupSound","shieldPickupSound","weaponLoadSound","tankExplosionSounds","bulletPuffSounds","chickenOutSound","shieldActivateSound","shieldWeakenedSound","shieldEndSound","spawnZoneTearingSound","spawnZoneOpenSound","spawnZoneUnstableSound","spawnZoneCollapseSound","winnerCelebrationSound","maze","roundEnded","celebrationDuration","roundTitleDelayDuration","roundTitleShown","nextVictoryAward","waitingTime","roundTitleGroup","betweenRoundsDuration","cameraShake","log"]
func original_is_weak_field(key):
	return ["gameController"].has(key) or super.original_is_weak_field(key)

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {}
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/battle/uibattleentities.gd").new()
	instance._construct_create()
	return instance

func original_getTankSprite(_arg0 = null):
	var _scope1: Dictionary = {"playerId": _arg0}
	return JS.get_property(JS.get_property(self, "tankSprites"), _scope1["playerId"])
	return null

func original__getTankPosition(_arg0 = null):
	var _scope2: Dictionary = {"playerId": _arg0, "tank": null, "gameBounds": null, "position": null}
	if JS.truthy(JS.has_property(JS.get_property(self, "tankSprites"), _scope2["playerId"])):
		_scope2["tank"] = JS.get_property(JS.get_property(self, "tankSprites"), _scope2["playerId"])
		_scope2["gameBounds"] = JS.get_property(JS.get_property(JS.get_property(self, "game"), "scale"), "bounds")
		_scope2["position"] = JS.invoke_method(_scope2["tank"], "toGlobal", [JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [0, 0])])
		JS.invoke_method(JS.get_property(JS.module("Phaser"), "Point"), "divide", [_scope2["position"], JS.get_property(JS.get_property(JS.get_property(self, "game"), "scale"), "scaleFactor"), _scope2["position"]])
		return {"x": JS.add(JS.get_property(_scope2["gameBounds"], "x"), JS.get_property(_scope2["position"], "x")), "y": JS.add(JS.get_property(_scope2["gameBounds"], "y"), JS.get_property(_scope2["position"], "y"))}
	return null
	return null

func original__getCollectiblePositionAngleAndScale(_arg0 = null):
	var _scope3: Dictionary = {"collectibleId": _arg0, "collectible": null, "gameBounds": null, "position": null, "extraInfo": null, "scale": null}
	if JS.truthy(JS.has_property(JS.get_property(self, "collectibles"), _scope3["collectibleId"])):
		_scope3["collectible"] = JS.get_property(JS.get_property(self, "collectibles"), _scope3["collectibleId"])
		_scope3["gameBounds"] = JS.get_property(JS.get_property(JS.get_property(self, "game"), "scale"), "bounds")
		_scope3["position"] = JS.invoke_method(_scope3["collectible"], "toGlobal", [JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [0, 0])])
		JS.invoke_method(JS.get_property(JS.module("Phaser"), "Point"), "divide", [_scope3["position"], JS.get_property(JS.get_property(JS.get_property(self, "game"), "scale"), "scaleFactor"), _scope3["position"]])
		_scope3["extraInfo"] = JS.invoke_method(_scope3["collectible"], "getExtraPositionInfo", [])
		_scope3["scale"] = (JS.number(JS.get_property(JS.get_property(_scope3["collectible"], "worldScale"), "x")) / JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")))
		return {"x": JS.add(JS.get_property(_scope3["gameBounds"], "x"), JS.get_property(_scope3["position"], "x")), "y": JS.add(JS.get_property(_scope3["gameBounds"], "y"), JS.get_property(_scope3["position"], "y")), "angle": JS.get_property(_scope3["collectible"], "angle"), "scale": _scope3["scale"], "extraInfo": _scope3["extraInfo"]}
	return null
	return null

func original__createMaze(_arg0 = null):
	var _scope4: Dictionary = {"maze": _arg0, "theme": null, "borders": null, "floors": null, "spaces": null, "walls": null, "wallDecorations": null, "i": null, "border": null, "borderImage": null, "sprite": null, "floor": null, "floorImage": null, "wallDecoration": null, "wallDecorationImage": null, "space": null, "spaceImage": null, "wall": null, "wallImage": null, "wallBody": null}
	_scope4["theme"] = JS.invoke_method(_scope4["maze"], "getTheme", [])
	_scope4["borders"] = JS.invoke_method(_scope4["maze"], "getBorders", [])
	_scope4["floors"] = JS.invoke_method(_scope4["maze"], "getFloors", [])
	_scope4["spaces"] = JS.invoke_method(_scope4["maze"], "getSpaces", [])
	_scope4["walls"] = JS.invoke_method(_scope4["maze"], "getWalls", [])
	_scope4["wallDecorations"] = JS.invoke_method(_scope4["maze"], "getWallDecorations", [])
	_scope4["i"] = 0
	while JS.truthy(JS.compare("<", _scope4["i"], JS.get_property(_scope4["borders"], "length"))):
		_scope4["border"] = JS.get_property(_scope4["borders"], _scope4["i"])
		_scope4["borderImage"] = JS.add(JS.add(JS.add("border", _scope4["theme"]), "-"), JS.get_property(_scope4["border"], "number"))
		_scope4["sprite"] = JS.invoke_method(JS.get_property(self, "mazeFloorGroup"), "create", [(JS.number((JS.number(JS.add(JS.get_property(_scope4["border"], "x"), 0.5)) - JS.number((JS.number(0.5) * JS.number(fmod(JS.get_property(_scope4["border"], "orientation"), 2)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number((JS.number(JS.add(JS.get_property(_scope4["border"], "y"), 0.5)) - JS.number((JS.number(0.5) * JS.number(fmod((JS.number(JS.get_property(_scope4["border"], "orientation")) - JS.number(1)), 2)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope4["borderImage"]])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "scale"), "setTo", [(JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number((-(1) if JS.truthy(JS.get_property(_scope4["border"], "flip")) else 1))), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "anchor"), "setTo", [0.5, 1])
		JS.set_property(_scope4["sprite"], "rotation", (JS.number((JS.number(JS.get_property(_scope4["border"], "orientation")) * JS.number(JS.get_property("@Math", "PI")))) / JS.number(2)))
		JS.increment(_scope4, "i", 1, false)
	_scope4["i"] = 0
	while JS.truthy(JS.compare("<", _scope4["i"], JS.get_property(_scope4["floors"], "length"))):
		_scope4["floor"] = JS.get_property(_scope4["floors"], _scope4["i"])
		_scope4["floorImage"] = JS.add(JS.add(JS.add("floor", _scope4["theme"]), "-"), JS.get_property(_scope4["floor"], "number"))
		_scope4["sprite"] = JS.invoke_method(JS.get_property(self, "mazeFloorGroup"), "create", [(JS.number(JS.add(JS.get_property(_scope4["floor"], "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number(JS.add(JS.get_property(_scope4["floor"], "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope4["floorImage"]])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "anchor"), "setTo", [0.5, 0.5])
		JS.set_property(_scope4["sprite"], "rotation", (JS.number((JS.number(JS.get_property(_scope4["floor"], "orientation")) * JS.number(JS.get_property("@Math", "PI")))) / JS.number(2)))
		JS.increment(_scope4, "i", 1, false)
	_scope4["i"] = 0
	while JS.truthy(JS.compare("<", _scope4["i"], JS.get_property(_scope4["wallDecorations"], "length"))):
		_scope4["wallDecoration"] = JS.get_property(_scope4["wallDecorations"], _scope4["i"])
		_scope4["wallDecorationImage"] = JS.add(JS.add(JS.add("wallDecoration", _scope4["theme"]), "-"), JS.get_property(_scope4["wallDecoration"], "number"))
		_scope4["sprite"] = JS.invoke_method(JS.get_property(self, "mazeWallDecorationGroup"), "create", [(JS.number(JS.add(JS.get_property(_scope4["wallDecoration"], "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number(JS.add(JS.get_property(_scope4["wallDecoration"], "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope4["wallDecorationImage"]])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "anchor"), "setTo", [0.5, 0.5])
		JS.set_property(_scope4["sprite"], "rotation", (JS.number((JS.number(JS.get_property(_scope4["wallDecoration"], "orientation")) * JS.number(JS.get_property("@Math", "PI")))) / JS.number(2)))
		JS.increment(_scope4, "i", 1, false)
	_scope4["i"] = 0
	while JS.truthy(JS.compare("<", _scope4["i"], JS.get_property(_scope4["spaces"], "length"))):
		_scope4["space"] = JS.get_property(_scope4["spaces"], _scope4["i"])
		_scope4["spaceImage"] = JS.add(JS.add(JS.add("space", _scope4["theme"]), "-"), JS.get_property(_scope4["space"], "number"))
		_scope4["sprite"] = JS.invoke_method(JS.get_property(self, "mazeFloorGroup"), "create", [(JS.number(JS.add(JS.get_property(_scope4["space"], "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number(JS.add(JS.get_property(_scope4["space"], "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope4["spaceImage"]])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "anchor"), "setTo", [0.5, 0.5])
		JS.set_property(_scope4["sprite"], "rotation", (JS.number((JS.number(JS.get_property(_scope4["space"], "orientation")) * JS.number(JS.get_property("@Math", "PI")))) / JS.number(2)))
		JS.increment(_scope4, "i", 1, false)
	_scope4["i"] = 0
	while JS.truthy(JS.compare("<", _scope4["i"], JS.get_property(_scope4["walls"], "length"))):
		_scope4["wall"] = JS.get_property(_scope4["walls"], _scope4["i"])
		_scope4["wallImage"] = JS.add(JS.add(JS.add("wall", _scope4["theme"]), "-"), JS.get_property(_scope4["wall"], "number"))
		_scope4["sprite"] = JS.invoke_method(JS.get_property(self, "mazeWallGroup"), "create", [(JS.number((JS.number(JS.add(JS.get_property(_scope4["wall"], "x"), 0.5)) - JS.number((JS.number(0.5) * JS.number((1 if JS.truthy(JS.get_property(_scope4["wall"], "rotate")) else 0)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number((JS.number(JS.add(JS.get_property(_scope4["wall"], "y"), 0.5)) - JS.number((JS.number(0.5) * JS.number((0 if JS.truthy(JS.get_property(_scope4["wall"], "rotate")) else 1)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope4["wallImage"]])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "anchor"), "setTo", [0.5, 0.5])
		JS.invoke_method(JS.get_property(_scope4["sprite"], "scale"), "setTo", [(JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number((-(1) if JS.truthy(JS.get_property(_scope4["wall"], "flipX")) else 1))), (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number((-(1) if JS.truthy(JS.get_property(_scope4["wall"], "flipY")) else 1)))])
		JS.set_property(_scope4["sprite"], "rotation", ((JS.number(JS.get_property("@Math", "PI")) / JS.number(2)) if JS.truthy(JS.get_property(_scope4["wall"], "rotate")) else 0))
		_scope4["wallBody"] = JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Physics"), "P2"), "Body"), [JS.get_property(self, "game"), null, (JS.number((JS.number(JS.add(JS.get_property(_scope4["wall"], "x"), 0.5)) - JS.number((JS.number(0.5) * JS.number((1 if JS.truthy(JS.get_property(_scope4["wall"], "rotate")) else 0)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number((JS.number(JS.add(JS.get_property(_scope4["wall"], "y"), 0.5)) - JS.number((JS.number(0.5) * JS.number((0 if JS.truthy(JS.get_property(_scope4["wall"], "rotate")) else 1)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px")))])
		JS.invoke_method(_scope4["wallBody"], "setRectangle", [JS.add(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"), JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "px")), JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "px"), 0, 0, ((JS.number(JS.get_property("@Math", "PI")) / JS.number(2)) if JS.truthy(JS.get_property(_scope4["wall"], "rotate")) else 0)])
		JS.set_property(_scope4["wallBody"], "dynamic", false)
		JS.invoke_method(_scope4["wallBody"], "setMaterial", [JS.get_property(JS.module("UIUtils"), "wallMaterial")])
		JS.invoke_method(_scope4["wallBody"], "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "wallCollisionGroup")])
		JS.invoke_method(_scope4["wallBody"], "collides", [[JS.get_property(JS.module("UIUtils"), "fragmentCollisionGroup"), JS.get_property(JS.module("UIUtils"), "puffCollisionGroup"), JS.get_property(JS.module("UIUtils"), "rayCollisionGroup")]])
		JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "addBody", [_scope4["wallBody"]])
		JS.increment(_scope4, "i", 1, false)
	return null

func original__updateTheme(_arg0 = null):
	var _scope5: Dictionary = {"theme": _arg0}
	JS.invoke_method(JS.get_property(self, "weaponSymbolGroup"), "callAll", ["setTheme", null, _scope5["theme"]])
	JS.invoke_method(JS.get_property(self, "crateGroup"), "callAll", ["setTheme", null, _scope5["theme"]])
	return null

func original__getMazeLocalBounds():
	var _scope6: Dictionary = {"mazeLocalBounds": null}
	_scope6["mazeLocalBounds"] = JS.invoke_method(JS.get_property(JS.module("Phaser"), "Rectangle"), "union", [JS.invoke_method(JS.get_property(self, "mazeFloorGroup"), "getLocalBounds", []), JS.invoke_method(JS.get_property(self, "mazeWallGroup"), "getLocalBounds", [])])
	if JS.truthy(JS.get_property(_scope6["mazeLocalBounds"], "empty")):
		JS.invoke_method(_scope6["mazeLocalBounds"], "inflate", [0.01, 0.01])
	return _scope6["mazeLocalBounds"]
	return null

func original__spawnRoundTitle(_arg0 = null, _arg1 = null):
	var _scope7: Dictionary = {"name": _arg0, "ranked": _arg1, "subtitle": null}
	JS.set_property(self, "roundTitleShown", true)
	_scope7["subtitle"] = ""
	if JS.truthy(_scope7["ranked"]):
		JS.set_property(_scope7, "subtitle", "Ranked")
	else:
		if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(self, "gameController"), "getMode", []), JS.get_property(JS.get_property(JS.module("Constants"), "GAME_MODES"), "BOOT_CAMP"), false)):
			JS.set_property(_scope7, "subtitle", "No achievements")
	JS.invoke_method(JS.get_property(self, "roundTitleGroup"), "spawn", [_scope7["name"], _scope7["subtitle"]])
	return null

func original__spawnCountDown(_arg0 = null):
	var _scope8: Dictionary = {"value": _arg0, "countDownSprite": null}
	_scope8["countDownSprite"] = JS.invoke_method(JS.get_property(self, "countDownGroup"), "getFirstExists", [false])
	if JS.truthy(_scope8["countDownSprite"]):
		JS.invoke_method(_scope8["countDownSprite"], "spawn", [_scope8["value"]])
		JS.invoke_method(JS.get_property(JS.get_property(self, "countDownSounds"), _scope8["value"]), "play", [])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create count down sprite. No sprite available."])
	return null

func original__createTank(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope9: Dictionary = {"tank": _arg0, "playSpawnAnimation": _arg1, "smoothing": _arg2, "tankSprite": null, "tankNameSprite": null}
	_scope9["tankSprite"] = JS.invoke_method(JS.get_property(self, "tankGroup"), "getFirstExists", [false])
	if JS.truthy(_scope9["tankSprite"]):
		JS.set_property(JS.get_property(self, "tankSprites"), JS.invoke_method(_scope9["tank"], "getPlayerId", []), _scope9["tankSprite"])
		JS.invoke_method(_scope9["tankSprite"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope9["tank"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope9["tank"], "getY", [])]), JS.invoke_method(_scope9["tank"], "getRotation", []), JS.invoke_method(_scope9["tank"], "getPlayerId", []), _scope9["playSpawnAnimation"], _scope9["smoothing"]])
		_scope9["tankNameSprite"] = JS.invoke_method(JS.get_property(self, "tankNameGroup"), "getFirstExists", [false])
		if JS.truthy(_scope9["tankNameSprite"]):
			JS.invoke_method(_scope9["tankNameSprite"], "spawn", [JS.invoke_method(_scope9["tank"], "getPlayerId", [])])
		else:
			JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create tank name sprite. No sprite available."])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create tank sprite. No sprite available."])
	return null

func original__removeTank(_arg0 = null):
	var _scope10: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "tankSprites"), _scope10["playerId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "tankSprites"), _scope10["playerId"]), "remove", [])
		JS.delete_property(JS.get_property(self, "tankSprites"), _scope10["playerId"])
		JS.invoke_method(self, "_removeUpgrades", [_scope10["playerId"]])
		JS.invoke_method(self, "_removeWeaponSymbol", [_scope10["playerId"]])
		return true
	return false
	return null

func original__spawnTankExplosion(_arg0 = null):
	var _scope11: Dictionary = {"playerId": _arg0, "explosion": null, "tank": null, "x": null, "y": null}
	_scope11["explosion"] = JS.invoke_method(JS.get_property(self, "tankExplosionGroup"), "getFirstExists", [false])
	_scope11["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [_scope11["playerId"]])
	if JS.truthy(JS.logical("&&", func():
		var _scope12: Dictionary = {}
		return _scope11["tank"]
		return null, func():
		var _scope13: Dictionary = {}
		return _scope11["explosion"]
		return null)):
		_scope11["x"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope11["tank"], "getX", [])])
		_scope11["y"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope11["tank"], "getY", [])])
		JS.invoke_method(_scope11["explosion"], "spawn", [_scope11["x"], _scope11["y"], _scope11["playerId"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create explosion group. No tank or group available."])
	return null

func original__spawnTankFeathers(_arg0 = null, _arg1 = null):
	var _scope14: Dictionary = {"playerId": _arg0, "tankPosition": _arg1, "tank": null, "i": null, "feather": null, "x": null, "y": null, "stake": null}
	_scope14["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [_scope14["playerId"]])
	if JS.truthy(_scope14["tank"]):
		JS.invoke_method(JS.get_property(self, "chickenOutSound"), "play", [])
		_scope14["i"] = 0
		while JS.truthy(JS.compare("<", _scope14["i"], JS.get_property(JS.module("UIConstants"), "TANK_FEATHER_COUNT"))):
			_scope14["feather"] = JS.invoke_method(JS.get_property(self, "tankFeatherGroup"), "getFirstExists", [false])
			if JS.truthy(_scope14["feather"]):
				_scope14["x"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope14["tank"], "getX", [])])
				_scope14["y"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope14["tank"], "getY", [])])
				JS.invoke_method(_scope14["feather"], "spawn", [_scope14["x"], _scope14["y"]])
			else:
				JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create tank feather. No sprite available."])
			JS.increment(_scope14, "i", 1, false)
		_scope14["stake"] = JS.invoke_method(JS.get_property(self, "gameController"), "getStake", [_scope14["playerId"]])
		if JS.truthy(_scope14["stake"]):
			JS.invoke_method(JS.module("GameManager"), "showRankChange", [-(JS.get_property(_scope14["stake"], "value")), _scope14["tankPosition"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create tank feather. No tank available."])
	return null

func original__addCameraShake(_arg0 = null):
	var _scope15: Dictionary = {"shake": _arg0}
	JS.set_property(self, "cameraShake", JS.invoke_method("@Math", "min", [JS.get_property(JS.module("UIConstants"), "MAX_CAMERA_SHAKE"), JS.add(JS.get_property(self, "cameraShake"), _scope15["shake"])]))
	return null

func original__fireWeapon(_arg0 = null):
	var _scope16: Dictionary = {"playerId": _arg0, "tankSprite": null}
	_scope16["tankSprite"] = JS.get_property(JS.get_property(self, "tankSprites"), _scope16["playerId"])
	if JS.truthy(_scope16["tankSprite"]):
		JS.invoke_method(_scope16["tankSprite"], "fire", [])
	return null

func original__emptyWeapon(_arg0 = null):
	var _scope17: Dictionary = {"playerId": _arg0, "tankSprite": null}
	_scope17["tankSprite"] = JS.get_property(JS.get_property(self, "tankSprites"), _scope17["playerId"])
	if JS.truthy(_scope17["tankSprite"]):
		JS.invoke_method(_scope17["tankSprite"], "emptyBarrel", [])
	return null

func original__updateHomingMissileTarget(_arg0 = null, _arg1 = null):
	var _scope18: Dictionary = {"projectileId": _arg0, "playerId": _arg1}
	if JS.truthy(JS.get_property(JS.get_property(self, "projectiles"), _scope18["projectileId"])):
		if JS.truthy(not JS.equal(_scope18["playerId"], null, true)):
			JS.invoke_method(JS.get_property(self, "homingMissileTargetChangeSound"), "play", [])
		JS.invoke_method(JS.get_property(JS.get_property(self, "projectiles"), _scope18["projectileId"]), "updateTarget", [_scope18["playerId"]])
	return null

func original__activateUpgrade(_arg0 = null):
	var _scope19: Dictionary = {"upgradeId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "upgrades"), _scope19["upgradeId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "upgrades"), _scope19["upgradeId"]), "activate", [])
	return null

func original__weakenUpgrade(_arg0 = null):
	var _scope20: Dictionary = {"upgradeId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "upgrades"), _scope20["upgradeId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "upgrades"), _scope20["upgradeId"]), "weaken", [])
	return null

func original__strengthenUpgrade(_arg0 = null):
	var _scope21: Dictionary = {"upgradeId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "upgrades"), _scope21["upgradeId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "upgrades"), _scope21["upgradeId"]), "strengthen", [])
	return null

func original__createProjectile(_arg0 = null):
	var _scope22: Dictionary = {"projectile": _arg0, "projectileImage": null, "laserGraphicsInstance": null, "homingMissileImage": null, "mineShrapnelImage": null}
	var _switch0 = JS.invoke_method(_scope22["projectile"], "getType", [])
	var _switch0_start = -1
	if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch0_start = 0
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch0_start = 1
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch0_start = 2
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch0_start = 3
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch0_start = 4
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch0_start = 5
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch0_start = 6
	while true:
		if _switch0_start >= 0 and _switch0_start <= 0:
			_scope22["projectileImage"] = JS.invoke_method(JS.get_property(self, "projectileGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope22["projectileImage"]))):
				JS.set_property(_scope22, "projectileImage", JS.invoke_method(JS.get_property(self, "projectileGroup"), "add", [JS.construct(JS.module("UIProjectileImage"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])]))
			JS.set_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope22["projectile"], "getId", []), _scope22["projectileImage"])
			JS.invoke_method(_scope22["projectileImage"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getY", [])]), JS.invoke_method(_scope22["projectile"], "getId", []), "bullet"])
			break
		if _switch0_start >= 0 and _switch0_start <= 1:
			_scope22["laserGraphicsInstance"] = JS.invoke_method(JS.get_property(self, "laserGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope22["laserGraphicsInstance"]))):
				JS.set_property(_scope22, "laserGraphicsInstance", JS.invoke_method(JS.get_property(self, "laserGroup"), "add", [JS.construct(JS.module("UILaserGraphics"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])]))
			JS.set_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope22["projectile"], "getId", []), _scope22["laserGraphicsInstance"])
			JS.invoke_method(_scope22["laserGraphicsInstance"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getY", [])]), JS.invoke_method(_scope22["projectile"], "getId", []), JS.invoke_method(_scope22["projectile"], "getPlayerId", [])])
			break
		if _switch0_start >= 0 and _switch0_start <= 2:
			_scope22["projectileImage"] = JS.invoke_method(JS.get_property(self, "projectileGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope22["projectileImage"]))):
				JS.set_property(_scope22, "projectileImage", JS.invoke_method(JS.get_property(self, "projectileGroup"), "add", [JS.construct(JS.module("UIProjectileImage"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])]))
			JS.set_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope22["projectile"], "getId", []), _scope22["projectileImage"])
			JS.invoke_method(_scope22["projectileImage"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getY", [])]), JS.invoke_method(_scope22["projectile"], "getId", []), "doubleBarrel"])
			break
		if _switch0_start >= 0 and _switch0_start <= 3:
			_scope22["projectileImage"] = JS.invoke_method(JS.get_property(self, "projectileGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope22["projectileImage"]))):
				JS.set_property(_scope22, "projectileImage", JS.invoke_method(JS.get_property(self, "projectileGroup"), "add", [JS.construct(JS.module("UIProjectileImage"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])]))
			JS.set_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope22["projectile"], "getId", []), _scope22["projectileImage"])
			JS.invoke_method(_scope22["projectileImage"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getY", [])]), JS.invoke_method(_scope22["projectile"], "getId", []), "shotgun"])
			break
		if _switch0_start >= 0 and _switch0_start <= 4:
			_scope22["homingMissileImage"] = JS.invoke_method(JS.get_property(self, "missileGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope22["homingMissileImage"]))):
				JS.set_property(_scope22, "homingMissileImage", JS.invoke_method(JS.get_property(self, "missileGroup"), "add", [JS.construct(JS.module("UIMissileImage"), [JS.get_property(self, "game"), JS.get_property(self, "gameController"), JS.get_property(self, "homingMissileTargetingSounds")])]))
			JS.set_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope22["projectile"], "getId", []), _scope22["homingMissileImage"])
			JS.invoke_method(_scope22["homingMissileImage"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getY", [])]), JS.invoke_method(_scope22["projectile"], "getId", []), JS.invoke_method(_scope22["projectile"], "getPlayerId", []), "homingMissile"])
			break
		if _switch0_start >= 0 and _switch0_start <= 5:
			_scope22["mineShrapnelImage"] = JS.invoke_method(JS.get_property(self, "shrapnelGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope22["mineShrapnelImage"]))):
				JS.set_property(_scope22, "mineShrapnelImage", JS.invoke_method(JS.get_property(self, "shrapnelGroup"), "add", [JS.construct(JS.module("UIShrapnelImage"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])]))
			JS.set_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope22["projectile"], "getId", []), _scope22["mineShrapnelImage"])
			JS.invoke_method(_scope22["mineShrapnelImage"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getY", [])]), JS.invoke_method(_scope22["projectile"], "getId", []), JS.invoke_method(_scope22["projectile"], "getPlayerId", [])])
			break
		if _switch0_start >= 0 and _switch0_start <= 6:
			_scope22["projectileImage"] = JS.invoke_method(JS.get_property(self, "projectileGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope22["projectileImage"]))):
				JS.set_property(_scope22, "projectileImage", JS.invoke_method(JS.get_property(self, "projectileGroup"), "add", [JS.construct(JS.module("UIProjectileImage"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])]))
			JS.set_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope22["projectile"], "getId", []), _scope22["projectileImage"])
			JS.invoke_method(_scope22["projectileImage"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope22["projectile"], "getY", [])]), JS.invoke_method(_scope22["projectile"], "getId", []), "gatlingGun"])
			break
		break
	return null

func original__bounceTankOnShield(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope23: Dictionary = {"tank": _arg0, "shieldedTank": _arg1, "collisionPoint": _arg2, "lookAtTankRotation": _arg3}
	if JS.truthy(JS.logical("||", func():
		var _scope24: Dictionary = {}
		return JS.logical("||", func():
			var _scope25: Dictionary = {}
			return not JS.equal(JS.invoke_method(_scope23["tank"], "getSpeed", []), 0, false)
			return null, func():
			var _scope26: Dictionary = {}
			return JS.logical("&&", func():
				var _scope27: Dictionary = {}
				return _scope23["lookAtTankRotation"]
				return null, func():
				var _scope28: Dictionary = {}
				return not JS.equal(JS.invoke_method(_scope23["tank"], "getRotationSpeed", []), 0, false)
				return null)
			return null)
		return null, func():
		var _scope29: Dictionary = {}
		return not JS.equal(JS.invoke_method(_scope23["shieldedTank"], "getSpeed", []), 0, false)
		return null)):
		JS.invoke_method(self, "_spawnShieldSparks", [_scope23["shieldedTank"], _scope23["collisionPoint"]])
		JS.invoke_method(JS.get_property(JS.get_property(self, "shieldImpactSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "SHIELD_IMPACT_AUDIO_COUNT")))])), "play", [])
	return null

func original__bounceProjectileOnShield(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope30: Dictionary = {"projectile": _arg0, "shieldedTank": _arg1, "collisionPoint": _arg2, "laserGraphicsInstance": null}
	JS.invoke_method(self, "_spawnShieldSparks", [_scope30["shieldedTank"], _scope30["collisionPoint"]])
	JS.invoke_method(JS.get_property(JS.get_property(self, "shieldImpactSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "SHIELD_IMPACT_AUDIO_COUNT")))])), "play", [])
	var _switch1 = JS.invoke_method(_scope30["projectile"], "getType", [])
	var _switch1_start = -1
	if JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch1_start = 0
	while true:
		if _switch1_start >= 0 and _switch1_start <= 0:
			_scope30["laserGraphicsInstance"] = JS.get_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope30["projectile"], "getId", []))
			if JS.truthy(_scope30["laserGraphicsInstance"]):
				JS.invoke_method(_scope30["laserGraphicsInstance"], "addPoint", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope30["collisionPoint"], "x")]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope30["collisionPoint"], "y")])])
			break
		break
	return null

func original__bounceProjectileOnMaze(_arg0 = null, _arg1 = null):
	var _scope31: Dictionary = {"projectile": _arg0, "collisionPoint": _arg1, "laserGraphicsInstance": null}
	var _switch2 = JS.invoke_method(_scope31["projectile"], "getType", [])
	var _switch2_start = -1
	if JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch2_start = 0
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch2_start = 1
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch2_start = 2
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch2_start = 3
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch2_start = 4
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch2_start = 5
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch2_start = 6
	while true:
		if _switch2_start >= 0 and _switch2_start <= 4:
			JS.invoke_method(JS.get_property(JS.get_property(self, "bulletBounceSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "BULLET_BOUNCE_AUDIO_COUNT")))])), "play", [])
			break
		if _switch2_start >= 0 and _switch2_start <= 5:
			_scope31["laserGraphicsInstance"] = JS.get_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope31["projectile"], "getId", []))
			if JS.truthy(_scope31["laserGraphicsInstance"]):
				JS.invoke_method(_scope31["laserGraphicsInstance"], "addPoint", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope31["collisionPoint"], "x")]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope31["collisionPoint"], "y")])])
			break
		if _switch2_start >= 0 and _switch2_start <= 6:
			JS.invoke_method(JS.get_property(JS.get_property(self, "shrapnelHitSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "SHRAPNEL_HIT_AUDIO_COUNT")))])), "play", [])
			break
		break
	return null

func original__removeProjectile(_arg0 = null):
	var _scope32: Dictionary = {"projectileId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "projectiles"), _scope32["projectileId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "projectiles"), _scope32["projectileId"]), "remove", [])
		JS.delete_property(JS.get_property(self, "projectiles"), _scope32["projectileId"])
	return null

func original__spawnProjectilePuffs(_arg0 = null):
	var _scope33: Dictionary = {"projectileId": _arg0, "projectile": null, "numPuffs": null, "i": null, "puff": null, "x": null, "y": null, "speedX": null, "speedY": null, "randomBulletPuffSound": null}
	_scope33["projectile"] = JS.invoke_method(JS.get_property(self, "gameController"), "getProjectile", [_scope33["projectileId"]])
	if JS.truthy(_scope33["projectile"]):
		var _switch3 = JS.invoke_method(_scope33["projectile"], "getType", [])
		var _switch3_start = -1
		if JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch3_start = 0
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch3_start = 1
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch3_start = 2
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch3_start = 3
		elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch3_start = 4
		while true:
			if _switch3_start >= 0 and _switch3_start <= 2:
				JS.invoke_method(JS.get_property(JS.get_property(self, "bulletPuffSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "BULLET_PUFF_AUDIO_COUNT")))])), "play", [])
				_scope33["numPuffs"] = JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "BULLET_PUFF_COUNT")])
				_scope33["i"] = 0
				while JS.truthy(JS.compare("<", _scope33["i"], _scope33["numPuffs"])):
					_scope33["puff"] = JS.invoke_method(JS.get_property(self, "bulletPuffGroup"), "getFirstExists", [false])
					if JS.truthy(_scope33["puff"]):
						_scope33["x"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope33["projectile"], "getX", [])])
						_scope33["y"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope33["projectile"], "getY", [])])
						_scope33["speedX"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope33["projectile"], "getSpeedX", [])])
						_scope33["speedY"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope33["projectile"], "getSpeedY", [])])
						JS.invoke_method(_scope33["puff"], "spawn", [_scope33["x"], _scope33["y"], _scope33["speedX"], _scope33["speedY"]])
					else:
						JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create bullet puff. No sprite available."])
					JS.increment(_scope33, "i", 1, false)
				break
			if _switch3_start >= 0 and _switch3_start <= 4:
				_scope33["randomBulletPuffSound"] = JS.get_property(JS.get_property(self, "bulletPuffSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "BULLET_PUFF_AUDIO_COUNT")))]))
				if JS.truthy((not JS.truthy(JS.get_property(_scope33["randomBulletPuffSound"], "isPlaying")))):
					JS.invoke_method(_scope33["randomBulletPuffSound"], "play", [])
				_scope33["puff"] = JS.invoke_method(JS.get_property(self, "bulletPuffGroup"), "getFirstExists", [false])
				if JS.truthy(_scope33["puff"]):
					_scope33["x"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope33["projectile"], "getX", [])])
					_scope33["y"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope33["projectile"], "getY", [])])
					_scope33["speedX"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope33["projectile"], "getSpeedX", [])])
					_scope33["speedY"] = JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope33["projectile"], "getSpeedY", [])])
					JS.invoke_method(_scope33["puff"], "spawn", [_scope33["x"], _scope33["y"], _scope33["speedX"], _scope33["speedY"]])
				else:
					JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create bullet puff. No sprite available."])
				break
			break
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create projectile puff. No projectile available."])
	return null

func original__createTrap(_arg0 = null):
	var _scope34: Dictionary = {"trap": _arg0, "mineSprite": null}
	var _switch4 = JS.invoke_method(_scope34["trap"], "getType", [])
	var _switch4_start = -1
	if JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch4_start = 0
	while true:
		if _switch4_start >= 0 and _switch4_start <= 0:
			_scope34["mineSprite"] = JS.invoke_method(JS.get_property(self, "mineGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope34["mineSprite"]))):
				JS.set_property(_scope34, "mineSprite", JS.invoke_method(JS.get_property(self, "mineGroup"), "add", [JS.construct(JS.module("UIMineSprite"), [JS.get_property(self, "game"), JS.get_property(self, "gameController"), JS.get_property(self, "mineActivateSound"), JS.get_property(self, "mineTripSound"), JS.get_property(self, "mineDetonateSound")])]))
			JS.set_property(JS.get_property(self, "traps"), JS.invoke_method(_scope34["trap"], "getId", []), _scope34["mineSprite"])
			JS.invoke_method(_scope34["mineSprite"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope34["trap"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope34["trap"], "getY", [])]), JS.invoke_method(_scope34["trap"], "getId", []), JS.invoke_method(_scope34["trap"], "getPlayerId", []), JS.invoke_method(_scope34["trap"], "getField", ["activated"]), JS.invoke_method(_scope34["trap"], "getField", ["tripped"])])
			break
		break
	return null

func original__releaseTrap(_arg0 = null):
	var _scope35: Dictionary = {"trap": _arg0}
	var _switch5 = JS.invoke_method(_scope35["trap"], "getType", [])
	var _switch5_start = -1
	if JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch5_start = 0
	while true:
		if _switch5_start >= 0 and _switch5_start <= 0:
			JS.invoke_method(self, "_spawnExplosion", [JS.invoke_method(_scope35["trap"], "getX", []), JS.invoke_method(_scope35["trap"], "getY", []), JS.get_property(JS.get_property(self, "mineExplosionSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "MINE_EXPLOSION_AUDIO_COUNT")))])), JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "MINE_EXPLOSION_SMOKE_COUNT")])])
			JS.invoke_method(self, "_addCameraShake", [JS.get_property(JS.module("UIConstants"), "MINE_EXPLOSION_CAMERA_SHAKE")])
			break
		break
	return null

func original__removeTrap(_arg0 = null):
	var _scope36: Dictionary = {"trapId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "traps"), _scope36["trapId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "traps"), _scope36["trapId"]), "remove", [])
		JS.delete_property(JS.get_property(self, "traps"), _scope36["trapId"])
	return null

func original__activateMine(_arg0 = null):
	var _scope37: Dictionary = {"trapId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "traps"), _scope37["trapId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "traps"), _scope37["trapId"]), "activate", [])
	return null

func original__tripMine(_arg0 = null):
	var _scope38: Dictionary = {"trapId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "traps"), _scope38["trapId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "traps"), _scope38["trapId"]), "trip", [])
	return null

func original__detonateMine(_arg0 = null):
	var _scope39: Dictionary = {"trapId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "traps"), _scope39["trapId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "traps"), _scope39["trapId"]), "detonate", [])
	return null

func original__spawnExplosion(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope40: Dictionary = {"x": _arg0, "y": _arg1, "sound": _arg2, "smokeCount": _arg3, "explosion": null}
	_scope40["explosion"] = JS.invoke_method(JS.get_property(self, "explosionGroup"), "getFirstExists", [false])
	if JS.truthy(_scope40["explosion"]):
		JS.set_property(_scope40, "x", JS.invoke_method(JS.module("UIUtils"), "mpx", [_scope40["x"]]))
		JS.set_property(_scope40, "y", JS.invoke_method(JS.module("UIUtils"), "mpx", [_scope40["y"]]))
		JS.invoke_method(_scope40["explosion"], "spawn", [_scope40["x"], _scope40["y"], _scope40["sound"], _scope40["smokeCount"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create explosion group. No group available."])
	return null

func original__spawnShieldSparks(_arg0 = null, _arg1 = null):
	var _scope41: Dictionary = {"shieldedTank": _arg0, "position": _arg1}
	JS.invoke_method(JS.get_property(self, "shieldSparkGroup"), "emit", [_scope41["shieldedTank"], _scope41["position"]])
	return null

func original__createCollectible(_arg0 = null, _arg1 = null):
	var _scope42: Dictionary = {"collectible": _arg0, "playSpawnAnimation": _arg1, "crateSprite": null}
	var _switch6 = JS.invoke_method(_scope42["collectible"], "getType", [])
	var _switch6_start = -1
	if JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_LASER"), true): _switch6_start = 0
	elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_DOUBLE_BARREL"), true): _switch6_start = 1
	elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SHOTGUN"), true): _switch6_start = 2
	elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_HOMING_MISSILE"), true): _switch6_start = 3
	elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_MINE"), true): _switch6_start = 4
	elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_GATLING_GUN"), true): _switch6_start = 5
	elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_AIMER"), true): _switch6_start = 6
	elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SHIELD"), true): _switch6_start = 7
	elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SPEED_BOOST"), true): _switch6_start = 8
	while true:
		if _switch6_start >= 0 and _switch6_start <= 8:
			_scope42["crateSprite"] = JS.invoke_method(JS.get_property(self, "crateGroup"), "getFirstExists", [false])
			if JS.truthy(_scope42["crateSprite"]):
				JS.set_property(JS.get_property(self, "collectibles"), JS.invoke_method(_scope42["collectible"], "getId", []), _scope42["crateSprite"])
				JS.invoke_method(_scope42["crateSprite"], "spawn", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope42["collectible"], "getX", [])]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope42["collectible"], "getY", [])]), JS.invoke_method(_scope42["collectible"], "getRotation", []), JS.invoke_method(_scope42["collectible"], "getType", []), JS.invoke_method(_scope42["collectible"], "getId", []), _scope42["playSpawnAnimation"]])
			else:
				JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create crate sprite. No sprite available."])
			break
		break
	return null

func original__removeCollectible(_arg0 = null):
	var _scope43: Dictionary = {"collectibleId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "collectibles"), _scope43["collectibleId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "collectibles"), _scope43["collectibleId"]), "remove", [])
		JS.delete_property(JS.get_property(self, "collectibles"), _scope43["collectibleId"])
	return null

func original__createWeapon(_arg0 = null, _arg1 = null):
	var _scope44: Dictionary = {"weapon": _arg0, "playSpawnAnimation": _arg1, "tankSprite": null}
	_scope44["tankSprite"] = JS.get_property(JS.get_property(self, "tankSprites"), JS.invoke_method(_scope44["weapon"], "getPlayerId", []))
	if JS.truthy(_scope44["tankSprite"]):
		JS.invoke_method(_scope44["tankSprite"], "addWeapon", [_scope44["weapon"], _scope44["playSpawnAnimation"]])
	return null

func original__removeWeapon(_arg0 = null):
	var _scope45: Dictionary = {"playerId": _arg0, "tankSprite": null}
	_scope45["tankSprite"] = JS.get_property(JS.get_property(self, "tankSprites"), _scope45["playerId"])
	if JS.truthy(_scope45["tankSprite"]):
		JS.invoke_method(_scope45["tankSprite"], "removeWeapon", [])
	return null

func original__createUpgrade(_arg0 = null, _arg1 = null):
	var _scope46: Dictionary = {"upgrade": _arg0, "playSpawnAnimation": _arg1, "tankSprite": null, "aimerGraphics": null, "shieldSprite": null}
	_scope46["tankSprite"] = JS.get_property(JS.get_property(self, "tankSprites"), JS.invoke_method(_scope46["upgrade"], "getPlayerId", []))
	if JS.truthy(_scope46["tankSprite"]):
		JS.invoke_method(_scope46["tankSprite"], "addUpgrade", [_scope46["upgrade"], _scope46["playSpawnAnimation"]])
	var _switch7 = JS.invoke_method(_scope46["upgrade"], "getType", [])
	var _switch7_start = -1
	if JS.equal(_switch7, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "LASER_AIMER"), true): _switch7_start = 0
	elif JS.equal(_switch7, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SPAWN_SHIELD"), true): _switch7_start = 1
	elif JS.equal(_switch7, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SHIELD"), true): _switch7_start = 2
	elif JS.equal(_switch7, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "AIMER"), true): _switch7_start = 3
	elif JS.equal(_switch7, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SPEED_BOOST"), true): _switch7_start = 4
	while true:
		if _switch7_start >= 0 and _switch7_start <= 0:
			_scope46["aimerGraphics"] = JS.invoke_method(JS.get_property(self, "aimerGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope46["aimerGraphics"]))):
				JS.set_property(_scope46, "aimerGraphics", JS.invoke_method(JS.get_property(self, "aimerGroup"), "add", [JS.construct(JS.module("UIAimerGraphics"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])]))
			JS.set_property(JS.get_property(self, "upgrades"), JS.invoke_method(_scope46["upgrade"], "getId", []), _scope46["aimerGraphics"])
			JS.invoke_method(_scope46["aimerGraphics"], "spawn", [JS.invoke_method(_scope46["upgrade"], "getPlayerId", []), JS.invoke_method(_scope46["upgrade"], "getField", ["length"]), JS.invoke_method(_scope46["upgrade"], "getField", ["activated"])])
			break
		if _switch7_start >= 0 and _switch7_start <= 2:
			_scope46["shieldSprite"] = JS.invoke_method(JS.get_property(self, "shieldGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope46["shieldSprite"]))):
				JS.set_property(_scope46, "shieldSprite", JS.invoke_method(JS.get_property(self, "shieldGroup"), "add", [JS.construct(JS.module("UIShieldSprite"), [JS.get_property(self, "game"), JS.get_property(self, "gameController"), JS.get_property(self, "shieldActivateSound"), JS.get_property(self, "shieldWeakenedSound"), JS.get_property(self, "shieldEndSound")])]))
			JS.set_property(JS.get_property(self, "upgrades"), JS.invoke_method(_scope46["upgrade"], "getId", []), _scope46["shieldSprite"])
			JS.invoke_method(_scope46["shieldSprite"], "spawn", [JS.invoke_method(_scope46["upgrade"], "getPlayerId", []), JS.invoke_method(_scope46["upgrade"], "getField", ["weakened"]), _scope46["playSpawnAnimation"]])
			break
		if _switch7_start >= 0 and _switch7_start <= 3:
			_scope46["aimerGraphics"] = JS.invoke_method(JS.get_property(self, "aimerGroup"), "getFirstExists", [false])
			if JS.truthy((not JS.truthy(_scope46["aimerGraphics"]))):
				JS.set_property(_scope46, "aimerGraphics", JS.invoke_method(JS.get_property(self, "aimerGroup"), "add", [JS.construct(JS.module("UIAimerGraphics"), [JS.get_property(self, "game"), JS.get_property(self, "gameController")])]))
			JS.set_property(JS.get_property(self, "upgrades"), JS.invoke_method(_scope46["upgrade"], "getId", []), _scope46["aimerGraphics"])
			JS.invoke_method(_scope46["aimerGraphics"], "spawn", [JS.invoke_method(_scope46["upgrade"], "getPlayerId", []), JS.invoke_method(_scope46["upgrade"], "getField", ["length"]), true])
			break
		if _switch7_start >= 0 and _switch7_start <= 4:
			break
		break
	return null

func original__removeUpgrade(_arg0 = null):
	var _scope47: Dictionary = {"upgradeId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "upgrades"), _scope47["upgradeId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "upgrades"), _scope47["upgradeId"]), "remove", [])
		JS.delete_property(JS.get_property(self, "upgrades"), _scope47["upgradeId"])
	return null

func original__removeUpgrades(_arg0 = null):
	var _scope48: Dictionary = {"playerId": _arg0, "upgradeId": null}
	for _iteration8 in JS.keys(JS.get_property(self, "upgrades")):
		JS.set_property(_scope48, "upgradeId", _iteration8)
		if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(JS.get_property(self, "upgrades"), _scope48["upgradeId"]), "getPlayerId", []), _scope48["playerId"], false)):
			JS.invoke_method(JS.get_property(JS.get_property(self, "upgrades"), _scope48["upgradeId"]), "remove", [])
			JS.delete_property(JS.get_property(self, "upgrades"), _scope48["upgradeId"])
	return null

func original__showWeaponSymbol(_arg0 = null):
	var _scope49: Dictionary = {"playerId": _arg0, "weaponSymbolSprite": null}
	if JS.truthy(JS.has_property(JS.get_property(self, "weaponSymbolGroups"), _scope49["playerId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "weaponSymbolGroups"), _scope49["playerId"]), "refresh", [])
	else:
		_scope49["weaponSymbolSprite"] = JS.invoke_method(JS.get_property(self, "weaponSymbolGroup"), "getFirstExists", [false])
		if JS.truthy(_scope49["weaponSymbolSprite"]):
			JS.set_property(JS.get_property(self, "weaponSymbolGroups"), _scope49["playerId"], _scope49["weaponSymbolSprite"])
			JS.invoke_method(_scope49["weaponSymbolSprite"], "spawn", [_scope49["playerId"]])
		else:
			JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create weapon symbol. No sprite available."])
	return null

func original__removeWeaponSymbol(_arg0 = null):
	var _scope50: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.get_property(JS.get_property(self, "weaponSymbolGroups"), _scope50["playerId"])):
		JS.invoke_method(JS.get_property(JS.get_property(self, "weaponSymbolGroups"), _scope50["playerId"]), "remove", [])
		JS.delete_property(JS.get_property(self, "weaponSymbolGroups"), _scope50["playerId"])
	return null

func original__spawnRubble(_arg0 = null):
	var _scope51: Dictionary = {"tank": _arg0}
	JS.invoke_method(JS.get_property(self, "rubbleGroup"), "emit", [_scope51["tank"]])
	return null
