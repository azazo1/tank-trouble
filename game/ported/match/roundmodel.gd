# 由原版 RoundModel 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var b2dworld = null
var tanks = {}
var projectiles = {}
var traps = {}
var collectibles = {}
var collectibleCounts = {}
var weapons = {}
var upgrades = {}
var counters = {}
var zones = {}
var trapCreated = false
var weaponCreated = false
var upgradeCreated = false
var counterCreated = false
var zoneCreated = false
var zoneChanged = false
var eventListeners = []
var collisionEvents = []
var destroyedPlayerIds = []
var destroyedProjectileIds = []
var destroyedTrapIds = []
var destroyedCollectibleIds = []
var destroyedZoneIds = []
var playerIdOtherWeaponIds = {}
var playerIdDefaultWeaponId = {}
var playerIdUpgradeIds = {}
var playerIdModifiers = {}
var started = false
var running = true
var goldSpawnCount = 0
var diamondSpawnCount = 0
var ranked = false
var victoryGoldAmount = 0
var stakes = []
var punishablePlayerIds = []
var cachedRoundState = null
var log = null
var maze = null
static var _static_RoundModel: Dictionary = {}
static var _initialized_RoundModel = false
static func initialize_original_static():
	if _initialized_RoundModel: return
	_initialized_RoundModel = true
	_static_RoundModel["_EVENTS"] = {"MAZE_SET": "maze set", "TANK_CREATED": "tank created", "TANK_DESTROYED": "tank destroyed", "TANK_KILLED": "tank killed", "PROJECTILE_CREATED": "projectile created", "PROJECTILE_DESTROYED": "projectile destroyed", "PROJECTILE_TIMEOUT": "projectile timeout", "TRAP_CREATED": "trap created", "TRAP_TRIPPED": "trap tripped", "TRAP_DESTROYED": "trap destroyed", "COLLECTIBLE_CREATED": "collectible created", "COLLECTIBLE_DESTROYED": "collectible destroyed", "WEAPON_CREATED": "weapon created", "WEAPON_DESTROYED": "weapon destroyed", "UPGRADE_CREATED": "upgrade created", "UPGRADE_DESTROYED": "upgrade destroyed", "COUNTER_CREATED": "counter created", "COUNTER_DESTROYED": "counter destroyed", "ZONE_CREATED": "zone created", "ZONE_DESTROYED": "zone destroyed", "TANK_TANK_COLLISION": "tank tank collision", "TANK_MAZE_COLLISION": "tank maze collision", "TANK_COLLECTIBLE_COLLISION": "tank collectible collision", "TANK_DEADLY_COLLISION": "tank deadly collision", "TANK_TRAP_COLLISION": "tank trap collision", "TANK_TRAP_END_COLLISION": "tank trap end collision", "TANK_SHIELD_COLLISION": "tank shield collision", "TANK_ZONE_COLLISION": "tank zone collision", "PROJECTILE_MAZE_COLLISION": "projectile maze collision", "PROJECTILE_SHIELD_COLLISION": "projectile shield collision", "PROJECTILE_ZONE_COLLISION": "projectile zone collision", "SHIELD_SHIELD_COLLISION": "shield shield collision", "SHIELD_ZONE_COLLISION": "shield zone collision", "TRAP_ZONE_COLLISION": "trap zone collision", "ROUND_CREATED": "round created", "ROUND_STARTED": "round started", "ROUND_ENDED": "round ended", "CELEBRATION_STARTED": "celebration started", "CELEBRATION_ENDED": "celebration ended", "TANK_CHICKENED_OUT": "tank chickened out", "TANK_CHANGED": "tank changed"}
static func original_static_get(key):
	initialize_original_static()
	if _static_RoundModel.has(key): return _static_RoundModel[key]
	return null
static func original_static_set(key, value):
	_static_RoundModel[key] = value
	return value
func original_own_fields():
	return ["b2dworld","tanks","projectiles","traps","collectibles","collectibleCounts","weapons","upgrades","counters","zones","trapCreated","weaponCreated","upgradeCreated","counterCreated","zoneCreated","zoneChanged","eventListeners","collisionEvents","destroyedPlayerIds","destroyedProjectileIds","destroyedTrapIds","destroyedCollectibleIds","destroyedZoneIds","playerIdOtherWeaponIds","playerIdDefaultWeaponId","playerIdUpgradeIds","playerIdModifiers","started","running","goldSpawnCount","diamondSpawnCount","ranked","victoryGoldAmount","stakes","punishablePlayerIds","cachedRoundState","log","maze"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"controllerId": _arg0, "b2dworld": _arg1, "collectibleType": null}
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", [JS.add("RoundModel", _scope0["controllerId"])]))
	JS.set_property(self, "b2dworld", _scope0["b2dworld"])
	JS.invoke_method(JS.get_property(self, "b2dworld"), "SetContactListener", [self])
	for _iteration0 in JS.keys(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES")):
		JS.set_property(_scope0, "collectibleType", _iteration0)
		JS.set_property(JS.get_property(self, "collectibleCounts"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), _scope0["collectibleType"]), 0)
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/match/roundmodel.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_BeginContact(_arg0 = null):
	var _scope1: Dictionary = {"b2dcontact": _arg0, "data": null, "collisionEvent": null}
	_scope1["data"] = JS.invoke_method(JS.module("B2DUtils"), "getContactData", [_scope1["b2dcontact"]])
	_scope1["collisionEvent"] = {}
	var _switch1 = JS.get_property(_scope1["data"], "contactBits")
	var _switch1_start = -1
	if JS.equal(_switch1, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP")), true): _switch1_start = 0
	elif JS.equal(_switch1, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")), true): _switch1_start = 1
	while true:
		if _switch1_start >= 0 and _switch1_start <= 0:
			JS.set_property(_scope1["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TRAP_COLLISION"))
			JS.set_property(_scope1["collisionEvent"], "data", _scope1["data"])
			break
		if _switch1_start >= 0 and _switch1_start <= 1:
			JS.set_property(_scope1["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_ZONE_COLLISION"))
			JS.set_property(_scope1["collisionEvent"], "data", _scope1["data"])
			break
		break
	if JS.truthy(not JS.equal(JS.get_property(_scope1["collisionEvent"], "data"), null, true)):
		JS.invoke_method(JS.get_property(self, "collisionEvents"), "push", [_scope1["collisionEvent"]])
	return null

func original_EndContact(_arg0 = null):
	var _scope2: Dictionary = {"b2dcontact": _arg0, "data": null, "collisionEvent": null}
	_scope2["data"] = JS.invoke_method(JS.module("B2DUtils"), "getContactData", [_scope2["b2dcontact"]])
	_scope2["collisionEvent"] = {}
	var _switch2 = JS.get_property(_scope2["data"], "contactBits")
	var _switch2_start = -1
	if JS.equal(_switch2, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP")), true): _switch2_start = 0
	while true:
		if _switch2_start >= 0 and _switch2_start <= 0:
			JS.set_property(_scope2["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TRAP_END_COLLISION"))
			JS.set_property(_scope2["collisionEvent"], "data", _scope2["data"])
			break
		break
	if JS.truthy(not JS.equal(JS.get_property(_scope2["collisionEvent"], "data"), null, true)):
		JS.invoke_method(JS.get_property(self, "collisionEvents"), "push", [_scope2["collisionEvent"]])
	return null

func original_PostSolve(_arg0 = null, _arg1 = null):
	var _scope3: Dictionary = {"b2dcontact": _arg0, "b2dcontactimpulse": _arg1}
	return null

func original_PreSolve(_arg0 = null, _arg1 = null):
	var _scope4: Dictionary = {"b2dcontact": _arg0, "b2dmanifold": _arg1, "data": null, "collisionEvent": null}
	if JS.truthy((not JS.truthy(JS.invoke_method(_scope4["b2dcontact"], "IsTouching", [])))):
		return null
	_scope4["data"] = JS.invoke_method(JS.module("B2DUtils"), "getContactData", [_scope4["b2dcontact"]])
	_scope4["collisionEvent"] = {}
	var _switch3 = JS.get_property(_scope4["data"], "contactBits")
	var _switch3_start = -1
	if JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), true): _switch3_start = 0
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), true): _switch3_start = 1
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), true): _switch3_start = 2
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), true): _switch3_start = 3
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP")), true): _switch3_start = 4
	elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), true): _switch3_start = 5
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK")), true): _switch3_start = 6
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK")), true): _switch3_start = 7
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK")), true): _switch3_start = 8
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK")), true): _switch3_start = 9
	elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD"), true): _switch3_start = 10
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")), true): _switch3_start = 11
	elif JS.equal(_switch3, JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")), true): _switch3_start = 12
	while true:
		if _switch3_start >= 0 and _switch3_start <= 0:
			if JS.truthy((not JS.truthy(JS.invoke_method(JS.get_property(_scope4["data"], "projectile"), "isDeadlyToOwner", [])))):
				JS.invoke_method(JS.get_property(_scope4["data"], "projectile"), "makeDeadlyToOwner", [])
			JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_MAZE_COLLISION"))
			JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			break
		if _switch3_start >= 0 and _switch3_start <= 1:
			if JS.truthy(JS.logical("||", func():
				var _scope5: Dictionary = {}
				return JS.invoke_method(JS.get_property(_scope4["data"], "projectile"), "isDeadlyToOwner", [])
				return null, func():
				var _scope6: Dictionary = {}
				return not JS.equal(JS.invoke_method(JS.get_property(_scope4["data"], "tankA"), "getPlayerId", []), JS.invoke_method(JS.get_property(_scope4["data"], "projectile"), "getPlayerId", []), false)
				return null)):
				JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_DEADLY_COLLISION"))
				JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
			break
		if _switch3_start >= 0 and _switch3_start <= 2:
			if JS.truthy(JS.logical("&&", func():
				var _scope7: Dictionary = {}
				return (not JS.truthy(JS.invoke_method(JS.get_property(_scope4["data"], "projectile"), "isDeadlyToOwner", [])))
				return null, func():
				var _scope8: Dictionary = {}
				return JS.equal(JS.invoke_method(JS.get_property(_scope4["data"], "projectile"), "getPlayerId", []), JS.invoke_method(JS.get_property(_scope4["data"], "shieldA"), "getPlayerId", []), false)
				return null)):
				JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
			else:
				if JS.truthy((not JS.truthy(JS.invoke_method(JS.get_property(_scope4["data"], "projectile"), "isDeadlyToOwner", [])))):
					JS.invoke_method(JS.get_property(_scope4["data"], "projectile"), "makeDeadlyToOwner", [])
				if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(_scope4["data"], "projectile"), "getType", []), JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), false)):
					JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
				JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_SHIELD_COLLISION"))
				JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			break
		if _switch3_start >= 0 and _switch3_start <= 3:
			if JS.truthy((not JS.truthy(JS.invoke_method(JS.get_property(_scope4["data"], "zone"), "isPhysical", [])))):
				JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
			JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_ZONE_COLLISION"))
			JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			break
		if _switch3_start >= 0 and _switch3_start <= 4:
			JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
			break
		if _switch3_start >= 0 and _switch3_start <= 5:
			JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TANK_COLLISION"))
			JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			break
		if _switch3_start >= 0 and _switch3_start <= 6:
			JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_MAZE_COLLISION"))
			JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			break
		if _switch3_start >= 0 and _switch3_start <= 7:
			JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_COLLECTIBLE_COLLISION"))
			JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
			break
		if _switch3_start >= 0 and _switch3_start <= 8:
			if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(_scope4["data"], "tankA"), "getPlayerId", []), JS.invoke_method(JS.get_property(_scope4["data"], "shieldA"), "getPlayerId", []), false)):
				JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
			else:
				JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_SHIELD_COLLISION"))
				JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			break
		if _switch3_start >= 0 and _switch3_start <= 9:
			if JS.truthy((not JS.truthy(JS.invoke_method(JS.get_property(_scope4["data"], "zone"), "isPhysical", [])))):
				JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
			JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_ZONE_COLLISION"))
			JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			break
		if _switch3_start >= 0 and _switch3_start <= 10:
			JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "SHIELD_SHIELD_COLLISION"))
			JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			break
		if _switch3_start >= 0 and _switch3_start <= 11:
			if JS.truthy((not JS.truthy(JS.invoke_method(JS.get_property(_scope4["data"], "zone"), "isPhysical", [])))):
				JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
			JS.set_property(_scope4["collisionEvent"], "collisionType", JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "SHIELD_ZONE_COLLISION"))
			JS.set_property(_scope4["collisionEvent"], "data", _scope4["data"])
			break
		if _switch3_start >= 0 and _switch3_start <= 12:
			JS.invoke_method(_scope4["b2dcontact"], "SetEnabled", [false])
			break
		break
	if JS.truthy(not JS.equal(JS.get_property(_scope4["collisionEvent"], "data"), null, true)):
		JS.invoke_method(JS.get_property(self, "collisionEvents"), "push", [_scope4["collisionEvent"]])
	return null

