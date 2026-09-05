# 由原版 Maze 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var data = {"theme": 0, "tiles": [], "borders": [], "floors": [], "spaces": [], "walls": [], "wallDecorations": []}
var width = 0
var height = 0
var graph = null
var vertices = []
var dijkstra = null
var tankPositions = []
var crateSpawnPositions = []
var tankSpawnPositions = []
var reachable = []
var tileToReachableIndex = []
var tilePresentToTileIndex = []
var tileBounds = null
var distances = []
var deadEndPenalties = []
static var _static_Maze: Dictionary = {}
static var _initialized_Maze = false
static func initialize_original_static():
	if _initialized_Maze: return
	_initialized_Maze = true
	_static_Maze["log"] = JS.invoke_method(JS.module("Log"), "create", ["Maze"])
static func original_static_get(key):
	initialize_original_static()
	if _static_Maze.has(key): return _static_Maze[key]
	return null
static func original_static_set(key, value):
	_static_Maze[key] = value
	return value
func original_own_fields():
	return ["data","width","height","graph","vertices","dijkstra","tankPositions","crateSpawnPositions","tankSpawnPositions","reachable","tileToReachableIndex","tilePresentToTileIndex","tileBounds","distances","deadEndPenalties"]

func _construct_withObject(_arg0 = null):
	var _scope0: Dictionary = {"obj": _arg0, "i": null, "j": null, "tilePresent": null}
	JS.set_property(self, "data", _scope0["obj"])
	JS.set_property(self, "width", JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), "length"))
	JS.set_property(self, "height", JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), 0), "length"))
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(self, "width"))):
		_scope0["j"] = 0
		while JS.truthy(JS.compare("<", _scope0["j"], JS.get_property(self, "height"))):
			_scope0["tilePresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope0["i"]), _scope0["j"]), 0), 1, false)
			if JS.truthy(_scope0["tilePresent"]):
				JS.invoke_method(self, "_calculateReachable", [{"x": _scope0["i"], "y": _scope0["j"]}, JS.get_property(self, "width"), JS.get_property(self, "height")])
				break
			JS.increment(_scope0, "j", 1, false)
		JS.increment(_scope0, "i", 1, false)
	JS.invoke_method(self, "_calculateTileBounds", [])
	JS.invoke_method(self, "_calculateDistances", [])
	JS.invoke_method(self, "_calculateDeadEndPenalties", [])
	JS.invoke_method(self, "_createGraph", [])
	return null
static func withObject(_arg0 = null):
	var instance = load("res://game/ported/world/maze.gd").new()
	instance._construct_withObject(_arg0)
	return instance

func _construct_createRandom(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope1: Dictionary = {"width": _arg0, "height": _arg1, "playerIds": _arg2, "theme": _arg3, "wallProbability": null, "tileProbability": null, "presentTile": null, "failedToReachEnoughTiles": null, "available": null, "failedToPlaceRemainingTanks": null, "i": null, "newPosition": null}
	JS.set_property(self, "width", _scope1["width"])
	JS.set_property(self, "height", _scope1["height"])
	_scope1["wallProbability"] = JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "WALL_PROBABILITIES"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "WALL_PROBABILITIES"), "length")))]))
	_scope1["tileProbability"] = JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "TILE_PROBABILITIES"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "TILE_PROBABILITIES"), "length")))]))
	while JS.truthy(true):
		JS.set_property(self, "tankPositions", [])
		JS.set_property(JS.get_property(self, "data"), "tiles", JS.invoke_method(self, "_createRandomMaze", [JS.get_property(self, "width"), JS.get_property(self, "height"), _scope1["wallProbability"], _scope1["tileProbability"]]))
		JS.invoke_method(self, "_calculateTilePresentToTileIndex", [JS.get_property(self, "width"), JS.get_property(self, "height")])
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(self, "tilePresentToTileIndex"), "length"), 0, false)):
			continue
		_scope1["presentTile"] = JS.get_property(JS.get_property(self, "tilePresentToTileIndex"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.get_property(self, "tilePresentToTileIndex"), "length")))]))
		JS.invoke_method(JS.get_property(self, "tankPositions"), "push", [{"x": JS.get_property(_scope1["presentTile"], "x"), "y": JS.get_property(_scope1["presentTile"], "y"), "rotation": (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(2))) * JS.number(JS.get_property("@Math", "PI"))), "playerId": JS.get_property(_scope1["playerIds"], 0)}])
		JS.invoke_method(self, "_calculateReachable", [JS.get_property(JS.get_property(self, "tankPositions"), 0), JS.get_property(self, "width"), JS.get_property(self, "height")])
		_scope1["failedToReachEnoughTiles"] = false
		while JS.truthy(JS.compare("<", JS.get_property(JS.get_property(self, "reachable"), "length"), (JS.number(JS.get_property(JS.module("Constants"), "MAZE_MINIMUM_REACHABLE_RATIO")) * JS.number(JS.get_property(JS.get_property(self, "tilePresentToTileIndex"), "length"))))):
			if JS.truthy((not JS.truthy(JS.invoke_method(self, "_expandReachable", [JS.get_property(JS.get_property(self, "tankPositions"), 0), JS.get_property(self, "width"), JS.get_property(self, "height")])))):
				if JS.truthy((not JS.truthy(JS.invoke_method(self, "_expandUnreachable", [JS.get_property(JS.get_property(self, "tankPositions"), 0), JS.get_property(self, "width"), JS.get_property(self, "height")])))):
					JS.set_property(_scope1, "failedToReachEnoughTiles", true)
					break
		if JS.truthy(_scope1["failedToReachEnoughTiles"]):
			JS.invoke_method(JS.get_property(JS.module("Maze"), "log"), "error", [JS.add(JS.add(JS.add(JS.add(JS.add(JS.add(JS.add("Failed to create random maze ", _scope1["width"]), " X "), _scope1["height"]), " with probabilities "), _scope1["wallProbability"]), " and "), _scope1["tileProbability"])])
			continue
		JS.invoke_method(self, "_markTilesAsUsed", [JS.get_property(JS.get_property(self, "tankPositions"), 0), JS.get_property(JS.module("Constants"), "MAZE_MINIMUM_TILES_BETWEEN_TANKS")])
		_scope1["available"] = JS.invoke_method(self, "_getUnusedTiles", [])
		_scope1["failedToPlaceRemainingTanks"] = false
		_scope1["i"] = 1
		while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(_scope1["playerIds"], "length"))):
			if JS.truthy(JS.compare("<=", JS.get_property(_scope1["available"], "length"), 0)):
				JS.set_property(_scope1, "failedToPlaceRemainingTanks", true)
				break
			_scope1["newPosition"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(_scope1["available"], "length")))])
			JS.invoke_method(JS.get_property(self, "tankPositions"), "push", [{"x": JS.get_property(JS.get_property(_scope1["available"], _scope1["newPosition"]), "x"), "y": JS.get_property(JS.get_property(_scope1["available"], _scope1["newPosition"]), "y"), "rotation": (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(2))) * JS.number(JS.get_property("@Math", "PI"))), "playerId": JS.get_property(_scope1["playerIds"], _scope1["i"])}])
			JS.invoke_method(self, "_markTilesAsUsed", [JS.get_property(JS.get_property(self, "tankPositions"), _scope1["i"]), JS.get_property(JS.module("Constants"), "MAZE_MINIMUM_TILES_BETWEEN_TANKS")])
			JS.set_property(_scope1, "available", JS.invoke_method(self, "_getUnusedTiles", []))
			JS.increment(_scope1, "i", 1, false)
		if JS.truthy(_scope1["failedToPlaceRemainingTanks"]):
			continue
		break
	_scope1["i"] = 0
	while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(JS.get_property(self, "tankPositions"), "length"))):
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope1["i"]), "x", JS.add(JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope1["i"]), "x"), 0.5))
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope1["i"]), "y", JS.add(JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope1["i"]), "y"), 0.5))
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope1["i"]), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope1["i"]), "x")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))))
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope1["i"]), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope1["i"]), "y")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))))
		JS.increment(_scope1, "i", 1, false)
	JS.set_property(JS.get_property(self, "data"), "theme", _scope1["theme"])
	JS.invoke_method(self, "_calculateBorderFloorsSpacesWallsAndDecorations", [])
	JS.invoke_method(self, "_calculateTileBounds", [])
	JS.invoke_method(self, "_calculateDistances", [])
	JS.invoke_method(self, "_calculateDeadEndPenalties", [])
	JS.invoke_method(self, "_createGraph", [])
	return null
static func createRandom(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var instance = load("res://game/ported/world/maze.gd").new()
	instance._construct_createRandom(_arg0, _arg1, _arg2, _arg3)
	return instance

func _construct_createSymmetric(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope2: Dictionary = {"width": _arg0, "height": _arg1, "playerIds": _arg2, "theme": _arg3, "wallProbability": null, "tileProbability": null, "blockWidth": null, "blockHeight": null, "presentTile": null, "failedToReachEnoughTiles": null, "openToTheRight": null, "j": null, "openToTheBottom": null, "i": null, "newPosition": null, "widthEven": null, "heightEven": null, "tankPosition": null, "swap": null, "otherIndex": null}
	JS.set_property(self, "width", _scope2["width"])
	JS.set_property(self, "height", _scope2["height"])
	_scope2["wallProbability"] = JS.invoke_method("@Math", "sqrt", [JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "WALL_PROBABILITIES"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "WALL_PROBABILITIES"), "length")))]))])
	_scope2["tileProbability"] = JS.invoke_method("@Math", "sqrt", [JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "TILE_PROBABILITIES"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE"), "TILE_PROBABILITIES"), "length")))]))])
	_scope2["blockWidth"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(self, "width")) / JS.number(2))])
	_scope2["blockHeight"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(self, "height")) / JS.number(2))])
	while JS.truthy(true):
		JS.set_property(self, "tankPositions", [])
		JS.set_property(JS.get_property(self, "data"), "tiles", JS.invoke_method(self, "_createRandomMaze", [_scope2["blockWidth"], _scope2["blockHeight"], _scope2["wallProbability"], _scope2["tileProbability"]]))
		JS.invoke_method(self, "_calculateTilePresentToTileIndex", [_scope2["blockWidth"], _scope2["blockHeight"]])
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(self, "tilePresentToTileIndex"), "length"), 0, false)):
			continue
		_scope2["presentTile"] = JS.get_property(JS.get_property(self, "tilePresentToTileIndex"), 0)
		JS.invoke_method(JS.get_property(self, "tankPositions"), "push", [{"x": JS.get_property(_scope2["presentTile"], "x"), "y": JS.get_property(_scope2["presentTile"], "y"), "rotation": (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(2))) * JS.number(JS.get_property("@Math", "PI"))), "playerId": JS.get_property(_scope2["playerIds"], 0)}])
		JS.invoke_method(self, "_calculateReachable", [JS.get_property(JS.get_property(self, "tankPositions"), 0), _scope2["blockWidth"], _scope2["blockHeight"]])
		_scope2["failedToReachEnoughTiles"] = false
		while JS.truthy(JS.compare("<", JS.get_property(JS.get_property(self, "reachable"), "length"), (JS.number(JS.get_property(JS.module("Constants"), "MAZE_MINIMUM_REACHABLE_RATIO")) * JS.number(JS.get_property(JS.get_property(self, "tilePresentToTileIndex"), "length"))))):
			if JS.truthy((not JS.truthy(JS.invoke_method(self, "_expandReachable", [JS.get_property(JS.get_property(self, "tankPositions"), 0), _scope2["blockWidth"], _scope2["blockHeight"]])))):
				if JS.truthy((not JS.truthy(JS.invoke_method(self, "_expandUnreachable", [JS.get_property(JS.get_property(self, "tankPositions"), 0), _scope2["blockWidth"], _scope2["blockHeight"]])))):
					JS.set_property(_scope2, "failedToReachEnoughTiles", true)
					break
		if JS.truthy(_scope2["failedToReachEnoughTiles"]):
			JS.invoke_method(JS.get_property(JS.module("Maze"), "log"), "error", [JS.add(JS.add(JS.add(JS.add(JS.add(JS.add(JS.add("Failed to create symmetric maze ", _scope2["width"]), " X "), _scope2["height"]), " with probabilities "), _scope2["wallProbability"]), " and "), _scope2["tileProbability"])])
			continue
		_scope2["openToTheRight"] = false
		_scope2["j"] = 0
		while JS.truthy(JS.compare("<", _scope2["j"], _scope2["blockHeight"])):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), (JS.number(_scope2["blockWidth"]) - JS.number(1))), _scope2["j"]), 0), 1, false)):
				JS.set_property(_scope2, "openToTheRight", true)
				break
			JS.increment(_scope2, "j", 1, false)
		_scope2["openToTheBottom"] = false
		_scope2["i"] = 0
		while JS.truthy(JS.compare("<", _scope2["i"], _scope2["blockWidth"])):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope2["i"]), (JS.number(_scope2["blockHeight"]) - JS.number(1))), 0), 1, false)):
				JS.set_property(_scope2, "openToTheBottom", true)
				break
			JS.increment(_scope2, "i", 1, false)
		if JS.truthy(JS.logical("||", func():
			var _scope3: Dictionary = {}
			return (not JS.truthy(_scope2["openToTheRight"]))
			return null, func():
			var _scope4: Dictionary = {}
			return (not JS.truthy(_scope2["openToTheBottom"]))
			return null)):
			continue
		JS.set_property(JS.get_property(self, "data"), "tiles", JS.invoke_method(self, "_createSymmetricMaze", [JS.get_property(JS.get_property(self, "data"), "tiles"), _scope2["blockWidth"], _scope2["blockHeight"], JS.get_property(self, "width"), JS.get_property(self, "height"), _scope2["wallProbability"]]))
		_scope2["i"] = 1
		while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(_scope2["playerIds"], "length"))):
			_scope2["newPosition"] = {"x": JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), 0), "x"), "y": JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), 0), "y"), "rotation": JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), 0), "rotation"), "playerId": JS.get_property(_scope2["playerIds"], _scope2["i"])}
			if JS.truthy(JS.logical("&&", func():
				var _scope5: Dictionary = {}
				return JS.compare(">=", _scope2["i"], 1)
				return null, func():
				var _scope6: Dictionary = {}
				return JS.compare("<=", _scope2["i"], 2)
				return null)):
				JS.set_property(_scope2["newPosition"], "x", (JS.number((JS.number(JS.get_property(self, "width")) - JS.number(1))) - JS.number(JS.get_property(_scope2["newPosition"], "x"))))
				JS.set_property(_scope2["newPosition"], "rotation", -(JS.get_property(_scope2["newPosition"], "rotation")))
			if JS.truthy(fmod(_scope2["i"], 2)):
				JS.set_property(_scope2["newPosition"], "y", (JS.number((JS.number(JS.get_property(self, "height")) - JS.number(1))) - JS.number(JS.get_property(_scope2["newPosition"], "y"))))
				JS.set_property(_scope2["newPosition"], "rotation", (JS.number(JS.get_property("@Math", "PI")) - JS.number(JS.get_property(_scope2["newPosition"], "rotation"))))
			JS.invoke_method(JS.get_property(self, "tankPositions"), "push", [_scope2["newPosition"]])
			JS.increment(_scope2, "i", 1, false)
		break
	JS.invoke_method(self, "_calculateReachable", [JS.get_property(JS.get_property(self, "tankPositions"), 0), JS.get_property(self, "width"), JS.get_property(self, "height")])
	if JS.truthy(not JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), _scope2["blockWidth"]), _scope2["blockHeight"]), null, true)):
		JS.invoke_method(JS.get_property(self, "crateSpawnPositions"), "push", [{"x": _scope2["blockWidth"], "y": _scope2["blockHeight"]}])
	_scope2["widthEven"] = JS.equal(fmod(JS.get_property(self, "width"), 2), 0, false)
	_scope2["heightEven"] = JS.equal(fmod(JS.get_property(self, "height"), 2), 0, false)
	if JS.truthy(JS.logical("||", func():
		var _scope7: Dictionary = {}
		return _scope2["widthEven"]
		return null, func():
		var _scope8: Dictionary = {}
		return _scope2["heightEven"]
		return null)):
		if JS.truthy(_scope2["widthEven"]):
			if JS.truthy(not JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), (JS.number((JS.number(_scope2["width"]) - JS.number(1))) - JS.number(_scope2["blockWidth"]))), _scope2["blockHeight"]), null, true)):
				JS.invoke_method(JS.get_property(self, "crateSpawnPositions"), "push", [{"x": (JS.number((JS.number(_scope2["width"]) - JS.number(1))) - JS.number(_scope2["blockWidth"])), "y": _scope2["blockHeight"]}])
		if JS.truthy(_scope2["heightEven"]):
			if JS.truthy(not JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), _scope2["blockWidth"]), (JS.number((JS.number(_scope2["height"]) - JS.number(1))) - JS.number(_scope2["blockHeight"]))), null, true)):
				JS.invoke_method(JS.get_property(self, "crateSpawnPositions"), "push", [{"x": _scope2["blockWidth"], "y": (JS.number((JS.number(_scope2["height"]) - JS.number(1))) - JS.number(_scope2["blockHeight"]))}])
		if JS.truthy(JS.logical("&&", func():
			var _scope9: Dictionary = {}
			return _scope2["widthEven"]
			return null, func():
			var _scope10: Dictionary = {}
			return _scope2["heightEven"]
			return null)):
			if JS.truthy(not JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), (JS.number((JS.number(_scope2["width"]) - JS.number(1))) - JS.number(_scope2["blockWidth"]))), (JS.number((JS.number(_scope2["height"]) - JS.number(1))) - JS.number(_scope2["blockHeight"]))), null, true)):
				JS.invoke_method(JS.get_property(self, "crateSpawnPositions"), "push", [{"x": (JS.number((JS.number(_scope2["width"]) - JS.number(1))) - JS.number(_scope2["blockWidth"])), "y": (JS.number((JS.number(_scope2["height"]) - JS.number(1))) - JS.number(_scope2["blockHeight"]))}])
	else:
		pass
	_scope2["tankPosition"] = JS.get_property(JS.get_property(self, "tankPositions"), 0)
	JS.invoke_method(JS.get_property(self, "tankSpawnPositions"), "push", [{"x": JS.get_property(_scope2["tankPosition"], "x"), "y": JS.get_property(_scope2["tankPosition"], "y")}])
	JS.invoke_method(JS.get_property(self, "tankSpawnPositions"), "push", [{"x": (JS.number((JS.number(_scope2["width"]) - JS.number(1))) - JS.number(JS.get_property(_scope2["tankPosition"], "x"))), "y": JS.get_property(_scope2["tankPosition"], "y")}])
	JS.invoke_method(JS.get_property(self, "tankSpawnPositions"), "push", [{"x": JS.get_property(_scope2["tankPosition"], "x"), "y": (JS.number((JS.number(_scope2["height"]) - JS.number(1))) - JS.number(JS.get_property(_scope2["tankPosition"], "y")))}])
	JS.invoke_method(JS.get_property(self, "tankSpawnPositions"), "push", [{"x": (JS.number((JS.number(_scope2["width"]) - JS.number(1))) - JS.number(JS.get_property(_scope2["tankPosition"], "x"))), "y": (JS.number((JS.number(_scope2["height"]) - JS.number(1))) - JS.number(JS.get_property(_scope2["tankPosition"], "y")))}])
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(self, "tankPositions"), "length"))):
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "x", JS.add(JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "x"), 0.5))
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "y", JS.add(JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "y"), 0.5))
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "x")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))))
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "y")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))))
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], (JS.number(JS.get_property(JS.get_property(self, "tankPositions"), "length")) - JS.number(1)))):
		_scope2["swap"] = JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "playerId")
		_scope2["otherIndex"] = JS.invoke_method("@Math", "floor", [JS.invoke_method(JS.module("MathUtils"), "randomRange", [_scope2["i"], JS.get_property(JS.get_property(self, "tankPositions"), "length")])])
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["i"]), "playerId", JS.get_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["otherIndex"]), "playerId"))
		JS.set_property(JS.get_property(JS.get_property(self, "tankPositions"), _scope2["otherIndex"]), "playerId", _scope2["swap"])
		JS.increment(_scope2, "i", 1, false)
	JS.set_property(JS.get_property(self, "data"), "theme", _scope2["theme"])
	JS.invoke_method(self, "_calculateBorderFloorsSpacesWallsAndDecorations", [])
	JS.invoke_method(self, "_calculateTileBounds", [])
	JS.invoke_method(self, "_calculateDistances", [])
	JS.invoke_method(self, "_calculateDeadEndPenalties", [])
	JS.invoke_method(self, "_createGraph", [])
	return null
