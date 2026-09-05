# 由原版 RoundController 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var model = null
var localPlayerIds = []
var gameMode = null
var id = null
var initialRoundStateReceived = false
var initialRoundStateSent = false
var tankStateEmissionValue = 0
var log = null
static var _static_RoundController: Dictionary = {}
static var _initialized_RoundController = false
static func initialize_original_static():
	if _initialized_RoundController: return
	_initialized_RoundController = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_RoundController.has(key): return _static_RoundController[key]
	return null
static func original_static_set(key, value):
	_static_RoundController[key] = value
	return value
func original_own_fields():
	return ["model","localPlayerIds","gameMode","id","initialRoundStateReceived","initialRoundStateSent","tankStateEmissionValue","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"localPlayerIds": _arg0, "gameMode": _arg1, "gameId": _arg2}
	JS.set_property(self, "id", JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["rc"]))
	JS.set_property(self, "localPlayerIds", _scope0["localPlayerIds"])
	JS.set_property(self, "gameMode", _scope0["gameMode"])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["RoundController"]))
	JS.set_property(self, "model", JS.invoke_method(JS.module("RoundModel"), "create", [JS.get_property(self, "id"), JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2World"), [JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), [0, 0]), true])]))
	if JS.truthy(JS.logical("||", func():
		var _scope1: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)
		return null, func():
		var _scope2: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "addEventListener", [JS.get_property(self, "_modelEventHandler"), self, _scope0["gameId"]])
		JS.invoke_method(JS.get_property(self, "gameMode"), "setRoundController", [self])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/match/roundcontroller.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original__modelEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope3: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3, "upgradeUpdate": null, "pickup": null, "killExperience": null, "kill": null, "trip": null}
	var _switch0 = _scope3["evt"]
	var _switch0_start = 53
	if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_CREATED"), true): _switch0_start = 0
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "MAZE_SET"), true): _switch0_start = 1
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_STARTED"), true): _switch0_start = 2
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_ENDED"), true): _switch0_start = 3
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "CELEBRATION_STARTED"), true): _switch0_start = 4
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "CELEBRATION_ENDED"), true): _switch0_start = 5
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_TIMEOUT"), true): _switch0_start = 6
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_CREATED"), true): _switch0_start = 7
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_DESTROYED"), true): _switch0_start = 8
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_CREATED"), true): _switch0_start = 9
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_TRIPPED"), true): _switch0_start = 10
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_DESTROYED"), true): _switch0_start = 11
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COLLECTIBLE_CREATED"), true): _switch0_start = 12
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COLLECTIBLE_DESTROYED"), true): _switch0_start = 13
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CREATED"), true): _switch0_start = 14
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_DESTROYED"), true): _switch0_start = 15
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_KILLED"), true): _switch0_start = 16
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "WEAPON_CREATED"), true): _switch0_start = 17
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "WEAPON_DESTROYED"), true): _switch0_start = 18
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_CREATED"), true): _switch0_start = 19
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_DESTROYED"), true): _switch0_start = 20
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COUNTER_CREATED"), true): _switch0_start = 21
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "COUNTER_DESTROYED"), true): _switch0_start = 22
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ZONE_CREATED"), true): _switch0_start = 23
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ZONE_DESTROYED"), true): _switch0_start = 24
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_FIRED"), true): _switch0_start = 25
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_EMPTY"), true): _switch0_start = 26
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "HOMING_MISSILE_TARGET_CHANGED"), true): _switch0_start = 27
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_ACTIVATED"), true): _switch0_start = 28
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_TRIPPED"), true): _switch0_start = 29
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "MINE_DETONATED"), true): _switch0_start = 30
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_ACTIVATED"), true): _switch0_start = 31
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_WEAKENED"), true): _switch0_start = 32
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_STRENGTHENED"), true): _switch0_start = 33
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Zone"), "_EVENTS"), "ZONE_ENTERED"), true): _switch0_start = 34
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Zone"), "_EVENTS"), "ZONE_LEFT"), true): _switch0_start = 35
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Zone"), "_EVENTS"), "ZONE_DESTABILIZED"), true): _switch0_start = 36
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TANK_COLLISION"), true): _switch0_start = 37
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_MAZE_COLLISION"), true): _switch0_start = 38
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_SHIELD_COLLISION"), true): _switch0_start = 39
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "SHIELD_SHIELD_COLLISION"), true): _switch0_start = 40
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Weapon"), "_EVENTS"), "WEAPON_DELAYED_FIRE"), true): _switch0_start = 41
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "SHIELD_ZONE_COLLISION"), true): _switch0_start = 42
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_SHIELD_COLLISION"), true): _switch0_start = 43
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_ZONE_COLLISION"), true): _switch0_start = 44
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "PROJECTILE_MAZE_COLLISION"), true): _switch0_start = 45
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_COLLECTIBLE_COLLISION"), true): _switch0_start = 46
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_DEADLY_COLLISION"), true): _switch0_start = 47
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TRAP_COLLISION"), true): _switch0_start = 48
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_TRAP_END_COLLISION"), true): _switch0_start = 49
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_ZONE_COLLISION"), true): _switch0_start = 50
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TRAP_ZONE_COLLISION"), true): _switch0_start = 51
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_CHICKENED_OUT"), true): _switch0_start = 52
	while true:
		if _switch0_start >= 0 and _switch0_start <= 40:
			break
		if _switch0_start >= 0 and _switch0_start <= 41:
			JS.invoke_method(_scope3["self"], "delayedFire", [_scope3["data"]])
			break
		if _switch0_start >= 0 and _switch0_start <= 42:
			var _switch1 = JS.invoke_method(JS.get_property(_scope3["data"], "zone"), "getType", [])
			var _switch1_start = -1
			if JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "SPAWN"), true): _switch1_start = 0
			elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "STORM"), true): _switch1_start = 1
			while true:
				if _switch1_start >= 0 and _switch1_start <= 0:
					_scope3["upgradeUpdate"] = JS.invoke_method(JS.module("UpgradeUpdate"), "create", [JS.invoke_method(JS.get_property(_scope3["data"], "shieldA"), "getId", []), JS.invoke_method(JS.get_property(_scope3["data"], "shieldA"), "getPlayerId", [])])
					JS.invoke_method(_scope3["self"], "destroyUpgrade", [_scope3["upgradeUpdate"]])
					break
				if _switch1_start >= 0 and _switch1_start <= 1:
					_scope3["upgradeUpdate"] = JS.invoke_method(JS.module("UpgradeUpdate"), "create", [JS.invoke_method(JS.get_property(_scope3["data"], "shieldA"), "getId", []), JS.invoke_method(JS.get_property(_scope3["data"], "shieldA"), "getPlayerId", [])])
					JS.invoke_method(_scope3["self"], "destroyUpgrade", [_scope3["upgradeUpdate"]])
					break
				break
			break
		if _switch0_start >= 0 and _switch0_start <= 43:
			JS.invoke_method(JS.get_property(_scope3["data"], "projectile"), "hitShield", [])
			break
		if _switch0_start >= 0 and _switch0_start <= 44:
			var _switch2 = JS.invoke_method(JS.get_property(_scope3["data"], "zone"), "getType", [])
			var _switch2_start = -1
			if JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "SPAWN"), true): _switch2_start = 0
			while true:
				if _switch2_start >= 0 and _switch2_start <= 0:
					JS.invoke_method(_scope3["self"], "destroyProjectile", [JS.invoke_method(JS.get_property(_scope3["data"], "projectile"), "getId", [])])
					break
				break
			break
		if _switch0_start >= 0 and _switch0_start <= 45:
			JS.invoke_method(JS.get_property(_scope3["data"], "projectile"), "hitMaze", [])
			break
		if _switch0_start >= 0 and _switch0_start <= 46:
			_scope3["pickup"] = JS.invoke_method(JS.module("Pickup"), "create", [JS.invoke_method(JS.get_property(_scope3["data"], "tankA"), "getPlayerId", []), JS.invoke_method(JS.get_property(_scope3["data"], "collectible"), "getId", []), JS.invoke_method(JS.get_property(_scope3["data"], "collectible"), "getType", [])])
			if JS.truthy(JS.compare("<", JS.invoke_method(JS.get_property(_scope3["data"], "collectible"), "getType", []), JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "WEAPON_CRATE_COUNT"))):
				if JS.truthy(JS.compare("<", JS.get_property(JS.invoke_method(_scope3["self"], "getQueuedWeapons", [JS.invoke_method(JS.get_property(_scope3["data"], "tankA"), "getPlayerId", [])]), "length"), JS.get_property(JS.module("Constants"), "MAX_WEAPON_QUEUE"))):
					JS.invoke_method(_scope3["self"], "pickUpCrate", [_scope3["pickup"]])
					JS.invoke_method(_scope3["self"], "destroyCollectible", [_scope3["pickup"]])
			else:
				if JS.truthy(JS.compare("<", JS.invoke_method(JS.get_property(_scope3["data"], "collectible"), "getType", []), JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "UPGRADE_CRATE_COUNT"))):
					if JS.truthy((not JS.truthy(JS.invoke_method(_scope3["self"], "getUpgradeByPlayerIdAndType", [JS.invoke_method(JS.get_property(_scope3["data"], "tankA"), "getPlayerId", []), JS.add(JS.invoke_method(JS.get_property(_scope3["data"], "collectible"), "getType", []), JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "COLLECTIBLE_TO_UPGRADE_OFFSET"))])))):
						JS.invoke_method(_scope3["self"], "pickUpCrate", [_scope3["pickup"]])
						JS.invoke_method(_scope3["self"], "destroyCollectible", [_scope3["pickup"]])
				else:
					JS.invoke_method(_scope3["self"], "destroyCollectible", [_scope3["pickup"]])
			break
		if _switch0_start >= 0 and _switch0_start <= 47:
			_scope3["killExperience"] = 0
			if JS.truthy(not JS.equal(JS.invoke_method(JS.get_property(_scope3["data"], "tankA"), "getPlayerId", []), JS.invoke_method(JS.get_property(_scope3["data"], "projectile"), "getPlayerId", []), true)):
				JS.set_property(_scope3, "killExperience", JS.invoke_method(JS.get_property(_scope3["self"], "gameMode"), "getKillExperience", []))
			_scope3["kill"] = JS.invoke_method(JS.module("Kill"), "create", [JS.invoke_method(JS.get_property(_scope3["data"], "tankA"), "getPlayerId", []), JS.invoke_method(JS.get_property(_scope3["data"], "projectile"), "getPlayerId", []), _scope3["killExperience"], JS.invoke_method(JS.get_property(_scope3["data"], "projectile"), "getId", []), JS.invoke_method(JS.get_property(_scope3["data"], "projectile"), "getType", [])])
			JS.invoke_method(_scope3["self"], "killTank", [_scope3["kill"]])
			JS.invoke_method(_scope3["self"], "destroyProjectile", [JS.invoke_method(JS.get_property(_scope3["data"], "projectile"), "getId", [])])
			break
		if _switch0_start >= 0 and _switch0_start <= 48:
			_scope3["trip"] = JS.invoke_method(JS.module("Trip"), "create", [JS.invoke_method(JS.get_property(_scope3["data"], "tankA"), "getPlayerId", []), JS.invoke_method(JS.get_property(_scope3["data"], "trap"), "getId", []), JS.invoke_method(JS.get_property(_scope3["data"], "trap"), "getType", []), true])
			JS.invoke_method(_scope3["self"], "tripTrap", [_scope3["trip"]])
			break
		if _switch0_start >= 0 and _switch0_start <= 49:
			_scope3["trip"] = JS.invoke_method(JS.module("Trip"), "create", [JS.invoke_method(JS.get_property(_scope3["data"], "tankA"), "getPlayerId", []), JS.invoke_method(JS.get_property(_scope3["data"], "trap"), "getId", []), JS.invoke_method(JS.get_property(_scope3["data"], "trap"), "getType", []), false])
			JS.invoke_method(_scope3["self"], "tripTrap", [_scope3["trip"]])
			break
		if _switch0_start >= 0 and _switch0_start <= 50:
			var _switch3 = JS.invoke_method(JS.get_property(_scope3["data"], "zone"), "getType", [])
			var _switch3_start = -1
			if JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "SPAWN"), true): _switch3_start = 0
			elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "STORM"), true): _switch3_start = 1
			while true:
				if _switch3_start >= 0 and _switch3_start <= 0:
					JS.invoke_method(_scope3["self"], "destroyTank", [JS.invoke_method(JS.get_property(_scope3["data"], "tankA"), "getPlayerId", [])])
					break
				if _switch3_start >= 0 and _switch3_start <= 1:
					JS.invoke_method(_scope3["self"], "destroyTank", [JS.invoke_method(JS.get_property(_scope3["data"], "tankA"), "getPlayerId", [])])
					break
				break
			break
		if _switch0_start >= 0 and _switch0_start <= 51:
			var _switch4 = JS.invoke_method(JS.get_property(_scope3["data"], "zone"), "getType", [])
			var _switch4_start = -1
			if JS.equal(_switch4, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "SPAWN"), true): _switch4_start = 0
			while true:
				if _switch4_start >= 0 and _switch4_start <= 0:
					JS.invoke_method(_scope3["self"], "destroyTrap", [JS.invoke_method(JS.get_property(_scope3["data"], "trap"), "getId", [])])
					break
				break
			break
		if _switch0_start >= 0 and _switch0_start <= 52:
			break
		if _switch0_start >= 0 and _switch0_start <= 53:
			JS.invoke_method(JS.get_property(_scope3["self"], "log"), "error", [JS.add("Unknown event received by RoundController._modelEventHandler: ", _scope3["evt"])])
		break
	return null