func original_setMaze(_arg0 = null):
	var _scope9: Dictionary = {"maze": _arg0}
	JS.set_property(self, "maze", _scope9["maze"])
	JS.invoke_method(JS.module("B2DUtils"), "createMaze", [JS.get_property(self, "b2dworld"), _scope9["maze"]])
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "MAZE_SET"), _scope9["maze"]])
	return null

func original_getMaze(_arg0 = null, _arg1 = null):
	var _scope10: Dictionary = {}
	return JS.get_property(self, "maze")
	return null

func original_removeTank(_arg0 = null):
	var _scope11: Dictionary = {"playerId": _arg0, "projectileIds": null, "trapIds": null, "projectile": null, "projectileId": null, "trap": null, "trapId": null, "chickenOut": null}
	if JS.truthy(JS.has_property(JS.get_property(self, "tanks"), _scope11["playerId"])):
		JS.set_property(self, "cachedRoundState", null)
		JS.invoke_method(JS.get_property(self, "destroyedPlayerIds"), "push", [_scope11["playerId"]])
		JS.invoke_method(JS.get_property(self, "punishablePlayerIds"), "push", [_scope11["playerId"]])
		_scope11["projectileIds"] = []
		_scope11["trapIds"] = []
		for _iteration4 in JS.keys(JS.get_property(self, "projectiles")):
			JS.set_property(_scope11, "projectile", _iteration4)
			if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(JS.get_property(self, "projectiles"), _scope11["projectile"]), "getPlayerId", []), _scope11["playerId"], false)):
				_scope11["projectileId"] = JS.invoke_method(JS.get_property(JS.get_property(self, "projectiles"), _scope11["projectile"]), "getId", [])
				JS.invoke_method(JS.get_property(self, "destroyedProjectileIds"), "push", [_scope11["projectileId"]])
				JS.invoke_method(_scope11["projectileIds"], "push", [_scope11["projectileId"]])
		for _iteration5 in JS.keys(JS.get_property(self, "traps")):
			JS.set_property(_scope11, "trap", _iteration5)
			if JS.truthy(JS.equal(JS.invoke_method(JS.get_property(JS.get_property(self, "traps"), _scope11["trap"]), "getPlayerId", []), _scope11["playerId"], false)):
				_scope11["trapId"] = JS.invoke_method(JS.get_property(JS.get_property(self, "traps"), _scope11["trap"]), "getId", [])
				JS.invoke_method(JS.get_property(self, "destroyedTrapIds"), "push", [_scope11["trapId"]])
				JS.invoke_method(_scope11["trapIds"], "push", [_scope11["trapId"]])
		_scope11["chickenOut"] = JS.invoke_method(JS.module("ChickenOut"), "create", [_scope11["playerId"], _scope11["projectileIds"], _scope11["trapIds"]])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CHICKENED_OUT"), _scope11["chickenOut"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add(JS.add("Attempt to remove tank with id ", _scope11["playerId"]), " from round, but tank is not currently in this round")])
	return null

func original_setProjectileState(_arg0 = null):
	var _scope12: Dictionary = {"projectileState": _arg0, "projectile": null, "b2dBody": null}
	JS.set_property(self, "cachedRoundState", null)
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope12["projectileState"], "getId", []))))):
		var _switch6 = JS.invoke_method(_scope12["projectileState"], "getType", [])
		var _switch6_start = -1
		if JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch6_start = 0
		elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch6_start = 1
		elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch6_start = 2
		elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch6_start = 3
		elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch6_start = 4
		elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch6_start = 5
		elif JS.equal(_switch6, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch6_start = 6
		while true:
			if _switch6_start >= 0 and _switch6_start <= 0:
				JS.set_property(_scope12, "projectile", JS.invoke_method(JS.module("Projectile"), "create", [_scope12["projectileState"], JS.get_property(JS.module("Constants"), "BULLET_MAX_LIFETIME"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_WINDOW"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_COUNT"), self, JS.get_property(self, "relayEvent"), self]))
				JS.set_property(_scope12, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createProjectileBody", [JS.get_property(self, "b2dworld"), _scope12["projectile"], JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET"), "RADIUS"), "m")]))
				break
			if _switch6_start >= 0 and _switch6_start <= 1:
				JS.set_property(_scope12, "projectile", JS.invoke_method(JS.module("Projectile"), "create", [_scope12["projectileState"], JS.get_property(JS.module("Constants"), "LASER_MAX_LIFETIME"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_WINDOW"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_COUNT"), self, JS.get_property(self, "relayEvent"), self]))
				JS.set_property(_scope12, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createProjectileBody", [JS.get_property(self, "b2dworld"), _scope12["projectile"], JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER"), "RADIUS"), "m")]))
				break
			if _switch6_start >= 0 and _switch6_start <= 2:
				JS.set_property(_scope12, "projectile", JS.invoke_method(JS.module("Projectile"), "create", [_scope12["projectileState"], JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_MAX_LIFETIME"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_WINDOW"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_COUNT"), self, JS.get_property(self, "relayEvent"), self]))
				JS.set_property(_scope12, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createProjectileBody", [JS.get_property(self, "b2dworld"), _scope12["projectile"], JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL"), "RADIUS"), "m")]))
				break
			if _switch6_start >= 0 and _switch6_start <= 3:
				JS.set_property(_scope12, "projectile", JS.invoke_method(JS.module("Shotgun"), "create", [_scope12["projectileState"], JS.get_property(JS.module("Constants"), "SHOTGUN_MAX_LIFETIME"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_WINDOW"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_COUNT"), self, JS.get_property(self, "relayEvent"), self]))
				JS.set_property(_scope12, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createProjectileBody", [JS.get_property(self, "b2dworld"), _scope12["projectile"], JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN"), "RADIUS"), "m")]))
				break
			if _switch6_start >= 0 and _switch6_start <= 4:
				JS.set_property(_scope12, "projectile", JS.invoke_method(JS.module("HomingMissile"), "create", [_scope12["projectileState"], JS.get_property(JS.module("Constants"), "HOMING_MISSILE_MAX_LIFETIME"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_WINDOW"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_COUNT"), self, JS.get_property(self, "relayEvent"), self]))
				JS.set_property(_scope12, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createProjectileBody", [JS.get_property(self, "b2dworld"), _scope12["projectile"], JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "HOMING_MISSILE"), "RADIUS"), "m")]))
				break
			if _switch6_start >= 0 and _switch6_start <= 5:
				JS.set_property(_scope12, "projectile", JS.invoke_method(JS.module("Shrapnel"), "create", [_scope12["projectileState"], 0, JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_WINDOW"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_COUNT"), self, JS.get_property(self, "relayEvent"), self]))
				JS.set_property(_scope12, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createProjectileBody", [JS.get_property(self, "b2dworld"), _scope12["projectile"], JS.get_property(JS.module("Constants"), "MINE_SHRAPNEL_RADIUS")]))
				break
			if _switch6_start >= 0 and _switch6_start <= 6:
				JS.set_property(_scope12, "projectile", JS.invoke_method(JS.module("Projectile"), "create", [_scope12["projectileState"], JS.get_property(JS.module("Constants"), "GATLING_GUN_MAX_LIFETIME"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_WINDOW"), JS.get_property(JS.module("Constants"), "PROJECTILE_BOUNCE_TIMEOUT_COUNT"), self, JS.get_property(self, "relayEvent"), self]))
				JS.set_property(_scope12, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createProjectileBody", [JS.get_property(self, "b2dworld"), _scope12["projectile"], JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN"), "RADIUS"), "m")]))
				break
			break
		JS.invoke_method(_scope12["projectile"], "setB2DBody", [_scope12["b2dBody"]])
		JS.set_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope12["projectileState"], "getId", []), _scope12["projectile"])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_CREATED"), _scope12["projectile"]])
	else:
		JS.invoke_method(JS.get_property(JS.get_property(self, "projectiles"), JS.invoke_method(_scope12["projectileState"], "getId", [])), "setProjectileState", [_scope12["projectileState"]])
	return null

func original_setTrapState(_arg0 = null):
	var _scope13: Dictionary = {"trapState": _arg0, "trap": null, "b2dBody": null}
	JS.set_property(self, "cachedRoundState", null)
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "traps"), JS.invoke_method(_scope13["trapState"], "getId", []))))):
		var _switch7 = JS.invoke_method(_scope13["trapState"], "getType", [])
		var _switch7_start = -1
		if JS.equal(_switch7, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch7_start = 0
		while true:
			if _switch7_start >= 0 and _switch7_start <= 0:
				JS.set_property(_scope13, "trap", JS.invoke_method(JS.module("Mine"), "create", [_scope13["trapState"], self, JS.get_property(self, "relayEvent"), self]))
				JS.set_property(_scope13, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createTrapBody", [JS.get_property(self, "b2dworld"), _scope13["trap"], JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MINE"), "RADIUS"), "m")]))
				break
			break
		JS.invoke_method(_scope13["trap"], "setB2DBody", [_scope13["b2dBody"]])
		JS.set_property(JS.get_property(self, "traps"), JS.invoke_method(_scope13["trapState"], "getId", []), _scope13["trap"])
		JS.set_property(self, "trapCreated", true)
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_CREATED"), _scope13["trap"]])
	else:
		pass
	return null