static func createSymmetric(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var instance = load("res://game/ported/world/maze.gd").new()
	instance._construct_createSymmetric(_arg0, _arg1, _arg2, _arg3)
	return instance

func original_toObj():
	var _scope11: Dictionary = {}
	return JS.get_property(self, "data")
	return null

func original__createRandomMaze(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope12: Dictionary = {"width": _arg0, "height": _arg1, "wallProbability": _arg2, "tileProbability": _arg3, "walls": null, "i": null, "j": null, "tiles": null, "tilePresent": null, "topWall": null, "leftWall": null}
	_scope12["walls"] = JS.construct("@Array", [JS.add(_scope12["width"], 1)])
	_scope12["i"] = 0
	while JS.truthy(JS.compare("<", _scope12["i"], JS.get_property(_scope12["walls"], "length"))):
		JS.set_property(_scope12["walls"], _scope12["i"], JS.construct("@Array", [JS.add(_scope12["height"], 1)]))
		_scope12["j"] = 0
		while JS.truthy(JS.compare("<", _scope12["j"], JS.add(_scope12["height"], 1))):
			JS.set_property(JS.get_property(_scope12["walls"], _scope12["i"]), _scope12["j"], (4 if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), _scope12["wallProbability"])) else JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(4))])))
			JS.increment(_scope12, "j", 1, false)
		JS.increment(_scope12, "i", 1, false)
	_scope12["tiles"] = JS.construct("@Array", [_scope12["width"]])
	_scope12["i"] = 0
	while JS.truthy(JS.compare("<", _scope12["i"], JS.get_property(_scope12["tiles"], "length"))):
		JS.set_property(_scope12["tiles"], _scope12["i"], JS.construct("@Array", [_scope12["height"]]))
		_scope12["j"] = 0
		while JS.truthy(JS.compare("<", _scope12["j"], _scope12["height"])):
			JS.set_property(JS.get_property(_scope12["tiles"], _scope12["i"]), _scope12["j"], JS.construct("@Array", [(0 if JS.truthy(JS.compare(">", JS.invoke_method("@Math", "random", []), _scope12["tileProbability"])) else 1), 0, 0]))
			JS.increment(_scope12, "j", 1, false)
		JS.increment(_scope12, "i", 1, false)
	_scope12["i"] = 0
	while JS.truthy(JS.compare("<", _scope12["i"], _scope12["width"])):
		_scope12["j"] = 0
		while JS.truthy(JS.compare("<", _scope12["j"], _scope12["height"])):
			_scope12["tilePresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope12["tiles"], _scope12["i"]), _scope12["j"]), 0), 1, false)
			_scope12["topWall"] = false
			_scope12["leftWall"] = false
			if JS.truthy(_scope12["tilePresent"]):
				JS.set_property(_scope12, "topWall", JS.logical("||", func():
					var _scope13: Dictionary = {}
					return JS.logical("||", func():
						var _scope14: Dictionary = {}
						return JS.logical("||", func():
							var _scope15: Dictionary = {}
							return JS.equal(JS.get_property(JS.get_property(_scope12["walls"], _scope12["i"]), _scope12["j"]), 0, false)
							return null, func():
							var _scope16: Dictionary = {}
							return JS.logical("&&", func():
								var _scope17: Dictionary = {}
								return JS.compare("<", JS.add(_scope12["i"], 1), JS.get_property(_scope12["walls"], "length"))
								return null, func():
								var _scope18: Dictionary = {}
								return JS.equal(JS.get_property(JS.get_property(_scope12["walls"], JS.add(_scope12["i"], 1)), _scope12["j"]), 2, false)
								return null)
							return null)
						return null, func():
						var _scope19: Dictionary = {}
						return JS.equal(_scope12["j"], 0, false)
						return null)
					return null, func():
					var _scope20: Dictionary = {}
					return JS.logical("&&", func():
						var _scope21: Dictionary = {}
						return JS.compare(">", _scope12["j"], 0)
						return null, func():
						var _scope22: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope12["tiles"], _scope12["i"]), (JS.number(_scope12["j"]) - JS.number(1))), 0), 0, false)
						return null)
					return null))
				JS.set_property(_scope12, "leftWall", JS.logical("||", func():
					var _scope23: Dictionary = {}
					return JS.logical("||", func():
						var _scope24: Dictionary = {}
						return JS.logical("||", func():
							var _scope25: Dictionary = {}
							return JS.equal(JS.get_property(JS.get_property(_scope12["walls"], _scope12["i"]), _scope12["j"]), 1, false)
							return null, func():
							var _scope26: Dictionary = {}
							return JS.logical("&&", func():
								var _scope27: Dictionary = {}
								return JS.compare("<", JS.add(_scope12["j"], 1), JS.get_property(JS.get_property(_scope12["walls"], _scope12["i"]), "length"))
								return null, func():
								var _scope28: Dictionary = {}
								return JS.equal(JS.get_property(JS.get_property(_scope12["walls"], _scope12["i"]), JS.add(_scope12["j"], 1)), 3, false)
								return null)
							return null)
						return null, func():
						var _scope29: Dictionary = {}
						return JS.equal(_scope12["i"], 0, false)
						return null)
					return null, func():
					var _scope30: Dictionary = {}
					return JS.logical("&&", func():
						var _scope31: Dictionary = {}
						return JS.compare(">", _scope12["i"], 0)
						return null, func():
						var _scope32: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope12["tiles"], (JS.number(_scope12["i"]) - JS.number(1))), _scope12["j"]), 0), 0, false)
						return null)
					return null))
			else:
				JS.set_property(_scope12, "topWall", JS.logical("&&", func():
					var _scope33: Dictionary = {}
					return JS.compare(">", _scope12["j"], 0)
					return null, func():
					var _scope34: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope12["tiles"], _scope12["i"]), (JS.number(_scope12["j"]) - JS.number(1))), 0), 1, false)
					return null))
				JS.set_property(_scope12, "leftWall", JS.logical("&&", func():
					var _scope35: Dictionary = {}
					return JS.compare(">", _scope12["i"], 0)
					return null, func():
					var _scope36: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope12["tiles"], (JS.number(_scope12["i"]) - JS.number(1))), _scope12["j"]), 0), 1, false)
					return null))
			JS.set_property(JS.get_property(JS.get_property(_scope12["tiles"], _scope12["i"]), _scope12["j"]), 1, (1 if JS.truthy(_scope12["topWall"]) else 0))
			JS.set_property(JS.get_property(JS.get_property(_scope12["tiles"], _scope12["i"]), _scope12["j"]), 2, (1 if JS.truthy(_scope12["leftWall"]) else 0))
			JS.increment(_scope12, "j", 1, false)
		JS.increment(_scope12, "i", 1, false)
	return _scope12["tiles"]
	return null

func original__createSymmetricMaze(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope37: Dictionary = {"blockTiles": _arg0, "blockWidth": _arg1, "blockHeight": _arg2, "width": _arg3, "height": _arg4, "wallProbability": _arg5, "addVerticalConnector": null, "addHorizontalConnector": null, "tiles": null, "i": null, "j": null, "potentialConnections": null, "amountToCloseOff": null, "verticalNeighbourTilesPresent": null, "neighbourTopWallPresent": null, "placeTile": null, "firstConnectorTile": null, "oppositeOfPreviousConnectorTile": null, "placeRandomWall": null, "horizontalNeighbourTilesPresent": null, "neighbourLeftWallPresent": null}
	_scope37["addVerticalConnector"] = fmod(_scope37["width"], 2)
	_scope37["addHorizontalConnector"] = fmod(_scope37["height"], 2)
	_scope37["tiles"] = JS.construct("@Array", [_scope37["width"]])
	_scope37["i"] = 0
	while JS.truthy(JS.compare("<", _scope37["i"], JS.get_property(_scope37["tiles"], "length"))):
		JS.set_property(_scope37["tiles"], _scope37["i"], JS.construct("@Array", [_scope37["height"]]))
		JS.increment(_scope37, "i", 1, false)
	_scope37["i"] = 0
	while JS.truthy(JS.compare("<", _scope37["i"], _scope37["blockWidth"])):
		_scope37["j"] = 0
		while JS.truthy(JS.compare("<", _scope37["j"], _scope37["blockHeight"])):
			JS.set_property(JS.get_property(_scope37["tiles"], _scope37["i"]), _scope37["j"], JS.get_property(JS.get_property(_scope37["blockTiles"], _scope37["i"]), _scope37["j"]))
			JS.increment(_scope37, "j", 1, false)
		JS.increment(_scope37, "i", 1, false)
	_scope37["i"] = 0
	while JS.truthy(JS.compare("<", _scope37["i"], _scope37["blockWidth"])):
		_scope37["j"] = 0
		while JS.truthy(JS.compare("<", _scope37["j"], (JS.number(_scope37["blockHeight"]) - JS.number(1)))):
			JS.set_property(JS.get_property(_scope37["tiles"], _scope37["i"]), (JS.number((JS.number(_scope37["height"]) - JS.number(1))) - JS.number(_scope37["j"])), JS.construct("@Array", [JS.get_property(JS.get_property(JS.get_property(_scope37["blockTiles"], _scope37["i"]), _scope37["j"]), 0), JS.get_property(JS.get_property(JS.get_property(_scope37["blockTiles"], _scope37["i"]), JS.add(_scope37["j"], 1)), 1), JS.get_property(JS.get_property(JS.get_property(_scope37["blockTiles"], _scope37["i"]), _scope37["j"]), 2)]))
			JS.increment(_scope37, "j", 1, false)
		JS.increment(_scope37, "i", 1, false)
	_scope37["i"] = 0
	while JS.truthy(JS.compare("<", _scope37["i"], _scope37["blockWidth"])):
		JS.set_property(JS.get_property(_scope37["tiles"], _scope37["i"]), (JS.number(_scope37["height"]) - JS.number(_scope37["blockHeight"])), JS.construct("@Array", [JS.get_property(JS.get_property(JS.get_property(_scope37["blockTiles"], _scope37["i"]), (JS.number(_scope37["blockHeight"]) - JS.number(1))), 0), 0, JS.get_property(JS.get_property(JS.get_property(_scope37["blockTiles"], _scope37["i"]), (JS.number(_scope37["blockHeight"]) - JS.number(1))), 2)]))
		JS.increment(_scope37, "i", 1, false)
	_scope37["potentialConnections"] = []
	_scope37["i"] = 0
	while JS.truthy(JS.compare("<", _scope37["i"], _scope37["blockWidth"])):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["i"]), (JS.number(_scope37["blockHeight"]) - JS.number(1))), 0), 1, false)):
			JS.invoke_method(_scope37["potentialConnections"], "push", [_scope37["i"]])
		JS.increment(_scope37, "i", 1, false)
	if JS.truthy(JS.compare(">=", JS.get_property(_scope37["potentialConnections"], "length"), 2)):
		JS.set_property(JS.get_property(JS.get_property(_scope37["tiles"], JS.get_property(_scope37["potentialConnections"], 0)), (JS.number(_scope37["height"]) - JS.number(_scope37["blockHeight"]))), 1, 1)
		JS.invoke_method(_scope37["potentialConnections"], "shift", [])
	JS.invoke_method(JS.module("ArrayUtils"), "shuffle", [_scope37["potentialConnections"]])
	_scope37["amountToCloseOff"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(_scope37["potentialConnections"], "length")))])
	_scope37["i"] = 0
	while JS.truthy(JS.compare("<", _scope37["i"], _scope37["amountToCloseOff"])):
		JS.set_property(JS.get_property(JS.get_property(_scope37["tiles"], JS.get_property(_scope37["potentialConnections"], _scope37["i"])), (JS.number(_scope37["height"]) - JS.number(_scope37["blockHeight"]))), 1, 1)
		JS.increment(_scope37, "i", 1, false)
	if JS.truthy(_scope37["addHorizontalConnector"]):
		_scope37["i"] = 0
		while JS.truthy(JS.compare("<", _scope37["i"], _scope37["blockWidth"])):
			_scope37["verticalNeighbourTilesPresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["i"]), (JS.number(_scope37["height"]) - JS.number(_scope37["blockHeight"]))), 0), 1, false)
			_scope37["neighbourTopWallPresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["i"]), (JS.number(_scope37["height"]) - JS.number(_scope37["blockHeight"]))), 1), 1, false)
			_scope37["placeTile"] = JS.logical("&&", func():
				var _scope38: Dictionary = {}
				return _scope37["verticalNeighbourTilesPresent"]
				return null, func():
				var _scope39: Dictionary = {}
				return (not JS.truthy(_scope37["neighbourTopWallPresent"]))
				return null)
			_scope37["firstConnectorTile"] = JS.logical("&&", func():
				var _scope40: Dictionary = {}
				return JS.equal(_scope37["i"], 0, false)
				return null, func():
				var _scope41: Dictionary = {}
				return _scope37["placeTile"]
				return null)
			_scope37["oppositeOfPreviousConnectorTile"] = JS.logical("&&", func():
				var _scope42: Dictionary = {}
				return JS.compare(">", _scope37["i"], 0)
				return null, func():
				var _scope43: Dictionary = {}
				return JS.logical("||", func():
					var _scope44: Dictionary = {}
					return JS.logical("&&", func():
						var _scope45: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["i"]) - JS.number(1))), _scope37["blockHeight"]), 0), 0, false)
						return null, func():
						var _scope46: Dictionary = {}
						return _scope37["placeTile"]
						return null)
					return null, func():
					var _scope47: Dictionary = {}
					return JS.logical("&&", func():
						var _scope48: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["i"]) - JS.number(1))), _scope37["blockHeight"]), 0), 1, false)
						return null, func():
						var _scope49: Dictionary = {}
						return (not JS.truthy(_scope37["placeTile"]))
						return null)
					return null)
				return null)
			_scope37["placeRandomWall"] = JS.logical("&&", func():
				var _scope50: Dictionary = {}
				return _scope37["placeTile"]
				return null, func():
				var _scope51: Dictionary = {}
				return JS.compare("<=", JS.invoke_method("@Math", "random", []), _scope37["wallProbability"])
				return null)
			JS.set_property(JS.get_property(_scope37["tiles"], _scope37["i"]), _scope37["blockHeight"], JS.construct("@Array", [(1 if JS.truthy(_scope37["placeTile"]) else 0), (1 if JS.truthy(JS.logical("&&", func():
				var _scope52: Dictionary = {}
				return _scope37["verticalNeighbourTilesPresent"]
				return null, func():
				var _scope53: Dictionary = {}
				return _scope37["neighbourTopWallPresent"]
				return null)) else 0), (1 if JS.truthy(JS.logical("||", func():
				var _scope54: Dictionary = {}
				return JS.logical("||", func():
					var _scope55: Dictionary = {}
					return _scope37["firstConnectorTile"]
					return null, func():
					var _scope56: Dictionary = {}
					return _scope37["oppositeOfPreviousConnectorTile"]
					return null)
				return null, func():
				var _scope57: Dictionary = {}
				return _scope37["placeRandomWall"]
				return null)) else 0)]))
			JS.increment(_scope37, "i", 1, false)
	_scope37["i"] = 0
	while JS.truthy(JS.compare("<", _scope37["i"], (JS.number(_scope37["blockWidth"]) - JS.number(1)))):
		_scope37["j"] = 0
		while JS.truthy(JS.compare("<", _scope37["j"], _scope37["height"])):
			JS.set_property(JS.get_property(_scope37["tiles"], (JS.number((JS.number(_scope37["width"]) - JS.number(1))) - JS.number(_scope37["i"]))), _scope37["j"], JS.construct("@Array", [JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["i"]), _scope37["j"]), 0), JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["i"]), _scope37["j"]), 1), JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], JS.add(_scope37["i"], 1)), _scope37["j"]), 2)]))
			JS.increment(_scope37, "j", 1, false)
		JS.increment(_scope37, "i", 1, false)
	_scope37["j"] = 0
	while JS.truthy(JS.compare("<", _scope37["j"], _scope37["height"])):
		JS.set_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["width"]) - JS.number(_scope37["blockWidth"]))), _scope37["j"], JS.construct("@Array", [JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["blockWidth"]) - JS.number(1))), _scope37["j"]), 0), JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["blockWidth"]) - JS.number(1))), _scope37["j"]), 1), 0]))
		JS.increment(_scope37, "j", 1, false)
	_scope37["potentialConnections"] = []
	_scope37["j"] = 0
	while JS.truthy(JS.compare("<", _scope37["j"], JS.add(_scope37["blockHeight"], (1 if JS.truthy(_scope37["addHorizontalConnector"]) else 0)))):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["blockWidth"]) - JS.number(1))), _scope37["j"]), 0), 1, false)):
			JS.invoke_method(_scope37["potentialConnections"], "push", [_scope37["j"]])
		JS.increment(_scope37, "j", 1, false)
	if JS.truthy(JS.compare(">=", JS.get_property(_scope37["potentialConnections"], "length"), 2)):
		JS.set_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["width"]) - JS.number(_scope37["blockWidth"]))), JS.get_property(_scope37["potentialConnections"], 0)), 2, 1)
		JS.set_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["width"]) - JS.number(_scope37["blockWidth"]))), (JS.number((JS.number(_scope37["height"]) - JS.number(1))) - JS.number(JS.get_property(_scope37["potentialConnections"], 0)))), 2, 1)
		JS.invoke_method(_scope37["potentialConnections"], "shift", [])
	JS.invoke_method(JS.module("ArrayUtils"), "shuffle", [_scope37["potentialConnections"]])
	_scope37["amountToCloseOff"] = JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(_scope37["potentialConnections"], "length")))])
	_scope37["i"] = 0
	while JS.truthy(JS.compare("<", _scope37["i"], _scope37["amountToCloseOff"])):
		JS.set_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["width"]) - JS.number(_scope37["blockWidth"]))), JS.get_property(_scope37["potentialConnections"], _scope37["i"])), 2, 1)
		JS.set_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["width"]) - JS.number(_scope37["blockWidth"]))), (JS.number((JS.number(_scope37["height"]) - JS.number(1))) - JS.number(JS.get_property(_scope37["potentialConnections"], _scope37["i"])))), 2, 1)
		JS.increment(_scope37, "i", 1, false)
	if JS.truthy(_scope37["addVerticalConnector"]):
		_scope37["j"] = 0
		while JS.truthy(JS.compare("<", _scope37["j"], _scope37["height"])):
			_scope37["horizontalNeighbourTilesPresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["width"]) - JS.number(_scope37["blockWidth"]))), _scope37["j"]), 0), 1, false)
			_scope37["neighbourLeftWallPresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["width"]) - JS.number(_scope37["blockWidth"]))), _scope37["j"]), 2), 1, false)
			_scope37["placeTile"] = JS.logical("&&", func():
				var _scope58: Dictionary = {}
				return _scope37["horizontalNeighbourTilesPresent"]
				return null, func():
				var _scope59: Dictionary = {}
				return (not JS.truthy(_scope37["neighbourLeftWallPresent"]))
				return null)
			_scope37["firstConnectorTile"] = JS.logical("&&", func():
				var _scope60: Dictionary = {}
				return JS.equal(_scope37["j"], 0, false)
				return null, func():
				var _scope61: Dictionary = {}
				return _scope37["placeTile"]
				return null)
			_scope37["oppositeOfPreviousConnectorTile"] = JS.logical("&&", func():
				var _scope62: Dictionary = {}
				return JS.compare(">", _scope37["j"], 0)
				return null, func():
				var _scope63: Dictionary = {}
				return JS.logical("||", func():
					var _scope64: Dictionary = {}
					return JS.logical("&&", func():
						var _scope65: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["blockWidth"]), (JS.number(_scope37["j"]) - JS.number(1))), 0), 0, false)
						return null, func():
						var _scope66: Dictionary = {}
						return _scope37["placeTile"]
						return null)
					return null, func():
					var _scope67: Dictionary = {}
					return JS.logical("&&", func():
						var _scope68: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["blockWidth"]), (JS.number(_scope37["j"]) - JS.number(1))), 0), 1, false)
						return null, func():
						var _scope69: Dictionary = {}
						return (not JS.truthy(_scope37["placeTile"]))
						return null)
					return null)
				return null)
			JS.set_property(JS.get_property(_scope37["tiles"], _scope37["blockWidth"]), _scope37["j"], JS.construct("@Array", [(1 if JS.truthy(_scope37["placeTile"]) else 0), (1 if JS.truthy(JS.logical("||", func():
				var _scope70: Dictionary = {}
				return _scope37["firstConnectorTile"]
				return null, func():
				var _scope71: Dictionary = {}
				return _scope37["oppositeOfPreviousConnectorTile"]
				return null)) else 0), (1 if JS.truthy(JS.logical("&&", func():
				var _scope72: Dictionary = {}
				return _scope37["horizontalNeighbourTilesPresent"]
				return null, func():
				var _scope73: Dictionary = {}
				return _scope37["neighbourLeftWallPresent"]
				return null)) else 0)]))
			JS.increment(_scope37, "j", 1, false)
		_scope37["j"] = 1
		while JS.truthy(JS.compare("<=", _scope37["j"], _scope37["blockHeight"])):
			_scope37["horizontalNeighbourTilesPresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["width"]) - JS.number(_scope37["blockWidth"]))), _scope37["j"]), 0), 1, false)
			_scope37["neighbourLeftWallPresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], (JS.number(_scope37["width"]) - JS.number(_scope37["blockWidth"]))), _scope37["j"]), 2), 1, false)
			_scope37["placeTile"] = JS.logical("&&", func():
				var _scope74: Dictionary = {}
				return _scope37["horizontalNeighbourTilesPresent"]
				return null, func():
				var _scope75: Dictionary = {}
				return (not JS.truthy(_scope37["neighbourLeftWallPresent"]))
				return null)
			_scope37["placeRandomWall"] = JS.logical("&&", func():
				var _scope76: Dictionary = {}
				return _scope37["placeTile"]
				return null, func():
				var _scope77: Dictionary = {}
				return JS.compare("<=", JS.invoke_method("@Math", "random", []), _scope37["wallProbability"])
				return null)
			JS.set_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["blockWidth"]), _scope37["j"]), 1, (1 if JS.truthy(JS.logical("||", func():
				var _scope78: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["blockWidth"]), _scope37["j"]), 1), 1, false)
				return null, func():
				var _scope79: Dictionary = {}
				return _scope37["placeRandomWall"]
				return null)) else 0))
			JS.set_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["blockWidth"]), (JS.number(_scope37["height"]) - JS.number(_scope37["j"]))), 1, (1 if JS.truthy(JS.logical("||", func():
				var _scope80: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope37["tiles"], _scope37["blockWidth"]), (JS.number(_scope37["height"]) - JS.number(_scope37["j"]))), 1), 1, false)
				return null, func():
				var _scope81: Dictionary = {}
				return _scope37["placeRandomWall"]
				return null)) else 0))
			JS.increment(_scope37, "j", 1, false)
	return _scope37["tiles"]
	return null