func original_removeTank(_arg0 = null):
	var _scope4: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "removeTank", [_scope4["playerId"]])
	return null

func original_setMaze(_arg0 = null):
	var _scope5: Dictionary = {"maze": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setMaze", [_scope5["maze"]])
	return null

func original_setRoundState(_arg0 = null):
	var _scope6: Dictionary = {"roundState": _arg0, "tankStates": null, "i": null, "projectileStates": null, "trapStates": null, "collectibleStates": null, "weaponStates": null, "upgradeStates": null, "counterStates": null, "zoneStates": null}
	_scope6["tankStates"] = JS.invoke_method(_scope6["roundState"], "getTankStates", [])
	_scope6["i"] = 0
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["tankStates"], "length"))):
		if JS.truthy(JS.logical("||", func():
			var _scope7: Dictionary = {}
			return JS.logical("||", func():
				var _scope8: Dictionary = {}
				return not JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
				return null, func():
				var _scope9: Dictionary = {}
				return JS.equal(JS.invoke_method(JS.get_property(self, "localPlayerIds"), "indexOf", [JS.invoke_method(JS.get_property(_scope6["tankStates"], _scope6["i"]), "getPlayerId", [])]), -(1), false)
				return null)
			return null, func():
			var _scope10: Dictionary = {}
			return JS.equal(JS.get_property(JS.invoke_method(JS.get_property(self, "model"), "getTanks", []), JS.invoke_method(JS.get_property(_scope6["tankStates"], _scope6["i"]), "getPlayerId", [])), null, true)
			return null)):
			JS.invoke_method(self, "setTankState", [JS.get_property(_scope6["tankStates"], _scope6["i"]), false])
		JS.increment(_scope6, "i", 1, true)
	_scope6["projectileStates"] = JS.invoke_method(_scope6["roundState"], "getProjectileStates", [])
	_scope6["i"] = 0
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["projectileStates"], "length"))):
		JS.invoke_method(self, "setProjectileState", [JS.get_property(_scope6["projectileStates"], _scope6["i"])])
		JS.increment(_scope6, "i", 1, true)
	_scope6["trapStates"] = JS.invoke_method(_scope6["roundState"], "getTrapStates", [])
	_scope6["i"] = 0
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["trapStates"], "length"))):
		JS.invoke_method(self, "setTrapState", [JS.get_property(_scope6["trapStates"], _scope6["i"])])
		JS.increment(_scope6, "i", 1, true)
	_scope6["collectibleStates"] = JS.invoke_method(_scope6["roundState"], "getCollectibleStates", [])
	_scope6["i"] = 0
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["collectibleStates"], "length"))):
		JS.invoke_method(self, "setCollectibleState", [JS.get_property(_scope6["collectibleStates"], _scope6["i"])])
		JS.increment(_scope6, "i", 1, true)
	_scope6["weaponStates"] = JS.invoke_method(_scope6["roundState"], "getWeaponStates", [])
	_scope6["i"] = 0
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["weaponStates"], "length"))):
		JS.invoke_method(self, "setWeaponState", [JS.get_property(_scope6["weaponStates"], _scope6["i"])])
		JS.increment(_scope6, "i", 1, true)
	_scope6["upgradeStates"] = JS.invoke_method(_scope6["roundState"], "getUpgradeStates", [])
	_scope6["i"] = 0
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["upgradeStates"], "length"))):
		JS.invoke_method(self, "setUpgradeState", [JS.get_property(_scope6["upgradeStates"], _scope6["i"])])
		JS.increment(_scope6, "i", 1, true)
	_scope6["counterStates"] = JS.invoke_method(_scope6["roundState"], "getCounterStates", [])
	_scope6["i"] = 0
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["counterStates"], "length"))):
		JS.invoke_method(self, "setCounterState", [JS.get_property(_scope6["counterStates"], _scope6["i"])])
		JS.increment(_scope6, "i", 1, true)
	_scope6["zoneStates"] = JS.invoke_method(_scope6["roundState"], "getZoneStates", [])
	_scope6["i"] = 0
	while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["zoneStates"], "length"))):
		JS.invoke_method(self, "setZoneState", [JS.get_property(_scope6["zoneStates"], _scope6["i"])])
		JS.increment(_scope6, "i", 1, true)
	JS.set_property(self, "initialRoundStateReceived", true)
	return null

