# 由原版 UIMazeView 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

var mazeFloorGroup = null
var mazeWallGroup = null
var mazeWallDecorationGroup = null
static var _static_UIMazeView: Dictionary = {}
static var _initialized_UIMazeView = false
static func initialize_original_static():
	if _initialized_UIMazeView: return
	_initialized_UIMazeView = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIMazeView.has(key): return _static_UIMazeView[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIMazeView[key] = value
	return value
func original_own_fields():
	return ["mazeFloorGroup","mazeWallGroup","mazeWallDecorationGroup"]
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/world/uimazeview.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

func original__createMaze(_arg0 = null):
	var _scope0: Dictionary = {"maze": _arg0, "theme": null, "borders": null, "floors": null, "spaces": null, "walls": null, "wallDecorations": null, "i": null, "border": null, "borderImage": null, "sprite": null, "floor": null, "floorImage": null, "wallDecoration": null, "wallDecorationImage": null, "space": null, "spaceImage": null, "wall": null, "wallImage": null, "wallBody": null}
	_scope0["theme"] = JS.invoke_method(_scope0["maze"], "getTheme", [])
	_scope0["borders"] = JS.invoke_method(_scope0["maze"], "getBorders", [])
	_scope0["floors"] = JS.invoke_method(_scope0["maze"], "getFloors", [])
	_scope0["spaces"] = JS.invoke_method(_scope0["maze"], "getSpaces", [])
	_scope0["walls"] = JS.invoke_method(_scope0["maze"], "getWalls", [])
	_scope0["wallDecorations"] = JS.invoke_method(_scope0["maze"], "getWallDecorations", [])
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["borders"], "length"))):
		_scope0["border"] = JS.get_property(_scope0["borders"], _scope0["i"])
		_scope0["borderImage"] = JS.add(JS.add(JS.add("border", _scope0["theme"]), "-"), JS.get_property(_scope0["border"], "number"))
		_scope0["sprite"] = JS.invoke_method(JS.get_property(self, "mazeFloorGroup"), "create", [(JS.number((JS.number(JS.add(JS.get_property(_scope0["border"], "x"), 0.5)) - JS.number((JS.number(0.5) * JS.number(fmod(JS.get_property(_scope0["border"], "orientation"), 2)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number((JS.number(JS.add(JS.get_property(_scope0["border"], "y"), 0.5)) - JS.number((JS.number(0.5) * JS.number(fmod((JS.number(JS.get_property(_scope0["border"], "orientation")) - JS.number(1)), 2)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope0["borderImage"]])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "scale"), "setTo", [(JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number((-(1) if JS.truthy(JS.get_property(_scope0["border"], "flip")) else 1))), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "anchor"), "setTo", [0.5, 1])
		JS.set_property(_scope0["sprite"], "rotation", (JS.number((JS.number(JS.get_property(_scope0["border"], "orientation")) * JS.number(JS.get_property("@Math", "PI")))) / JS.number(2)))
		JS.increment(_scope0, "i", 1, false)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["floors"], "length"))):
		_scope0["floor"] = JS.get_property(_scope0["floors"], _scope0["i"])
		_scope0["floorImage"] = JS.add(JS.add(JS.add("floor", _scope0["theme"]), "-"), JS.get_property(_scope0["floor"], "number"))
		_scope0["sprite"] = JS.invoke_method(JS.get_property(self, "mazeFloorGroup"), "create", [(JS.number(JS.add(JS.get_property(_scope0["floor"], "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number(JS.add(JS.get_property(_scope0["floor"], "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope0["floorImage"]])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "anchor"), "setTo", [0.5, 0.5])
		JS.set_property(_scope0["sprite"], "rotation", (JS.number((JS.number(JS.get_property(_scope0["floor"], "orientation")) * JS.number(JS.get_property("@Math", "PI")))) / JS.number(2)))
		JS.increment(_scope0, "i", 1, false)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["wallDecorations"], "length"))):
		_scope0["wallDecoration"] = JS.get_property(_scope0["wallDecorations"], _scope0["i"])
		_scope0["wallDecorationImage"] = JS.add(JS.add(JS.add("wallDecoration", _scope0["theme"]), "-"), JS.get_property(_scope0["wallDecoration"], "number"))
		_scope0["sprite"] = JS.invoke_method(JS.get_property(self, "mazeWallDecorationGroup"), "create", [(JS.number(JS.add(JS.get_property(_scope0["wallDecoration"], "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number(JS.add(JS.get_property(_scope0["wallDecoration"], "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope0["wallDecorationImage"]])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "anchor"), "setTo", [0.5, 0.5])
		JS.set_property(_scope0["sprite"], "rotation", (JS.number((JS.number(JS.get_property(_scope0["wallDecoration"], "orientation")) * JS.number(JS.get_property("@Math", "PI")))) / JS.number(2)))
		JS.increment(_scope0, "i", 1, false)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["spaces"], "length"))):
		_scope0["space"] = JS.get_property(_scope0["spaces"], _scope0["i"])
		_scope0["spaceImage"] = JS.add(JS.add(JS.add("space", _scope0["theme"]), "-"), JS.get_property(_scope0["space"], "number"))
		_scope0["sprite"] = JS.invoke_method(JS.get_property(self, "mazeFloorGroup"), "create", [(JS.number(JS.add(JS.get_property(_scope0["space"], "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number(JS.add(JS.get_property(_scope0["space"], "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope0["spaceImage"]])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "anchor"), "setTo", [0.5, 0.5])
		JS.set_property(_scope0["sprite"], "rotation", (JS.number((JS.number(JS.get_property(_scope0["space"], "orientation")) * JS.number(JS.get_property("@Math", "PI")))) / JS.number(2)))
		JS.increment(_scope0, "i", 1, false)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["walls"], "length"))):
		_scope0["wall"] = JS.get_property(_scope0["walls"], _scope0["i"])
		_scope0["wallImage"] = JS.add(JS.add(JS.add("wall", _scope0["theme"]), "-"), JS.get_property(_scope0["wall"], "number"))
		_scope0["sprite"] = JS.invoke_method(JS.get_property(self, "mazeWallGroup"), "create", [(JS.number((JS.number(JS.add(JS.get_property(_scope0["wall"], "x"), 0.5)) - JS.number((JS.number(0.5) * JS.number((1 if JS.truthy(JS.get_property(_scope0["wall"], "rotate")) else 0)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number((JS.number(JS.add(JS.get_property(_scope0["wall"], "y"), 0.5)) - JS.number((JS.number(0.5) * JS.number((0 if JS.truthy(JS.get_property(_scope0["wall"], "rotate")) else 1)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), "game", _scope0["wallImage"]])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "anchor"), "setTo", [0.5, 0.5])
		JS.invoke_method(JS.get_property(_scope0["sprite"], "scale"), "setTo", [(JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number((-(1) if JS.truthy(JS.get_property(_scope0["wall"], "flipX")) else 1))), (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) * JS.number((-(1) if JS.truthy(JS.get_property(_scope0["wall"], "flipY")) else 1)))])
		JS.set_property(_scope0["sprite"], "rotation", ((JS.number(JS.get_property("@Math", "PI")) / JS.number(2)) if JS.truthy(JS.get_property(_scope0["wall"], "rotate")) else 0))
		_scope0["wallBody"] = JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Physics"), "P2"), "Body"), [JS.get_property(self, "game"), null, (JS.number((JS.number(JS.add(JS.get_property(_scope0["wall"], "x"), 0.5)) - JS.number((JS.number(0.5) * JS.number((1 if JS.truthy(JS.get_property(_scope0["wall"], "rotate")) else 0)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"))), (JS.number((JS.number(JS.add(JS.get_property(_scope0["wall"], "y"), 0.5)) - JS.number((JS.number(0.5) * JS.number((0 if JS.truthy(JS.get_property(_scope0["wall"], "rotate")) else 1)))))) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px")))])
		JS.invoke_method(_scope0["wallBody"], "setRectangle", [JS.add(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "px"), JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "px")), JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "px"), 0, 0, ((JS.number(JS.get_property("@Math", "PI")) / JS.number(2)) if JS.truthy(JS.get_property(_scope0["wall"], "rotate")) else 0)])
		JS.set_property(_scope0["wallBody"], "dynamic", false)
		JS.invoke_method(_scope0["wallBody"], "setMaterial", [JS.get_property(JS.module("UIUtils"), "wallMaterial")])
		JS.invoke_method(_scope0["wallBody"], "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "wallCollisionGroup")])
		JS.invoke_method(_scope0["wallBody"], "collides", [[JS.get_property(JS.module("UIUtils"), "fragmentCollisionGroup"), JS.get_property(JS.module("UIUtils"), "puffCollisionGroup"), JS.get_property(JS.module("UIUtils"), "rayCollisionGroup")]])
		JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "addBody", [_scope0["wallBody"]])
		JS.increment(_scope0, "i", 1, false)
	return null

func original__getMazeLocalBounds():
	var _scope1: Dictionary = {"mazeLocalBounds": null}
	_scope1["mazeLocalBounds"] = JS.invoke_method(JS.get_property(JS.module("Phaser"), "Rectangle"), "union", [JS.invoke_method(JS.get_property(self, "mazeFloorGroup"), "getLocalBounds", []), JS.invoke_method(JS.get_property(self, "mazeWallGroup"), "getLocalBounds", [])])
	if JS.truthy(JS.get_property(_scope1["mazeLocalBounds"], "empty")):
		JS.invoke_method(_scope1["mazeLocalBounds"], "inflate", [0.01, 0.01])
	return _scope1["mazeLocalBounds"]
	return null