func original__createGraph():
	var _scope82: Dictionary = {"i": null, "j": null, "self": null}
	JS.set_property(self, "graph", JS.construct(JS.get_property(JS.module("jKstra"), "Graph"), []))
	JS.set_property(self, "vertices", JS.construct("@Array", [JS.get_property(self, "width")]))
	_scope82["i"] = 0
	while JS.truthy(JS.compare("<", _scope82["i"], JS.get_property(self, "width"))):
		JS.set_property(JS.get_property(self, "vertices"), _scope82["i"], JS.construct("@Array", [JS.get_property(self, "height")]))
		JS.increment(_scope82, "i", 1, false)
	_scope82["i"] = 0
	while JS.truthy(JS.compare("<", _scope82["i"], JS.get_property(self, "width"))):
		_scope82["j"] = 0
		while JS.truthy(JS.compare("<", _scope82["j"], JS.get_property(self, "height"))):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope82["i"]), _scope82["j"]), 0), 1, false)):
				JS.set_property(JS.get_property(JS.get_property(self, "vertices"), _scope82["i"]), _scope82["j"], JS.invoke_method(JS.get_property(self, "graph"), "addVertex", [{"x": _scope82["i"], "y": _scope82["j"]}]))
			JS.increment(_scope82, "j", 1, false)
		JS.increment(_scope82, "i", 1, false)
	_scope82["self"] = self
	JS.invoke_method(JS.get_property(self, "graph"), "forEachVertex", [func(_arg0 = null):
		var _scope83: Dictionary = {"v": _arg0, "current": null}
		_scope83["current"] = JS.get_property(_scope83["v"], "data")
		if JS.truthy(JS.logical("&&", func():
			var _scope84: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope83["current"], "x"), 0)
			return null, func():
			var _scope85: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.get_property(_scope83["current"], "y")), 2), 0, false)
			return null)):
			JS.invoke_method(JS.get_property(_scope82["self"], "graph"), "addEdge", [_scope83["v"], JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "vertices"), (JS.number(JS.get_property(_scope83["current"], "x")) - JS.number(1))), JS.get_property(_scope83["current"], "y")), {"x": (JS.number(JS.get_property(_scope83["current"], "x")) - JS.number(1)), "y": JS.get_property(_scope83["current"], "y"), "length": 1}])
		if JS.truthy(JS.logical("&&", func():
			var _scope86: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope83["current"], "x"), (JS.number(JS.get_property(_scope82["self"], "width")) - JS.number(1)))
			return null, func():
			var _scope87: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), JS.get_property(_scope83["current"], "y")), 2), 0, false)
			return null)):
			JS.invoke_method(JS.get_property(_scope82["self"], "graph"), "addEdge", [_scope83["v"], JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "vertices"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), JS.get_property(_scope83["current"], "y")), {"x": JS.add(JS.get_property(_scope83["current"], "x"), 1), "y": JS.get_property(_scope83["current"], "y"), "length": 1}])
		if JS.truthy(JS.logical("&&", func():
			var _scope88: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope83["current"], "y"), (JS.number(JS.get_property(_scope82["self"], "height")) - JS.number(1)))
			return null, func():
			var _scope89: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.add(JS.get_property(_scope83["current"], "y"), 1)), 1), 0, false)
			return null)):
			JS.invoke_method(JS.get_property(_scope82["self"], "graph"), "addEdge", [_scope83["v"], JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "vertices"), JS.get_property(_scope83["current"], "x")), JS.add(JS.get_property(_scope83["current"], "y"), 1)), {"x": JS.get_property(_scope83["current"], "x"), "y": JS.add(JS.get_property(_scope83["current"], "y"), 1), "length": 1}])
		if JS.truthy(JS.logical("&&", func():
			var _scope90: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope83["current"], "y"), 0)
			return null, func():
			var _scope91: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.get_property(_scope83["current"], "y")), 1), 0, false)
			return null)):
			JS.invoke_method(JS.get_property(_scope82["self"], "graph"), "addEdge", [_scope83["v"], JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "vertices"), JS.get_property(_scope83["current"], "x")), (JS.number(JS.get_property(_scope83["current"], "y")) - JS.number(1))), {"x": JS.get_property(_scope83["current"], "x"), "y": (JS.number(JS.get_property(_scope83["current"], "y")) - JS.number(1)), "length": 1}])
		if JS.truthy(JS.logical("&&", func():
			var _scope92: Dictionary = {}
			return JS.logical("&&", func():
				var _scope93: Dictionary = {}
				return JS.logical("&&", func():
					var _scope94: Dictionary = {}
					return JS.logical("&&", func():
						var _scope95: Dictionary = {}
						return JS.logical("&&", func():
							var _scope96: Dictionary = {}
							return JS.compare(">", JS.get_property(_scope83["current"], "x"), 0)
							return null, func():
							var _scope97: Dictionary = {}
							return JS.compare("<", JS.get_property(_scope83["current"], "y"), (JS.number(JS.get_property(_scope82["self"], "height")) - JS.number(1)))
							return null)
						return null, func():
						var _scope98: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.get_property(_scope83["current"], "y")), 2), 0, false)
						return null)
					return null, func():
					var _scope99: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.add(JS.get_property(_scope83["current"], "y"), 1)), 2), 0, false)
					return null)
				return null, func():
				var _scope100: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.add(JS.get_property(_scope83["current"], "y"), 1)), 1), 0, false)
				return null)
			return null, func():
			var _scope101: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), (JS.number(JS.get_property(_scope83["current"], "x")) - JS.number(1))), JS.add(JS.get_property(_scope83["current"], "y"), 1)), 1), 0, false)
			return null)):
			JS.invoke_method(JS.get_property(_scope82["self"], "graph"), "addEdge", [_scope83["v"], JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "vertices"), (JS.number(JS.get_property(_scope83["current"], "x")) - JS.number(1))), JS.add(JS.get_property(_scope83["current"], "y"), 1)), {"x": (JS.number(JS.get_property(_scope83["current"], "x")) - JS.number(1)), "y": JS.add(JS.get_property(_scope83["current"], "y"), 1), "length": JS.get_property("@Math", "SQRT2")}])
		if JS.truthy(JS.logical("&&", func():
			var _scope102: Dictionary = {}
			return JS.logical("&&", func():
				var _scope103: Dictionary = {}
				return JS.logical("&&", func():
					var _scope104: Dictionary = {}
					return JS.logical("&&", func():
						var _scope105: Dictionary = {}
						return JS.logical("&&", func():
							var _scope106: Dictionary = {}
							return JS.compare("<", JS.get_property(_scope83["current"], "x"), (JS.number(JS.get_property(_scope82["self"], "width")) - JS.number(1)))
							return null, func():
							var _scope107: Dictionary = {}
							return JS.compare("<", JS.get_property(_scope83["current"], "y"), (JS.number(JS.get_property(_scope82["self"], "height")) - JS.number(1)))
							return null)
						return null, func():
						var _scope108: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), JS.get_property(_scope83["current"], "y")), 2), 0, false)
						return null)
					return null, func():
					var _scope109: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), JS.add(JS.get_property(_scope83["current"], "y"), 1)), 2), 0, false)
					return null)
				return null, func():
				var _scope110: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.add(JS.get_property(_scope83["current"], "y"), 1)), 1), 0, false)
				return null)
			return null, func():
			var _scope111: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), JS.add(JS.get_property(_scope83["current"], "y"), 1)), 1), 0, false)
			return null)):
			JS.invoke_method(JS.get_property(_scope82["self"], "graph"), "addEdge", [_scope83["v"], JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "vertices"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), JS.add(JS.get_property(_scope83["current"], "y"), 1)), {"x": JS.add(JS.get_property(_scope83["current"], "x"), 1), "y": JS.add(JS.get_property(_scope83["current"], "y"), 1), "length": JS.get_property("@Math", "SQRT2")}])
		if JS.truthy(JS.logical("&&", func():
			var _scope112: Dictionary = {}
			return JS.logical("&&", func():
				var _scope113: Dictionary = {}
				return JS.logical("&&", func():
					var _scope114: Dictionary = {}
					return JS.logical("&&", func():
						var _scope115: Dictionary = {}
						return JS.logical("&&", func():
							var _scope116: Dictionary = {}
							return JS.compare(">", JS.get_property(_scope83["current"], "x"), 0)
							return null, func():
							var _scope117: Dictionary = {}
							return JS.compare(">", JS.get_property(_scope83["current"], "y"), 0)
							return null)
						return null, func():
						var _scope118: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.get_property(_scope83["current"], "y")), 2), 0, false)
						return null)
					return null, func():
					var _scope119: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), (JS.number(JS.get_property(_scope83["current"], "y")) - JS.number(1))), 2), 0, false)
					return null)
				return null, func():
				var _scope120: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.get_property(_scope83["current"], "y")), 1), 0, false)
				return null)
			return null, func():
			var _scope121: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), (JS.number(JS.get_property(_scope83["current"], "x")) - JS.number(1))), JS.get_property(_scope83["current"], "y")), 1), 0, false)
			return null)):
			JS.invoke_method(JS.get_property(_scope82["self"], "graph"), "addEdge", [_scope83["v"], JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "vertices"), (JS.number(JS.get_property(_scope83["current"], "x")) - JS.number(1))), (JS.number(JS.get_property(_scope83["current"], "y")) - JS.number(1))), {"x": (JS.number(JS.get_property(_scope83["current"], "x")) - JS.number(1)), "y": (JS.number(JS.get_property(_scope83["current"], "y")) - JS.number(1)), "length": JS.get_property("@Math", "SQRT2")}])
		if JS.truthy(JS.logical("&&", func():
			var _scope122: Dictionary = {}
			return JS.logical("&&", func():
				var _scope123: Dictionary = {}
				return JS.logical("&&", func():
					var _scope124: Dictionary = {}
					return JS.logical("&&", func():
						var _scope125: Dictionary = {}
						return JS.logical("&&", func():
							var _scope126: Dictionary = {}
							return JS.compare("<", JS.get_property(_scope83["current"], "x"), (JS.number(JS.get_property(_scope82["self"], "width")) - JS.number(1)))
							return null, func():
							var _scope127: Dictionary = {}
							return JS.compare(">", JS.get_property(_scope83["current"], "y"), 0)
							return null)
						return null, func():
						var _scope128: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), JS.get_property(_scope83["current"], "y")), 2), 0, false)
						return null)
					return null, func():
					var _scope129: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), (JS.number(JS.get_property(_scope83["current"], "y")) - JS.number(1))), 2), 0, false)
					return null)
				return null, func():
				var _scope130: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.get_property(_scope83["current"], "x")), JS.get_property(_scope83["current"], "y")), 1), 0, false)
				return null)
			return null, func():
			var _scope131: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "data"), "tiles"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), JS.get_property(_scope83["current"], "y")), 1), 0, false)
			return null)):
			JS.invoke_method(JS.get_property(_scope82["self"], "graph"), "addEdge", [_scope83["v"], JS.get_property(JS.get_property(JS.get_property(_scope82["self"], "vertices"), JS.add(JS.get_property(_scope83["current"], "x"), 1)), (JS.number(JS.get_property(_scope83["current"], "y")) - JS.number(1))), {"x": JS.add(JS.get_property(_scope83["current"], "x"), 1), "y": (JS.number(JS.get_property(_scope83["current"], "y")) - JS.number(1)), "length": JS.get_property("@Math", "SQRT2")}])
		return null])
	JS.set_property(self, "dijkstra", JS.construct(JS.get_property(JS.get_property(JS.module("jKstra"), "algos"), "Dijkstra"), [JS.get_property(self, "graph")]))
	return null