func original_getRoundState(_arg0 = null):
	var _scope11: Dictionary = {"expandedState": _arg0, "roundState": null}
	JS.set_property(_scope11, "expandedState", JS.bitwise("|", _scope11["expandedState"], (not JS.truthy(JS.get_property(self, "initialRoundStateSent")))))
	_scope11["roundState"] = JS.invoke_method(JS.get_property(self, "model"), "getRoundState", [_scope11["expandedState"]])
	return _scope11["roundState"]
	return null

func original_clearExpandedRoundStateBits():
	var _scope12: Dictionary = {}
	JS.set_property(self, "initialRoundStateSent", true)
	JS.invoke_method(JS.get_property(self, "model"), "clearExpandedRoundStateBits", [])
	return null

func original_verifyAndCorrectTankState(_arg0 = null):
	var _scope13: Dictionary = {"tankState": _arg0, "tank": null, "stateVerified": null, "positionDiff": null, "rotationDiff": null, "maze": null, "tankPosition": null, "tankStatePosition": null, "mazeDistance": null}
	_scope13["tank"] = JS.invoke_method(self, "getTank", [JS.invoke_method(_scope13["tankState"], "getPlayerId", [])])
	if JS.truthy((not JS.truthy(_scope13["tank"]))):
		return true
	_scope13["stateVerified"] = true
	if JS.truthy(JS.logical("||", func():
		var _scope14: Dictionary = {}
		return JS.global_call("isNaN", [JS.invoke_method(_scope13["tankState"], "getX", [])])
		return null, func():
		var _scope15: Dictionary = {}
		return JS.global_call("isNaN", [JS.invoke_method(_scope13["tankState"], "getY", [])])
		return null)):
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Received NaN tank position in tank state"])
		JS.invoke_method(_scope13["tankState"], "setX", [JS.invoke_method(_scope13["tank"], "getX", [])])
		JS.invoke_method(_scope13["tankState"], "setY", [JS.invoke_method(_scope13["tank"], "getY", [])])
		JS.set_property(_scope13, "stateVerified", false)
	if JS.truthy(JS.global_call("isNaN", [JS.invoke_method(_scope13["tankState"], "getRotation", [])])):
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Received NaN tank rotation in tank state"])
		JS.invoke_method(_scope13["tankState"], "setRotation", [JS.invoke_method(_scope13["tank"], "getRotation", [])])
		JS.set_property(_scope13, "stateVerified", false)
	_scope13["positionDiff"] = JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.invoke_method(_scope13["tank"], "getX", [])) - JS.number(JS.invoke_method(_scope13["tankState"], "getX", []))), (JS.number(JS.invoke_method(_scope13["tank"], "getY", [])) - JS.number(JS.invoke_method(_scope13["tankState"], "getY", [])))])
	if JS.truthy(JS.compare(">", JS.invoke_method(_scope13["positionDiff"], "LengthSquared", []), JS.get_property(JS.get_property(JS.module("Constants"), "SERVER"), "MAX_ACCEPTED_POSITION_DIFF_SQUARED"))):
		JS.invoke_method(_scope13["tankState"], "setX", [JS.invoke_method(_scope13["tank"], "getX", [])])
		JS.invoke_method(_scope13["tankState"], "setY", [JS.invoke_method(_scope13["tank"], "getY", [])])
		JS.set_property(_scope13, "stateVerified", false)
	_scope13["rotationDiff"] = (JS.number(JS.invoke_method(_scope13["tank"], "getRotation", [])) - JS.number(JS.invoke_method(_scope13["tankState"], "getRotation", [])))
	if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "abs", [_scope13["rotationDiff"]]), JS.get_property(JS.get_property(JS.module("Constants"), "SERVER"), "MAX_ACCEPTED_ROTATION_DIFF"))):
		JS.invoke_method(_scope13["tankState"], "setRotation", [JS.invoke_method(_scope13["tank"], "getRotation", [])])
		JS.set_property(_scope13, "stateVerified", false)
	_scope13["maze"] = JS.invoke_method(self, "getMaze", [])
	if JS.truthy(_scope13["maze"]):
		if JS.truthy((not JS.truthy(JS.invoke_method(_scope13["maze"], "isTankStateInsideMaze", [_scope13["tankState"]])))):
			JS.invoke_method(_scope13["tankState"], "setX", [JS.invoke_method(_scope13["tank"], "getX", [])])
			JS.invoke_method(_scope13["tankState"], "setY", [JS.invoke_method(_scope13["tank"], "getY", [])])
			JS.set_property(_scope13, "stateVerified", false)
	if JS.truthy(_scope13["maze"]):
		_scope13["tankPosition"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope13["tank"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope13["tank"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
		_scope13["tankStatePosition"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope13["tankState"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope13["tankState"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
		_scope13["mazeDistance"] = JS.invoke_method(_scope13["maze"], "getDistanceBetweenPositions", [_scope13["tankPosition"], _scope13["tankStatePosition"]])
		if JS.truthy(JS.compare(">", _scope13["mazeDistance"], JS.get_property(JS.get_property(JS.module("Constants"), "SERVER"), "MAX_ACCEPTED_MAZE_DISTANCE"))):
			JS.invoke_method(_scope13["tankState"], "setX", [JS.invoke_method(_scope13["tank"], "getX", [])])
			JS.invoke_method(_scope13["tankState"], "setY", [JS.invoke_method(_scope13["tank"], "getY", [])])
			JS.set_property(_scope13, "stateVerified", false)
	return _scope13["stateVerified"]
	return null

func original_setTankState(_arg0 = null, _arg1 = null):
	var _scope16: Dictionary = {"tankState": _arg0, "initial": _arg1, "tank": null}
	if JS.truthy(JS.logical("||", func():
		var _scope17: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)
		return null, func():
		var _scope18: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)
		return null)):
		_scope16["tank"] = JS.invoke_method(self, "getTank", [JS.invoke_method(_scope16["tankState"], "getPlayerId", [])])
		if JS.truthy(JS.logical("&&", func():
			var _scope19: Dictionary = {}
			return (not JS.truthy(_scope16["tank"]))
			return null, func():
			var _scope20: Dictionary = {}
			return (not JS.truthy(_scope16["initial"]))
			return null)):
			return null
		JS.invoke_method(JS.get_property(self, "model"), "setTankState", [_scope16["tankState"]])
	else:
		JS.invoke_method(JS.get_property(self, "model"), "setTankState", [_scope16["tankState"]])
	JS.invoke_method(self, "_updateWeaponLockingAndFiring", [])
	return null

func original_setProjectileState(_arg0 = null):
	var _scope21: Dictionary = {"projectileState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setProjectileState", [_scope21["projectileState"]])
	return null

func original_setTrapState(_arg0 = null):
	var _scope22: Dictionary = {"trapState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setTrapState", [_scope22["trapState"]])
	return null

func original_setCollectibleState(_arg0 = null):
	var _scope23: Dictionary = {"collectibleState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setCollectibleState", [_scope23["collectibleState"]])
	return null

func original_setWeaponState(_arg0 = null):
	var _scope24: Dictionary = {"weaponState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setWeaponState", [_scope24["weaponState"]])
	return null

func original_setUpgradeState(_arg0 = null):
	var _scope25: Dictionary = {"upgradeState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setUpgradeState", [_scope25["upgradeState"]])
	return null

func original_setCounterState(_arg0 = null):
	var _scope26: Dictionary = {"counterState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setCounterState", [_scope26["counterState"]])
	return null

func original_setZoneState(_arg0 = null):
	var _scope27: Dictionary = {"zoneState": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setZoneState", [_scope27["zoneState"]])
	return null

func original_setInputState(_arg0 = null):
	var _scope28: Dictionary = {"inputState": _arg0, "playerId": null, "tank": null, "tankState": null}
	if JS.truthy(JS.logical("||", func():
		var _scope29: Dictionary = {}
		return (not JS.truthy(JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])))
		return null, func():
		var _scope30: Dictionary = {}
		return (not JS.truthy(JS.invoke_method(JS.get_property(self, "model"), "getMaze", [])))
		return null)):
		return null
	_scope28["playerId"] = JS.invoke_method(_scope28["inputState"], "getPlayerId", [])
	_scope28["tank"] = JS.invoke_method(self, "getTank", [_scope28["playerId"]])
	if JS.truthy(_scope28["tank"]):
		_scope28["tankState"] = JS.invoke_method(JS.module("TankState"), "withState", [_scope28["playerId"], JS.invoke_method(_scope28["tank"], "getX", []), JS.invoke_method(_scope28["tank"], "getY", []), JS.invoke_method(_scope28["inputState"], "getForward", []), JS.invoke_method(_scope28["inputState"], "getBack", []), JS.invoke_method(_scope28["tank"], "getRotation", []), JS.invoke_method(_scope28["inputState"], "getLeft", []), JS.invoke_method(_scope28["inputState"], "getRight", []), JS.invoke_method(_scope28["inputState"], "getFire", []), JS.invoke_method(_scope28["tank"], "getLocked", [])])
		JS.invoke_method(self, "setTankState", [_scope28["tankState"], false])
		if JS.truthy(JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)):
			JS.set_property(self, "tankStateEmissionValue", 0)
			JS.invoke_method(JS.get_property(self, "model"), "emitTankState", [_scope28["tankState"]])
	return null

func original_createRound(_arg0 = null):
	var _scope31: Dictionary = {"ranked": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "createRound", [_scope31["ranked"]])
	return null

func original_startRound():
	var _scope32: Dictionary = {}
	if JS.truthy(JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)):
		JS.set_property(self, "initialRoundStateReceived", true)
	JS.invoke_method(JS.get_property(self, "model"), "startRound", [])
	return null

func original_endRound(_arg0 = null):
	var _scope33: Dictionary = {"victoryAward": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "endRound", [_scope33["victoryAward"]])
	JS.set_property(self, "initialRoundStateReceived", false)
	return null

func original_startCelebration():
	var _scope34: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "model"), "startCelebration", [])
	return null