func original_setCollectibleState(_arg0 = null):
	var _scope14: Dictionary = {"collectibleState": _arg0, "collectible": null, "b2dBody": null}
	JS.set_property(self, "cachedRoundState", null)
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "collectibles"), JS.invoke_method(_scope14["collectibleState"], "getId", []))))):
		_scope14["collectible"] = JS.invoke_method(JS.module("Collectible"), "create", [_scope14["collectibleState"]])
		var _switch8 = JS.invoke_method(_scope14["collectibleState"], "getType", [])
		var _switch8_start = -1
		if JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_LASER"), true): _switch8_start = 0
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_DOUBLE_BARREL"), true): _switch8_start = 1
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SHOTGUN"), true): _switch8_start = 2
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_HOMING_MISSILE"), true): _switch8_start = 3
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_MINE"), true): _switch8_start = 4
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_GATLING_GUN"), true): _switch8_start = 5
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_AIMER"), true): _switch8_start = 6
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SHIELD"), true): _switch8_start = 7
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SPEED_BOOST"), true): _switch8_start = 8
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "GOLD"), true): _switch8_start = 9
		elif JS.equal(_switch8, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "DIAMOND"), true): _switch8_start = 10
		while true:
			if _switch8_start >= 0 and _switch8_start <= 8:
				JS.set_property(_scope14, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createCrateBody", [JS.get_property(self, "b2dworld"), _scope14["collectible"]]))
				break
			if _switch8_start >= 0 and _switch8_start <= 9:
				JS.set_property(_scope14, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createGoldBody", [JS.get_property(self, "b2dworld"), _scope14["collectible"]]))
				JS.increment(self, "goldSpawnCount", 1, false)
				break
			if _switch8_start >= 0 and _switch8_start <= 10:
				JS.set_property(_scope14, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createDiamondBody", [JS.get_property(self, "b2dworld"), _scope14["collectible"]]))
				JS.increment(self, "diamondSpawnCount", 1, false)
				break
			break
		JS.invoke_method(_scope14["collectible"], "setB2DBody", [_scope14["b2dBody"]])
		JS.set_property(JS.get_property(self, "collectibles"), JS.invoke_method(_scope14["collectibleState"], "getId", []), _scope14["collectible"])
		JS.increment(JS.get_property(self, "collectibleCounts"), JS.invoke_method(_scope14["collectible"], "getType", []), 1, true)
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COLLECTIBLE_CREATED"), _scope14["collectible"]])
	else:
		JS.invoke_method(JS.get_property(JS.get_property(self, "collectibles"), JS.invoke_method(_scope14["collectibleState"], "getId", [])), "setCollectibleState", [_scope14["collectibleState"]])
	return null

func original_setTankState(_arg0 = null, _arg1 = null):
	var _scope15: Dictionary = {"tankState": _arg0, "tank": null, "b2dBody": null}
	JS.set_property(self, "cachedRoundState", null)
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "tanks"), JS.invoke_method(_scope15["tankState"], "getPlayerId", []))))):
		_scope15["tank"] = JS.invoke_method(JS.module("Tank"), "create", [_scope15["tankState"], self])
		JS.set_property(JS.get_property(self, "tanks"), JS.invoke_method(_scope15["tankState"], "getPlayerId", []), _scope15["tank"])
		JS.set_property(JS.get_property(self, "playerIdDefaultWeaponId"), JS.invoke_method(_scope15["tankState"], "getPlayerId", []), null)
		JS.set_property(JS.get_property(self, "playerIdOtherWeaponIds"), JS.invoke_method(_scope15["tankState"], "getPlayerId", []), [])
		JS.set_property(JS.get_property(self, "playerIdUpgradeIds"), JS.invoke_method(_scope15["tankState"], "getPlayerId", []), [])
		JS.invoke_method(self, "_updateModifiers", [JS.invoke_method(_scope15["tankState"], "getPlayerId", [])])
		_scope15["b2dBody"] = JS.invoke_method(JS.module("B2DUtils"), "createTankBody", [JS.get_property(self, "b2dworld"), _scope15["tank"]])
		JS.invoke_method(_scope15["tank"], "setB2DBody", [_scope15["b2dBody"]])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CREATED"), _scope15["tank"]])
	else:
		JS.invoke_method(JS.get_property(JS.get_property(self, "tanks"), JS.invoke_method(_scope15["tankState"], "getPlayerId", [])), "setTankState", [_scope15["tankState"]])
	return null