func original__calculateTilePresentToTileIndex(_arg0 = null, _arg1 = null):
	var _scope132: Dictionary = {"width": _arg0, "height": _arg1, "i": null, "j": null, "tilePresent": null}
	JS.set_property(self, "tilePresentToTileIndex", JS.construct("@Array", []))
	_scope132["i"] = 0
	while JS.truthy(JS.compare("<", _scope132["i"], _scope132["width"])):
		_scope132["j"] = 0
		while JS.truthy(JS.compare("<", _scope132["j"], _scope132["height"])):
			_scope132["tilePresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope132["i"]), _scope132["j"]), 0), 1, false)
			if JS.truthy(_scope132["tilePresent"]):
				JS.invoke_method(JS.get_property(self, "tilePresentToTileIndex"), "push", [{"x": _scope132["i"], "y": _scope132["j"]}])
			JS.increment(_scope132, "j", 1, false)
		JS.increment(_scope132, "i", 1, false)
	return null

func original__calculateReachable(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope133: Dictionary = {"tankPosition": _arg0, "width": _arg1, "height": _arg2, "i": null, "self": null}
	JS.set_property(self, "tileToReachableIndex", JS.construct("@Array", [_scope133["width"]]))
	_scope133["i"] = 0
	while JS.truthy(JS.compare("<", _scope133["i"], _scope133["width"])):
		JS.set_property(JS.get_property(self, "tileToReachableIndex"), _scope133["i"], JS.construct("@Array", [_scope133["height"]]))
		JS.increment(_scope133, "i", 1, false)
	JS.set_property(self, "reachable", [])
	_scope133["self"] = self
	JS.invoke_method(self, "_traverseCloseTiles", [_scope133["tankPosition"], JS.get_property("@Number", "MAX_VALUE"), _scope133["width"], _scope133["height"], func(_arg0 = null):
		var _scope134: Dictionary = {"current": _arg0}
		JS.set_property(JS.get_property(JS.get_property(_scope133["self"], "tileToReachableIndex"), JS.get_property(_scope134["current"], "x")), JS.get_property(_scope134["current"], "y"), JS.get_property(JS.get_property(_scope133["self"], "reachable"), "length"))
		JS.invoke_method(JS.get_property(_scope133["self"], "reachable"), "push", [{"x": JS.get_property(_scope134["current"], "x"), "y": JS.get_property(_scope134["current"], "y"), "used": false}])
		return null])
	return null

func original__expandReachable(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope135: Dictionary = {"tankPosition": _arg0, "width": _arg1, "height": _arg2, "foundExpansion": null, "reachableIndex": null, "i": null, "current": null}
	_scope135["foundExpansion"] = false
	_scope135["reachableIndex"] = JS.construct("@Array", [])
	_scope135["i"] = 0
	while JS.truthy(JS.compare("<", _scope135["i"], JS.get_property(JS.get_property(self, "reachable"), "length"))):
		JS.invoke_method(_scope135["reachableIndex"], "push", [_scope135["i"]])
		JS.increment(_scope135, "i", 1, false)
	JS.invoke_method(JS.module("ArrayUtils"), "shuffle", [_scope135["reachableIndex"]])
	_scope135["i"] = 0
	while JS.truthy(JS.compare("<", _scope135["i"], JS.get_property(JS.get_property(self, "reachable"), "length"))):
		_scope135["current"] = JS.get_property(JS.get_property(self, "reachable"), JS.get_property(_scope135["reachableIndex"], _scope135["i"]))
		if JS.truthy(JS.logical("&&", func():
			var _scope136: Dictionary = {}
			return JS.logical("&&", func():
				var _scope137: Dictionary = {}
				return JS.compare(">", JS.get_property(_scope135["current"], "x"), 0)
				return null, func():
				var _scope138: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), (JS.number(JS.get_property(_scope135["current"], "x")) - JS.number(1))), JS.get_property(_scope135["current"], "y")), 0), 1, false)
				return null)
			return null, func():
			var _scope139: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), (JS.number(JS.get_property(_scope135["current"], "x")) - JS.number(1))), JS.get_property(_scope135["current"], "y")), null, true)
			return null)):
			JS.set_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope135["current"], "x")), JS.get_property(_scope135["current"], "y")), 2, 0)
			JS.set_property(_scope135, "foundExpansion", true)
			break
		if JS.truthy(JS.logical("&&", func():
			var _scope140: Dictionary = {}
			return JS.logical("&&", func():
				var _scope141: Dictionary = {}
				return JS.compare("<", JS.get_property(_scope135["current"], "x"), (JS.number(_scope135["width"]) - JS.number(1)))
				return null, func():
				var _scope142: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope135["current"], "x"), 1)), JS.get_property(_scope135["current"], "y")), 0), 1, false)
				return null)
			return null, func():
			var _scope143: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), JS.add(JS.get_property(_scope135["current"], "x"), 1)), JS.get_property(_scope135["current"], "y")), null, true)
			return null)):
			JS.set_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope135["current"], "x"), 1)), JS.get_property(_scope135["current"], "y")), 2, 0)
			JS.set_property(_scope135, "foundExpansion", true)
			break
		if JS.truthy(JS.logical("&&", func():
			var _scope144: Dictionary = {}
			return JS.logical("&&", func():
				var _scope145: Dictionary = {}
				return JS.compare("<", JS.get_property(_scope135["current"], "y"), (JS.number(_scope135["height"]) - JS.number(1)))
				return null, func():
				var _scope146: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope135["current"], "x")), JS.add(JS.get_property(_scope135["current"], "y"), 1)), 0), 1, false)
				return null)
			return null, func():
			var _scope147: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), JS.get_property(_scope135["current"], "x")), JS.add(JS.get_property(_scope135["current"], "y"), 1)), null, true)
			return null)):
			JS.set_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope135["current"], "x")), JS.add(JS.get_property(_scope135["current"], "y"), 1)), 1, 0)
			JS.set_property(_scope135, "foundExpansion", true)
			break
		if JS.truthy(JS.logical("&&", func():
			var _scope148: Dictionary = {}
			return JS.logical("&&", func():
				var _scope149: Dictionary = {}
				return JS.compare(">", JS.get_property(_scope135["current"], "y"), 0)
				return null, func():
				var _scope150: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope135["current"], "x")), (JS.number(JS.get_property(_scope135["current"], "y")) - JS.number(1))), 0), 1, false)
				return null)
			return null, func():
			var _scope151: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), JS.get_property(_scope135["current"], "x")), (JS.number(JS.get_property(_scope135["current"], "y")) - JS.number(1))), null, true)
			return null)):
			JS.set_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope135["current"], "x")), JS.get_property(_scope135["current"], "y")), 1, 0)
			JS.set_property(_scope135, "foundExpansion", true)
			break
		JS.increment(_scope135, "i", 1, false)
	if JS.truthy(_scope135["foundExpansion"]):
		JS.invoke_method(self, "_calculateReachable", [_scope135["tankPosition"], _scope135["width"], _scope135["height"]])
	return _scope135["foundExpansion"]
	return null

func original__expandUnreachable(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope152: Dictionary = {"tankPosition": _arg0, "width": _arg1, "height": _arg2, "foundExpansion": null, "unreachable": null, "i": null, "j": null, "current": null}
	_scope152["foundExpansion"] = false
	_scope152["unreachable"] = JS.construct("@Array", [])
	_scope152["i"] = 0
	while JS.truthy(JS.compare("<", _scope152["i"], _scope152["width"])):
		_scope152["j"] = 0
		while JS.truthy(JS.compare("<", _scope152["j"], _scope152["height"])):
			if JS.truthy(JS.logical("&&", func():
				var _scope153: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope152["i"]), _scope152["j"]), 0), 1, false)
				return null, func():
				var _scope154: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), _scope152["i"]), _scope152["j"]), null, true)
				return null)):
				JS.invoke_method(_scope152["unreachable"], "push", [{"x": _scope152["i"], "y": _scope152["j"]}])
			JS.increment(_scope152, "j", 1, false)
		JS.increment(_scope152, "i", 1, false)
	JS.invoke_method(JS.module("ArrayUtils"), "shuffle", [_scope152["unreachable"]])
	_scope152["i"] = 0
	while JS.truthy(JS.compare("<", _scope152["i"], JS.get_property(_scope152["unreachable"], "length"))):
		_scope152["current"] = JS.get_property(_scope152["unreachable"], _scope152["i"])
		if JS.truthy(JS.logical("&&", func():
			var _scope155: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope152["current"], "x"), 0)
			return null, func():
			var _scope156: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), (JS.number(JS.get_property(_scope152["current"], "x")) - JS.number(1))), JS.get_property(_scope152["current"], "y")), 0), 0, false)
			return null)):
			JS.invoke_method(self, "_addTile", [(JS.number(JS.get_property(_scope152["current"], "x")) - JS.number(1)), JS.get_property(_scope152["current"], "y"), _scope152["width"], _scope152["height"]])
			JS.set_property(_scope152, "foundExpansion", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope157: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope152["current"], "x"), (JS.number(_scope152["width"]) - JS.number(1)))
			return null, func():
			var _scope158: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope152["current"], "x"), 1)), JS.get_property(_scope152["current"], "y")), 0), 0, false)
			return null)):
			JS.invoke_method(self, "_addTile", [JS.add(JS.get_property(_scope152["current"], "x"), 1), JS.get_property(_scope152["current"], "y"), _scope152["width"], _scope152["height"]])
			JS.set_property(_scope152, "foundExpansion", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope159: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope152["current"], "y"), (JS.number(_scope152["height"]) - JS.number(1)))
			return null, func():
			var _scope160: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope152["current"], "x")), JS.add(JS.get_property(_scope152["current"], "y"), 1)), 0), 0, false)
			return null)):
			JS.invoke_method(self, "_addTile", [JS.get_property(_scope152["current"], "x"), JS.add(JS.get_property(_scope152["current"], "y"), 1), _scope152["width"], _scope152["height"]])
			JS.set_property(_scope152, "foundExpansion", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope161: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope152["current"], "y"), 0)
			return null, func():
			var _scope162: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope152["current"], "x")), (JS.number(JS.get_property(_scope152["current"], "y")) - JS.number(1))), 0), 0, false)
			return null)):
			JS.invoke_method(self, "_addTile", [JS.get_property(_scope152["current"], "x"), (JS.number(JS.get_property(_scope152["current"], "y")) - JS.number(1)), _scope152["width"], _scope152["height"]])
			JS.set_property(_scope152, "foundExpansion", true)
		if JS.truthy(_scope152["foundExpansion"]):
			break
		JS.increment(_scope152, "i", 1, false)
	if JS.truthy(_scope152["foundExpansion"]):
		JS.invoke_method(self, "_calculateReachable", [_scope152["tankPosition"], _scope152["width"], _scope152["height"]])
		JS.invoke_method(self, "_calculateTilePresentToTileIndex", [_scope152["width"], _scope152["height"]])
	return _scope152["foundExpansion"]
	return null

func original__addTile(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope163: Dictionary = {"x": _arg0, "y": _arg1, "width": _arg2, "height": _arg3}
	JS.set_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope163["x"]), _scope163["y"]), 0, 1)
	if JS.truthy(JS.logical("||", func():
		var _scope164: Dictionary = {}
		return JS.compare("<=", _scope163["x"], 0)
		return null, func():
		var _scope165: Dictionary = {}
		return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), (JS.number(_scope163["x"]) - JS.number(1))), _scope163["y"]), 0), 0, false)
		return null)):
		JS.set_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope163["x"]), _scope163["y"]), 2, 1)
	if JS.truthy(JS.logical("&&", func():
		var _scope166: Dictionary = {}
		return JS.compare("<", _scope163["x"], (JS.number(_scope163["width"]) - JS.number(1)))
		return null, func():
		var _scope167: Dictionary = {}
		return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(_scope163["x"], 1)), _scope163["y"]), 0), 0, false)
		return null)):
		JS.set_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(_scope163["x"], 1)), _scope163["y"]), 2, 1)
	if JS.truthy(JS.logical("||", func():
		var _scope168: Dictionary = {}
		return JS.compare("<=", _scope163["y"], 0)
		return null, func():
		var _scope169: Dictionary = {}
		return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope163["x"]), (JS.number(_scope163["y"]) - JS.number(1))), 0), 0, false)
		return null)):
		JS.set_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope163["x"]), _scope163["y"]), 1, 1)
	if JS.truthy(JS.logical("&&", func():
		var _scope170: Dictionary = {}
		return JS.compare("<", _scope163["y"], (JS.number(_scope163["height"]) - JS.number(1)))
		return null, func():
		var _scope171: Dictionary = {}
		return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope163["x"]), JS.add(_scope163["y"], 1)), 0), 0, false)
		return null)):
		JS.set_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope163["x"]), JS.add(_scope163["y"], 1)), 1, 1)
	return null

func original__traverseCloseTiles(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope172: Dictionary = {"position": _arg0, "maximumDistance": _arg1, "width": _arg2, "height": _arg3, "traverseFn": _arg4, "alreadyAddedToWorklist": null, "i": null, "worklist": null, "current": null}
	_scope172["alreadyAddedToWorklist"] = JS.construct("@Array", [_scope172["width"]])
	_scope172["i"] = 0
	while JS.truthy(JS.compare("<", _scope172["i"], _scope172["width"])):
		JS.set_property(_scope172["alreadyAddedToWorklist"], _scope172["i"], JS.construct("@Array", [_scope172["height"]]))
		JS.increment(_scope172, "i", 1, false)
	_scope172["worklist"] = []
	JS.invoke_method(_scope172["worklist"], "push", [{"x": JS.get_property(_scope172["position"], "x"), "y": JS.get_property(_scope172["position"], "y"), "distance": 0}])
	JS.set_property(JS.get_property(_scope172["alreadyAddedToWorklist"], JS.get_property(_scope172["position"], "x")), JS.get_property(_scope172["position"], "y"), true)
	while JS.truthy(JS.compare(">", JS.get_property(_scope172["worklist"], "length"), 0)):
		_scope172["current"] = JS.invoke_method(_scope172["worklist"], "shift", [])
		if JS.truthy(JS.compare(">", JS.get_property(_scope172["current"], "distance"), _scope172["maximumDistance"])):
			continue
		JS.invoke(_scope172["traverseFn"], [_scope172["current"]])
		if JS.truthy(JS.logical("&&", func():
			var _scope173: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope172["current"], "x"), 0)
			return null, func():
			var _scope174: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope172["current"], "x")), JS.get_property(_scope172["current"], "y")), 2), 0, false)
			return null)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope172["alreadyAddedToWorklist"], (JS.number(JS.get_property(_scope172["current"], "x")) - JS.number(1))), JS.get_property(_scope172["current"], "y")), null, true)):
				JS.set_property(JS.get_property(_scope172["alreadyAddedToWorklist"], (JS.number(JS.get_property(_scope172["current"], "x")) - JS.number(1))), JS.get_property(_scope172["current"], "y"), true)
				JS.invoke_method(_scope172["worklist"], "push", [{"x": (JS.number(JS.get_property(_scope172["current"], "x")) - JS.number(1)), "y": JS.get_property(_scope172["current"], "y"), "distance": JS.add(JS.get_property(_scope172["current"], "distance"), 1)}])
		if JS.truthy(JS.logical("&&", func():
			var _scope175: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope172["current"], "x"), (JS.number(_scope172["width"]) - JS.number(1)))
			return null, func():
			var _scope176: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope172["current"], "x"), 1)), JS.get_property(_scope172["current"], "y")), 2), 0, false)
			return null)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope172["alreadyAddedToWorklist"], JS.add(JS.get_property(_scope172["current"], "x"), 1)), JS.get_property(_scope172["current"], "y")), null, true)):
				JS.set_property(JS.get_property(_scope172["alreadyAddedToWorklist"], JS.add(JS.get_property(_scope172["current"], "x"), 1)), JS.get_property(_scope172["current"], "y"), true)
				JS.invoke_method(_scope172["worklist"], "push", [{"x": JS.add(JS.get_property(_scope172["current"], "x"), 1), "y": JS.get_property(_scope172["current"], "y"), "distance": JS.add(JS.get_property(_scope172["current"], "distance"), 1)}])
		if JS.truthy(JS.logical("&&", func():
			var _scope177: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope172["current"], "y"), (JS.number(_scope172["height"]) - JS.number(1)))
			return null, func():
			var _scope178: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope172["current"], "x")), JS.add(JS.get_property(_scope172["current"], "y"), 1)), 1), 0, false)
			return null)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope172["alreadyAddedToWorklist"], JS.get_property(_scope172["current"], "x")), JS.add(JS.get_property(_scope172["current"], "y"), 1)), null, true)):
				JS.set_property(JS.get_property(_scope172["alreadyAddedToWorklist"], JS.get_property(_scope172["current"], "x")), JS.add(JS.get_property(_scope172["current"], "y"), 1), true)
				JS.invoke_method(_scope172["worklist"], "push", [{"x": JS.get_property(_scope172["current"], "x"), "y": JS.add(JS.get_property(_scope172["current"], "y"), 1), "distance": JS.add(JS.get_property(_scope172["current"], "distance"), 1)}])
		if JS.truthy(JS.logical("&&", func():
			var _scope179: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope172["current"], "y"), 0)
			return null, func():
			var _scope180: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope172["current"], "x")), JS.get_property(_scope172["current"], "y")), 1), 0, false)
			return null)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope172["alreadyAddedToWorklist"], JS.get_property(_scope172["current"], "x")), (JS.number(JS.get_property(_scope172["current"], "y")) - JS.number(1))), null, true)):
				JS.set_property(JS.get_property(_scope172["alreadyAddedToWorklist"], JS.get_property(_scope172["current"], "x")), (JS.number(JS.get_property(_scope172["current"], "y")) - JS.number(1)), true)
				JS.invoke_method(_scope172["worklist"], "push", [{"x": JS.get_property(_scope172["current"], "x"), "y": (JS.number(JS.get_property(_scope172["current"], "y")) - JS.number(1)), "distance": JS.add(JS.get_property(_scope172["current"], "distance"), 1)}])
	return null