func original_endCelebration():
	var _scope35: Dictionary = {}
	JS.invoke_method(JS.get_property(self, "model"), "endCelebration", [])
	return null

func original_pullTrigger(_arg0 = null):
	var _scope36: Dictionary = {"playerId": _arg0, "tank": null, "weapon": null, "projectileStates": null, "i": null, "trapStates": null}
	_scope36["tank"] = JS.invoke_method(self, "getTank", [_scope36["playerId"]])
	if JS.truthy(_scope36["tank"]):
		_scope36["weapon"] = JS.invoke_method(self, "getActiveWeapon", [_scope36["playerId"]])
		if JS.truthy(_scope36["weapon"]):
			if JS.truthy(JS.invoke_method(_scope36["weapon"], "fire", [])):
				if JS.truthy(JS.logical("||", func():
					var _scope37: Dictionary = {}
					return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)
					return null, func():
					var _scope38: Dictionary = {}
					return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)
					return null)):
					_scope36["projectileStates"] = JS.invoke_method(_scope36["weapon"], "getProjectileStates", [_scope36["tank"]])
					_scope36["i"] = 0
					while JS.truthy(JS.compare("<", _scope36["i"], JS.get_property(_scope36["projectileStates"], "length"))):
						JS.invoke_method(self, "setProjectileState", [JS.get_property(_scope36["projectileStates"], _scope36["i"])])
						JS.increment(_scope36, "i", 1, false)
					_scope36["trapStates"] = JS.invoke_method(_scope36["weapon"], "getTrapStates", [_scope36["tank"]])
					_scope36["i"] = 0
					while JS.truthy(JS.compare("<", _scope36["i"], JS.get_property(_scope36["trapStates"], "length"))):
						JS.invoke_method(self, "setTrapState", [JS.get_property(_scope36["trapStates"], _scope36["i"])])
						JS.increment(_scope36, "i", 1, false)
	return null

