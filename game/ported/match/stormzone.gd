# 由原版 StormZone 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/match/zone.gd"

var _expansionTime = 0
var _expansionSequence = null
var _tileBounds = null
var _expansionSide = 0
var _expansionTilesRight = 0
var _expansionTilesBottom = 0
var _expansionTilesLeft = 0
var _expansionTilesTop = 0
static var _static_StormZone: Dictionary = {}
static var _initialized_StormZone = false
static func initialize_original_static():
	if _initialized_StormZone: return
	_initialized_StormZone = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_StormZone.has(key): return _static_StormZone[key]
	return JS.get_property(JS.module("Zone"), key)
static func original_static_set(key, value):
	_static_StormZone[key] = value
	return value
func original_own_fields():
	return ["_expansionTime","_expansionSequence","_tileBounds","_expansionSide","_expansionTilesRight","_expansionTilesBottom","_expansionTilesLeft","_expansionTilesTop"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/match/stormzone.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

func original_update(_arg0 = null):
	var _scope0: Dictionary = {"deltaTime": _arg0, "corners": null}
	JS.set_property(self, "_expansionTime", (JS.number(JS.get_property(self, "_expansionTime")) - JS.number(_scope0["deltaTime"])))
	if JS.truthy(JS.compare("<=", JS.get_property(self, "_expansionTime"), JS.get_property(JS.module("Constants"), "STORM_ZONE_START_GROW_TIME"))):
		if JS.truthy(JS.compare("<", JS.get_property(self, "_expansionSide"), 0)):
			JS.set_property(self, "_expansionSide", JS.get_property(JS.get_property(self, "_expansionSequence"), JS.add(JS.add(JS.add(JS.get_property(self, "_expansionTilesRight"), JS.get_property(self, "_expansionTilesBottom")), JS.get_property(self, "_expansionTilesLeft")), JS.get_property(self, "_expansionTilesTop"))))
			var _switch0 = JS.get_property(self, "_expansionSide")
			var _switch0_start = -1
			if JS.equal(_switch0, 0, true): _switch0_start = 0
			elif JS.equal(_switch0, 1, true): _switch0_start = 1
			elif JS.equal(_switch0, 2, true): _switch0_start = 2
			elif JS.equal(_switch0, 3, true): _switch0_start = 3
			while true:
				if _switch0_start >= 0 and _switch0_start <= 0:
					JS.set_property(self, "_expansionTilesRight", JS.add(JS.get_property(self, "_expansionTilesRight"), 1))
					break
				if _switch0_start >= 0 and _switch0_start <= 1:
					JS.set_property(self, "_expansionTilesBottom", JS.add(JS.get_property(self, "_expansionTilesBottom"), 1))
					break
				if _switch0_start >= 0 and _switch0_start <= 2:
					JS.set_property(self, "_expansionTilesLeft", JS.add(JS.get_property(self, "_expansionTilesLeft"), 1))
					break
				if _switch0_start >= 0 and _switch0_start <= 3:
					JS.set_property(self, "_expansionTilesTop", JS.add(JS.get_property(self, "_expansionTilesTop"), 1))
					break
				break
			JS.invoke_method(self, "_rebuildTiles", [])
			JS.invoke_method(JS.get_property(self, "roundModel"), "changeZone", [JS.get_property(self, "id")])
		_scope0["corners"] = JS.invoke_method(self, "getCorners", [])
		JS.invoke_method(JS.module("B2DUtils"), "updateStormZoneBody", [JS.get_property(self, "b2dbody"), self, JS.get_property(_scope0["corners"], "stormStartRight"), JS.get_property(_scope0["corners"], "stormEndRight"), JS.get_property(_scope0["corners"], "stormStartBottom"), JS.get_property(_scope0["corners"], "stormEndBottom"), JS.get_property(_scope0["corners"], "stormStartLeft"), JS.get_property(_scope0["corners"], "stormEndLeft"), JS.get_property(_scope0["corners"], "stormStartTop"), JS.get_property(_scope0["corners"], "stormEndTop")])
	if JS.truthy(JS.compare("<=", JS.get_property(self, "_expansionTime"), 0)):
		JS.set_property(self, "_expansionSide", -(1))
		JS.set_property(self, "_expansionTime", JS.get_property(JS.module("Constants"), "STORM_ZONE_EXPANSION_TIME"))
		JS.invoke_method(self, "_rebuildTiles", [])
		JS.invoke_method(JS.get_property(self, "roundModel"), "changeZone", [JS.get_property(self, "id")])
	return null

func original_getCorners():
	var _scope1: Dictionary = {"ratio": null, "stormStartRight": null, "stormEndRight": null, "stormStartBottom": null, "stormEndBottom": null, "stormStartLeft": null, "stormEndLeft": null, "stormStartTop": null, "stormEndTop": null}
	_scope1["ratio"] = JS.invoke_method("@Math", "max", [0, JS.invoke_method("@Math", "min", [1, (JS.number((JS.number(JS.get_property(JS.module("Constants"), "STORM_ZONE_START_GROW_TIME")) - JS.number(JS.get_property(self, "_expansionTime")))) / JS.number(JS.get_property(JS.module("Constants"), "STORM_ZONE_START_GROW_TIME")))])])
	_scope1["stormStartRight"] = (JS.number((JS.number(JS.add(JS.get_property(JS.get_property(self, "_tileBounds"), "maxX"), 1)) - JS.number((JS.number(JS.get_property(self, "_expansionTilesRight")) - JS.number(((JS.number(1) - JS.number(_scope1["ratio"])) if JS.truthy(JS.equal(JS.get_property(self, "_expansionSide"), 0, false)) else 0)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))
	_scope1["stormEndRight"] = JS.add((JS.number(JS.add(JS.get_property(JS.get_property(self, "_tileBounds"), "maxX"), 1)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))
	_scope1["stormStartBottom"] = (JS.number((JS.number(JS.add(JS.get_property(JS.get_property(self, "_tileBounds"), "maxY"), 1)) - JS.number((JS.number(JS.get_property(self, "_expansionTilesBottom")) - JS.number(((JS.number(1) - JS.number(_scope1["ratio"])) if JS.truthy(JS.equal(JS.get_property(self, "_expansionSide"), 1, false)) else 0)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))
	_scope1["stormEndBottom"] = JS.add((JS.number(JS.add(JS.get_property(JS.get_property(self, "_tileBounds"), "maxY"), 1)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))
	_scope1["stormStartLeft"] = (JS.number((JS.number(JS.get_property(JS.get_property(self, "_tileBounds"), "minX")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
	_scope1["stormEndLeft"] = (JS.number((JS.number(JS.add(JS.get_property(JS.get_property(self, "_tileBounds"), "minX"), JS.get_property(self, "_expansionTilesLeft"))) - JS.number(((JS.number(1) - JS.number(_scope1["ratio"])) if JS.truthy(JS.equal(JS.get_property(self, "_expansionSide"), 2, false)) else 0)))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))
	_scope1["stormStartTop"] = (JS.number((JS.number(JS.get_property(JS.get_property(self, "_tileBounds"), "minY")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
	_scope1["stormEndTop"] = (JS.number((JS.number(JS.add(JS.get_property(JS.get_property(self, "_tileBounds"), "minY"), JS.get_property(self, "_expansionTilesTop"))) - JS.number(((JS.number(1) - JS.number(_scope1["ratio"])) if JS.truthy(JS.equal(JS.get_property(self, "_expansionSide"), 3, false)) else 0)))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))
	return {"stormStartRight": _scope1["stormStartRight"], "stormEndRight": _scope1["stormEndRight"], "stormStartBottom": _scope1["stormStartBottom"], "stormEndBottom": _scope1["stormEndBottom"], "stormStartLeft": _scope1["stormStartLeft"], "stormEndLeft": _scope1["stormEndLeft"], "stormStartTop": _scope1["stormStartTop"], "stormEndTop": _scope1["stormEndTop"]}
	return null

func original_done():
	var _scope2: Dictionary = {}
	return false
	return null

func original_isPhysical():
	var _scope3: Dictionary = {}
	return false
	return null

func original__rebuildTiles():
	var _scope4: Dictionary = {"tilesRight": null, "tilesBottom": null, "tilesLeft": null, "tilesTop": null, "nextExpansionSide": null, "maze": null, "i": null, "j": null, "position": null}
	_scope4["tilesRight"] = JS.get_property(self, "_expansionTilesRight")
	_scope4["tilesBottom"] = JS.get_property(self, "_expansionTilesBottom")
	_scope4["tilesLeft"] = JS.get_property(self, "_expansionTilesLeft")
	_scope4["tilesTop"] = JS.get_property(self, "_expansionTilesTop")
	if JS.truthy(JS.compare("<", JS.get_property(self, "_expansionSide"), 0)):
		_scope4["nextExpansionSide"] = JS.get_property(JS.get_property(self, "_expansionSequence"), JS.add(JS.add(JS.add(JS.get_property(self, "_expansionTilesRight"), JS.get_property(self, "_expansionTilesBottom")), JS.get_property(self, "_expansionTilesLeft")), JS.get_property(self, "_expansionTilesTop")))
		var _switch1 = _scope4["nextExpansionSide"]
		var _switch1_start = -1
		if JS.equal(_switch1, 0, true): _switch1_start = 0
		elif JS.equal(_switch1, 1, true): _switch1_start = 1
		elif JS.equal(_switch1, 2, true): _switch1_start = 2
		elif JS.equal(_switch1, 3, true): _switch1_start = 3
		while true:
			if _switch1_start >= 0 and _switch1_start <= 0:
				JS.set_property(_scope4, "tilesRight", JS.add(_scope4["tilesRight"], 1))
				break
			if _switch1_start >= 0 and _switch1_start <= 1:
				JS.set_property(_scope4, "tilesBottom", JS.add(_scope4["tilesBottom"], 1))
				break
			if _switch1_start >= 0 and _switch1_start <= 2:
				JS.set_property(_scope4, "tilesLeft", JS.add(_scope4["tilesLeft"], 1))
				break
			if _switch1_start >= 0 and _switch1_start <= 3:
				JS.set_property(_scope4, "tilesTop", JS.add(_scope4["tilesTop"], 1))
				break
			break
	_scope4["maze"] = JS.invoke_method(JS.get_property(self, "roundModel"), "getMaze", [])
	JS.set_property(self, "tiles", JS.construct("@Array", []))
	_scope4["i"] = JS.get_property(JS.get_property(self, "_tileBounds"), "minX")
	while JS.truthy(JS.compare("<=", _scope4["i"], JS.get_property(JS.get_property(self, "_tileBounds"), "maxX"))):
		_scope4["j"] = JS.get_property(JS.get_property(self, "_tileBounds"), "minY")
		while JS.truthy(JS.compare("<=", _scope4["j"], JS.get_property(JS.get_property(self, "_tileBounds"), "maxY"))):
			if JS.truthy(JS.logical("||", func():
				var _scope5: Dictionary = {}
				return JS.logical("||", func():
					var _scope6: Dictionary = {}
					return JS.logical("||", func():
						var _scope7: Dictionary = {}
						return JS.compare("<", _scope4["i"], JS.add(JS.get_property(JS.get_property(self, "_tileBounds"), "minX"), _scope4["tilesLeft"]))
						return null, func():
						var _scope8: Dictionary = {}
						return JS.compare(">", _scope4["i"], (JS.number(JS.get_property(JS.get_property(self, "_tileBounds"), "maxX")) - JS.number(_scope4["tilesRight"])))
						return null)
					return null, func():
					var _scope9: Dictionary = {}
					return JS.compare("<", _scope4["j"], JS.add(JS.get_property(JS.get_property(self, "_tileBounds"), "minY"), _scope4["tilesTop"]))
					return null)
				return null, func():
				var _scope10: Dictionary = {}
				return JS.compare(">", _scope4["j"], JS.add(JS.get_property(JS.get_property(self, "_tileBounds"), "maxY"), -(_scope4["tilesBottom"])))
				return null)):
				_scope4["position"] = {"x": _scope4["i"], "y": _scope4["j"]}
				if JS.truthy(_scope4["maze"]):
					if JS.truthy(JS.invoke_method(_scope4["maze"], "isPositionInsideMaze", [_scope4["position"]])):
						JS.set_property(JS.get_property(self, "tiles"), JS.get_property(JS.get_property(self, "tiles"), "length"), _scope4["position"])
			JS.increment(_scope4, "j", 1, false)
		JS.increment(_scope4, "i", 1, false)
	return null

static func original_createInitialZoneState(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope11: Dictionary = {"id": _arg0, "expansionSequence": _arg1, "tileBounds": _arg2, "fields": null}
	_scope11["fields"] = {"_expansionTime": 0, "_expansionSequence": _scope11["expansionSequence"], "_tileBounds": _scope11["tileBounds"], "_expansionSide": 0, "_expansionTilesRight": 0, "_expansionTilesBottom": 0, "_expansionTilesLeft": 0, "_expansionTilesTop": 0}
	return JS.invoke_method(JS.module("Zone"), "createInitialZoneState", [_scope11["id"], JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "STORM"), [], JS.invoke_method("@JSON", "stringify", [_scope11["fields"]])])
	return null