func original__markTilesAsUsed(_arg0 = null, _arg1 = null):
	var _scope181: Dictionary = {"position": _arg0, "minimumDistance": _arg1, "self": null}
	_scope181["self"] = self
	JS.invoke_method(self, "_traverseCloseTiles", [_scope181["position"], _scope181["minimumDistance"], JS.get_property(self, "width"), JS.get_property(self, "height"), func(_arg0 = null):
		var _scope182: Dictionary = {"current": _arg0}
		JS.set_property(JS.get_property(JS.get_property(_scope181["self"], "reachable"), JS.get_property(JS.get_property(JS.get_property(_scope181["self"], "tileToReachableIndex"), JS.get_property(_scope182["current"], "x")), JS.get_property(_scope182["current"], "y"))), "used", true)
		return null])
	return null

func original__clearUsedTiles():
	var _scope183: Dictionary = {"i": null}
	_scope183["i"] = 0
	while JS.truthy(JS.compare("<", _scope183["i"], JS.get_property(JS.get_property(self, "reachable"), "length"))):
		JS.set_property(JS.get_property(JS.get_property(self, "reachable"), _scope183["i"]), "used", false)
		JS.increment(_scope183, "i", 1, false)
	return null

func original__getUnusedTiles():
	var _scope184: Dictionary = {"unused": null, "i": null, "current": null}
	_scope184["unused"] = JS.construct("@Array", [])
	_scope184["i"] = 0
	while JS.truthy(JS.compare("<", _scope184["i"], JS.get_property(JS.get_property(self, "reachable"), "length"))):
		_scope184["current"] = JS.get_property(JS.get_property(self, "reachable"), _scope184["i"])
		if JS.truthy((not JS.truthy(JS.get_property(_scope184["current"], "used")))):
			JS.invoke_method(_scope184["unused"], "push", [{"x": JS.get_property(_scope184["current"], "x"), "y": JS.get_property(_scope184["current"], "y")}])
		JS.increment(_scope184, "i", 1, false)
	return _scope184["unused"]
	return null

func original_traverseCloseTiles(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope185: Dictionary = {"position": _arg0, "maximumDistance": _arg1, "traverseFn": _arg2}
	if JS.truthy((not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope185["position"]])))):
		JS.invoke_method(JS.get_property(JS.module("Maze"), "log"), "error", ["A position was outside the maze."])
		return null
	JS.invoke_method(self, "_traverseCloseTiles", [_scope185["position"], _scope185["maximumDistance"], JS.get_property(self, "width"), JS.get_property(self, "height"), _scope185["traverseFn"]])
	return null

func original_getTheme():
	var _scope186: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "theme")
	return null

func original_getWidth():
	var _scope187: Dictionary = {}
	return JS.get_property(self, "width")
	return null

func original_getHeight():
	var _scope188: Dictionary = {}
	return JS.get_property(self, "height")
	return null

func original_getTiles():
	var _scope189: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "tiles")
	return null

func original_getBorders():
	var _scope190: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "borders")
	return null

func original_getFloors():
	var _scope191: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "floors")
	return null

func original_getSpaces():
	var _scope192: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "spaces")
	return null

func original_getWalls():
	var _scope193: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "walls")
	return null

func original_getWallDecorations():
	var _scope194: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "wallDecorations")
	return null

func original_getTileBounds():
	var _scope195: Dictionary = {}
	return JS.get_property(self, "tileBounds")
	return null

func original_getDistances():
	var _scope196: Dictionary = {}
	return JS.get_property(self, "distances")
	return null

func original_getDistancesFromPosition(_arg0 = null):
	var _scope197: Dictionary = {"position": _arg0}
	if JS.truthy((not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope197["position"]])))):
		return false
	return JS.get_property(JS.get_property(JS.get_property(self, "distances"), JS.get_property(_scope197["position"], "x")), JS.get_property(_scope197["position"], "y"))
	return null

func original_getDistanceBetweenPositions(_arg0 = null, _arg1 = null):
	var _scope198: Dictionary = {"startPosition": _arg0, "endPosition": _arg1}
	if JS.truthy(JS.logical("||", func():
		var _scope199: Dictionary = {}
		return (not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope198["startPosition"]])))
		return null, func():
		var _scope200: Dictionary = {}
		return (not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope198["endPosition"]])))
		return null)):
		return false
	return JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "distances"), JS.get_property(_scope198["startPosition"], "x")), JS.get_property(_scope198["startPosition"], "y")), JS.get_property(_scope198["endPosition"], "x")), JS.get_property(_scope198["endPosition"], "y"))
	return null

func original_getDistanceToPosition(_arg0 = null, _arg1 = null):
	var _scope201: Dictionary = {"distances": _arg0, "position": _arg1}
	if JS.truthy((not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope201["position"]])))):
		return false
	return JS.get_property(JS.get_property(_scope201["distances"], JS.get_property(_scope201["position"], "x")), JS.get_property(_scope201["position"], "y"))
	return null

func original_getDeadEndPenalties():
	var _scope202: Dictionary = {}
	return JS.get_property(self, "deadEndPenalties")
	return null

func original_getDeadEndPenalty(_arg0 = null):
	var _scope203: Dictionary = {"position": _arg0}
	if JS.truthy((not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope203["position"]])))):
		return 0
	return JS.get_property(JS.get_property(JS.get_property(self, "deadEndPenalties"), JS.get_property(_scope203["position"], "x")), JS.get_property(_scope203["position"], "y"))
	return null

func original_getReachable():
	var _scope204: Dictionary = {}
	return JS.get_property(self, "reachable")
	return null

func original_getReachableIndexFromPosition(_arg0 = null):
	var _scope205: Dictionary = {"position": _arg0}
	if JS.truthy((not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope205["position"]])))):
		return false
	return JS.get_property(JS.get_property(JS.get_property(self, "tileToReachableIndex"), JS.get_property(_scope205["position"], "x")), JS.get_property(_scope205["position"], "y"))
	return null

func original_getTankPositions():
	var _scope206: Dictionary = {}
	return JS.get_property(self, "tankPositions")
	return null

func original_getRandomUnusedPosition(_arg0 = null, _arg1 = null):
	var _scope207: Dictionary = {"roundState": _arg0, "minimumDistance": _arg1, "unused": null}
	JS.invoke_method(self, "_updateUsedPositions", [_scope207["roundState"], _scope207["minimumDistance"], true])
	_scope207["unused"] = JS.invoke_method(self, "_getUnusedTiles", [])
	return JS.invoke_method(self, "_getRandomPosition", [_scope207["unused"]])
	return null

func original_getCrateSpawnPosition(_arg0 = null):
	var _scope208: Dictionary = {"roundState": _arg0, "unused": null, "comparePositionFn": null, "availablePositions": null, "i": null, "crateSpawnPosition": null, "unusedIndex": null}
	JS.invoke_method(self, "_updateUsedPositions", [_scope208["roundState"], 0, true])
	_scope208["unused"] = JS.invoke_method(self, "_getUnusedTiles", [])
	_scope208["comparePositionFn"] = func(_arg0 = null, _arg1 = null):
		var _scope209: Dictionary = {"a": _arg0, "b": _arg1}
		return JS.logical("&&", func():
			var _scope210: Dictionary = {}
			return JS.equal(JS.get_property(_scope209["a"], "x"), JS.get_property(_scope209["b"], "x"), false)
			return null, func():
			var _scope211: Dictionary = {}
			return JS.equal(JS.get_property(_scope209["a"], "y"), JS.get_property(_scope209["b"], "y"), false)
			return null)
		return null
	_scope208["availablePositions"] = JS.construct("@Array", [])
	_scope208["i"] = 0
	while JS.truthy(JS.compare("<", _scope208["i"], JS.get_property(JS.get_property(self, "crateSpawnPositions"), "length"))):
		_scope208["crateSpawnPosition"] = JS.get_property(JS.get_property(self, "crateSpawnPositions"), _scope208["i"])
		_scope208["unusedIndex"] = JS.invoke_method(JS.module("ArrayUtils"), "indexOf", [_scope208["unused"], _scope208["crateSpawnPosition"], _scope208["comparePositionFn"]])
		if JS.truthy(not JS.equal(_scope208["unusedIndex"], -(1), false)):
			JS.invoke_method(_scope208["availablePositions"], "push", [JS.get_property(_scope208["unused"], _scope208["unusedIndex"])])
		JS.increment(_scope208, "i", 1, true)
	return JS.invoke_method(self, "_getRandomPosition", [_scope208["availablePositions"]])
	return null

func original_getTankSpawnPosition(_arg0 = null):
	var _scope212: Dictionary = {"roundState": _arg0, "unused": null, "comparePositionFn": null, "availablePositions": null, "i": null, "tankSpawnPosition": null, "unusedIndex": null, "tankStates": null, "maxDistance": null, "bestPositions": null, "availablePosition": null, "distances": null, "distance": null, "j": null, "tankState": null, "position": null}
	JS.invoke_method(self, "_updateUsedPositions", [_scope212["roundState"], 0, false])
	_scope212["unused"] = JS.invoke_method(self, "_getUnusedTiles", [])
	_scope212["comparePositionFn"] = func(_arg0 = null, _arg1 = null):
		var _scope213: Dictionary = {"a": _arg0, "b": _arg1}
		return JS.logical("&&", func():
			var _scope214: Dictionary = {}
			return JS.equal(JS.get_property(_scope213["a"], "x"), JS.get_property(_scope213["b"], "x"), false)
			return null, func():
			var _scope215: Dictionary = {}
			return JS.equal(JS.get_property(_scope213["a"], "y"), JS.get_property(_scope213["b"], "y"), false)
			return null)
		return null
	_scope212["availablePositions"] = JS.construct("@Array", [])
	_scope212["i"] = 0
	while JS.truthy(JS.compare("<", _scope212["i"], JS.get_property(JS.get_property(self, "tankSpawnPositions"), "length"))):
		_scope212["tankSpawnPosition"] = JS.get_property(JS.get_property(self, "tankSpawnPositions"), _scope212["i"])
		_scope212["unusedIndex"] = JS.invoke_method(JS.module("ArrayUtils"), "indexOf", [_scope212["unused"], _scope212["tankSpawnPosition"], _scope212["comparePositionFn"]])
		if JS.truthy(not JS.equal(_scope212["unusedIndex"], -(1), false)):
			JS.invoke_method(_scope212["availablePositions"], "push", [JS.get_property(_scope212["unused"], _scope212["unusedIndex"])])
		JS.increment(_scope212, "i", 1, true)
	_scope212["tankStates"] = JS.invoke_method(_scope212["roundState"], "getTankStates", [])
	_scope212["maxDistance"] = 0
	_scope212["bestPositions"] = []
	_scope212["i"] = 0
	while JS.truthy(JS.compare("<", _scope212["i"], JS.get_property(_scope212["availablePositions"], "length"))):
		_scope212["availablePosition"] = JS.get_property(_scope212["availablePositions"], _scope212["i"])
		_scope212["distances"] = JS.invoke_method(self, "getDistancesFromPosition", [_scope212["availablePosition"]])
		_scope212["distance"] = JS.get_property("@Number", "MAX_VALUE")
		_scope212["j"] = 0
		while JS.truthy(JS.compare("<", _scope212["j"], JS.get_property(_scope212["tankStates"], "length"))):
			_scope212["tankState"] = JS.get_property(_scope212["tankStates"], _scope212["j"])
			_scope212["position"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope212["tankState"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope212["tankState"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
			if JS.truthy((not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope212["position"]])))):
				JS.invoke_method(JS.get_property(JS.module("Maze"), "log"), "error", ["A tank position was outside the maze. This should have been corrected by the server!"])
				JS.increment(_scope212, "j", 1, true)
				continue
			JS.set_property(_scope212, "distance", JS.invoke_method("@Math", "min", [_scope212["distance"], JS.get_property(JS.get_property(_scope212["distances"], JS.get_property(_scope212["position"], "x")), JS.get_property(_scope212["position"], "y"))]))
			JS.increment(_scope212, "j", 1, true)
		if JS.truthy(JS.compare(">", _scope212["distance"], _scope212["maxDistance"])):
			JS.set_property(_scope212, "maxDistance", _scope212["distance"])
			JS.set_property(_scope212, "bestPositions", JS.construct("@Array", [_scope212["availablePosition"]]))
		else:
			if JS.truthy(JS.equal(_scope212["distance"], _scope212["maxDistance"], false)):
				JS.invoke_method(_scope212["bestPositions"], "push", [_scope212["availablePosition"]])
		JS.increment(_scope212, "i", 1, false)
	return JS.invoke_method(self, "_getRandomPosition", [_scope212["bestPositions"]])
	return null

func original__getRandomPosition(_arg0 = null):
	var _scope216: Dictionary = {"positions": _arg0, "position": null}
	if JS.truthy(JS.equal(JS.get_property(_scope216["positions"], "length"), 0, false)):
		return null
	_scope216["position"] = JS.invoke_method(JS.module("MathUtils"), "randomArrayEntry", [_scope216["positions"]])
	return JS.invoke_method(self, "_makePositionPhysical", [_scope216["position"]])
	return null

func original__makePositionPhysical(_arg0 = null):
	var _scope217: Dictionary = {"position": _arg0}
	JS.set_property(_scope217["position"], "x", JS.add(JS.get_property(_scope217["position"], "x"), 0.5))
	JS.set_property(_scope217["position"], "y", JS.add(JS.get_property(_scope217["position"], "y"), 0.5))
	JS.set_property(_scope217["position"], "x", (JS.number(JS.get_property(_scope217["position"], "x")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))))
	JS.set_property(_scope217["position"], "y", (JS.number(JS.get_property(_scope217["position"], "y")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))))
	JS.set_property(_scope217["position"], "rotation", (JS.number((JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(2))) * JS.number(JS.get_property("@Math", "PI"))))
	return _scope217["position"]
	return null

func original_isTankStateInsideMaze(_arg0 = null):
	var _scope218: Dictionary = {"tankState": _arg0, "position": null}
	_scope218["position"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope218["tankState"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope218["tankState"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
	return JS.invoke_method(self, "_isPositionInsideMaze", [_scope218["position"]])
	return null

func original_isPositionInsideMaze(_arg0 = null):
	var _scope219: Dictionary = {"position": _arg0, "distances": null}
	if JS.truthy(JS.logical("||", func():
		var _scope220: Dictionary = {}
		return JS.logical("||", func():
			var _scope221: Dictionary = {}
			return JS.logical("||", func():
				var _scope222: Dictionary = {}
				return JS.compare("<", JS.get_property(_scope219["position"], "x"), 0)
				return null, func():
				var _scope223: Dictionary = {}
				return JS.compare(">=", JS.get_property(_scope219["position"], "x"), JS.get_property(self, "width"))
				return null)
			return null, func():
			var _scope224: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope219["position"], "y"), 0)
			return null)
		return null, func():
		var _scope225: Dictionary = {}
		return JS.compare(">=", JS.get_property(_scope219["position"], "y"), JS.get_property(self, "height"))
		return null)):
		return false
	_scope219["distances"] = JS.get_property(JS.get_property(JS.get_property(self, "distances"), JS.get_property(_scope219["position"], "x")), JS.get_property(_scope219["position"], "y"))
	if JS.truthy(JS.equal(_scope219["distances"], null, true)):
		return false
	return true
	return null

func original__isPositionInsideMaze(_arg0 = null):
	var _scope226: Dictionary = {"position": _arg0, "distances": null}
	if JS.truthy(JS.logical("||", func():
		var _scope227: Dictionary = {}
		return JS.logical("||", func():
			var _scope228: Dictionary = {}
			return JS.logical("||", func():
				var _scope229: Dictionary = {}
				return JS.compare("<", JS.get_property(_scope226["position"], "x"), 0)
				return null, func():
				var _scope230: Dictionary = {}
				return JS.compare(">=", JS.get_property(_scope226["position"], "x"), JS.get_property(self, "width"))
				return null)
			return null, func():
			var _scope231: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope226["position"], "y"), 0)
			return null)
		return null, func():
		var _scope232: Dictionary = {}
		return JS.compare(">=", JS.get_property(_scope226["position"], "y"), JS.get_property(self, "height"))
		return null)):
		JS.invoke_method(JS.get_property(JS.module("Maze"), "log"), "error", [JS.add(JS.add(JS.add("Position outside tiles: ", JS.get_property(_scope226["position"], "x")), ", "), JS.get_property(_scope226["position"], "y"))])
		return false
	_scope226["distances"] = JS.get_property(JS.get_property(JS.get_property(self, "distances"), JS.get_property(_scope226["position"], "x")), JS.get_property(_scope226["position"], "y"))
	if JS.truthy(JS.equal(_scope226["distances"], null, true)):
		JS.invoke_method(JS.get_property(JS.module("Maze"), "log"), "error", [JS.add(JS.add(JS.add("Position pointing to invalid tile: ", JS.get_property(_scope226["position"], "x")), ", "), JS.get_property(_scope226["position"], "y"))])
		return false
	return true
	return null