func original_setWeaponState(_arg0 = null):
	var _scope16: Dictionary = {"weaponState": _arg0, "weapon": null, "newWeapon": null, "tank": null}
	JS.set_property(self, "cachedRoundState", null)
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "weapons"), JS.invoke_method(_scope16["weaponState"], "getId", []))))):
		var _switch9 = JS.invoke_method(_scope16["weaponState"], "getType", [])
		var _switch9_start = -1
		if JS.equal(_switch9, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch9_start = 0
		elif JS.equal(_switch9, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch9_start = 1
		elif JS.equal(_switch9, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch9_start = 2
		elif JS.equal(_switch9, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch9_start = 3
		elif JS.equal(_switch9, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch9_start = 4
		elif JS.equal(_switch9, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch9_start = 5
		elif JS.equal(_switch9, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch9_start = 6
		while true:
			if _switch9_start >= 0 and _switch9_start <= 0:
				JS.set_property(_scope16, "weapon", JS.invoke_method(JS.module("BulletWeapon"), "create", [_scope16["weaponState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch9_start >= 0 and _switch9_start <= 1:
				JS.set_property(_scope16, "weapon", JS.invoke_method(JS.module("LaserWeapon"), "create", [_scope16["weaponState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch9_start >= 0 and _switch9_start <= 2:
				JS.set_property(_scope16, "weapon", JS.invoke_method(JS.module("DoubleBarrelWeapon"), "create", [_scope16["weaponState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch9_start >= 0 and _switch9_start <= 3:
				JS.set_property(_scope16, "weapon", JS.invoke_method(JS.module("ShotgunWeapon"), "create", [_scope16["weaponState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch9_start >= 0 and _switch9_start <= 4:
				JS.set_property(_scope16, "weapon", JS.invoke_method(JS.module("HomingMissileWeapon"), "create", [_scope16["weaponState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch9_start >= 0 and _switch9_start <= 5:
				JS.set_property(_scope16, "weapon", JS.invoke_method(JS.module("MineWeapon"), "create", [_scope16["weaponState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch9_start >= 0 and _switch9_start <= 6:
				JS.set_property(_scope16, "weapon", JS.invoke_method(JS.module("GatlingGunWeapon"), "create", [_scope16["weaponState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			break
		JS.set_property(JS.get_property(self, "weapons"), JS.invoke_method(_scope16["weaponState"], "getId", []), _scope16["weapon"])
		if JS.truthy(JS.invoke_method(_scope16["weapon"], "isDefault", [])):
			JS.set_property(JS.get_property(self, "playerIdDefaultWeaponId"), JS.invoke_method(_scope16["weaponState"], "getPlayerId", []), JS.invoke_method(_scope16["weapon"], "getId", []))
		else:
			JS.invoke_method(JS.get_property(JS.get_property(self, "playerIdOtherWeaponIds"), JS.invoke_method(_scope16["weaponState"], "getPlayerId", [])), "unshift", [JS.invoke_method(_scope16["weapon"], "getId", [])])
		_scope16["newWeapon"] = JS.invoke_method(self, "getActiveWeapon", [JS.invoke_method(_scope16["weaponState"], "getPlayerId", [])])
		_scope16["tank"] = JS.get_property(JS.get_property(self, "tanks"), JS.invoke_method(_scope16["weaponState"], "getPlayerId", []))
		if JS.truthy(JS.logical("&&", func():
			var _scope17: Dictionary = {}
			return _scope16["newWeapon"]
			return null, func():
			var _scope18: Dictionary = {}
			return _scope16["tank"]
			return null)):
			JS.invoke_method(JS.module("B2DUtils"), "updateTankBodyTurret", [JS.invoke_method(_scope16["tank"], "getB2DBody", []), _scope16["tank"], _scope16["newWeapon"]])
		JS.set_property(self, "weaponCreated", true)
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "WEAPON_CREATED"), _scope16["weapon"]])
	else:
		pass
	return null

func original_setUpgradeState(_arg0 = null):
	var _scope19: Dictionary = {"upgradeState": _arg0, "upgrade": null, "tank": null}
	JS.set_property(self, "cachedRoundState", null)
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "upgrades"), JS.invoke_method(_scope19["upgradeState"], "getId", []))))):
		var _switch10 = JS.invoke_method(_scope19["upgradeState"], "getType", [])
		var _switch10_start = -1
		if JS.equal(_switch10, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "LASER_AIMER"), true): _switch10_start = 0
		elif JS.equal(_switch10, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SPAWN_SHIELD"), true): _switch10_start = 1
		elif JS.equal(_switch10, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "AIMER"), true): _switch10_start = 2
		elif JS.equal(_switch10, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SHIELD"), true): _switch10_start = 3
		elif JS.equal(_switch10, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SPEED_BOOST"), true): _switch10_start = 4
		while true:
			if _switch10_start >= 0 and _switch10_start <= 0:
				JS.set_property(_scope19, "upgrade", JS.invoke_method(JS.module("LaserAimerUpgrade"), "create", [_scope19["upgradeState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch10_start >= 0 and _switch10_start <= 1:
				JS.set_property(_scope19, "upgrade", JS.invoke_method(JS.module("SpawnShieldUpgrade"), "create", [_scope19["upgradeState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch10_start >= 0 and _switch10_start <= 2:
				JS.set_property(_scope19, "upgrade", JS.invoke_method(JS.module("AimerUpgrade"), "create", [_scope19["upgradeState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch10_start >= 0 and _switch10_start <= 3:
				JS.set_property(_scope19, "upgrade", JS.invoke_method(JS.module("ShieldUpgrade"), "create", [_scope19["upgradeState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch10_start >= 0 and _switch10_start <= 4:
				JS.set_property(_scope19, "upgrade", JS.invoke_method(JS.module("SpeedBoostUpgrade"), "create", [_scope19["upgradeState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			break
		JS.set_property(JS.get_property(self, "upgrades"), JS.invoke_method(_scope19["upgradeState"], "getId", []), _scope19["upgrade"])
		JS.invoke_method(JS.get_property(JS.get_property(self, "playerIdUpgradeIds"), JS.invoke_method(_scope19["upgradeState"], "getPlayerId", [])), "push", [JS.invoke_method(_scope19["upgrade"], "getId", [])])
		JS.invoke_method(self, "_updateModifiers", [JS.invoke_method(_scope19["upgradeState"], "getPlayerId", [])])
		_scope19["tank"] = JS.get_property(JS.get_property(self, "tanks"), JS.invoke_method(_scope19["upgradeState"], "getPlayerId", []))
		if JS.truthy(_scope19["tank"]):
			JS.invoke_method(JS.module("B2DUtils"), "addTankBodyUpgrade", [JS.invoke_method(_scope19["tank"], "getB2DBody", []), _scope19["upgrade"]])
		JS.set_property(self, "upgradeCreated", true)
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_CREATED"), _scope19["upgrade"]])
	else:
		pass
	return null

func original_setCounterState(_arg0 = null):
	var _scope20: Dictionary = {"counterState": _arg0, "counter": null}
	JS.set_property(self, "cachedRoundState", null)
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "counters"), JS.invoke_method(_scope20["counterState"], "getId", []))))):
		var _switch11 = JS.invoke_method(_scope20["counterState"], "getType", [])
		var _switch11_start = -1
		if JS.equal(_switch11, JS.get_property(JS.get_property(JS.module("Constants"), "COUNTER_TYPES"), "TIMER_COUNTDOWN"), true): _switch11_start = 0
		elif JS.equal(_switch11, JS.get_property(JS.get_property(JS.module("Constants"), "COUNTER_TYPES"), "OVERTIME_COUNT_UP"), true): _switch11_start = 1
		while true:
			if _switch11_start >= 0 and _switch11_start <= 0:
				JS.set_property(_scope20, "counter", JS.invoke_method(JS.module("TimerCountdownCounter"), "create", [_scope20["counterState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			if _switch11_start >= 0 and _switch11_start <= 1:
				JS.set_property(_scope20, "counter", JS.invoke_method(JS.module("OvertimeCountUpCounter"), "create", [_scope20["counterState"], self, JS.get_property(self, "relayEvent"), self]))
				break
			break
		JS.set_property(JS.get_property(self, "counters"), JS.invoke_method(_scope20["counterState"], "getId", []), _scope20["counter"])
		JS.set_property(self, "counterCreated", true)
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COUNTER_CREATED"), _scope20["counter"]])
	else:
		pass
	return null

func original_setZoneState(_arg0 = null):
	var _scope21: Dictionary = {"zoneState": _arg0, "zone": null, "b2dBody": null, "corners": null}
	JS.set_property(self, "cachedRoundState", null)
	if JS.truthy((not JS.truthy(JS.has_property(JS.get_property(self, "zones"), JS.invoke_method(_scope21["zoneState"], "getId", []))))):
		_scope21["b2dBody"] = null
		var _switch12 = JS.invoke_method(_scope21["zoneState"], "getType", [])
		var _switch12_start = -1
		if JS.equal(_switch12, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "SPAWN"), true): _switch12_start = 0
		elif JS.equal(_switch12, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "STORM"), true): _switch12_start = 1
		while true:
			if _switch12_start >= 0 and _switch12_start <= 0:
				JS.set_property(_scope21, "zone", JS.invoke_method(JS.module("SpawnZone"), "create", [_scope21["zoneState"], self, JS.get_property(self, "relayEvent"), self]))
				JS.set_property(_scope21, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createSpawnZoneBody", [JS.get_property(self, "b2dworld"), _scope21["zone"], JS.invoke_method(_scope21["zone"], "getField", ["radius"])]))
				break
			if _switch12_start >= 0 and _switch12_start <= 1:
				JS.set_property(_scope21, "zone", JS.invoke_method(JS.module("StormZone"), "create", [_scope21["zoneState"], self, JS.get_property(self, "relayEvent"), self]))
				_scope21["corners"] = JS.invoke_method(_scope21["zone"], "getCorners", [])
				JS.set_property(_scope21, "b2dBody", JS.invoke_method(JS.module("B2DUtils"), "createStormZoneBody", [JS.get_property(self, "b2dworld"), _scope21["zone"], JS.get_property(_scope21["corners"], "stormStartRight"), JS.get_property(_scope21["corners"], "stormEndRight"), JS.get_property(_scope21["corners"], "stormStartBottom"), JS.get_property(_scope21["corners"], "stormEndBottom"), JS.get_property(_scope21["corners"], "stormStartLeft"), JS.get_property(_scope21["corners"], "stormEndLeft"), JS.get_property(_scope21["corners"], "stormStartTop"), JS.get_property(_scope21["corners"], "stormEndTop")]))
				break
			break
		JS.invoke_method(_scope21["zone"], "setB2DBody", [_scope21["b2dBody"]])
		JS.set_property(JS.get_property(self, "zones"), JS.invoke_method(_scope21["zoneState"], "getId", []), _scope21["zone"])
		JS.set_property(self, "zoneCreated", true)
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ZONE_CREATED"), _scope21["zone"]])
	else:
		if JS.truthy(JS.equal(JS.invoke_method(_scope21["zoneState"], "getType", []), JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "STORM"), false)):
			JS.invoke_method(JS.get_property(JS.get_property(self, "zones"), JS.invoke_method(_scope21["zoneState"], "getId", [])), "setZoneState", [_scope21["zoneState"]])
	return null

func original_emitTankState(_arg0 = null):
	var _scope22: Dictionary = {"tankState": _arg0}
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CHANGED"), _scope22["tankState"]])
	return null

func original_getRoundState(_arg0 = null):
	var _scope23: Dictionary = {"expandedState": _arg0, "rs": null, "tankStates": null, "projectileStates": null, "collectibleStates": null, "playerIds": null, "i": null, "playerId": null, "tank": null, "projectileIds": null, "projectileId": null, "projectile": null, "collectibleIds": null, "collectibleId": null, "collectible": null}
	JS.set_property(_scope23, "expandedState", JS.bitwise("|", _scope23["expandedState"], JS.logical("||", func():
		var _scope34: Dictionary = {}
		return JS.logical("||", func():
			var _scope35: Dictionary = {}
			return JS.logical("||", func():
				var _scope36: Dictionary = {}
				return JS.logical("||", func():
					var _scope37: Dictionary = {}
					return JS.logical("||", func():
						var _scope38: Dictionary = {}
						return JS.get_property(self, "trapCreated")
						return null, func():
						var _scope39: Dictionary = {}
						return JS.get_property(self, "weaponCreated")
						return null)
					return null, func():
					var _scope40: Dictionary = {}
					return JS.get_property(self, "upgradeCreated")
					return null)
				return null, func():
				var _scope41: Dictionary = {}
				return JS.get_property(self, "counterCreated")
				return null)
			return null, func():
			var _scope42: Dictionary = {}
			return JS.get_property(self, "zoneCreated")
			return null)
		return null, func():
		var _scope43: Dictionary = {}
		return JS.get_property(self, "zoneChanged")
		return null)))
	if JS.truthy(JS.get_property(self, "cachedRoundState")):
		if JS.truthy(JS.logical("||", func():
			var _scope44: Dictionary = {}
			return JS.logical("&&", func():
				var _scope45: Dictionary = {}
				return _scope23["expandedState"]
				return null, func():
				var _scope46: Dictionary = {}
				return JS.invoke_method(JS.get_property(self, "cachedRoundState"), "isExpanded", [])
				return null)
			return null, func():
			var _scope47: Dictionary = {}
			return JS.logical("&&", func():
				var _scope48: Dictionary = {}
				return (not JS.truthy(_scope23["expandedState"]))
				return null, func():
				var _scope49: Dictionary = {}
				return (not JS.truthy(JS.invoke_method(JS.get_property(self, "cachedRoundState"), "isExpanded", [])))
				return null)
			return null)):
			return JS.get_property(self, "cachedRoundState")
	_scope23["rs"] = JS.invoke_method(JS.module("RoundState"), "create", [])
	_scope23["tankStates"] = []
	_scope23["projectileStates"] = []
	_scope23["collectibleStates"] = []
	_scope23["playerIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "tanks")])
	_scope23["i"] = 0
	while JS.truthy(JS.compare("<", _scope23["i"], JS.get_property(_scope23["playerIds"], "length"))):
		_scope23["playerId"] = JS.get_property(_scope23["playerIds"], _scope23["i"])
		if JS.truthy(JS.compare(">=", JS.invoke_method(JS.get_property(self, "destroyedPlayerIds"), "indexOf", [_scope23["playerId"]]), 0)):
			JS.increment(_scope23, "i", 1, true)
			continue
		_scope23["tank"] = JS.get_property(JS.get_property(self, "tanks"), _scope23["playerId"])
		JS.invoke_method(_scope23["tankStates"], "push", [JS.invoke_method(_scope23["tank"], "getTankState", [])])
		JS.increment(_scope23, "i", 1, true)
	JS.invoke_method(_scope23["rs"], "setTankStates", [_scope23["tankStates"]])
	_scope23["projectileIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "projectiles")])
	_scope23["i"] = 0
	while JS.truthy(JS.compare("<", _scope23["i"], JS.get_property(_scope23["projectileIds"], "length"))):
		_scope23["projectileId"] = JS.get_property(_scope23["projectileIds"], _scope23["i"])
		if JS.truthy(JS.compare(">=", JS.invoke_method(JS.get_property(self, "destroyedProjectileIds"), "indexOf", [_scope23["projectileId"]]), 0)):
			JS.increment(_scope23, "i", 1, true)
			continue
		_scope23["projectile"] = JS.get_property(JS.get_property(self, "projectiles"), _scope23["projectileId"])
		JS.invoke_method(_scope23["projectileStates"], "push", [JS.invoke_method(_scope23["projectile"], "getProjectileState", [])])
		JS.increment(_scope23, "i", 1, true)
	JS.invoke_method(_scope23["rs"], "setProjectileStates", [_scope23["projectileStates"]])
	_scope23["collectibleIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "collectibles")])
	_scope23["i"] = 0
	while JS.truthy(JS.compare("<", _scope23["i"], JS.get_property(_scope23["collectibleIds"], "length"))):
		_scope23["collectibleId"] = JS.get_property(_scope23["collectibleIds"], _scope23["i"])
		if JS.truthy(JS.compare(">=", JS.invoke_method(JS.get_property(self, "destroyedCollectibleIds"), "indexOf", [_scope23["collectibleId"]]), 0)):
			JS.increment(_scope23, "i", 1, true)
			continue
		_scope23["collectible"] = JS.get_property(JS.get_property(self, "collectibles"), _scope23["collectibleId"])
		JS.invoke_method(_scope23["collectibleStates"], "push", [JS.invoke_method(_scope23["collectible"], "getCollectibleState", [])])
		JS.increment(_scope23, "i", 1, true)
	JS.invoke_method(_scope23["rs"], "setCollectibleStates", [_scope23["collectibleStates"]])
	if JS.truthy(_scope23["expandedState"]):
		JS.invoke_method(self, "_getExpandedRoundState", [_scope23["rs"]])
	JS.set_property(self, "cachedRoundState", _scope23["rs"])
	return _scope23["rs"]
	return null

func original__getExpandedRoundState(_arg0 = null):
	var _scope50: Dictionary = {"rs": _arg0, "trapStates": null, "trapIds": null, "i": null, "trapId": null, "trap": null, "weaponStates": null, "weaponIds": null, "weaponId": null, "weapon": null, "upgradeStates": null, "upgradeIds": null, "upgradeId": null, "upgrade": null, "counterStates": null, "counterIds": null, "counterId": null, "counter": null, "zoneStates": null, "zoneIds": null, "zoneId": null, "zone": null}
	_scope50["trapStates"] = []
	_scope50["trapIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "traps")])
	_scope50["i"] = 0
	while JS.truthy(JS.compare("<", _scope50["i"], JS.get_property(_scope50["trapIds"], "length"))):
		_scope50["trapId"] = JS.get_property(_scope50["trapIds"], _scope50["i"])
		if JS.truthy(JS.compare(">=", JS.invoke_method(JS.get_property(self, "destroyedTrapIds"), "indexOf", [_scope50["trapId"]]), 0)):
			JS.increment(_scope50, "i", 1, true)
			continue
		_scope50["trap"] = JS.get_property(JS.get_property(self, "traps"), _scope50["trapId"])
		JS.invoke_method(_scope50["trapStates"], "push", [JS.invoke_method(_scope50["trap"], "getTrapState", [])])
		JS.increment(_scope50, "i", 1, true)
	JS.invoke_method(_scope50["rs"], "setTrapStates", [_scope50["trapStates"]])
	_scope50["weaponStates"] = []
	_scope50["weaponIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "weapons")])
	_scope50["i"] = 0
	while JS.truthy(JS.compare("<", _scope50["i"], JS.get_property(_scope50["weaponIds"], "length"))):
		_scope50["weaponId"] = JS.get_property(_scope50["weaponIds"], _scope50["i"])
		_scope50["weapon"] = JS.get_property(JS.get_property(self, "weapons"), _scope50["weaponId"])
		JS.invoke_method(_scope50["weaponStates"], "push", [JS.invoke_method(_scope50["weapon"], "getWeaponState", [])])
		JS.increment(_scope50, "i", 1, true)
	JS.invoke_method(_scope50["rs"], "setWeaponStates", [_scope50["weaponStates"]])
	_scope50["upgradeStates"] = []
	_scope50["upgradeIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "upgrades")])
	_scope50["i"] = 0
	while JS.truthy(JS.compare("<", _scope50["i"], JS.get_property(_scope50["upgradeIds"], "length"))):
		_scope50["upgradeId"] = JS.get_property(_scope50["upgradeIds"], _scope50["i"])
		_scope50["upgrade"] = JS.get_property(JS.get_property(self, "upgrades"), _scope50["upgradeId"])
		JS.invoke_method(_scope50["upgradeStates"], "push", [JS.invoke_method(_scope50["upgrade"], "getUpgradeState", [])])
		JS.increment(_scope50, "i", 1, true)
	JS.invoke_method(_scope50["rs"], "setUpgradeStates", [_scope50["upgradeStates"]])
	_scope50["counterStates"] = []
	_scope50["counterIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "counters")])
	_scope50["i"] = 0
	while JS.truthy(JS.compare("<", _scope50["i"], JS.get_property(_scope50["counterIds"], "length"))):
		_scope50["counterId"] = JS.get_property(_scope50["counterIds"], _scope50["i"])
		_scope50["counter"] = JS.get_property(JS.get_property(self, "counters"), _scope50["counterId"])
		JS.invoke_method(_scope50["counterStates"], "push", [JS.invoke_method(_scope50["counter"], "getCounterState", [])])
		JS.increment(_scope50, "i", 1, false)
	JS.invoke_method(_scope50["rs"], "setCounterStates", [_scope50["counterStates"]])
	_scope50["zoneStates"] = []
	_scope50["zoneIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(self, "zones")])
	_scope50["i"] = 0
	while JS.truthy(JS.compare("<", _scope50["i"], JS.get_property(_scope50["zoneIds"], "length"))):
		_scope50["zoneId"] = JS.get_property(_scope50["zoneIds"], _scope50["i"])
		if JS.truthy(JS.compare(">=", JS.invoke_method(JS.get_property(self, "destroyedZoneIds"), "indexOf", [_scope50["zoneId"]]), 0)):
			JS.increment(_scope50, "i", 1, false)
			continue
		_scope50["zone"] = JS.get_property(JS.get_property(self, "zones"), _scope50["zoneId"])
		JS.invoke_method(_scope50["zoneStates"], "push", [JS.invoke_method(_scope50["zone"], "getZoneState", [])])
		JS.increment(_scope50, "i", 1, false)
	JS.invoke_method(_scope50["rs"], "setZoneStates", [_scope50["zoneStates"]])
	return null

func original_clearExpandedRoundStateBits():
	var _scope51: Dictionary = {}
	JS.set_property(self, "trapCreated", false)
	JS.set_property(self, "weaponCreated", false)
	JS.set_property(self, "upgradeCreated", false)
	JS.set_property(self, "counterCreated", false)
	JS.set_property(self, "zoneCreated", false)
	JS.set_property(self, "zoneChanged", false)
	return null

func original_getTank(_arg0 = null):
	var _scope52: Dictionary = {"playerId": _arg0}
	return JS.get_property(JS.get_property(self, "tanks"), _scope52["playerId"])
	return null

func original_getTankCount():
	var _scope53: Dictionary = {}
	return JS.get_property(JS.invoke_method("@Object", "keys", [JS.get_property(self, "tanks")]), "length")
	return null

func original_getCrateCount():
	var _scope54: Dictionary = {"sum": null, "i": null}
	_scope54["sum"] = 0
	_scope54["i"] = 0
	while JS.truthy(JS.compare("<", _scope54["i"], JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_COUNT"))):
		JS.set_property(_scope54, "sum", JS.add(_scope54["sum"], JS.get_property(JS.get_property(self, "collectibleCounts"), _scope54["i"])))
		JS.increment(_scope54, "i", 1, false)
	return _scope54["sum"]
	return null

func original_getCollectibleCount(_arg0 = null):
	var _scope55: Dictionary = {"collectibleType": _arg0}
	return JS.get_property(JS.get_property(self, "collectibleCounts"), _scope55["collectibleType"])
	return null

func original_getGoldSpawnCount():
	var _scope56: Dictionary = {}
	return JS.get_property(self, "goldSpawnCount")
	return null

func original_getDiamondSpawnCount():
	var _scope57: Dictionary = {}
	return JS.get_property(self, "diamondSpawnCount")
	return null

func original_getTanks():
	var _scope58: Dictionary = {}
	return JS.get_property(self, "tanks")
	return null

func original_destroyTank(_arg0 = null):
	var _scope59: Dictionary = {"playerId": _arg0}
	JS.set_property(self, "cachedRoundState", null)
	JS.invoke_method(JS.get_property(self, "destroyedPlayerIds"), "push", [_scope59["playerId"]])
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_DESTROYED"), _scope59["playerId"]])
	return null

func original_killTank(_arg0 = null):
	var _scope60: Dictionary = {"kill": _arg0}
	JS.set_property(self, "cachedRoundState", null)
	JS.invoke_method(JS.get_property(self, "log"), "debug", [JS.add(JS.add("Marking tank ", JS.invoke_method(_scope60["kill"], "getVictimPlayerId", [])), " as killed")])
	JS.invoke_method(JS.get_property(self, "destroyedPlayerIds"), "push", [JS.invoke_method(_scope60["kill"], "getVictimPlayerId", [])])
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_KILLED"), _scope60["kill"]])
	return null

func original_getProjectile(_arg0 = null):
	var _scope61: Dictionary = {"projectileId": _arg0}
	return JS.get_property(JS.get_property(self, "projectiles"), _scope61["projectileId"])
	return null

func original_getProjectiles():
	var _scope62: Dictionary = {}
	return JS.get_property(self, "projectiles")
	return null

func original_getTrap(_arg0 = null):
	var _scope63: Dictionary = {"trapId": _arg0}
	return JS.get_property(JS.get_property(self, "traps"), _scope63["trapId"])
	return null

func original_getTraps():
	var _scope64: Dictionary = {}
	return JS.get_property(self, "traps")
	return null

func original_getCollectible(_arg0 = null):
	var _scope65: Dictionary = {"collectibleId": _arg0}
	return JS.get_property(JS.get_property(self, "collectibles"), _scope65["collectibleId"])
	return null

func original_getCollectibles():
	var _scope66: Dictionary = {}
	return JS.get_property(self, "collectibles")
	return null

func original_getWeapons():
	var _scope67: Dictionary = {}
	return JS.get_property(self, "weapons")
	return null

func original_getActiveWeapon(_arg0 = null):
	var _scope68: Dictionary = {"playerId": _arg0, "otherWeaponIds": null}
	_scope68["otherWeaponIds"] = JS.get_property(JS.get_property(self, "playerIdOtherWeaponIds"), _scope68["playerId"])
	if JS.truthy(JS.logical("||", func():
		var _scope69: Dictionary = {}
		return (not JS.truthy(_scope68["otherWeaponIds"]))
		return null, func():
		var _scope70: Dictionary = {}
		return JS.equal(JS.get_property(_scope68["otherWeaponIds"], "length"), 0, false)
		return null)):
		return JS.invoke_method(self, "getDefaultWeapon", [_scope68["playerId"]])
	else:
		return JS.get_property(JS.get_property(self, "weapons"), JS.get_property(_scope68["otherWeaponIds"], (JS.number(JS.get_property(_scope68["otherWeaponIds"], "length")) - JS.number(1))))
	return null

func original_getQueuedWeapons(_arg0 = null):
	var _scope71: Dictionary = {"playerId": _arg0, "otherWeaponIds": null, "result": null, "i": null}
	_scope71["otherWeaponIds"] = JS.get_property(JS.get_property(self, "playerIdOtherWeaponIds"), _scope71["playerId"])
	_scope71["result"] = []
	if JS.truthy(_scope71["otherWeaponIds"]):
		_scope71["i"] = 0
		while JS.truthy(JS.compare("<", _scope71["i"], (JS.number(JS.get_property(_scope71["otherWeaponIds"], "length")) - JS.number(1)))):
			JS.invoke_method(_scope71["result"], "push", [JS.get_property(JS.get_property(self, "weapons"), JS.get_property(_scope71["otherWeaponIds"], _scope71["i"]))])
			JS.increment(_scope71, "i", 1, false)
	return _scope71["result"]
	return null

func original_getDefaultWeapon(_arg0 = null):
	var _scope72: Dictionary = {"playerId": _arg0, "weaponId": null}
	_scope72["weaponId"] = JS.get_property(JS.get_property(self, "playerIdDefaultWeaponId"), _scope72["playerId"])
	if JS.truthy(_scope72["weaponId"]):
		return JS.get_property(JS.get_property(self, "weapons"), _scope72["weaponId"])
	else:
		return null
	return null

func original_getUpgrades():
	var _scope73: Dictionary = {}
	return JS.get_property(self, "upgrades")
	return null

func original_getUpgrade(_arg0 = null):
	var _scope74: Dictionary = {"upgradeId": _arg0}
	return JS.get_property(JS.get_property(self, "upgrades"), _scope74["upgradeId"])
	return null

func original_getUpgradeByPlayerIdAndType(_arg0 = null, _arg1 = null):
	var _scope75: Dictionary = {"playerId": _arg0, "type": _arg1, "upgrade": null}
	for _iteration13 in JS.keys(JS.get_property(self, "upgrades")):
		JS.set_property(JS.global_fields, "upgradeId", _iteration13)
		_scope75["upgrade"] = JS.get_property(JS.get_property(self, "upgrades"), JS.get_property(JS.global_fields, "upgradeId"))
		if JS.truthy(JS.logical("&&", func():
			var _scope76: Dictionary = {}
			return JS.equal(JS.invoke_method(_scope75["upgrade"], "getPlayerId", []), _scope75["playerId"], true)
			return null, func():
			var _scope77: Dictionary = {}
			return JS.equal(JS.invoke_method(_scope75["upgrade"], "getType", []), _scope75["type"], true)
			return null)):
			return _scope75["upgrade"]
	return null
	return null

func original_getCounters():
	var _scope78: Dictionary = {}
	return JS.get_property(self, "counters")
	return null

func original_getCounter(_arg0 = null):
	var _scope79: Dictionary = {"counterId": _arg0}
	return JS.get_property(JS.get_property(self, "counters"), _scope79["counterId"])
	return null

func original_getZones():
	var _scope80: Dictionary = {}
	return JS.get_property(self, "zones")
	return null

func original_getZone(_arg0 = null):
	var _scope81: Dictionary = {"zoneId": _arg0}
	return JS.get_property(JS.get_property(self, "zones"), _scope81["zoneId"])
	return null

func original_delayedFire(_arg0 = null):
	var _scope82: Dictionary = {"playerId": _arg0, "tank": null, "weapon": null, "projectileStates": null, "i": null}
	_scope82["tank"] = JS.invoke_method(self, "getTank", [_scope82["playerId"]])
	if JS.truthy(_scope82["tank"]):
		_scope82["weapon"] = JS.invoke_method(self, "getActiveWeapon", [_scope82["playerId"]])
		if JS.truthy(_scope82["weapon"]):
			_scope82["projectileStates"] = JS.invoke_method(_scope82["weapon"], "getProjectileStates", [_scope82["tank"]])
			_scope82["i"] = 0
			while JS.truthy(JS.compare("<", _scope82["i"], JS.get_property(_scope82["projectileStates"], "length"))):
				JS.invoke_method(self, "setProjectileState", [JS.get_property(_scope82["projectileStates"], _scope82["i"])])
				JS.increment(_scope82, "i", 1, false)
	return null

func original_destroyProjectile(_arg0 = null):
	var _scope83: Dictionary = {"projectileId": _arg0, "projectile": null, "defaultWeapon": null}
	_scope83["projectile"] = JS.get_property(JS.get_property(self, "projectiles"), _scope83["projectileId"])
	if JS.truthy(_scope83["projectile"]):
		JS.set_property(self, "cachedRoundState", null)
		_scope83["defaultWeapon"] = JS.invoke_method(self, "getDefaultWeapon", [JS.invoke_method(_scope83["projectile"], "getPlayerId", [])])
		if JS.truthy(JS.logical("&&", func():
			var _scope84: Dictionary = {}
			return _scope83["defaultWeapon"]
			return null, func():
			var _scope85: Dictionary = {}
			return JS.equal(JS.invoke_method(_scope83["defaultWeapon"], "getType", []), JS.invoke_method(_scope83["projectile"], "getType", []), true)
			return null)):
			JS.invoke_method(_scope83["defaultWeapon"], "reload", [_scope83["projectile"]])
		JS.invoke_method(JS.get_property(self, "destroyedProjectileIds"), "push", [_scope83["projectileId"]])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_DESTROYED"), _scope83["projectileId"]])
	return null

func original_timeoutProjectile(_arg0 = null):
	var _scope86: Dictionary = {"projectileId": _arg0, "projectile": null, "defaultWeapon": null}
	_scope86["projectile"] = JS.get_property(JS.get_property(self, "projectiles"), _scope86["projectileId"])
	if JS.truthy(_scope86["projectile"]):
		JS.set_property(self, "cachedRoundState", null)
		_scope86["defaultWeapon"] = JS.invoke_method(self, "getDefaultWeapon", [JS.invoke_method(_scope86["projectile"], "getPlayerId", [])])
		if JS.truthy(JS.logical("&&", func():
			var _scope87: Dictionary = {}
			return _scope86["defaultWeapon"]
			return null, func():
			var _scope88: Dictionary = {}
			return JS.equal(JS.invoke_method(_scope86["defaultWeapon"], "getType", []), JS.invoke_method(_scope86["projectile"], "getType", []), true)
			return null)):
			JS.invoke_method(_scope86["defaultWeapon"], "reload", [_scope86["projectile"]])
		JS.invoke_method(JS.get_property(self, "destroyedProjectileIds"), "push", [_scope86["projectileId"]])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_TIMEOUT"), _scope86["projectileId"]])
	return null

func original_destroyTrap(_arg0 = null):
	var _scope89: Dictionary = {"trapId": _arg0, "trap": null}
	_scope89["trap"] = JS.get_property(JS.get_property(self, "traps"), _scope89["trapId"])
	if JS.truthy(_scope89["trap"]):
		JS.set_property(self, "cachedRoundState", null)
		JS.invoke_method(JS.get_property(self, "destroyedTrapIds"), "push", [_scope89["trapId"]])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_DESTROYED"), _scope89["trapId"]])
	return null

func original_tripTrap(_arg0 = null):
	var _scope90: Dictionary = {"trip": _arg0, "trap": null}
	_scope90["trap"] = JS.get_property(JS.get_property(self, "traps"), JS.invoke_method(_scope90["trip"], "getTrapId", []))
	if JS.truthy(_scope90["trap"]):
		JS.set_property(self, "cachedRoundState", null)
		JS.invoke_method(_scope90["trap"], "trip", [JS.invoke_method(_scope90["trip"], "getPlayerId", []), JS.invoke_method(_scope90["trip"], "getEntered", [])])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_TRIPPED"), _scope90["trip"]])
	return null

func original_destroyCollectible(_arg0 = null):
	var _scope91: Dictionary = {"pickup": _arg0, "collectible": null}
	_scope91["collectible"] = JS.get_property(JS.get_property(self, "collectibles"), JS.invoke_method(_scope91["pickup"], "getCollectibleId", []))
	if JS.truthy(_scope91["collectible"]):
		JS.set_property(self, "cachedRoundState", null)
		JS.invoke_method(JS.get_property(self, "destroyedCollectibleIds"), "push", [JS.invoke_method(_scope91["pickup"], "getCollectibleId", [])])
		JS.increment(JS.get_property(self, "collectibleCounts"), JS.invoke_method(_scope91["collectible"], "getType", []), -1, true)
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COLLECTIBLE_DESTROYED"), _scope91["pickup"]])
	return null

func original_updateWeapon(_arg0 = null, _arg1 = null):
	var _scope92: Dictionary = {"playerId": _arg0, "weaponId": _arg1, "weapon": null, "tank": null}
	_scope92["weapon"] = JS.get_property(JS.get_property(self, "weapons"), _scope92["weaponId"])
	if JS.truthy(_scope92["weapon"]):
		_scope92["tank"] = JS.get_property(JS.get_property(self, "tanks"), _scope92["playerId"])
		if JS.truthy(_scope92["tank"]):
			JS.invoke_method(JS.module("B2DUtils"), "updateTankBodyTurret", [JS.invoke_method(_scope92["tank"], "getB2DBody", []), _scope92["tank"], _scope92["weapon"]])
	return null

func original_destroyWeapon(_arg0 = null):
	var _scope93: Dictionary = {"weaponDeactivation": _arg0, "weaponId": null, "playerId": null, "weapon": null, "defaultWeaponId": null, "otherWeaponIds": null, "i": null, "newWeapon": null, "tank": null}
	_scope93["weaponId"] = JS.invoke_method(_scope93["weaponDeactivation"], "getWeaponId", [])
	_scope93["playerId"] = JS.invoke_method(_scope93["weaponDeactivation"], "getPlayerId", [])
	_scope93["weapon"] = JS.get_property(JS.get_property(self, "weapons"), _scope93["weaponId"])
	if JS.truthy(_scope93["weapon"]):
		JS.set_property(self, "cachedRoundState", null)
		JS.delete_property(JS.get_property(self, "weapons"), _scope93["weaponId"])
		_scope93["defaultWeaponId"] = JS.get_property(JS.get_property(self, "playerIdDefaultWeaponId"), _scope93["playerId"])
		if JS.truthy(JS.equal(_scope93["defaultWeaponId"], _scope93["weaponId"], true)):
			JS.set_property(JS.get_property(self, "playerIdDefaultWeaponId"), _scope93["playerId"], null)
		else:
			_scope93["otherWeaponIds"] = JS.get_property(JS.get_property(self, "playerIdOtherWeaponIds"), _scope93["playerId"])
			_scope93["i"] = 0
			while JS.truthy(JS.compare("<", _scope93["i"], JS.get_property(_scope93["otherWeaponIds"], "length"))):
				if JS.truthy(JS.equal(JS.get_property(_scope93["otherWeaponIds"], _scope93["i"]), _scope93["weaponId"], true)):
					JS.invoke_method(_scope93["otherWeaponIds"], "splice", [_scope93["i"], 1])
					break
				JS.increment(_scope93, "i", 1, false)
		_scope93["newWeapon"] = JS.invoke_method(self, "getActiveWeapon", [_scope93["playerId"]])
		_scope93["tank"] = JS.get_property(JS.get_property(self, "tanks"), _scope93["playerId"])
		if JS.truthy(JS.logical("&&", func():
			var _scope94: Dictionary = {}
			return _scope93["newWeapon"]
			return null, func():
			var _scope95: Dictionary = {}
			return _scope93["tank"]
			return null)):
			JS.invoke_method(JS.module("B2DUtils"), "updateTankBodyTurret", [JS.invoke_method(_scope93["tank"], "getB2DBody", []), _scope93["tank"], _scope93["newWeapon"]])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "WEAPON_DESTROYED"), _scope93["weaponDeactivation"]])
	return null

func original_destroyUpgrade(_arg0 = null):
	var _scope96: Dictionary = {"upgradeUpdate": _arg0, "upgradeId": null, "playerId": null, "upgrade": null, "upgradeIds": null, "i": null, "tank": null}
	_scope96["upgradeId"] = JS.invoke_method(_scope96["upgradeUpdate"], "getUpgradeId", [])
	_scope96["playerId"] = JS.invoke_method(_scope96["upgradeUpdate"], "getPlayerId", [])
	_scope96["upgrade"] = JS.get_property(JS.get_property(self, "upgrades"), _scope96["upgradeId"])
	if JS.truthy(_scope96["upgrade"]):
		JS.set_property(self, "cachedRoundState", null)
		JS.delete_property(JS.get_property(self, "upgrades"), _scope96["upgradeId"])
		_scope96["upgradeIds"] = JS.get_property(JS.get_property(self, "playerIdUpgradeIds"), _scope96["playerId"])
		_scope96["i"] = 0
		while JS.truthy(JS.compare("<", _scope96["i"], JS.get_property(_scope96["upgradeIds"], "length"))):
			if JS.truthy(JS.equal(JS.get_property(_scope96["upgradeIds"], _scope96["i"]), _scope96["upgradeId"], true)):
				JS.invoke_method(_scope96["upgradeIds"], "splice", [_scope96["i"], 1])
				break
			JS.increment(_scope96, "i", 1, false)
		JS.invoke_method(self, "_updateModifiers", [_scope96["playerId"]])
		_scope96["tank"] = JS.get_property(JS.get_property(self, "tanks"), _scope96["playerId"])
		if JS.truthy(_scope96["tank"]):
			JS.invoke_method(JS.module("B2DUtils"), "removeTankBodyUpgrade", [JS.invoke_method(_scope96["tank"], "getB2DBody", []), JS.invoke_method(_scope96["upgrade"], "getType", [])])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_DESTROYED"), _scope96["upgradeUpdate"]])
	return null

func original_destroyCounter(_arg0 = null):
	var _scope97: Dictionary = {"counterId": _arg0, "counter": null}
	_scope97["counter"] = JS.get_property(JS.get_property(self, "counters"), _scope97["counterId"])
	if JS.truthy(_scope97["counter"]):
		JS.set_property(self, "cachedRoundState", null)
		JS.delete_property(JS.get_property(self, "counters"), _scope97["counterId"])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COUNTER_DESTROYED"), _scope97["counterId"]])
	return null

func original_destroyZone(_arg0 = null):
	var _scope98: Dictionary = {"zoneId": _arg0, "zone": null}
	_scope98["zone"] = JS.get_property(JS.get_property(self, "zones"), _scope98["zoneId"])
	if JS.truthy(_scope98["zone"]):
		JS.set_property(self, "cachedRoundState", null)
		JS.invoke_method(JS.get_property(self, "destroyedZoneIds"), "push", [_scope98["zoneId"]])
		JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ZONE_DESTROYED"), _scope98["zoneId"]])
	return null

func original_changeZone(_arg0 = null):
	var _scope99: Dictionary = {"zoneId": _arg0, "zone": null}
	_scope99["zone"] = JS.get_property(JS.get_property(self, "zones"), _scope99["zoneId"])
	if JS.truthy(_scope99["zone"]):
		JS.set_property(self, "zoneChanged", true)
	return null

func original_update(_arg0 = null):
	var _scope100: Dictionary = {"deltaTime": _arg0, "tank": null, "projectile": null, "trap": null, "collectible": null, "weapon": null, "upgrade": null, "counter": null, "zone": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "running")))):
		return null
	JS.set_property(self, "cachedRoundState", null)
	JS.invoke_method(self, "_removeDestroyed", [])
	JS.invoke_method(JS.get_property(self, "b2dworld"), "Step", [_scope100["deltaTime"], 10, 10])
	JS.invoke_method(self, "_filterAndDispatchCollisionEvents", [])
	JS.invoke_method(self, "_removeDestroyed", [])
	for _iteration14 in JS.keys(JS.get_property(self, "tanks")):
		JS.set_property(_scope100, "tank", _iteration14)
		JS.invoke_method(JS.get_property(JS.get_property(self, "tanks"), _scope100["tank"]), "update", [_scope100["deltaTime"]])
	for _iteration15 in JS.keys(JS.get_property(self, "projectiles")):
		JS.set_property(_scope100, "projectile", _iteration15)
		JS.invoke_method(JS.get_property(JS.get_property(self, "projectiles"), _scope100["projectile"]), "update", [_scope100["deltaTime"]])
	for _iteration16 in JS.keys(JS.get_property(self, "traps")):
		JS.set_property(_scope100, "trap", _iteration16)
		JS.invoke_method(JS.get_property(JS.get_property(self, "traps"), _scope100["trap"]), "update", [_scope100["deltaTime"]])
	for _iteration17 in JS.keys(JS.get_property(self, "collectibles")):
		JS.set_property(_scope100, "collectible", _iteration17)
		JS.invoke_method(JS.get_property(JS.get_property(self, "collectibles"), _scope100["collectible"]), "update", [_scope100["deltaTime"]])
	for _iteration18 in JS.keys(JS.get_property(self, "weapons")):
		JS.set_property(_scope100, "weapon", _iteration18)
		JS.invoke_method(JS.get_property(JS.get_property(self, "weapons"), _scope100["weapon"]), "update", [_scope100["deltaTime"]])
	for _iteration19 in JS.keys(JS.get_property(self, "upgrades")):
		JS.set_property(_scope100, "upgrade", _iteration19)
		JS.invoke_method(JS.get_property(JS.get_property(self, "upgrades"), _scope100["upgrade"]), "update", [_scope100["deltaTime"]])
	for _iteration20 in JS.keys(JS.get_property(self, "counters")):
		JS.set_property(_scope100, "counter", _iteration20)
		JS.invoke_method(JS.get_property(JS.get_property(self, "counters"), _scope100["counter"]), "update", [_scope100["deltaTime"]])
	for _iteration21 in JS.keys(JS.get_property(self, "zones")):
		JS.set_property(_scope100, "zone", _iteration21)
		JS.invoke_method(JS.get_property(JS.get_property(self, "zones"), _scope100["zone"]), "update", [_scope100["deltaTime"]])
	return null

func original__filterAndDispatchCollisionEvents():
	var _scope101: Dictionary = {"dispatchedCollisionEvents": null, "i": null, "event": null, "eventAlreadyDispatched": null, "j": null, "dispatchedEvent": null}
	_scope101["dispatchedCollisionEvents"] = []
	_scope101["i"] = 0
	while JS.truthy(JS.compare("<", _scope101["i"], JS.get_property(JS.get_property(self, "collisionEvents"), "length"))):
		_scope101["event"] = JS.get_property(JS.get_property(self, "collisionEvents"), _scope101["i"])
		_scope101["eventAlreadyDispatched"] = false
		_scope101["j"] = 0
		while JS.truthy(JS.compare("<", _scope101["j"], JS.get_property(_scope101["dispatchedCollisionEvents"], "length"))):
			_scope101["dispatchedEvent"] = JS.get_property(_scope101["dispatchedCollisionEvents"], _scope101["j"])
			if JS.truthy(JS.logical("&&", func():
				var _scope102: Dictionary = {}
				return JS.equal(JS.get_property(_scope101["event"], "collisionType"), JS.get_property(_scope101["dispatchedEvent"], "collisionType"), true)
				return null, func():
				var _scope103: Dictionary = {}
				return JS.logical("||", func():
					var _scope104: Dictionary = {}
					return JS.logical("||", func():
						var _scope105: Dictionary = {}
						return JS.logical("||", func():
							var _scope106: Dictionary = {}
							return JS.logical("||", func():
								var _scope107: Dictionary = {}
								return JS.logical("||", func():
									var _scope108: Dictionary = {}
									return JS.logical("&&", func():
										var _scope109: Dictionary = {}
										return JS.logical("&&", func():
											var _scope110: Dictionary = {}
											return JS.logical("&&", func():
												var _scope111: Dictionary = {}
												return not JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "tankA"), null, true)
												return null, func():
												var _scope112: Dictionary = {}
												return JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "tankA"), JS.get_property(JS.get_property(_scope101["dispatchedEvent"], "data"), "tankA"), true)
												return null)
											return null, func():
											var _scope113: Dictionary = {}
											return not JS.equal(JS.get_property(_scope101["event"], "collisionType"), JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TRAP_COLLISION"), true)
											return null)
										return null, func():
										var _scope114: Dictionary = {}
										return not JS.equal(JS.get_property(_scope101["event"], "collisionType"), JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TRAP_END_COLLISION"), true)
										return null)
									return null, func():
									var _scope115: Dictionary = {}
									return JS.logical("&&", func():
										var _scope116: Dictionary = {}
										return not JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "collectible"), null, true)
										return null, func():
										var _scope117: Dictionary = {}
										return JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "collectible"), JS.get_property(JS.get_property(_scope101["dispatchedEvent"], "data"), "collectible"), true)
										return null)
									return null)
								return null, func():
								var _scope118: Dictionary = {}
								return JS.logical("&&", func():
									var _scope119: Dictionary = {}
									return not JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "trap"), null, true)
									return null, func():
									var _scope120: Dictionary = {}
									return JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "trap"), JS.get_property(JS.get_property(_scope101["dispatchedEvent"], "data"), "trap"), true)
									return null)
								return null)
							return null, func():
							var _scope121: Dictionary = {}
							return JS.logical("&&", func():
								var _scope122: Dictionary = {}
								return JS.logical("&&", func():
									var _scope123: Dictionary = {}
									return not JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "shieldA"), null, true)
									return null, func():
									var _scope124: Dictionary = {}
									return JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "shieldA"), JS.get_property(JS.get_property(_scope101["dispatchedEvent"], "data"), "shieldA"), true)
									return null)
								return null, func():
								var _scope125: Dictionary = {}
								return not JS.equal(JS.get_property(_scope101["event"], "collisionType"), JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_SHIELD_COLLISION"), true)
								return null)
							return null)
						return null, func():
						var _scope126: Dictionary = {}
						return JS.logical("&&", func():
							var _scope127: Dictionary = {}
							return JS.logical("&&", func():
								var _scope128: Dictionary = {}
								return not JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "zone"), null, true)
								return null, func():
								var _scope129: Dictionary = {}
								return JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "zone"), JS.get_property(JS.get_property(_scope101["dispatchedEvent"], "data"), "zone"), true)
								return null)
							return null, func():
							var _scope130: Dictionary = {}
							return not JS.equal(JS.get_property(_scope101["event"], "collisionType"), JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_ZONE_COLLISION"), true)
							return null)
						return null)
					return null, func():
					var _scope131: Dictionary = {}
					return JS.logical("&&", func():
						var _scope132: Dictionary = {}
						return JS.logical("&&", func():
							var _scope133: Dictionary = {}
							return JS.logical("&&", func():
								var _scope134: Dictionary = {}
								return not JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "projectile"), null, true)
								return null, func():
								var _scope135: Dictionary = {}
								return JS.equal(JS.get_property(JS.get_property(_scope101["event"], "data"), "projectile"), JS.get_property(JS.get_property(_scope101["dispatchedEvent"], "data"), "projectile"), true)
								return null)
							return null, func():
							var _scope136: Dictionary = {}
							return not JS.equal(JS.get_property(_scope101["event"], "collisionType"), JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_MAZE_COLLISION"), true)
							return null)
						return null, func():
						var _scope137: Dictionary = {}
						return not JS.equal(JS.get_property(_scope101["event"], "collisionType"), JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_SHIELD_COLLISION"), true)
						return null)
					return null)
				return null)):
				JS.set_property(_scope101, "eventAlreadyDispatched", true)
				break
			JS.increment(_scope101, "j", 1, false)
		if JS.truthy((not JS.truthy(_scope101["eventAlreadyDispatched"]))):
			JS.invoke_method(_scope101["dispatchedCollisionEvents"], "push", [_scope101["event"]])
			JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(_scope101["event"], "collisionType"), JS.get_property(_scope101["event"], "data")])
		JS.increment(_scope101, "i", 1, false)
	JS.set_property(self, "collisionEvents", [])
	return null

func original__removeDestroyed():
	var _scope138: Dictionary = {"i": null, "tank": null, "j": null, "projectile": null, "trap": null, "collectible": null, "zone": null}
	_scope138["i"] = 0
	while JS.truthy(JS.compare("<", _scope138["i"], JS.get_property(JS.get_property(self, "destroyedPlayerIds"), "length"))):
		_scope138["tank"] = JS.get_property(JS.get_property(self, "tanks"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"]))
		if JS.truthy(_scope138["tank"]):
			JS.invoke_method(JS.get_property(self, "b2dworld"), "DestroyBody", [JS.invoke_method(_scope138["tank"], "getB2DBody", [])])
			JS.delete_property(JS.get_property(self, "tanks"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"]))
			JS.delete_property(JS.get_property(self, "weapons"), JS.get_property(JS.get_property(self, "playerIdDefaultWeaponId"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"])))
			_scope138["j"] = 0
			while JS.truthy(JS.compare("<", _scope138["j"], JS.get_property(JS.get_property(JS.get_property(self, "playerIdOtherWeaponIds"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"])), "length"))):
				JS.delete_property(JS.get_property(self, "weapons"), JS.get_property(JS.get_property(JS.get_property(self, "playerIdOtherWeaponIds"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"])), _scope138["j"]))
				JS.increment(_scope138, "j", 1, false)
			JS.delete_property(JS.get_property(self, "playerIdDefaultWeaponId"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"]))
			JS.delete_property(JS.get_property(self, "playerIdOtherWeaponIds"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"]))
			_scope138["j"] = 0
			while JS.truthy(JS.compare("<", _scope138["j"], JS.get_property(JS.get_property(JS.get_property(self, "playerIdUpgradeIds"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"])), "length"))):
				JS.delete_property(JS.get_property(self, "upgrades"), JS.get_property(JS.get_property(JS.get_property(self, "playerIdUpgradeIds"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"])), _scope138["j"]))
				JS.increment(_scope138, "j", 1, false)
			JS.delete_property(JS.get_property(self, "playerIdUpgradeIds"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"]))
			JS.delete_property(JS.get_property(self, "playerIdModifiers"), JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"]))
		else:
			if JS.truthy(JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), false)):
				JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Tried to destroy tank which was already gone: ", JS.get_property(JS.get_property(self, "destroyedPlayerIds"), _scope138["i"]))])
		JS.increment(_scope138, "i", 1, false)
	JS.set_property(self, "destroyedPlayerIds", [])
	_scope138["i"] = 0
	while JS.truthy(JS.compare("<", _scope138["i"], JS.get_property(JS.get_property(self, "destroyedProjectileIds"), "length"))):
		_scope138["projectile"] = JS.get_property(JS.get_property(self, "projectiles"), JS.get_property(JS.get_property(self, "destroyedProjectileIds"), _scope138["i"]))
		if JS.truthy(_scope138["projectile"]):
			JS.invoke_method(JS.get_property(self, "b2dworld"), "DestroyBody", [JS.invoke_method(_scope138["projectile"], "getB2DBody", [])])
			JS.delete_property(JS.get_property(self, "projectiles"), JS.get_property(JS.get_property(self, "destroyedProjectileIds"), _scope138["i"]))
		else:
			if JS.truthy(JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), false)):
				JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Tried to destroy projectile which was already gone: ", JS.get_property(JS.get_property(self, "destroyedProjectileIds"), _scope138["i"]))])
		JS.increment(_scope138, "i", 1, false)
	JS.set_property(self, "destroyedProjectileIds", [])
	_scope138["i"] = 0
	while JS.truthy(JS.compare("<", _scope138["i"], JS.get_property(JS.get_property(self, "destroyedTrapIds"), "length"))):
		_scope138["trap"] = JS.get_property(JS.get_property(self, "traps"), JS.get_property(JS.get_property(self, "destroyedTrapIds"), _scope138["i"]))
		if JS.truthy(_scope138["trap"]):
			JS.invoke_method(JS.get_property(self, "b2dworld"), "DestroyBody", [JS.invoke_method(_scope138["trap"], "getB2DBody", [])])
			JS.delete_property(JS.get_property(self, "traps"), JS.get_property(JS.get_property(self, "destroyedTrapIds"), _scope138["i"]))
		else:
			if JS.truthy(JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), false)):
				JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Tried to destroy trap which was already gone: ", JS.get_property(JS.get_property(self, "destroyedTrapIds"), _scope138["i"]))])
		JS.increment(_scope138, "i", 1, false)
	JS.set_property(self, "destroyedTrapIds", [])
	_scope138["i"] = 0
	while JS.truthy(JS.compare("<", _scope138["i"], JS.get_property(JS.get_property(self, "destroyedCollectibleIds"), "length"))):
		_scope138["collectible"] = JS.get_property(JS.get_property(self, "collectibles"), JS.get_property(JS.get_property(self, "destroyedCollectibleIds"), _scope138["i"]))
		if JS.truthy(_scope138["collectible"]):
			JS.invoke_method(JS.get_property(self, "b2dworld"), "DestroyBody", [JS.invoke_method(_scope138["collectible"], "getB2DBody", [])])
			JS.delete_property(JS.get_property(self, "collectibles"), JS.get_property(JS.get_property(self, "destroyedCollectibleIds"), _scope138["i"]))
		else:
			if JS.truthy(JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), false)):
				JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Tried to destroy collectible which was already gone: ", JS.get_property(JS.get_property(self, "destroyedCollectibleIds"), _scope138["i"]))])
		JS.increment(_scope138, "i", 1, false)
	JS.set_property(self, "destroyedCollectibleIds", [])
	_scope138["i"] = 0
	while JS.truthy(JS.compare("<", _scope138["i"], JS.get_property(JS.get_property(self, "destroyedZoneIds"), "length"))):
		_scope138["zone"] = JS.get_property(JS.get_property(self, "zones"), JS.get_property(JS.get_property(self, "destroyedZoneIds"), _scope138["i"]))
		if JS.truthy(_scope138["zone"]):
			JS.invoke_method(JS.get_property(self, "b2dworld"), "DestroyBody", [JS.invoke_method(_scope138["zone"], "getB2DBody", [])])
			JS.delete_property(JS.get_property(self, "zones"), JS.get_property(JS.get_property(self, "destroyedZoneIds"), _scope138["i"]))
		else:
			if JS.truthy(JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), false)):
				JS.invoke_method(JS.get_property(self, "log"), "error", [JS.add("Tried to destroy zone which was already gone: ", JS.get_property(JS.get_property(self, "destroyedZoneIds"), _scope138["i"]))])
		JS.increment(_scope138, "i", 1, false)
	JS.set_property(self, "destroyedZoneIds", [])
	return null

func original_addEventListener(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope139: Dictionary = {"callback": _arg0, "context": _arg1, "gameId": _arg2}
	JS.invoke_method(JS.get_property(self, "eventListeners"), "push", [{"cb": _scope139["callback"], "ctxt": JS.weak(_scope139["context"]), "gameId": _scope139["gameId"]}])
	return null

func original_removeEventListener(_arg0 = null, _arg1 = null):
	var _scope140: Dictionary = {"callback": _arg0, "context": _arg1, "i": null}
	_scope140["i"] = 0
	while JS.truthy(JS.compare("<", _scope140["i"], JS.get_property(JS.get_property(self, "eventListeners"), "length"))):
		if JS.truthy(JS.logical("&&", func():
			var _scope141: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "eventListeners"), _scope140["i"]), "cb"), _scope140["callback"], true)
			return null, func():
			var _scope142: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "eventListeners"), _scope140["i"]), "ctxt"), _scope140["context"], true)
			return null)):
			JS.invoke_method(JS.get_property(self, "eventListeners"), "splice", [_scope140["i"], 1])
			return null
		JS.increment(_scope140, "i", 1, true)
	return null

func original__notifyEventListeners(_arg0 = null, _arg1 = null):
	var _scope143: Dictionary = {"evt": _arg0, "data": _arg1, "i": null}
	_scope143["i"] = 0
	while JS.truthy(JS.compare("<", _scope143["i"], JS.get_property(JS.get_property(self, "eventListeners"), "length"))):
		# 事件回调中的 GDScript 错误由引擎报告, 调用方继续派发后续监听器.
		JS.invoke_method(JS.get_property(JS.get_property(self, "eventListeners"), _scope143["i"]), "cb", [JS.get_property(JS.get_property(JS.get_property(self, "eventListeners"), _scope143["i"]), "ctxt"), JS.get_property(JS.get_property(JS.get_property(self, "eventListeners"), _scope143["i"]), "gameId"), _scope143["evt"], _scope143["data"]])
		JS.increment(_scope143, "i", 1, true)
	return null

func original_createRound(_arg0 = null):
	var _scope144: Dictionary = {"ranked": _arg0}
	JS.set_property(self, "ranked", _scope144["ranked"])
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_CREATED"), _scope144["ranked"]])
	return null

func original_startRound():
	var _scope145: Dictionary = {}
	JS.set_property(self, "started", true)
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_STARTED")])
	return null

func original_endRound(_arg0 = null):
	var _scope146: Dictionary = {"victoryAward": _arg0}
	JS.set_property(self, "started", false)
	JS.set_property(self, "running", false)
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_ENDED"), _scope146["victoryAward"]])
	JS.set_property(self, "b2dworld", null)
	JS.set_property(self, "tanks", {})
	JS.set_property(self, "projectiles", {})
	JS.set_property(self, "traps", {})
	JS.set_property(self, "collectibles", {})
	JS.set_property(self, "weapons", {})
	JS.set_property(self, "upgrades", {})
	JS.set_property(self, "counters", {})
	JS.set_property(self, "zones", {})
	JS.set_property(self, "collisionEvents", [])
	JS.set_property(self, "destroyedPlayerIds", [])
	JS.set_property(self, "destroyedProjectileIds", [])
	JS.set_property(self, "destroyedCollectibleIds", [])
	JS.set_property(self, "destroyedZoneIds", [])
	JS.set_property(self, "playerIdOtherWeaponIds", {})
	JS.set_property(self, "playerIdDefaultWeaponId", {})
	JS.set_property(self, "playerIdUpgradeIds", {})
	JS.set_property(self, "playerIdModifiers", {})
	return null

func original_startCelebration():
	var _scope147: Dictionary = {}
	JS.set_property(self, "maze", null)
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "CELEBRATION_STARTED")])
	return null

func original_endCelebration():
	var _scope148: Dictionary = {}
	JS.invoke_method(self, "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "CELEBRATION_ENDED")])
	return null

func original_getStarted():
	var _scope149: Dictionary = {}
	return JS.get_property(self, "started")
	return null

func original_setVictoryGoldAmount(_arg0 = null):
	var _scope150: Dictionary = {"victoryGoldAmount": _arg0}
	JS.set_property(self, "victoryGoldAmount", _scope150["victoryGoldAmount"])
	return null

func original_getVictoryGoldAmount():
	var _scope151: Dictionary = {}
	return JS.get_property(self, "victoryGoldAmount")
	return null

func original_setStakes(_arg0 = null):
	var _scope152: Dictionary = {"stakes": _arg0}
	JS.set_property(self, "stakes", _scope152["stakes"])
	return null

func original_getStake(_arg0 = null):
	var _scope153: Dictionary = {"playerId": _arg0, "i": null, "stake": null}
	_scope153["i"] = 0
	while JS.truthy(JS.compare("<", _scope153["i"], JS.get_property(JS.get_property(self, "stakes"), "length"))):
		_scope153["stake"] = JS.get_property(JS.get_property(self, "stakes"), _scope153["i"])
		if JS.truthy(JS.equal(JS.get_property(_scope153["stake"], "playerId"), _scope153["playerId"], false)):
			return _scope153["stake"]
		JS.increment(_scope153, "i", 1, false)
	return null
	return null

func original_getRankChanges(_arg0 = null):
	var _scope154: Dictionary = {"winnerPlayerIds": _arg0, "changes": null, "rankBeforeChanges": null, "totalStakes": null, "i": null, "stake": null, "stakesPerWinner": null, "j": null, "changesArray": null, "playerId": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "ranked")))):
		return []
	_scope154["changes"] = {}
	_scope154["rankBeforeChanges"] = {}
	if JS.truthy(JS.compare(">", JS.get_property(_scope154["winnerPlayerIds"], "length"), 0)):
		_scope154["totalStakes"] = 0
		_scope154["i"] = 0
		while JS.truthy(JS.compare("<", _scope154["i"], JS.get_property(JS.get_property(self, "stakes"), "length"))):
			_scope154["stake"] = JS.get_property(JS.get_property(self, "stakes"), _scope154["i"])
			JS.set_property(_scope154["changes"], JS.get_property(_scope154["stake"], "playerId"), -(JS.get_property(_scope154["stake"], "value")))
			JS.set_property(_scope154["rankBeforeChanges"], JS.get_property(_scope154["stake"], "playerId"), JS.get_property(_scope154["stake"], "rank"))
			JS.set_property(_scope154, "totalStakes", JS.add(_scope154["totalStakes"], JS.get_property(_scope154["stake"], "value")))
			JS.increment(_scope154, "i", 1, false)
		_scope154["stakesPerWinner"] = JS.invoke_method("@Math", "ceil", [(JS.number(_scope154["totalStakes"]) / JS.number(JS.get_property(_scope154["winnerPlayerIds"], "length")))])
		_scope154["i"] = 0
		while JS.truthy(JS.compare("<", _scope154["i"], JS.get_property(_scope154["winnerPlayerIds"], "length"))):
			JS.set_property(_scope154["changes"], JS.get_property(_scope154["winnerPlayerIds"], _scope154["i"]), JS.add(JS.get_property(_scope154["changes"], JS.get_property(_scope154["winnerPlayerIds"], _scope154["i"])), _scope154["stakesPerWinner"]))
			JS.increment(_scope154, "i", 1, false)
	else:
		_scope154["i"] = 0
		while JS.truthy(JS.compare("<", _scope154["i"], JS.get_property(JS.get_property(self, "stakes"), "length"))):
			_scope154["stake"] = JS.get_property(JS.get_property(self, "stakes"), _scope154["i"])
			_scope154["j"] = 0
			while JS.truthy(JS.compare("<", _scope154["j"], JS.get_property(JS.get_property(self, "punishablePlayerIds"), "length"))):
				if JS.truthy(JS.equal(JS.get_property(_scope154["stake"], "playerId"), JS.get_property(JS.get_property(self, "punishablePlayerIds"), _scope154["j"]), false)):
					JS.set_property(_scope154["changes"], JS.get_property(_scope154["stake"], "playerId"), -(JS.get_property(_scope154["stake"], "value")))
					JS.set_property(_scope154["rankBeforeChanges"], JS.get_property(_scope154["stake"], "playerId"), JS.get_property(_scope154["stake"], "rank"))
					break
				JS.increment(_scope154, "j", 1, false)
			JS.increment(_scope154, "i", 1, false)
	_scope154["changesArray"] = []
	for _iteration22 in JS.keys(_scope154["changes"]):
		JS.set_property(_scope154, "playerId", _iteration22)
		JS.invoke_method(_scope154["changesArray"], "push", [{"playerId": _scope154["playerId"], "rank": JS.get_property(_scope154["rankBeforeChanges"], _scope154["playerId"]), "change": JS.get_property(_scope154["changes"], _scope154["playerId"])}])
	return _scope154["changesArray"]
	return null

func original_getModifier(_arg0 = null, _arg1 = null):
	var _scope155: Dictionary = {"playerId": _arg0, "modifierType": _arg1, "modifiers": null}
	_scope155["modifiers"] = JS.get_property(JS.get_property(self, "playerIdModifiers"), _scope155["playerId"])
	if JS.truthy(_scope155["modifiers"]):
		return JS.get_property(_scope155["modifiers"], _scope155["modifierType"])
	else:
		return JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MODIFIER_INFO"), _scope155["modifierType"]), "DEFAULT")
	return null

func original_relayEvent(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope156: Dictionary = {"self": _arg0, "evt": _arg1, "data": _arg2}
	JS.invoke_method(_scope156["self"], "_notifyEventListeners", [_scope156["evt"], _scope156["data"]])
	return null

func original__updateModifiers(_arg0 = null):
	var _scope157: Dictionary = {"playerId": _arg0, "newModifiers": null, "modifierType": null, "modifier": null, "upgradeIds": null, "i": null, "upgrade": null}
	_scope157["newModifiers"] = {}
	for _iteration23 in JS.keys(JS.get_property(JS.module("Constants"), "MODIFIER_TYPES")):
		JS.set_property(_scope157, "modifierType", _iteration23)
		_scope157["modifier"] = JS.get_property(JS.get_property(JS.module("Constants"), "MODIFIER_TYPES"), _scope157["modifierType"])
		JS.set_property(_scope157["newModifiers"], _scope157["modifier"], JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MODIFIER_INFO"), _scope157["modifier"]), "DEFAULT"))
	_scope157["upgradeIds"] = JS.get_property(JS.get_property(self, "playerIdUpgradeIds"), _scope157["playerId"])
	_scope157["i"] = 0
	while JS.truthy(JS.compare("<", _scope157["i"], JS.get_property(_scope157["upgradeIds"], "length"))):
		_scope157["upgrade"] = JS.get_property(JS.get_property(self, "upgrades"), JS.get_property(_scope157["upgradeIds"], _scope157["i"]))
		var _switch24 = JS.invoke_method(_scope157["upgrade"], "getType", [])
		var _switch24_start = -1
		if JS.equal(_switch24, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SPEED_BOOST"), true): _switch24_start = 0
		while true:
			if _switch24_start >= 0 and _switch24_start <= 0:
				JS.set_property(_scope157["newModifiers"], JS.get_property(JS.get_property(JS.module("Constants"), "MODIFIER_TYPES"), "SPEED"), JS.add(JS.get_property(_scope157["newModifiers"], JS.get_property(JS.get_property(JS.module("Constants"), "MODIFIER_TYPES"), "SPEED")), JS.invoke_method(_scope157["upgrade"], "getField", ["speedBoost"])))
				break
			break
		JS.increment(_scope157, "i", 1, false)
	JS.set_property(JS.get_property(self, "playerIdModifiers"), _scope157["playerId"], _scope157["newModifiers"])
	return null

func original_getB2DWorld():
	var _scope158: Dictionary = {}
	return JS.get_property(self, "b2dworld")
	return null