func original_releaseTrigger(_arg0 = null):
	var _scope39: Dictionary = {"playerId": _arg0, "tank": null, "weapon": null}
	_scope39["tank"] = JS.invoke_method(self, "getTank", [_scope39["playerId"]])
	if JS.truthy(_scope39["tank"]):
		_scope39["weapon"] = JS.invoke_method(self, "getActiveWeapon", [_scope39["playerId"]])
		if JS.truthy(_scope39["weapon"]):
			JS.invoke_method(_scope39["weapon"], "release", [])
	return null

func original_delayedFire(_arg0 = null):
	var _scope40: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope41: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope42: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "delayedFire", [_scope40["playerId"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to fire projectile delayed while round was not started"])
	return null

func original_timeoutProjectile(_arg0 = null):
	var _scope43: Dictionary = {"projectileId": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope44: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope45: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "timeoutProjectile", [_scope43["projectileId"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to timeout projectile while round was not started"])
	return null

func original_destroyProjectile(_arg0 = null):
	var _scope46: Dictionary = {"projectileId": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope47: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope48: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "destroyProjectile", [_scope46["projectileId"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to destroy projectile while round was not started"])
	return null

func original_tripTrap(_arg0 = null):
	var _scope49: Dictionary = {"trip": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope50: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope51: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "tripTrap", [_scope49["trip"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to trip trap while round was not started"])
	return null

func original_destroyTrap(_arg0 = null):
	var _scope52: Dictionary = {"trapId": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope53: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope54: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "destroyTrap", [_scope52["trapId"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to destroy trap while round was not started"])
	return null

func original_destroyCollectible(_arg0 = null):
	var _scope55: Dictionary = {"pickup": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope56: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope57: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "destroyCollectible", [_scope55["pickup"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to destroy collectible while round was not started"])
	return null

func original_destroyWeapon(_arg0 = null):
	var _scope58: Dictionary = {"weaponDeactivation": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope59: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope60: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "destroyWeapon", [_scope58["weaponDeactivation"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to destroy weapon while round was not started"])
	return null

func original_destroyUpgrade(_arg0 = null):
	var _scope61: Dictionary = {"upgradeUpdate": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope62: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope63: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "destroyUpgrade", [_scope61["upgradeUpdate"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to destroy upgrade while round was not started"])
	return null

func original_destroyCounter(_arg0 = null):
	var _scope64: Dictionary = {"counterId": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope65: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope66: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "destroyCounter", [_scope64["counterId"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to destroy counter while round was not started"])
	return null

func original_destroyZone(_arg0 = null):
	var _scope67: Dictionary = {"zoneId": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope68: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope69: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "destroyZone", [_scope67["zoneId"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to destroy zone while round was not started"])
	return null

func original_killTank(_arg0 = null):
	var _scope70: Dictionary = {"kill": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope71: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope72: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "killTank", [_scope70["kill"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to kill tank while round was not started"])
	return null

func original_destroyTank(_arg0 = null):
	var _scope73: Dictionary = {"playerId": _arg0}
	if JS.truthy(JS.logical("||", func():
		var _scope74: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope75: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		JS.invoke_method(JS.get_property(self, "model"), "destroyTank", [_scope73["playerId"]])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to destroy tank while round was not started"])
	return null

func original_spawnTank(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope76: Dictionary = {"playerId": _arg0, "position": _arg1, "respawn": _arg2, "tankState": null, "weaponState": null, "upgradeState": null}
	_scope76["tankState"] = JS.invoke_method(JS.module("TankState"), "withState", [_scope76["playerId"], JS.get_property(_scope76["position"], "x"), JS.get_property(_scope76["position"], "y"), false, false, JS.get_property(_scope76["position"], "rotation"), false, false, false, false])
	JS.invoke_method(self, "setTankState", [_scope76["tankState"], true])
	_scope76["weaponState"] = null
	_scope76["upgradeState"] = null
	if JS.truthy(_scope76["respawn"]):
		JS.set_property(_scope76, "weaponState", JS.invoke_method(JS.get_property(self, "gameMode"), "getRespawnWeaponState", [JS.invoke_method(_scope76["tankState"], "getPlayerId", [])]))
		JS.set_property(_scope76, "upgradeState", JS.invoke_method(JS.get_property(self, "gameMode"), "getRespawnUpgradeState", [JS.invoke_method(_scope76["tankState"], "getPlayerId", [])]))
	else:
		JS.set_property(_scope76, "weaponState", JS.invoke_method(JS.get_property(self, "gameMode"), "getInitialWeaponState", [JS.invoke_method(_scope76["tankState"], "getPlayerId", [])]))
		JS.set_property(_scope76, "upgradeState", JS.invoke_method(JS.get_property(self, "gameMode"), "getInitialUpgradeState", [JS.invoke_method(_scope76["tankState"], "getPlayerId", [])]))
	if JS.truthy(_scope76["weaponState"]):
		JS.invoke_method(self, "setWeaponState", [_scope76["weaponState"]])
	if JS.truthy(_scope76["upgradeState"]):
		JS.invoke_method(self, "setUpgradeState", [_scope76["upgradeState"]])
	return null

func original_spawnCrate(_arg0 = null, _arg1 = null):
	var _scope77: Dictionary = {"type": _arg0, "position": _arg1, "collectibleState": null}
	_scope77["collectibleState"] = JS.invoke_method(JS.module("CollectibleState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["c"]), _scope77["type"], JS.get_property(_scope77["position"], "x"), JS.get_property(_scope77["position"], "y"), JS.get_property(_scope77["position"], "rotation")])
	JS.invoke_method(self, "setCollectibleState", [_scope77["collectibleState"]])
	return null

func original_pickUpCrate(_arg0 = null):
	var _scope78: Dictionary = {"pickup": _arg0, "weaponState": null, "upgradeState": null, "collectible": null}
	if JS.truthy(JS.logical("||", func():
		var _scope79: Dictionary = {}
		return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
		return null, func():
		var _scope80: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_ONLINE"), false)
		return null)):
		_scope78["weaponState"] = null
		_scope78["upgradeState"] = null
		_scope78["collectible"] = JS.invoke_method(self, "getCollectible", [JS.invoke_method(_scope78["pickup"], "getCollectibleId", [])])
		if JS.truthy(_scope78["collectible"]):
			var _switch5 = JS.invoke_method(_scope78["collectible"], "getType", [])
			var _switch5_start = -1
			if JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_LASER"), true): _switch5_start = 0
			elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_DOUBLE_BARREL"), true): _switch5_start = 1
			elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SHOTGUN"), true): _switch5_start = 2
			elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_HOMING_MISSILE"), true): _switch5_start = 3
			elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_MINE"), true): _switch5_start = 4
			elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_GATLING_GUN"), true): _switch5_start = 5
			elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_AIMER"), true): _switch5_start = 6
			elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SHIELD"), true): _switch5_start = 7
			elif JS.equal(_switch5, JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "CRATE_SPEED_BOOST"), true): _switch5_start = 8
			while true:
				if _switch5_start >= 0 and _switch5_start <= 0:
					JS.set_property(_scope78, "weaponState", JS.invoke_method(JS.module("LaserWeapon"), "createInitialWeaponState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["lw"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", [])]))
					JS.set_property(_scope78, "upgradeState", JS.invoke_method(JS.module("LaserAimerUpgrade"), "createInitialUpgradeState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["lau"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", []), JS.invoke_method(_scope78["weaponState"], "getId", []), JS.get_property(JS.module("Constants"), "LASER_AIMER_LENGTH")]))
					break
				if _switch5_start >= 0 and _switch5_start <= 1:
					JS.set_property(_scope78, "weaponState", JS.invoke_method(JS.module("DoubleBarrelWeapon"), "createInitialWeaponState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["dbw"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", []), JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_AMMO_COUNT")]))
					break
				if _switch5_start >= 0 and _switch5_start <= 2:
					JS.set_property(_scope78, "weaponState", JS.invoke_method(JS.module("ShotgunWeapon"), "createInitialWeaponState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["sw"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", []), JS.get_property(JS.module("Constants"), "SHOTGUN_AMMO_COUNT")]))
					break
				if _switch5_start >= 0 and _switch5_start <= 3:
					JS.set_property(_scope78, "weaponState", JS.invoke_method(JS.module("HomingMissileWeapon"), "createInitialWeaponState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["hmw"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", [])]))
					break
				if _switch5_start >= 0 and _switch5_start <= 4:
					JS.set_property(_scope78, "weaponState", JS.invoke_method(JS.module("MineWeapon"), "createInitialWeaponState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["mw"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", []), JS.get_property(JS.module("Constants"), "MINE_AMMO_COUNT")]))
					break
				if _switch5_start >= 0 and _switch5_start <= 5:
					JS.set_property(_scope78, "weaponState", JS.invoke_method(JS.module("GatlingGunWeapon"), "createInitialWeaponState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["ggw"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", []), JS.get_property(JS.module("Constants"), "GATLING_GUN_AMMO_COUNT")]))
					break
				if _switch5_start >= 0 and _switch5_start <= 6:
					JS.set_property(_scope78, "upgradeState", JS.invoke_method(JS.module("AimerUpgrade"), "createInitialUpgradeState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["au"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", []), JS.get_property(JS.module("Constants"), "AIMER_LIFETIME"), JS.get_property(JS.module("Constants"), "AIMER_LENGTH")]))
					break
				if _switch5_start >= 0 and _switch5_start <= 7:
					JS.set_property(_scope78, "upgradeState", JS.invoke_method(JS.module("ShieldUpgrade"), "createInitialUpgradeState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["su"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", []), JS.get_property(JS.module("Constants"), "SHIELD_LIFETIME")]))
					break
				if _switch5_start >= 0 and _switch5_start <= 8:
					JS.set_property(_scope78, "upgradeState", JS.invoke_method(JS.module("SpeedBoostUpgrade"), "createInitialUpgradeState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["sbu"]), JS.invoke_method(_scope78["pickup"], "getPlayerId", []), JS.get_property(JS.module("Constants"), "SPEED_BOOST_LIFETIME"), JS.get_property(JS.module("Constants"), "SPEED_BOOST_EFFECT")]))
					break
				break
			if JS.truthy(_scope78["weaponState"]):
				JS.invoke_method(self, "setWeaponState", [_scope78["weaponState"]])
			if JS.truthy(_scope78["upgradeState"]):
				JS.invoke_method(self, "setUpgradeState", [_scope78["upgradeState"]])
		else:
			JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to pick up crate which was not there"])
	else:
		JS.invoke_method(JS.get_property(self, "log"), "error", ["Attempt to pick up crate while round was not started"])
	return null

func original_spawnGold():
	var _scope81: Dictionary = {"goldPosition": null, "collectibleState": null}
	if JS.truthy(JS.compare("<", JS.invoke_method(JS.get_property(self, "model"), "getGoldSpawnCount", []), JS.get_property(JS.get_property(JS.module("Constants"), "SERVER"), "GOLD_SPAWN_MAX_PER_ROUND"))):
		if JS.truthy(JS.compare(">", JS.invoke_method(JS.get_property(self, "model"), "getTankCount", []), 1)):
			if JS.truthy(JS.compare("<", JS.invoke_method(self, "getCollectibleCount", [JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "GOLD")]), JS.get_property(JS.module("Constants"), "MAX_GOLDS"))):
				_scope81["goldPosition"] = JS.invoke_method(JS.invoke_method(JS.get_property(self, "model"), "getMaze", []), "getRandomUnusedPosition", [JS.invoke_method(self, "getRoundState", [true]), JS.get_property(JS.module("Constants"), "GOLD_MINIMUM_TILES_TO_TANKS")])
				if JS.truthy(_scope81["goldPosition"]):
					_scope81["collectibleState"] = JS.invoke_method(JS.module("CollectibleState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["g"]), JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "GOLD"), JS.get_property(_scope81["goldPosition"], "x"), JS.get_property(_scope81["goldPosition"], "y"), 0])
					JS.invoke_method(self, "setCollectibleState", [_scope81["collectibleState"]])
	return null

func original_spawnDiamond():
	var _scope82: Dictionary = {"diamondPosition": null, "collectibleState": null}
	if JS.truthy(JS.compare("<", JS.invoke_method(JS.get_property(self, "model"), "getDiamondSpawnCount", []), JS.get_property(JS.get_property(JS.module("Constants"), "SERVER"), "DIAMOND_SPAWN_MAX_PER_ROUND"))):
		if JS.truthy(JS.compare(">", JS.invoke_method(JS.get_property(self, "model"), "getTankCount", []), 1)):
			if JS.truthy(JS.compare("<", JS.invoke_method(self, "getCollectibleCount", [JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "DIAMOND")]), JS.get_property(JS.module("Constants"), "MAX_DIAMONDS"))):
				_scope82["diamondPosition"] = JS.invoke_method(JS.invoke_method(JS.get_property(self, "model"), "getMaze", []), "getRandomUnusedPosition", [JS.invoke_method(self, "getRoundState", [true]), JS.get_property(JS.module("Constants"), "DIAMOND_MINIMUM_TILES_TO_TANKS")])
				if JS.truthy(_scope82["diamondPosition"]):
					_scope82["collectibleState"] = JS.invoke_method(JS.module("CollectibleState"), "withState", [JS.invoke_method(JS.get_property(JS.module("IdGenerator"), "instance"), "gen", ["d"]), JS.get_property(JS.get_property(JS.module("Constants"), "COLLECTIBLE_TYPES"), "DIAMOND"), JS.get_property(_scope82["diamondPosition"], "x"), JS.get_property(_scope82["diamondPosition"], "y"), JS.add((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.25)), (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(0.5))) * JS.number(JS.get_property("@Math", "PI"))))])
					JS.invoke_method(self, "setCollectibleState", [_scope82["collectibleState"]])
	return null

func original__updateWeaponLockingAndFiring():
	var _scope83: Dictionary = {"tanks": null, "tank": null, "weapon": null}
	_scope83["tanks"] = JS.invoke_method(JS.get_property(self, "model"), "getTanks", [])
	for _iteration6 in JS.keys(_scope83["tanks"]):
		JS.set_property(_scope83, "tank", _iteration6)
		_scope83["weapon"] = JS.invoke_method(self, "getActiveWeapon", [JS.invoke_method(JS.get_property(_scope83["tanks"], _scope83["tank"]), "getPlayerId", [])])
		if JS.truthy(_scope83["weapon"]):
			JS.invoke_method(JS.get_property(_scope83["tanks"], _scope83["tank"]), "setLocked", [JS.invoke_method(_scope83["weapon"], "movementLocked", [])])
	for _iteration7 in JS.keys(_scope83["tanks"]):
		JS.set_property(_scope83, "tank", _iteration7)
		if JS.truthy(JS.invoke_method(JS.get_property(_scope83["tanks"], _scope83["tank"]), "getFireDown", [])):
			JS.invoke_method(self, "pullTrigger", [JS.invoke_method(JS.get_property(_scope83["tanks"], _scope83["tank"]), "getPlayerId", [])])
		else:
			JS.invoke_method(self, "releaseTrigger", [JS.invoke_method(JS.get_property(_scope83["tanks"], _scope83["tank"]), "getPlayerId", [])])
	return null

func original_update(_arg0 = null):
	var _scope84: Dictionary = {"deltaTime": _arg0, "projectiles": null, "projectile": null, "traps": null, "trap": null, "projectileStates": null, "i": null, "weapons": null, "weapon": null, "weaponDeactivation": null, "upgrades": null, "upgrade": null, "upgradeUpdate": null, "counters": null, "counter": null, "zones": null, "zone": null, "winnerPlayerIds": null, "victoryExperiencePerWinner": null, "victoryGoldAmountPerWinner": null, "rankChanges": null, "tank": null}
	JS.invoke_method(self, "_updateWeaponLockingAndFiring", [])
	if JS.truthy(JS.logical("||", func():
		var _scope85: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_CLIENT_LOCAL"), true)
		return null, func():
		var _scope86: Dictionary = {}
		return JS.equal(JS.invoke_method(JS.module("Constants"), "getMode", []), JS.get_property(JS.module("Constants"), "MODE_SERVER"), true)
		return null)):
		if JS.truthy(JS.logical("&&", func():
			var _scope87: Dictionary = {}
			return JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])
			return null, func():
			var _scope88: Dictionary = {}
			return JS.invoke_method(JS.get_property(self, "model"), "getMaze", [])
			return null)):
			_scope84["projectiles"] = JS.invoke_method(JS.get_property(self, "model"), "getProjectiles", [])
			for _iteration8 in JS.keys(_scope84["projectiles"]):
				JS.set_property(_scope84, "projectile", _iteration8)
				if JS.truthy(JS.invoke_method(JS.get_property(_scope84["projectiles"], _scope84["projectile"]), "done", [])):
					JS.invoke_method(JS.get_property(self, "model"), "timeoutProjectile", [JS.invoke_method(JS.get_property(_scope84["projectiles"], _scope84["projectile"]), "getId", [])])
			_scope84["traps"] = JS.invoke_method(JS.get_property(self, "model"), "getTraps", [])
			for _iteration9 in JS.keys(_scope84["traps"]):
				JS.set_property(_scope84, "trap", _iteration9)
				if JS.truthy(JS.invoke_method(JS.get_property(_scope84["traps"], _scope84["trap"]), "released", [])):
					_scope84["projectileStates"] = JS.invoke_method(JS.get_property(_scope84["traps"], _scope84["trap"]), "getProjectileStates", [])
					_scope84["i"] = 0
					while JS.truthy(JS.compare("<", _scope84["i"], JS.get_property(_scope84["projectileStates"], "length"))):
						JS.invoke_method(self, "setProjectileState", [JS.get_property(_scope84["projectileStates"], _scope84["i"])])
						JS.increment(_scope84, "i", 1, false)
			for _iteration10 in JS.keys(_scope84["traps"]):
				JS.set_property(_scope84, "trap", _iteration10)
				if JS.truthy(JS.invoke_method(JS.get_property(_scope84["traps"], _scope84["trap"]), "done", [])):
					JS.invoke_method(self, "destroyTrap", [JS.invoke_method(JS.get_property(_scope84["traps"], _scope84["trap"]), "getId", [])])
			_scope84["weapons"] = JS.invoke_method(JS.get_property(self, "model"), "getWeapons", [])
			for _iteration11 in JS.keys(_scope84["weapons"]):
				JS.set_property(_scope84, "weapon", _iteration11)
				if JS.truthy(JS.invoke_method(JS.get_property(_scope84["weapons"], _scope84["weapon"]), "done", [])):
					_scope84["weaponDeactivation"] = JS.invoke_method(JS.module("WeaponDeactivation"), "create", [JS.invoke_method(JS.get_property(_scope84["weapons"], _scope84["weapon"]), "getId", []), JS.invoke_method(JS.get_property(_scope84["weapons"], _scope84["weapon"]), "getPlayerId", [])])
					JS.invoke_method(self, "destroyWeapon", [_scope84["weaponDeactivation"]])
			_scope84["upgrades"] = JS.invoke_method(JS.get_property(self, "model"), "getUpgrades", [])
			for _iteration12 in JS.keys(_scope84["upgrades"]):
				JS.set_property(_scope84, "upgrade", _iteration12)
				if JS.truthy(JS.invoke_method(JS.get_property(_scope84["upgrades"], _scope84["upgrade"]), "done", [])):
					_scope84["upgradeUpdate"] = JS.invoke_method(JS.module("UpgradeUpdate"), "create", [JS.invoke_method(JS.get_property(_scope84["upgrades"], _scope84["upgrade"]), "getId", []), JS.invoke_method(JS.get_property(_scope84["upgrades"], _scope84["upgrade"]), "getPlayerId", [])])
					JS.invoke_method(self, "destroyUpgrade", [_scope84["upgradeUpdate"]])
			_scope84["counters"] = JS.invoke_method(JS.get_property(self, "model"), "getCounters", [])
			for _iteration13 in JS.keys(_scope84["counters"]):
				JS.set_property(_scope84, "counter", _iteration13)
				if JS.truthy(JS.invoke_method(JS.get_property(_scope84["counters"], _scope84["counter"]), "done", [])):
					JS.invoke_method(self, "destroyCounter", [JS.invoke_method(JS.get_property(_scope84["counters"], _scope84["counter"]), "getId", [])])
			_scope84["zones"] = JS.invoke_method(JS.get_property(self, "model"), "getZones", [])
			for _iteration14 in JS.keys(_scope84["zones"]):
				JS.set_property(_scope84, "zone", _iteration14)
				if JS.truthy(JS.invoke_method(JS.get_property(_scope84["zones"], _scope84["zone"]), "done", [])):
					JS.invoke_method(self, "destroyZone", [JS.invoke_method(JS.get_property(_scope84["zones"], _scope84["zone"]), "getId", [])])
			JS.invoke_method(JS.get_property(self, "gameMode"), "update", [_scope84["deltaTime"]])
			if JS.truthy(JS.invoke_method(JS.get_property(self, "gameMode"), "isRoundOver", [])):
				_scope84["winnerPlayerIds"] = JS.invoke_method(JS.get_property(self, "gameMode"), "getWinnerPlayerIds", [])
				_scope84["victoryExperiencePerWinner"] = 0
				if JS.truthy(JS.compare(">", JS.get_property(_scope84["winnerPlayerIds"], "length"), 0)):
					JS.set_property(_scope84, "victoryExperiencePerWinner", JS.invoke_method("@Math", "ceil", [(JS.number(JS.invoke_method(JS.get_property(self, "gameMode"), "getVictoryExperience", [])) / JS.number(JS.get_property(_scope84["winnerPlayerIds"], "length")))]))
				_scope84["victoryGoldAmountPerWinner"] = 0
				if JS.truthy(JS.compare(">", JS.get_property(_scope84["winnerPlayerIds"], "length"), 0)):
					JS.set_property(_scope84, "victoryGoldAmountPerWinner", JS.invoke_method("@Math", "ceil", [(JS.number(JS.invoke_method(JS.get_property(self, "model"), "getVictoryGoldAmount", [])) / JS.number(JS.get_property(_scope84["winnerPlayerIds"], "length")))]))
				_scope84["rankChanges"] = JS.invoke_method(JS.get_property(self, "model"), "getRankChanges", [_scope84["winnerPlayerIds"]])
				JS.invoke_method(self, "endRound", [JS.invoke_method(JS.module("VictoryAward"), "create", [_scope84["winnerPlayerIds"], _scope84["victoryExperiencePerWinner"], _scope84["victoryGoldAmountPerWinner"], _scope84["rankChanges"]])])
	else:
		if JS.truthy(JS.invoke_method(JS.get_property(self, "model"), "getStarted", [])):
			JS.set_property(self, "tankStateEmissionValue", JS.add(JS.get_property(self, "tankStateEmissionValue"), _scope84["deltaTime"]))
			if JS.truthy(JS.compare(">=", JS.get_property(self, "tankStateEmissionValue"), JS.get_property(JS.get_property(JS.module("Constants"), "CLIENT"), "TANKSTATE_EMISSION_INTERVAL"))):
				JS.set_property(self, "tankStateEmissionValue", 0)
				_scope84["i"] = 0
				while JS.truthy(JS.compare("<", _scope84["i"], JS.get_property(JS.get_property(self, "localPlayerIds"), "length"))):
					_scope84["tank"] = JS.invoke_method(self, "getTank", [JS.get_property(JS.get_property(self, "localPlayerIds"), _scope84["i"])])
					if JS.truthy(_scope84["tank"]):
						JS.invoke_method(JS.get_property(self, "model"), "emitTankState", [JS.invoke_method(_scope84["tank"], "getTankState", [])])
					JS.increment(_scope84, "i", 1, false)
	JS.invoke_method(JS.get_property(self, "model"), "update", [_scope84["deltaTime"]])
	return null

func original_addEventListener(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope89: Dictionary = {"callback": _arg0, "context": _arg1, "gameId": _arg2}
	JS.invoke_method(JS.get_property(self, "model"), "addEventListener", [_scope89["callback"], _scope89["context"], _scope89["gameId"]])
	return null

func original_removeEventListener(_arg0 = null, _arg1 = null):
	var _scope90: Dictionary = {"callback": _arg0, "context": _arg1}
	JS.invoke_method(JS.get_property(self, "model"), "removeEventListener", [_scope90["callback"], _scope90["context"]])
	return null

func original_getId():
	var _scope91: Dictionary = {}
	return JS.get_property(self, "id")
	return null

func original_getTank(_arg0 = null):
	var _scope92: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getTank", [_scope92["playerId"]])
	return null

func original_getTanks():
	var _scope93: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getTanks", [])
	return null

func original_getProjectile(_arg0 = null):
	var _scope94: Dictionary = {"projectileId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getProjectile", [_scope94["projectileId"]])
	return null

func original_getProjectiles():
	var _scope95: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getProjectiles", [])
	return null

func original_getTrap(_arg0 = null):
	var _scope96: Dictionary = {"trapId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getTrap", [_scope96["trapId"]])
	return null

func original_getTraps():
	var _scope97: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getTraps", [])
	return null

func original_getCollectible(_arg0 = null):
	var _scope98: Dictionary = {"collectibleId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getCollectible", [_scope98["collectibleId"]])
	return null

func original_getCollectibles():
	var _scope99: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getCollectibles", [])
	return null

func original_getCrateCount():
	var _scope100: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getCrateCount", [])
	return null

func original_getCollectibleCount(_arg0 = null):
	var _scope101: Dictionary = {"collectibleType": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getCollectibleCount", [_scope101["collectibleType"]])
	return null

func original_getActiveWeapon(_arg0 = null):
	var _scope102: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getActiveWeapon", [_scope102["playerId"]])
	return null

func original_getDefaultWeapon(_arg0 = null):
	var _scope103: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getDefaultWeapon", [_scope103["playerId"]])
	return null

func original_getQueuedWeapons(_arg0 = null):
	var _scope104: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getQueuedWeapons", [_scope104["playerId"]])
	return null

func original_getUpgrades():
	var _scope105: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getUpgrades", [])
	return null

func original_getUpgrade(_arg0 = null):
	var _scope106: Dictionary = {"upgradeId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getUpgrade", [_scope106["upgradeId"]])
	return null

func original_getUpgradeByPlayerIdAndType(_arg0 = null, _arg1 = null):
	var _scope107: Dictionary = {"playerId": _arg0, "upgradeType": _arg1}
	return JS.invoke_method(JS.get_property(self, "model"), "getUpgradeByPlayerIdAndType", [_scope107["playerId"], _scope107["upgradeType"]])
	return null

func original_getCounters():
	var _scope108: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getCounters", [])
	return null

func original_getCounter(_arg0 = null):
	var _scope109: Dictionary = {"counterId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getCounter", [_scope109["counterId"]])
	return null

func original_getZones():
	var _scope110: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getZones", [])
	return null

func original_getZone(_arg0 = null):
	var _scope111: Dictionary = {"zoneId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getZone", [_scope111["zoneId"]])
	return null

func original_getMaze(_arg0 = null, _arg1 = null):
	var _scope112: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getMaze", [])
	return null

func original_getModifier(_arg0 = null, _arg1 = null):
	var _scope113: Dictionary = {"playerId": _arg0, "modifierType": _arg1}
	return JS.invoke_method(JS.get_property(self, "model"), "getModifier", [_scope113["playerId"], _scope113["modifierType"]])
	return null

func original_setVictoryGoldAmount(_arg0 = null):
	var _scope114: Dictionary = {"victoryGoldAmount": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setVictoryGoldAmount", [_scope114["victoryGoldAmount"]])
	return null

func original_setStakes(_arg0 = null):
	var _scope115: Dictionary = {"stakes": _arg0}
	JS.invoke_method(JS.get_property(self, "model"), "setStakes", [_scope115["stakes"]])
	return null

func original_getStake(_arg0 = null):
	var _scope116: Dictionary = {"playerId": _arg0}
	return JS.invoke_method(JS.get_property(self, "model"), "getStake", [_scope116["playerId"]])
	return null

func original_getInitialRoundStateReceived():
	var _scope117: Dictionary = {}
	return JS.get_property(self, "initialRoundStateReceived")
	return null

func original_getB2DWorld():
	var _scope118: Dictionary = {}
	return JS.invoke_method(JS.get_property(self, "model"), "getB2DWorld", [])
	return null