func original__updateUsedPositions(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope233: Dictionary = {"roundState": _arg0, "minimumDistance": _arg1, "includeTankSpawnPositions": _arg2, "tankStates": null, "i": null, "tankState": null, "position": null, "trapStates": null, "trapState": null, "collectibleStates": null, "collectibleState": null, "zoneStates": null, "zoneState": null, "tiles": null, "j": null, "tankSpawnPosition": null}
	JS.invoke_method(self, "_clearUsedTiles", [])
	_scope233["tankStates"] = JS.invoke_method(_scope233["roundState"], "getTankStates", [])
	_scope233["i"] = 0
	while JS.truthy(JS.compare("<", _scope233["i"], JS.get_property(_scope233["tankStates"], "length"))):
		_scope233["tankState"] = JS.get_property(_scope233["tankStates"], _scope233["i"])
		_scope233["position"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope233["tankState"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope233["tankState"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
		if JS.truthy((not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope233["position"]])))):
			JS.invoke_method(JS.get_property(JS.module("Maze"), "log"), "error", ["A tank position was outside the maze. This should have been corrected by the server!"])
			JS.increment(_scope233, "i", 1, true)
			continue
		JS.invoke_method(self, "_markTilesAsUsed", [_scope233["position"], _scope233["minimumDistance"]])
		JS.increment(_scope233, "i", 1, true)
	_scope233["trapStates"] = JS.invoke_method(_scope233["roundState"], "getTrapStates", [])
	_scope233["i"] = 0
	while JS.truthy(JS.compare("<", _scope233["i"], JS.get_property(_scope233["trapStates"], "length"))):
		_scope233["trapState"] = JS.get_property(_scope233["trapStates"], _scope233["i"])
		_scope233["position"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope233["trapState"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope233["trapState"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
		if JS.truthy((not JS.truthy(JS.invoke_method(self, "_isPositionInsideMaze", [_scope233["position"]])))):
			JS.invoke_method(JS.get_property(JS.module("Maze"), "log"), "error", ["A trap position was outside the maze. This indicates that someone wall-hacked the game!"])
			JS.increment(_scope233, "i", 1, true)
			continue
		JS.invoke_method(self, "_markTilesAsUsed", [_scope233["position"], 0])
		JS.increment(_scope233, "i", 1, true)
	_scope233["collectibleStates"] = JS.invoke_method(_scope233["roundState"], "getCollectibleStates", [])
	_scope233["i"] = 0
	while JS.truthy(JS.compare("<", _scope233["i"], JS.get_property(_scope233["collectibleStates"], "length"))):
		_scope233["collectibleState"] = JS.get_property(_scope233["collectibleStates"], _scope233["i"])
		_scope233["position"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope233["collectibleState"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope233["collectibleState"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
		JS.invoke_method(self, "_markTilesAsUsed", [_scope233["position"], 0])
		JS.increment(_scope233, "i", 1, true)
	_scope233["zoneStates"] = JS.invoke_method(_scope233["roundState"], "getZoneStates", [])
	_scope233["i"] = 0
	while JS.truthy(JS.compare("<", _scope233["i"], JS.get_property(_scope233["zoneStates"], "length"))):
		_scope233["zoneState"] = JS.get_property(_scope233["zoneStates"], _scope233["i"])
		var _switch0 = JS.invoke_method(_scope233["zoneState"], "getType", [])
		var _switch0_start = -1
		if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "SPAWN"), true): _switch0_start = 0
		elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "ZONE_TYPES"), "STORM"), true): _switch0_start = 1
		while true:
			if _switch0_start >= 0 and _switch0_start <= 0:
				_scope233["tiles"] = JS.invoke_method(_scope233["zoneState"], "getTiles", [])
				_scope233["j"] = 0
				while JS.truthy(JS.compare("<", _scope233["j"], JS.get_property(_scope233["tiles"], "length"))):
					JS.invoke_method(self, "_markTilesAsUsed", [JS.get_property(_scope233["tiles"], _scope233["j"]), 0])
					JS.increment(_scope233, "j", 1, true)
				break
			if _switch0_start >= 0 and _switch0_start <= 1:
				_scope233["tiles"] = JS.invoke_method(_scope233["zoneState"], "getTiles", [])
				_scope233["j"] = 0
				while JS.truthy(JS.compare("<", _scope233["j"], JS.get_property(_scope233["tiles"], "length"))):
					JS.invoke_method(self, "_markTilesAsUsed", [JS.get_property(_scope233["tiles"], _scope233["j"]), 0])
					JS.increment(_scope233, "j", 1, true)
				break
			break
		JS.increment(_scope233, "i", 1, true)
	if JS.truthy(_scope233["includeTankSpawnPositions"]):
		_scope233["i"] = 0
		while JS.truthy(JS.compare("<", _scope233["i"], JS.get_property(JS.get_property(self, "tankSpawnPositions"), "length"))):
			_scope233["tankSpawnPosition"] = JS.get_property(JS.get_property(self, "tankSpawnPositions"), _scope233["i"])
			JS.invoke_method(self, "_markTilesAsUsed", [_scope233["tankSpawnPosition"], 0])
			JS.increment(_scope233, "i", 1, true)
	return null

func original_getStormExpansionSequence():
	var _scope234: Dictionary = {"result": null, "tileBounds": null, "remainingWidth": null, "remainingHeight": null, "horizontalWeight": null}
	_scope234["result"] = []
	_scope234["tileBounds"] = JS.invoke_method(self, "getTileBounds", [])
	_scope234["remainingWidth"] = JS.add((JS.number(JS.get_property(_scope234["tileBounds"], "maxX")) - JS.number(JS.get_property(_scope234["tileBounds"], "minX"))), 1)
	_scope234["remainingHeight"] = JS.add((JS.number(JS.get_property(_scope234["tileBounds"], "maxY")) - JS.number(JS.get_property(_scope234["tileBounds"], "minY"))), 1)
	while JS.truthy(JS.logical("&&", func():
		var _scope235: Dictionary = {}
		return JS.compare(">", _scope234["remainingWidth"], 0)
		return null, func():
		var _scope236: Dictionary = {}
		return JS.compare(">", _scope234["remainingHeight"], 0)
		return null)):
		_scope234["horizontalWeight"] = (JS.number(_scope234["remainingWidth"]) / JS.number(JS.add(_scope234["remainingWidth"], _scope234["remainingHeight"])))
		if JS.truthy(JS.compare("<", JS.invoke_method("@Math", "random", []), _scope234["horizontalWeight"])):
			JS.invoke_method(_scope234["result"], "push", [(0 if JS.truthy(JS.compare("<", JS.invoke_method("@Math", "random", []), 0.5)) else 2)])
			JS.set_property(_scope234, "remainingWidth", (JS.number(_scope234["remainingWidth"]) - JS.number(1)))
		else:
			JS.invoke_method(_scope234["result"], "push", [(1 if JS.truthy(JS.compare("<", JS.invoke_method("@Math", "random", []), 0.5)) else 3)])
			JS.set_property(_scope234, "remainingHeight", (JS.number(_scope234["remainingHeight"]) - JS.number(1)))
	return _scope234["result"]
	return null

func original__calculateBorderFloorsSpacesWallsAndDecorations():
	var _scope237: Dictionary = {"tileToWallConfiguration": null, "i": null, "j": null, "tilePresent": null, "floor": null, "wallDecoration": null, "space": null, "borders": null, "k": null, "border": null, "walls": null, "wall": null}
	JS.set_property(JS.get_property(self, "data"), "borders", [])
	JS.set_property(JS.get_property(self, "data"), "floors", [])
	JS.set_property(JS.get_property(self, "data"), "spaces", [])
	JS.set_property(JS.get_property(self, "data"), "walls", [])
	JS.set_property(JS.get_property(self, "data"), "wallDecorations", [])
	_scope237["tileToWallConfiguration"] = JS.construct("@Array", [JS.get_property(self, "width")])
	_scope237["i"] = 0
	while JS.truthy(JS.compare("<", _scope237["i"], JS.get_property(self, "width"))):
		JS.set_property(_scope237["tileToWallConfiguration"], _scope237["i"], JS.construct("@Array", [JS.get_property(self, "height")]))
		JS.increment(_scope237, "i", 1, false)
	_scope237["i"] = 0
	while JS.truthy(JS.compare("<", _scope237["i"], JS.get_property(self, "width"))):
		_scope237["j"] = 0
		while JS.truthy(JS.compare("<", _scope237["j"], JS.get_property(self, "height"))):
			JS.set_property(JS.get_property(_scope237["tileToWallConfiguration"], _scope237["i"]), _scope237["j"], JS.add(JS.add(JS.add(JS.bitwise("<<", JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope237["i"]), _scope237["j"]), 1), 0), JS.bitwise("<<", JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope237["i"]), _scope237["j"]), 2), 1)), JS.bitwise("<<", (JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope237["i"]), JS.add(_scope237["j"], 1)), 1) if JS.truthy(JS.compare("<", _scope237["j"], (JS.number(JS.get_property(self, "height")) - JS.number(1)))) else JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope237["i"]), _scope237["j"]), 0)), 2)), JS.bitwise("<<", (JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(_scope237["i"], 1)), _scope237["j"]), 2) if JS.truthy(JS.compare("<", _scope237["i"], (JS.number(JS.get_property(self, "width")) - JS.number(1)))) else JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope237["i"]), _scope237["j"]), 0)), 3)))
			JS.increment(_scope237, "j", 1, false)
		JS.increment(_scope237, "i", 1, false)
	_scope237["i"] = 0
	while JS.truthy(JS.compare("<", _scope237["i"], JS.get_property(self, "width"))):
		_scope237["j"] = 0
		while JS.truthy(JS.compare("<", _scope237["j"], JS.get_property(self, "height"))):
			_scope237["tilePresent"] = JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope237["i"]), _scope237["j"]), 0), 1, false)
			if JS.truthy(_scope237["tilePresent"]):
				_scope237["floor"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomFloor", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.get_property(JS.get_property(_scope237["tileToWallConfiguration"], _scope237["i"]), _scope237["j"])])
				if JS.truthy(_scope237["floor"]):
					JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "floors"), "push", [{"x": _scope237["i"], "y": _scope237["j"], "number": JS.get_property(_scope237["floor"], "number"), "orientation": JS.get_property(_scope237["floor"], "orientation")}])
				_scope237["wallDecoration"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomWallDecoration", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.get_property(JS.get_property(_scope237["tileToWallConfiguration"], _scope237["i"]), _scope237["j"])])
				if JS.truthy(_scope237["wallDecoration"]):
					JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "wallDecorations"), "push", [{"x": _scope237["i"], "y": _scope237["j"], "number": JS.get_property(_scope237["wallDecoration"], "number"), "orientation": JS.get_property(_scope237["wallDecoration"], "orientation")}])
			else:
				if JS.truthy(JS.logical("||", func():
					var _scope238: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(_scope237["tileToWallConfiguration"], _scope237["i"]), _scope237["j"]), 15, true)
					return null, func():
					var _scope239: Dictionary = {}
					return JS.invoke_method(self, "_isClosedOffSpace", [{"x": _scope237["i"], "y": _scope237["j"]}])
					return null)):
					_scope237["space"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomSpace", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.get_property(JS.get_property(_scope237["tileToWallConfiguration"], _scope237["i"]), _scope237["j"])])
					if JS.truthy(_scope237["space"]):
						JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "spaces"), "push", [{"x": _scope237["i"], "y": _scope237["j"], "number": JS.get_property(_scope237["space"], "number"), "orientation": JS.get_property(_scope237["space"], "orientation")}])
				else:
					_scope237["borders"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomBorders", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.get_property(JS.get_property(_scope237["tileToWallConfiguration"], _scope237["i"]), _scope237["j"])])
					_scope237["k"] = 0
					while JS.truthy(JS.compare("<", _scope237["k"], JS.get_property(_scope237["borders"], "length"))):
						_scope237["border"] = JS.get_property(_scope237["borders"], _scope237["k"])
						JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "borders"), "push", [{"x": _scope237["i"], "y": _scope237["j"], "number": JS.get_property(_scope237["border"], "number"), "orientation": JS.get_property(_scope237["border"], "orientation"), "flip": JS.get_property(_scope237["border"], "flip")}])
						JS.increment(_scope237, "k", 1, false)
			JS.increment(_scope237, "j", 1, false)
		JS.increment(_scope237, "i", 1, false)
	_scope237["i"] = 0
	while JS.truthy(JS.compare("<", _scope237["i"], JS.get_property(self, "width"))):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope237["i"]), 0), 1), 1, false)):
			_scope237["borders"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomBorders", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.bitwise("<<", 1, 2)])
			_scope237["k"] = 0
			while JS.truthy(JS.compare("<", _scope237["k"], JS.get_property(_scope237["borders"], "length"))):
				_scope237["border"] = JS.get_property(_scope237["borders"], _scope237["k"])
				JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "borders"), "push", [{"x": _scope237["i"], "y": -(1), "number": JS.get_property(_scope237["border"], "number"), "orientation": JS.get_property(_scope237["border"], "orientation"), "flip": JS.get_property(_scope237["border"], "flip")}])
				JS.increment(_scope237, "k", 1, false)
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope237["i"]), (JS.number(JS.get_property(self, "height")) - JS.number(1))), 0), 1, false)):
			_scope237["borders"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomBorders", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.bitwise("<<", 1, 0)])
			_scope237["k"] = 0
			while JS.truthy(JS.compare("<", _scope237["k"], JS.get_property(_scope237["borders"], "length"))):
				_scope237["border"] = JS.get_property(_scope237["borders"], _scope237["k"])
				JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "borders"), "push", [{"x": _scope237["i"], "y": JS.get_property(self, "height"), "number": JS.get_property(_scope237["border"], "number"), "orientation": JS.get_property(_scope237["border"], "orientation"), "flip": JS.get_property(_scope237["border"], "flip")}])
				JS.increment(_scope237, "k", 1, false)
		JS.increment(_scope237, "i", 1, false)
	_scope237["j"] = 0
	while JS.truthy(JS.compare("<", _scope237["j"], JS.get_property(self, "height"))):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), 0), _scope237["j"]), 2), 1, false)):
			_scope237["borders"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomBorders", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.bitwise("<<", 1, 3)])
			_scope237["k"] = 0
			while JS.truthy(JS.compare("<", _scope237["k"], JS.get_property(_scope237["borders"], "length"))):
				_scope237["border"] = JS.get_property(_scope237["borders"], _scope237["k"])
				JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "borders"), "push", [{"x": -(1), "y": _scope237["j"], "number": JS.get_property(_scope237["border"], "number"), "orientation": JS.get_property(_scope237["border"], "orientation"), "flip": JS.get_property(_scope237["border"], "flip")}])
				JS.increment(_scope237, "k", 1, false)
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), (JS.number(JS.get_property(self, "width")) - JS.number(1))), _scope237["j"]), 0), 1, false)):
			_scope237["borders"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomBorders", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.bitwise("<<", 1, 1)])
			_scope237["k"] = 0
			while JS.truthy(JS.compare("<", _scope237["k"], JS.get_property(_scope237["borders"], "length"))):
				_scope237["border"] = JS.get_property(_scope237["borders"], _scope237["k"])
				JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "borders"), "push", [{"x": JS.get_property(self, "width"), "y": _scope237["j"], "number": JS.get_property(_scope237["border"], "number"), "orientation": JS.get_property(_scope237["border"], "orientation"), "flip": JS.get_property(_scope237["border"], "flip")}])
				JS.increment(_scope237, "k", 1, false)
		JS.increment(_scope237, "j", 1, false)
	_scope237["i"] = 0
	while JS.truthy(JS.compare("<", _scope237["i"], JS.get_property(self, "width"))):
		_scope237["j"] = 0
		while JS.truthy(JS.compare("<", _scope237["j"], JS.get_property(self, "height"))):
			_scope237["walls"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomWalls", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.get_property(JS.get_property(_scope237["tileToWallConfiguration"], _scope237["i"]), _scope237["j"])])
			_scope237["k"] = 0
			while JS.truthy(JS.compare("<", _scope237["k"], JS.get_property(_scope237["walls"], "length"))):
				_scope237["wall"] = JS.get_property(_scope237["walls"], _scope237["k"])
				JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "walls"), "push", [{"x": _scope237["i"], "y": _scope237["j"], "number": JS.get_property(_scope237["wall"], "number"), "rotate": JS.get_property(_scope237["wall"], "rotate"), "flipX": JS.get_property(_scope237["wall"], "flipX"), "flipY": JS.get_property(_scope237["wall"], "flipY")}])
				JS.increment(_scope237, "k", 1, false)
			JS.increment(_scope237, "j", 1, false)
		JS.increment(_scope237, "i", 1, false)
	_scope237["i"] = 0
	while JS.truthy(JS.compare("<", _scope237["i"], JS.get_property(self, "width"))):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope237["i"]), (JS.number(JS.get_property(self, "height")) - JS.number(1))), 0), 1, false)):
			_scope237["walls"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomWalls", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.bitwise("<<", 1, 0)])
			_scope237["k"] = 0
			while JS.truthy(JS.compare("<", _scope237["k"], JS.get_property(_scope237["walls"], "length"))):
				_scope237["wall"] = JS.get_property(_scope237["walls"], _scope237["k"])
				JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "walls"), "push", [{"x": _scope237["i"], "y": JS.get_property(self, "height"), "number": JS.get_property(_scope237["wall"], "number"), "rotate": JS.get_property(_scope237["wall"], "rotate"), "flipX": JS.get_property(_scope237["wall"], "flipX"), "flipY": JS.get_property(_scope237["wall"], "flipY")}])
				JS.increment(_scope237, "k", 1, false)
		JS.increment(_scope237, "i", 1, false)
	_scope237["j"] = 0
	while JS.truthy(JS.compare("<", _scope237["j"], JS.get_property(self, "height"))):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), (JS.number(JS.get_property(self, "width")) - JS.number(1))), _scope237["j"]), 0), 1, false)):
			_scope237["walls"] = JS.invoke_method(JS.module("MazeThemeManager"), "getRandomWalls", [JS.get_property(JS.get_property(self, "data"), "theme"), JS.bitwise("<<", 1, 1)])
			_scope237["k"] = 0
			while JS.truthy(JS.compare("<", _scope237["k"], JS.get_property(_scope237["walls"], "length"))):
				_scope237["wall"] = JS.get_property(_scope237["walls"], _scope237["k"])
				JS.invoke_method(JS.get_property(JS.get_property(self, "data"), "walls"), "push", [{"x": JS.get_property(self, "width"), "y": _scope237["j"], "number": JS.get_property(_scope237["wall"], "number"), "rotate": JS.get_property(_scope237["wall"], "rotate"), "flipX": JS.get_property(_scope237["wall"], "flipX"), "flipY": JS.get_property(_scope237["wall"], "flipY")}])
				JS.increment(_scope237, "k", 1, false)
		JS.increment(_scope237, "j", 1, false)
	return null

