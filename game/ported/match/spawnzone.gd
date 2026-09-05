# 由原版 SpawnZone 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/match/zone.gd"

var _lifetime = 0
var _radius = 0
var _unstable = false
static var _static_SpawnZone: Dictionary = {}
static var _initialized_SpawnZone = false
static func initialize_original_static():
	if _initialized_SpawnZone: return
	_initialized_SpawnZone = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_SpawnZone.has(key): return _static_SpawnZone[key]
	return JS.get_property(JS.module("Zone"), key)
static func original_static_set(key, value):
	_static_SpawnZone[key] = value
	return value
func original_own_fields():
	return ["_lifetime","_radius","_unstable"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/match/spawnzone.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

func original_update(_arg0 = null):
	var _scope0: Dictionary = {"deltaTime": _arg0, "ratio": null}
	JS.set_property(self, "_lifetime", (JS.number(JS.get_property(self, "_lifetime")) - JS.number(_scope0["deltaTime"])))
	if JS.truthy(JS.compare("<=", JS.get_property(self, "_lifetime"), JS.get_property(JS.module("Constants"), "SPAWN_ZONE_START_GROW_TIME"))):
		_scope0["ratio"] = JS.invoke_method("@Math", "min", [1, (JS.number((JS.number(JS.get_property(JS.module("Constants"), "SPAWN_ZONE_START_GROW_TIME")) - JS.number(JS.get_property(self, "_lifetime")))) / JS.number((JS.number(JS.get_property(JS.module("Constants"), "SPAWN_ZONE_START_GROW_TIME")) - JS.number(JS.get_property(JS.module("Constants"), "SPAWN_ZONE_END_GROW_TIME")))))])
		JS.set_property(self, "_radius", JS.add(JS.get_property(JS.module("Constants"), "SPAWN_ZONE_START_RADIUS"), (JS.number(_scope0["ratio"]) * JS.number((JS.number(JS.get_property(JS.module("Constants"), "SPAWN_ZONE_END_RADIUS")) - JS.number(JS.get_property(JS.module("Constants"), "SPAWN_ZONE_START_RADIUS")))))))
		JS.invoke_method(JS.module("B2DUtils"), "updateSpawnZoneBody", [JS.get_property(self, "b2dbody"), self, JS.get_property(self, "_radius")])
	if JS.truthy(JS.compare("<=", JS.get_property(self, "_lifetime"), JS.get_property(JS.module("Constants"), "SPAWN_ZONE_END_GROW_TIME"))):
		if JS.truthy((not JS.truthy(JS.get_property(self, "_unstable")))):
			JS.set_property(self, "_unstable", true)
			JS.invoke_method(self, "_emitEvent", [JS.get_property(JS.get_property(JS.module("Zone"), "_EVENTS"), "ZONE_DESTABILIZED"), JS.get_property(self, "id")])
	return null

func original_done():
	var _scope1: Dictionary = {}
	return JS.compare("<=", JS.get_property(self, "_lifetime"), 0)
	return null

func original_isPhysical():
	var _scope2: Dictionary = {}
	return false
	return null

static func original_createInitialZoneState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope3: Dictionary = {"id": _arg0, "tiles": _arg1, "lifetime": _arg2, "radius": _arg3, "fields": null}
	_scope3["fields"] = {"_lifetime": _scope3["lifetime"], "_radius": _scope3["radius"], "_unstable": false}
	return JS.invoke_method(JS.module("Zone"), "createInitialZoneState", [_scope3["id"], JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "SPAWN"), _scope3["tiles"], JS.invoke_method("@JSON", "stringify", [_scope3["fields"]])])
	return null