func original__isClosedOffSpace(_arg0 = null):
	var _scope240: Dictionary = {"startPosition": _arg0, "alreadyAddedToWorklist": null, "i": null, "worklist": null, "current": null}
	_scope240["alreadyAddedToWorklist"] = JS.construct("@Array", [JS.get_property(self, "width")])
	_scope240["i"] = 0
	while JS.truthy(JS.compare("<", _scope240["i"], JS.get_property(self, "width"))):
		JS.set_property(_scope240["alreadyAddedToWorklist"], _scope240["i"], JS.construct("@Array", [JS.get_property(self, "height")]))
		JS.increment(_scope240, "i", 1, false)
	_scope240["worklist"] = []
	JS.invoke_method(_scope240["worklist"], "push", [{"x": JS.get_property(_scope240["startPosition"], "x"), "y": JS.get_property(_scope240["startPosition"], "y")}])
	JS.set_property(JS.get_property(_scope240["alreadyAddedToWorklist"], JS.get_property(_scope240["startPosition"], "x")), JS.get_property(_scope240["startPosition"], "y"), true)
	while JS.truthy(JS.compare(">", JS.get_property(_scope240["worklist"], "length"), 0)):
		_scope240["current"] = JS.invoke_method(_scope240["worklist"], "pop", [])
		if JS.truthy(JS.logical("||", func():
			var _scope241: Dictionary = {}
			return JS.logical("||", func():
				var _scope242: Dictionary = {}
				return JS.logical("||", func():
					var _scope243: Dictionary = {}
					return JS.equal(JS.get_property(_scope240["current"], "x"), 0, false)
					return null, func():
					var _scope244: Dictionary = {}
					return JS.equal(JS.get_property(_scope240["current"], "x"), (JS.number(JS.get_property(self, "width")) - JS.number(1)), false)
					return null)
				return null, func():
				var _scope245: Dictionary = {}
				return JS.equal(JS.get_property(_scope240["current"], "y"), 0, false)
				return null)
			return null, func():
			var _scope246: Dictionary = {}
			return JS.equal(JS.get_property(_scope240["current"], "y"), (JS.number(JS.get_property(self, "height")) - JS.number(1)), false)
			return null)):
			return false
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope240["current"], "x")), JS.get_property(_scope240["current"], "y")), 2), 0, false)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope240["alreadyAddedToWorklist"], (JS.number(JS.get_property(_scope240["current"], "x")) - JS.number(1))), JS.get_property(_scope240["current"], "y")), null, true)):
				JS.set_property(JS.get_property(_scope240["alreadyAddedToWorklist"], (JS.number(JS.get_property(_scope240["current"], "x")) - JS.number(1))), JS.get_property(_scope240["current"], "y"), true)
				JS.invoke_method(_scope240["worklist"], "push", [{"x": (JS.number(JS.get_property(_scope240["current"], "x")) - JS.number(1)), "y": JS.get_property(_scope240["current"], "y")}])
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope240["current"], "x"), 1)), JS.get_property(_scope240["current"], "y")), 2), 0, false)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope240["alreadyAddedToWorklist"], JS.add(JS.get_property(_scope240["current"], "x"), 1)), JS.get_property(_scope240["current"], "y")), null, true)):
				JS.set_property(JS.get_property(_scope240["alreadyAddedToWorklist"], JS.add(JS.get_property(_scope240["current"], "x"), 1)), JS.get_property(_scope240["current"], "y"), true)
				JS.invoke_method(_scope240["worklist"], "push", [{"x": JS.add(JS.get_property(_scope240["current"], "x"), 1), "y": JS.get_property(_scope240["current"], "y")}])
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope240["current"], "x")), JS.add(JS.get_property(_scope240["current"], "y"), 1)), 1), 0, false)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope240["alreadyAddedToWorklist"], JS.get_property(_scope240["current"], "x")), JS.add(JS.get_property(_scope240["current"], "y"), 1)), null, true)):
				JS.set_property(JS.get_property(_scope240["alreadyAddedToWorklist"], JS.get_property(_scope240["current"], "x")), JS.add(JS.get_property(_scope240["current"], "y"), 1), true)
				JS.invoke_method(_scope240["worklist"], "push", [{"x": JS.get_property(_scope240["current"], "x"), "y": JS.add(JS.get_property(_scope240["current"], "y"), 1)}])
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope240["current"], "x")), JS.get_property(_scope240["current"], "y")), 1), 0, false)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope240["alreadyAddedToWorklist"], JS.get_property(_scope240["current"], "x")), (JS.number(JS.get_property(_scope240["current"], "y")) - JS.number(1))), null, true)):
				JS.set_property(JS.get_property(_scope240["alreadyAddedToWorklist"], JS.get_property(_scope240["current"], "x")), (JS.number(JS.get_property(_scope240["current"], "y")) - JS.number(1)), true)
				JS.invoke_method(_scope240["worklist"], "push", [{"x": JS.get_property(_scope240["current"], "x"), "y": (JS.number(JS.get_property(_scope240["current"], "y")) - JS.number(1))}])
	return true
	return null

func original__calculateTileBounds():
	var _scope247: Dictionary = {"i": null, "j": null}
	JS.set_property(self, "tileBounds", {"minX": JS.get_property(self, "width"), "minY": JS.get_property(self, "height"), "maxX": 0, "maxY": 0})
	_scope247["i"] = 0
	while JS.truthy(JS.compare("<", _scope247["i"], JS.get_property(self, "width"))):
		_scope247["j"] = 0
		while JS.truthy(JS.compare("<", _scope247["j"], JS.get_property(self, "height"))):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), _scope247["i"]), _scope247["j"]), 0), 1, false)):
				JS.set_property(JS.get_property(self, "tileBounds"), "minX", JS.invoke_method("@Math", "min", [_scope247["i"], JS.get_property(JS.get_property(self, "tileBounds"), "minX")]))
				JS.set_property(JS.get_property(self, "tileBounds"), "minY", JS.invoke_method("@Math", "min", [_scope247["j"], JS.get_property(JS.get_property(self, "tileBounds"), "minY")]))
				JS.set_property(JS.get_property(self, "tileBounds"), "maxX", JS.invoke_method("@Math", "max", [_scope247["i"], JS.get_property(JS.get_property(self, "tileBounds"), "maxX")]))
				JS.set_property(JS.get_property(self, "tileBounds"), "maxY", JS.invoke_method("@Math", "max", [_scope247["j"], JS.get_property(JS.get_property(self, "tileBounds"), "maxY")]))
			JS.increment(_scope247, "j", 1, false)
		JS.increment(_scope247, "i", 1, false)
	return null

func original__calculateDistances():
	var _scope248: Dictionary = {"i": null, "j": null}
	JS.set_property(self, "distances", JS.construct("@Array", [JS.get_property(self, "width")]))
	_scope248["i"] = 0
	while JS.truthy(JS.compare("<", _scope248["i"], JS.get_property(self, "width"))):
		JS.set_property(JS.get_property(self, "distances"), _scope248["i"], JS.construct("@Array", [JS.get_property(self, "height")]))
		_scope248["j"] = 0
		while JS.truthy(JS.compare("<", _scope248["j"], JS.get_property(self, "height"))):
			JS.set_property(JS.get_property(JS.get_property(self, "distances"), _scope248["i"]), _scope248["j"], null)
			JS.increment(_scope248, "j", 1, false)
		JS.increment(_scope248, "i", 1, false)
	_scope248["i"] = 0
	while JS.truthy(JS.compare("<", _scope248["i"], JS.get_property(JS.get_property(self, "reachable"), "length"))):
		JS.set_property(JS.get_property(JS.get_property(self, "distances"), JS.get_property(JS.get_property(JS.get_property(self, "reachable"), _scope248["i"]), "x")), JS.get_property(JS.get_property(JS.get_property(self, "reachable"), _scope248["i"]), "y"), JS.invoke_method(self, "_calculateDistancesFromPosition", [JS.get_property(JS.get_property(self, "reachable"), _scope248["i"])]))
		JS.increment(_scope248, "i", 1, false)
	return null

func original__calculateDistancesFromPosition(_arg0 = null):
	var _scope249: Dictionary = {"position": _arg0, "result": null, "i": null, "j": null}
	_scope249["result"] = JS.construct("@Array", [JS.get_property(self, "width")])
	_scope249["i"] = 0
	while JS.truthy(JS.compare("<", _scope249["i"], JS.get_property(self, "width"))):
		JS.set_property(_scope249["result"], _scope249["i"], JS.construct("@Array", [JS.get_property(self, "height")]))
		_scope249["j"] = 0
		while JS.truthy(JS.compare("<", _scope249["j"], JS.get_property(self, "height"))):
			JS.set_property(JS.get_property(_scope249["result"], _scope249["i"]), _scope249["j"], JS.get_property("@Number", "MAX_VALUE"))
			JS.increment(_scope249, "j", 1, false)
		JS.increment(_scope249, "i", 1, false)
	JS.invoke_method(self, "_traverseCloseTiles", [_scope249["position"], JS.get_property("@Number", "MAX_VALUE"), JS.get_property(self, "width"), JS.get_property(self, "height"), func(_arg0 = null):
		var _scope250: Dictionary = {"current": _arg0}
		JS.set_property(JS.get_property(_scope249["result"], JS.get_property(_scope250["current"], "x")), JS.get_property(_scope250["current"], "y"), JS.get_property(_scope250["current"], "distance"))
		return null])
	return _scope249["result"]
	return null

func original_getGradientPath(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope251: Dictionary = {"startPosition": _arg0, "maxLength": _arg1, "gradientFn": _arg2, "result": null, "currentValue": null, "current": null, "nextValue": null, "next": null, "foundPath": null, "value": null}
	_scope251["result"] = []
	_scope251["currentValue"] = JS.invoke(_scope251["gradientFn"], [_scope251["startPosition"]])
	_scope251["current"] = _scope251["startPosition"]
	_scope251["nextValue"] = 0
	_scope251["next"] = null
	_scope251["foundPath"] = true
	while JS.truthy(JS.logical("&&", func():
		var _scope252: Dictionary = {}
		return JS.compare(">", _scope251["maxLength"], 0)
		return null, func():
		var _scope253: Dictionary = {}
		return _scope251["foundPath"]
		return null)):
		JS.set_property(_scope251, "foundPath", false)
		if JS.truthy(JS.logical("&&", func():
			var _scope254: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope251["current"], "x"), 0)
			return null, func():
			var _scope255: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.get_property(_scope251["current"], "y")), 2), 0, false)
			return null)):
			_scope251["value"] = JS.invoke(_scope251["gradientFn"], [{"x": (JS.number(JS.get_property(_scope251["current"], "x")) - JS.number(1)), "y": JS.get_property(_scope251["current"], "y")}])
			if JS.truthy(JS.compare(">", _scope251["value"], _scope251["currentValue"])):
				JS.set_property(_scope251, "currentValue", _scope251["value"])
				JS.set_property(_scope251, "next", {"x": (JS.number(JS.get_property(_scope251["current"], "x")) - JS.number(1)), "y": JS.get_property(_scope251["current"], "y")})
				JS.set_property(_scope251, "foundPath", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope256: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope251["current"], "x"), (JS.number(JS.get_property(self, "width")) - JS.number(1)))
			return null, func():
			var _scope257: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope251["current"], "x"), 1)), JS.get_property(_scope251["current"], "y")), 2), 0, false)
			return null)):
			_scope251["value"] = JS.invoke(_scope251["gradientFn"], [{"x": JS.add(JS.get_property(_scope251["current"], "x"), 1), "y": JS.get_property(_scope251["current"], "y")}])
			if JS.truthy(JS.compare(">", _scope251["value"], _scope251["currentValue"])):
				JS.set_property(_scope251, "currentValue", _scope251["value"])
				JS.set_property(_scope251, "next", {"x": JS.add(JS.get_property(_scope251["current"], "x"), 1), "y": JS.get_property(_scope251["current"], "y")})
				JS.set_property(_scope251, "foundPath", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope258: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope251["current"], "y"), (JS.number(JS.get_property(self, "height")) - JS.number(1)))
			return null, func():
			var _scope259: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.add(JS.get_property(_scope251["current"], "y"), 1)), 1), 0, false)
			return null)):
			_scope251["value"] = JS.invoke(_scope251["gradientFn"], [{"x": JS.get_property(_scope251["current"], "x"), "y": JS.add(JS.get_property(_scope251["current"], "y"), 1)}])
			if JS.truthy(JS.compare(">", _scope251["value"], _scope251["currentValue"])):
				JS.set_property(_scope251, "currentValue", _scope251["value"])
				JS.set_property(_scope251, "next", {"x": JS.get_property(_scope251["current"], "x"), "y": JS.add(JS.get_property(_scope251["current"], "y"), 1)})
				JS.set_property(_scope251, "foundPath", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope260: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope251["current"], "y"), 0)
			return null, func():
			var _scope261: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.get_property(_scope251["current"], "y")), 1), 0, false)
			return null)):
			_scope251["value"] = JS.invoke(_scope251["gradientFn"], [{"x": JS.get_property(_scope251["current"], "x"), "y": (JS.number(JS.get_property(_scope251["current"], "y")) - JS.number(1))}])
			if JS.truthy(JS.compare(">", _scope251["value"], _scope251["currentValue"])):
				JS.set_property(_scope251, "currentValue", _scope251["value"])
				JS.set_property(_scope251, "next", {"x": JS.get_property(_scope251["current"], "x"), "y": (JS.number(JS.get_property(_scope251["current"], "y")) - JS.number(1))})
				JS.set_property(_scope251, "foundPath", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope262: Dictionary = {}
			return JS.logical("&&", func():
				var _scope263: Dictionary = {}
				return JS.logical("&&", func():
					var _scope264: Dictionary = {}
					return JS.logical("&&", func():
						var _scope265: Dictionary = {}
						return JS.logical("&&", func():
							var _scope266: Dictionary = {}
							return JS.compare(">", JS.get_property(_scope251["current"], "x"), 0)
							return null, func():
							var _scope267: Dictionary = {}
							return JS.compare("<", JS.get_property(_scope251["current"], "y"), (JS.number(JS.get_property(self, "height")) - JS.number(1)))
							return null)
						return null, func():
						var _scope268: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.get_property(_scope251["current"], "y")), 2), 0, false)
						return null)
					return null, func():
					var _scope269: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.add(JS.get_property(_scope251["current"], "y"), 1)), 2), 0, false)
					return null)
				return null, func():
				var _scope270: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.add(JS.get_property(_scope251["current"], "y"), 1)), 1), 0, false)
				return null)
			return null, func():
			var _scope271: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), (JS.number(JS.get_property(_scope251["current"], "x")) - JS.number(1))), JS.add(JS.get_property(_scope251["current"], "y"), 1)), 1), 0, false)
			return null)):
			_scope251["value"] = JS.invoke(_scope251["gradientFn"], [{"x": (JS.number(JS.get_property(_scope251["current"], "x")) - JS.number(1)), "y": JS.add(JS.get_property(_scope251["current"], "y"), 1)}])
			if JS.truthy(JS.compare(">", _scope251["value"], _scope251["currentValue"])):
				JS.set_property(_scope251, "currentValue", _scope251["value"])
				JS.set_property(_scope251, "next", {"x": (JS.number(JS.get_property(_scope251["current"], "x")) - JS.number(1)), "y": JS.add(JS.get_property(_scope251["current"], "y"), 1)})
				JS.set_property(_scope251, "foundPath", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope272: Dictionary = {}
			return JS.logical("&&", func():
				var _scope273: Dictionary = {}
				return JS.logical("&&", func():
					var _scope274: Dictionary = {}
					return JS.logical("&&", func():
						var _scope275: Dictionary = {}
						return JS.logical("&&", func():
							var _scope276: Dictionary = {}
							return JS.compare("<", JS.get_property(_scope251["current"], "x"), (JS.number(JS.get_property(self, "width")) - JS.number(1)))
							return null, func():
							var _scope277: Dictionary = {}
							return JS.compare("<", JS.get_property(_scope251["current"], "y"), (JS.number(JS.get_property(self, "height")) - JS.number(1)))
							return null)
						return null, func():
						var _scope278: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope251["current"], "x"), 1)), JS.get_property(_scope251["current"], "y")), 2), 0, false)
						return null)
					return null, func():
					var _scope279: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope251["current"], "x"), 1)), JS.add(JS.get_property(_scope251["current"], "y"), 1)), 2), 0, false)
					return null)
				return null, func():
				var _scope280: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.add(JS.get_property(_scope251["current"], "y"), 1)), 1), 0, false)
				return null)
			return null, func():
			var _scope281: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope251["current"], "x"), 1)), JS.add(JS.get_property(_scope251["current"], "y"), 1)), 1), 0, false)
			return null)):
			_scope251["value"] = JS.invoke(_scope251["gradientFn"], [{"x": JS.add(JS.get_property(_scope251["current"], "x"), 1), "y": JS.add(JS.get_property(_scope251["current"], "y"), 1)}])
			if JS.truthy(JS.compare(">", _scope251["value"], _scope251["currentValue"])):
				JS.set_property(_scope251, "currentValue", _scope251["value"])
				JS.set_property(_scope251, "next", {"x": JS.add(JS.get_property(_scope251["current"], "x"), 1), "y": JS.add(JS.get_property(_scope251["current"], "y"), 1)})
				JS.set_property(_scope251, "foundPath", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope282: Dictionary = {}
			return JS.logical("&&", func():
				var _scope283: Dictionary = {}
				return JS.logical("&&", func():
					var _scope284: Dictionary = {}
					return JS.logical("&&", func():
						var _scope285: Dictionary = {}
						return JS.logical("&&", func():
							var _scope286: Dictionary = {}
							return JS.compare(">", JS.get_property(_scope251["current"], "x"), 0)
							return null, func():
							var _scope287: Dictionary = {}
							return JS.compare(">", JS.get_property(_scope251["current"], "y"), 0)
							return null)
						return null, func():
						var _scope288: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.get_property(_scope251["current"], "y")), 2), 0, false)
						return null)
					return null, func():
					var _scope289: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), (JS.number(JS.get_property(_scope251["current"], "y")) - JS.number(1))), 2), 0, false)
					return null)
				return null, func():
				var _scope290: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.get_property(_scope251["current"], "y")), 1), 0, false)
				return null)
			return null, func():
			var _scope291: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), (JS.number(JS.get_property(_scope251["current"], "x")) - JS.number(1))), JS.get_property(_scope251["current"], "y")), 1), 0, false)
			return null)):
			_scope251["value"] = JS.invoke(_scope251["gradientFn"], [{"x": (JS.number(JS.get_property(_scope251["current"], "x")) - JS.number(1)), "y": (JS.number(JS.get_property(_scope251["current"], "y")) - JS.number(1))}])
			if JS.truthy(JS.compare(">", _scope251["value"], _scope251["currentValue"])):
				JS.set_property(_scope251, "currentValue", _scope251["value"])
				JS.set_property(_scope251, "next", {"x": (JS.number(JS.get_property(_scope251["current"], "x")) - JS.number(1)), "y": (JS.number(JS.get_property(_scope251["current"], "y")) - JS.number(1))})
				JS.set_property(_scope251, "foundPath", true)
		if JS.truthy(JS.logical("&&", func():
			var _scope292: Dictionary = {}
			return JS.logical("&&", func():
				var _scope293: Dictionary = {}
				return JS.logical("&&", func():
					var _scope294: Dictionary = {}
					return JS.logical("&&", func():
						var _scope295: Dictionary = {}
						return JS.logical("&&", func():
							var _scope296: Dictionary = {}
							return JS.compare("<", JS.get_property(_scope251["current"], "x"), (JS.number(JS.get_property(self, "width")) - JS.number(1)))
							return null, func():
							var _scope297: Dictionary = {}
							return JS.compare(">", JS.get_property(_scope251["current"], "y"), 0)
							return null)
						return null, func():
						var _scope298: Dictionary = {}
						return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope251["current"], "x"), 1)), JS.get_property(_scope251["current"], "y")), 2), 0, false)
						return null)
					return null, func():
					var _scope299: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope251["current"], "x"), 1)), (JS.number(JS.get_property(_scope251["current"], "y")) - JS.number(1))), 2), 0, false)
					return null)
				return null, func():
				var _scope300: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope251["current"], "x")), JS.get_property(_scope251["current"], "y")), 1), 0, false)
				return null)
			return null, func():
			var _scope301: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope251["current"], "x"), 1)), JS.get_property(_scope251["current"], "y")), 1), 0, false)
			return null)):
			_scope251["value"] = JS.invoke(_scope251["gradientFn"], [{"x": JS.add(JS.get_property(_scope251["current"], "x"), 1), "y": (JS.number(JS.get_property(_scope251["current"], "y")) - JS.number(1))}])
			if JS.truthy(JS.compare(">", _scope251["value"], _scope251["currentValue"])):
				JS.set_property(_scope251, "currentValue", _scope251["value"])
				JS.set_property(_scope251, "next", {"x": JS.add(JS.get_property(_scope251["current"], "x"), 1), "y": (JS.number(JS.get_property(_scope251["current"], "y")) - JS.number(1))})
				JS.set_property(_scope251, "foundPath", true)
		if JS.truthy(_scope251["foundPath"]):
			JS.invoke_method(_scope251["result"], "push", [_scope251["next"]])
		JS.increment(_scope251, "maxLength", -1, false)
		JS.set_property(_scope251, "current", _scope251["next"])
	return _scope251["result"]
	return null

func original_getPathAwayFrom(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope302: Dictionary = {"startPosition": _arg0, "fromPosition": _arg1, "maxLength": _arg2, "deadEndWeight": _arg3, "distances": null, "self": null, "path": null}
	_scope302["distances"] = JS.get_property(JS.get_property(JS.get_property(self, "distances"), JS.get_property(_scope302["fromPosition"], "x")), JS.get_property(_scope302["fromPosition"], "y"))
	_scope302["self"] = self
	_scope302["path"] = JS.invoke_method(self, "getGradientPath", [_scope302["startPosition"], _scope302["maxLength"], func(_arg0 = null):
		var _scope303: Dictionary = {"current": _arg0}
		return (JS.number(JS.get_property(JS.get_property(_scope302["distances"], JS.get_property(_scope303["current"], "x")), JS.get_property(_scope303["current"], "y"))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(_scope302["self"], "deadEndPenalties"), JS.get_property(_scope303["current"], "x")), JS.get_property(_scope303["current"], "y"))) * JS.number(_scope302["deadEndWeight"]))))
		return null])
	return _scope302["path"]
	return null

func original_getPathAwayFromWithThreats(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope304: Dictionary = {"startPosition": _arg0, "fromPosition": _arg1, "maxLength": _arg2, "deadEndWeight": _arg3, "threatMap": _arg4, "threatWeight": _arg5, "distances": null, "self": null, "path": null}
	_scope304["distances"] = JS.get_property(JS.get_property(JS.get_property(self, "distances"), JS.get_property(_scope304["fromPosition"], "x")), JS.get_property(_scope304["fromPosition"], "y"))
	_scope304["self"] = self
	_scope304["path"] = JS.invoke_method(self, "getGradientPath", [_scope304["startPosition"], _scope304["maxLength"], func(_arg0 = null):
		var _scope305: Dictionary = {"current": _arg0}
		return (JS.number((JS.number(JS.get_property(JS.get_property(_scope304["distances"], JS.get_property(_scope305["current"], "x")), JS.get_property(_scope305["current"], "y"))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(_scope304["self"], "deadEndPenalties"), JS.get_property(_scope305["current"], "x")), JS.get_property(_scope305["current"], "y"))) * JS.number(_scope304["deadEndWeight"]))))) - JS.number((JS.number(JS.invoke_method(_scope304["threatMap"], "get", [_scope305["current"]])) * JS.number(_scope304["threatWeight"]))))
		return null])
	return _scope304["path"]
	return null

func original_getPathAwayWithMultipleDistancesAndThreats(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope306: Dictionary = {"startPosition": _arg0, "maxLength": _arg1, "deadEndWeight": _arg2, "distancesArray": _arg3, "threatMap": _arg4, "threatWeight": _arg5, "self": null, "path": null}
	_scope306["self"] = self
	_scope306["path"] = JS.invoke_method(self, "getGradientPath", [_scope306["startPosition"], _scope306["maxLength"], func(_arg0 = null):
		var _scope307: Dictionary = {"current": _arg0, "distance": null, "i": null}
		_scope307["distance"] = 0
		_scope307["i"] = 0
		while JS.truthy(JS.compare("<", _scope307["i"], JS.get_property(_scope306["distancesArray"], "length"))):
			JS.set_property(_scope307, "distance", JS.add(_scope307["distance"], JS.get_property(JS.get_property(JS.get_property(_scope306["distancesArray"], _scope307["i"]), JS.get_property(_scope307["current"], "x")), JS.get_property(_scope307["current"], "y"))))
			JS.increment(_scope307, "i", 1, false)
		JS.set_property(_scope307, "distance", (JS.number(_scope307["distance"]) / JS.number(JS.get_property(_scope306["distancesArray"], "length"))))
		return (JS.number((JS.number(_scope307["distance"]) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(_scope306["self"], "deadEndPenalties"), JS.get_property(_scope307["current"], "x")), JS.get_property(_scope307["current"], "y"))) * JS.number(_scope306["deadEndWeight"]))))) - JS.number((JS.number(JS.invoke_method(_scope306["threatMap"], "get", [_scope307["current"]])) * JS.number(_scope306["threatWeight"]))))
		return null])
	return _scope306["path"]
	return null

func original_getShortestPathWithGraph(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope308: Dictionary = {"startPosition": _arg0, "endPosition": _arg1, "weights": _arg2, "lengthWeight": _arg3, "result": null}
	_scope308["result"] = null
	if JS.truthy(not JS.equal(_scope308["weights"], null, true)):
		JS.set_property(_scope308, "result", JS.invoke_method(JS.get_property(self, "dijkstra"), "shortestPath", [JS.get_property(JS.get_property(JS.get_property(self, "vertices"), JS.get_property(_scope308["startPosition"], "x")), JS.get_property(_scope308["startPosition"], "y")), JS.get_property(JS.get_property(JS.get_property(self, "vertices"), JS.get_property(_scope308["endPosition"], "x")), JS.get_property(_scope308["endPosition"], "y")), {"edgeCost": func(_arg0 = null):
			var _scope309: Dictionary = {"e": _arg0}
			return JS.add(JS.get_property(JS.get_property(_scope308["weights"], JS.get_property(JS.get_property(_scope309["e"], "data"), "x")), JS.get_property(JS.get_property(_scope309["e"], "data"), "y")), (JS.number(JS.get_property(JS.get_property(_scope309["e"], "data"), "length")) * JS.number(_scope308["lengthWeight"])))
			return null}]))
	else:
		JS.set_property(_scope308, "result", JS.invoke_method(JS.get_property(self, "dijkstra"), "shortestPath", [JS.get_property(JS.get_property(JS.get_property(self, "vertices"), JS.get_property(_scope308["startPosition"], "x")), JS.get_property(_scope308["startPosition"], "y")), JS.get_property(JS.get_property(JS.get_property(self, "vertices"), JS.get_property(_scope308["endPosition"], "x")), JS.get_property(_scope308["endPosition"], "y")), {"edgeCost": func(_arg0 = null):
			var _scope310: Dictionary = {"e": _arg0}
			return JS.get_property(JS.get_property(_scope310["e"], "data"), "length")
			return null}]))
	if JS.truthy(not JS.equal(_scope308["result"], null, true)):
		return JS.invoke_method(_scope308["result"], "map", [func(_arg0 = null):
			var _scope311: Dictionary = {"e": _arg0}
			return JS.get_property(_scope311["e"], "data")
			return null])
	else:
		return []
	return null

func original__calculateDeadEndPenalties():
	var _scope312: Dictionary = {"result": null, "i": null, "j": null, "worklist": null, "current": null, "numExits": null, "next": null, "penalty": null}
	_scope312["result"] = JS.construct("@Array", [JS.get_property(self, "width")])
	_scope312["i"] = 0
	while JS.truthy(JS.compare("<", _scope312["i"], JS.get_property(self, "width"))):
		JS.set_property(_scope312["result"], _scope312["i"], JS.construct("@Array", [JS.get_property(self, "height")]))
		_scope312["j"] = 0
		while JS.truthy(JS.compare("<", _scope312["j"], JS.get_property(self, "height"))):
			JS.set_property(JS.get_property(_scope312["result"], _scope312["i"]), _scope312["j"], 0)
			JS.increment(_scope312, "j", 1, false)
		JS.increment(_scope312, "i", 1, false)
	_scope312["worklist"] = []
	_scope312["i"] = 0
	while JS.truthy(JS.compare("<", _scope312["i"], JS.get_property(JS.get_property(self, "reachable"), "length"))):
		_scope312["current"] = JS.get_property(JS.get_property(self, "reachable"), _scope312["i"])
		_scope312["numExits"] = 0
		if JS.truthy(JS.logical("&&", func():
			var _scope313: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope312["current"], "x"), 0)
			return null, func():
			var _scope314: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope312["current"], "x")), JS.get_property(_scope312["current"], "y")), 2), 0, false)
			return null)):
			JS.increment(_scope312, "numExits", 1, false)
		if JS.truthy(JS.logical("&&", func():
			var _scope315: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope312["current"], "x"), (JS.number(JS.get_property(self, "width")) - JS.number(1)))
			return null, func():
			var _scope316: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope312["current"], "x"), 1)), JS.get_property(_scope312["current"], "y")), 2), 0, false)
			return null)):
			JS.increment(_scope312, "numExits", 1, false)
		if JS.truthy(JS.logical("&&", func():
			var _scope317: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope312["current"], "y"), (JS.number(JS.get_property(self, "height")) - JS.number(1)))
			return null, func():
			var _scope318: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope312["current"], "x")), JS.add(JS.get_property(_scope312["current"], "y"), 1)), 1), 0, false)
			return null)):
			JS.increment(_scope312, "numExits", 1, false)
		if JS.truthy(JS.logical("&&", func():
			var _scope319: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope312["current"], "y"), 0)
			return null, func():
			var _scope320: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope312["current"], "x")), JS.get_property(_scope312["current"], "y")), 1), 0, false)
			return null)):
			JS.increment(_scope312, "numExits", 1, false)
		if JS.truthy(JS.equal(_scope312["numExits"], 1, false)):
			JS.invoke_method(_scope312["worklist"], "push", [{"x": JS.get_property(_scope312["current"], "x"), "y": JS.get_property(_scope312["current"], "y")}])
		JS.increment(_scope312, "i", 1, false)
	while JS.truthy(JS.compare(">", JS.get_property(_scope312["worklist"], "length"), 0)):
		_scope312["current"] = JS.invoke_method(_scope312["worklist"], "shift", [])
		_scope312["numExits"] = 0
		_scope312["next"] = null
		_scope312["penalty"] = JS.get_property(JS.module("Constants"), "MAZE_MAX_DEAD_END_PENALTY")
		if JS.truthy(JS.logical("&&", func():
			var _scope321: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope312["current"], "x"), 0)
			return null, func():
			var _scope322: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope312["current"], "x")), JS.get_property(_scope312["current"], "y")), 2), 0, false)
			return null)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope312["result"], (JS.number(JS.get_property(_scope312["current"], "x")) - JS.number(1))), JS.get_property(_scope312["current"], "y")), 0, false)):
				JS.increment(_scope312, "numExits", 1, false)
				JS.set_property(_scope312, "next", {"x": (JS.number(JS.get_property(_scope312["current"], "x")) - JS.number(1)), "y": JS.get_property(_scope312["current"], "y")})
			else:
				JS.set_property(_scope312, "penalty", JS.invoke_method("@Math", "max", [1, JS.invoke_method("@Math", "min", [_scope312["penalty"], (JS.number(JS.get_property(JS.get_property(_scope312["result"], (JS.number(JS.get_property(_scope312["current"], "x")) - JS.number(1))), JS.get_property(_scope312["current"], "y"))) - JS.number(1))])]))
		if JS.truthy(JS.logical("&&", func():
			var _scope323: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope312["current"], "x"), (JS.number(JS.get_property(self, "width")) - JS.number(1)))
			return null, func():
			var _scope324: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.add(JS.get_property(_scope312["current"], "x"), 1)), JS.get_property(_scope312["current"], "y")), 2), 0, false)
			return null)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope312["result"], JS.add(JS.get_property(_scope312["current"], "x"), 1)), JS.get_property(_scope312["current"], "y")), 0, false)):
				JS.increment(_scope312, "numExits", 1, false)
				JS.set_property(_scope312, "next", {"x": JS.add(JS.get_property(_scope312["current"], "x"), 1), "y": JS.get_property(_scope312["current"], "y")})
			else:
				JS.set_property(_scope312, "penalty", JS.invoke_method("@Math", "max", [1, JS.invoke_method("@Math", "min", [_scope312["penalty"], (JS.number(JS.get_property(JS.get_property(_scope312["result"], JS.add(JS.get_property(_scope312["current"], "x"), 1)), JS.get_property(_scope312["current"], "y"))) - JS.number(1))])]))
		if JS.truthy(JS.logical("&&", func():
			var _scope325: Dictionary = {}
			return JS.compare("<", JS.get_property(_scope312["current"], "y"), (JS.number(JS.get_property(self, "height")) - JS.number(1)))
			return null, func():
			var _scope326: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope312["current"], "x")), JS.add(JS.get_property(_scope312["current"], "y"), 1)), 1), 0, false)
			return null)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope312["result"], JS.get_property(_scope312["current"], "x")), JS.add(JS.get_property(_scope312["current"], "y"), 1)), 0, false)):
				JS.increment(_scope312, "numExits", 1, false)
				JS.set_property(_scope312, "next", {"x": JS.get_property(_scope312["current"], "x"), "y": JS.add(JS.get_property(_scope312["current"], "y"), 1)})
			else:
				JS.set_property(_scope312, "penalty", JS.invoke_method("@Math", "max", [1, JS.invoke_method("@Math", "min", [_scope312["penalty"], (JS.number(JS.get_property(JS.get_property(_scope312["result"], JS.get_property(_scope312["current"], "x")), JS.add(JS.get_property(_scope312["current"], "y"), 1))) - JS.number(1))])]))
		if JS.truthy(JS.logical("&&", func():
			var _scope327: Dictionary = {}
			return JS.compare(">", JS.get_property(_scope312["current"], "y"), 0)
			return null, func():
			var _scope328: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "data"), "tiles"), JS.get_property(_scope312["current"], "x")), JS.get_property(_scope312["current"], "y")), 1), 0, false)
			return null)):
			if JS.truthy(JS.equal(JS.get_property(JS.get_property(_scope312["result"], JS.get_property(_scope312["current"], "x")), (JS.number(JS.get_property(_scope312["current"], "y")) - JS.number(1))), 0, false)):
				JS.increment(_scope312, "numExits", 1, false)
				JS.set_property(_scope312, "next", {"x": JS.get_property(_scope312["current"], "x"), "y": (JS.number(JS.get_property(_scope312["current"], "y")) - JS.number(1))})
			else:
				JS.set_property(_scope312, "penalty", JS.invoke_method("@Math", "max", [1, JS.invoke_method("@Math", "min", [_scope312["penalty"], (JS.number(JS.get_property(JS.get_property(_scope312["result"], JS.get_property(_scope312["current"], "x")), (JS.number(JS.get_property(_scope312["current"], "y")) - JS.number(1)))) - JS.number(1))])]))
		if JS.truthy(JS.compare("<=", _scope312["numExits"], 1)):
			JS.set_property(JS.get_property(_scope312["result"], JS.get_property(_scope312["current"], "x")), JS.get_property(_scope312["current"], "y"), _scope312["penalty"])
		if JS.truthy(JS.equal(_scope312["numExits"], 1, false)):
			JS.invoke_method(_scope312["worklist"], "push", [_scope312["next"]])
	JS.set_property(self, "deadEndPenalties", _scope312["result"])
	return null
