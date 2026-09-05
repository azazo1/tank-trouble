# 由原版 B2DUtils 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_B2DUtils: Dictionary = {}
static var _initialized_B2DUtils = false
static func initialize_original_static():
	if _initialized_B2DUtils: return
	_initialized_B2DUtils = true
	_static_B2DUtils["_manifoldInstance"] = null
static func original_static_get(key):
	initialize_original_static()
	if _static_B2DUtils.has(key): return _static_B2DUtils[key]
	return null
static func original_static_set(key, value):
	_static_B2DUtils[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/physics/b2dutils.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

static func original_createMaze(_arg0 = null, _arg1 = null):
	var _scope0: Dictionary = {"b2dworld": _arg0, "maze": _arg1, "tiles": null, "tempArray": null, "i": null, "j": null, "points": null, "iStep": null, "wallVertices": null, "jStep": null}
	_scope0["tiles"] = JS.invoke_method(_scope0["maze"], "getTiles", [])
	_scope0["tempArray"] = JS.construct("@Array", [JS.get_property(_scope0["tiles"], "length")])
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["tiles"], "length"))):
		JS.set_property(_scope0["tempArray"], _scope0["i"], JS.construct("@Array", [JS.get_property(JS.get_property(_scope0["tiles"], 0), "length")]))
		_scope0["j"] = 0
		while JS.truthy(JS.compare("<", _scope0["j"], JS.get_property(JS.get_property(_scope0["tiles"], 0), "length"))):
			JS.set_property(JS.get_property(_scope0["tempArray"], _scope0["i"]), _scope0["j"], {"topWallColliderCreated": false, "leftWallColliderCreated": false})
			JS.increment(_scope0, "j", 1, false)
		JS.increment(_scope0, "i", 1, false)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["tiles"], "length"))):
		_scope0["j"] = 0
		while JS.truthy(JS.compare("<", _scope0["j"], JS.get_property(JS.get_property(_scope0["tiles"], 0), "length"))):
			if JS.truthy(JS.logical("&&", func():
				var _scope1: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["i"]), _scope0["j"]), 1), 1, false)
				return null, func():
				var _scope2: Dictionary = {}
				return (not JS.truthy(JS.get_property(JS.get_property(JS.get_property(_scope0["tempArray"], _scope0["i"]), _scope0["j"]), "topWallColliderCreated")))
				return null)):
				_scope0["points"] = JS.construct("@Array", [])
				if JS.truthy(JS.logical("||", func():
					var _scope3: Dictionary = {}
					return JS.compare("<", (JS.number(_scope0["j"]) - JS.number(1)), 0)
					return null, func():
					var _scope4: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["i"]), (JS.number(_scope0["j"]) - JS.number(1))), 2), 1, false)
					return null)):
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))), JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
				else:
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
				if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["i"]), _scope0["j"]), 2), 1, false)):
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))), JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
				else:
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
				_scope0["iStep"] = _scope0["i"]
				while JS.truthy(JS.compare("<", _scope0["iStep"], JS.get_property(_scope0["tiles"], "length"))):
					if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["iStep"]), _scope0["j"]), 1), 1, false)):
						JS.set_property(JS.get_property(JS.get_property(_scope0["tempArray"], _scope0["iStep"]), _scope0["j"]), "topWallColliderCreated", true)
						JS.increment(_scope0, "iStep", 1, false)
					else:
						break
				if JS.truthy(JS.logical("||", func():
					var _scope5: Dictionary = {}
					return JS.equal(_scope0["iStep"], JS.get_property(_scope0["tiles"], "length"), false)
					return null, func():
					var _scope6: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["iStep"]), _scope0["j"]), 2), 1, false)
					return null)):
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number(JS.add((JS.number(_scope0["iStep"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m"))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
				else:
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["iStep"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
				if JS.truthy(JS.logical("||", func():
					var _scope7: Dictionary = {}
					return JS.logical("||", func():
						var _scope8: Dictionary = {}
						return JS.equal(_scope0["iStep"], JS.get_property(_scope0["tiles"], "length"), false)
						return null, func():
						var _scope9: Dictionary = {}
						return JS.compare("<", (JS.number(_scope0["j"]) - JS.number(1)), 0)
						return null)
					return null, func():
					var _scope10: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["iStep"]), (JS.number(_scope0["j"]) - JS.number(1))), 2), 1, false)
					return null)):
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number(JS.add((JS.number(_scope0["iStep"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m"))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
				else:
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["iStep"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
				_scope0["wallVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 6), JS.get_property(_scope0["points"], 7)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 4), JS.get_property(_scope0["points"], 5)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 2), JS.get_property(_scope0["points"], 3)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 0), JS.get_property(_scope0["points"], 1)])]
				JS.invoke_method(JS.module("B2DUtils"), "_createWallBody", [_scope0["b2dworld"], _scope0["wallVertices"], _scope0["maze"]])
			if JS.truthy(JS.logical("&&", func():
				var _scope11: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["i"]), _scope0["j"]), 2), 1, false)
				return null, func():
				var _scope12: Dictionary = {}
				return (not JS.truthy(JS.get_property(JS.get_property(JS.get_property(_scope0["tempArray"], _scope0["i"]), _scope0["j"]), "leftWallColliderCreated")))
				return null)):
				_scope0["points"] = JS.construct("@Array", [])
				if JS.truthy(JS.logical("||", func():
					var _scope13: Dictionary = {}
					return JS.compare("<", (JS.number(_scope0["i"]) - JS.number(1)), 0)
					return null, func():
					var _scope14: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], (JS.number(_scope0["i"]) - JS.number(1))), _scope0["j"]), 1), 1, false)
					return null)):
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))), JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")))
				else:
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
				if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["i"]), _scope0["j"]), 1), 1, false)):
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))), JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")))
				else:
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
				_scope0["jStep"] = _scope0["j"]
				while JS.truthy(JS.compare("<", _scope0["jStep"], JS.get_property(JS.get_property(_scope0["tiles"], 0), "length"))):
					if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["i"]), _scope0["jStep"]), 2), 1, false)):
						JS.set_property(JS.get_property(JS.get_property(_scope0["tempArray"], _scope0["i"]), _scope0["jStep"]), "leftWallColliderCreated", true)
						JS.increment(_scope0, "jStep", 1, false)
					else:
						break
				if JS.truthy(JS.logical("||", func():
					var _scope15: Dictionary = {}
					return JS.equal(_scope0["jStep"], JS.get_property(JS.get_property(_scope0["tiles"], 0), "length"), false)
					return null, func():
					var _scope16: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["i"]), _scope0["jStep"]), 1), 1, false)
					return null)):
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number(JS.add((JS.number(_scope0["jStep"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m"))))
				else:
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["jStep"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
				if JS.truthy(JS.logical("||", func():
					var _scope17: Dictionary = {}
					return JS.logical("||", func():
						var _scope18: Dictionary = {}
						return JS.equal(_scope0["jStep"], JS.get_property(JS.get_property(_scope0["tiles"], 0), "length"), false)
						return null, func():
						var _scope19: Dictionary = {}
						return JS.compare("<", (JS.number(_scope0["i"]) - JS.number(1)), 0)
						return null)
					return null, func():
					var _scope20: Dictionary = {}
					return JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], (JS.number(_scope0["i"]) - JS.number(1))), _scope0["jStep"]), 1), 1, false)
					return null)):
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number(JS.add((JS.number(_scope0["jStep"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))) - JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m"))))
				else:
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
					JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["jStep"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
				_scope0["wallVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 0), JS.get_property(_scope0["points"], 1)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 2), JS.get_property(_scope0["points"], 3)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 4), JS.get_property(_scope0["points"], 5)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 6), JS.get_property(_scope0["points"], 7)])]
				JS.invoke_method(JS.module("B2DUtils"), "_createWallBody", [_scope0["b2dworld"], _scope0["wallVertices"], _scope0["maze"]])
			JS.increment(_scope0, "j", 1, false)
		JS.increment(_scope0, "i", 1, false)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["tiles"], "length"))):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["i"]), (JS.number(JS.get_property(JS.get_property(_scope0["tiles"], 0), "length")) - JS.number(1))), 0), 1, false)):
			_scope0["points"] = JS.construct("@Array", [])
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(JS.get_property(JS.get_property(_scope0["tiles"], 0), "length")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(JS.get_property(JS.get_property(_scope0["tiles"], 0), "length")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
			while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["tiles"], "length"))):
				if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], _scope0["i"]), (JS.number(JS.get_property(JS.get_property(_scope0["tiles"], 0), "length")) - JS.number(1))), 0), 1, false)):
					JS.increment(_scope0, "i", 1, false)
				else:
					break
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(JS.get_property(JS.get_property(_scope0["tiles"], 0), "length")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["i"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(JS.get_property(JS.get_property(_scope0["tiles"], 0), "length")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
			_scope0["wallVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 6), JS.get_property(_scope0["points"], 7)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 4), JS.get_property(_scope0["points"], 5)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 2), JS.get_property(_scope0["points"], 3)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 0), JS.get_property(_scope0["points"], 1)])]
			JS.invoke_method(JS.module("B2DUtils"), "_createWallBody", [_scope0["b2dworld"], _scope0["wallVertices"], _scope0["maze"]])
		JS.increment(_scope0, "i", 1, false)
	_scope0["j"] = 0
	while JS.truthy(JS.compare("<", _scope0["j"], JS.get_property(JS.get_property(_scope0["tiles"], 0), "length"))):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], (JS.number(JS.get_property(_scope0["tiles"], "length")) - JS.number(1))), _scope0["j"]), 0), 1, false)):
			_scope0["points"] = JS.construct("@Array", [])
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(JS.get_property(_scope0["tiles"], "length")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(JS.get_property(_scope0["tiles"], "length")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
			while JS.truthy(JS.compare("<", _scope0["j"], JS.get_property(JS.get_property(_scope0["tiles"], 0), "length"))):
				if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(_scope0["tiles"], (JS.number(JS.get_property(_scope0["tiles"], "length")) - JS.number(1))), _scope0["j"]), 0), 1, false)):
					JS.increment(_scope0, "j", 1, false)
				else:
					break
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(JS.get_property(_scope0["tiles"], "length")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), (JS.number((JS.number(JS.get_property(_scope0["tiles"], "length")) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))) - JS.number((JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2)))))
			JS.set_property(_scope0["points"], JS.get_property(_scope0["points"], "length"), JS.add((JS.number(_scope0["j"]) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_WALL_WIDTH"), "m")) / JS.number(2))))
			_scope0["wallVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 0), JS.get_property(_scope0["points"], 1)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 2), JS.get_property(_scope0["points"], 3)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 4), JS.get_property(_scope0["points"], 5)]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope0["points"], 6), JS.get_property(_scope0["points"], 7)])]
			JS.invoke_method(JS.module("B2DUtils"), "_createWallBody", [_scope0["b2dworld"], _scope0["wallVertices"], _scope0["maze"]])
		JS.increment(_scope0, "j", 1, false)
	return null

static func original__createWallBody(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope21: Dictionary = {"b2dworld": _arg0, "wallVertices": _arg1, "maze": _arg2, "wallFixtureDef": null, "wallBodyDef": null, "box2dBody": null}
	_scope21["wallFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope21["wallFixtureDef"], "density", 0)
	JS.set_property(_scope21["wallFixtureDef"], "friction", 0.05)
	JS.set_property(_scope21["wallFixtureDef"], "restitution", 0)
	JS.set_property(_scope21["wallFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope21["wallVertices"]]))
	JS.set_property(_scope21["wallFixtureDef"], "userData", {"gameObject": _scope21["maze"]})
	JS.set_property(_scope21["wallFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope21["wallFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE"))
	JS.set_property(JS.get_property(_scope21["wallFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP")))
	_scope21["wallBodyDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2BodyDef"), [])
	JS.set_property(_scope21["wallBodyDef"], "type", JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2Body"), "b2_staticBody"))
	_scope21["box2dBody"] = JS.invoke_method(_scope21["b2dworld"], "CreateBody", [_scope21["wallBodyDef"]])
	JS.invoke_method(_scope21["box2dBody"], "CreateFixture", [_scope21["wallFixtureDef"]])
	return _scope21["box2dBody"]
	return null

static func original_createProjectileBody(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope22: Dictionary = {"b2dworld": _arg0, "projectile": _arg1, "radius": _arg2, "projectileFixtureDef": null, "projectileBodyDef": null, "box2dBody": null}
	_scope22["projectileFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope22["projectileFixtureDef"], "density", 0.01)
	JS.set_property(_scope22["projectileFixtureDef"], "friction", 0)
	JS.set_property(_scope22["projectileFixtureDef"], "restitution", 1)
	JS.set_property(_scope22["projectileFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2CircleShape"), [_scope22["radius"]]))
	JS.set_property(_scope22["projectileFixtureDef"], "userData", {"gameObject": _scope22["projectile"]})
	JS.set_property(_scope22["projectileFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope22["projectileFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE"))
	JS.set_property(JS.get_property(_scope22["projectileFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	_scope22["projectileBodyDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2BodyDef"), [])
	JS.set_property(_scope22["projectileBodyDef"], "type", JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2Body"), "b2_dynamicBody"))
	JS.set_property(_scope22["projectileBodyDef"], "linearDamping", 0)
	JS.set_property(_scope22["projectileBodyDef"], "fixedRotation", true)
	JS.set_property(_scope22["projectileBodyDef"], "active", true)
	JS.set_property(_scope22["projectileBodyDef"], "bullet", true)
	_scope22["box2dBody"] = JS.invoke_method(_scope22["b2dworld"], "CreateBody", [_scope22["projectileBodyDef"]])
	JS.invoke_method(_scope22["box2dBody"], "CreateFixture", [_scope22["projectileFixtureDef"]])
	JS.invoke_method(_scope22["box2dBody"], "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.invoke_method(_scope22["projectile"], "getX", []), JS.invoke_method(_scope22["projectile"], "getY", [])])])
	JS.invoke_method(_scope22["box2dBody"], "SetLinearVelocity", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.invoke_method(_scope22["projectile"], "getSpeedX", []), JS.invoke_method(_scope22["projectile"], "getSpeedY", [])])])
	return _scope22["box2dBody"]
	return null

static func original_createTrapBody(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope23: Dictionary = {"b2dworld": _arg0, "trap": _arg1, "radius": _arg2, "trapFixtureDef": null, "trapBodyDef": null, "box2dBody": null}
	_scope23["trapFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope23["trapFixtureDef"], "density", 0.1)
	JS.set_property(_scope23["trapFixtureDef"], "friction", 0)
	JS.set_property(_scope23["trapFixtureDef"], "restitution", 1)
	JS.set_property(_scope23["trapFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2CircleShape"), [_scope23["radius"]]))
	JS.set_property(_scope23["trapFixtureDef"], "userData", {"gameObject": _scope23["trap"]})
	JS.set_property(_scope23["trapFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope23["trapFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP"))
	JS.set_property(JS.get_property(_scope23["trapFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	_scope23["trapBodyDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2BodyDef"), [])
	JS.set_property(_scope23["trapBodyDef"], "type", JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2Body"), "b2_dynamicBody"))
	JS.set_property(_scope23["trapBodyDef"], "linearDamping", 0)
	JS.set_property(_scope23["trapBodyDef"], "fixedRotation", true)
	JS.set_property(_scope23["trapBodyDef"], "active", true)
	JS.set_property(_scope23["trapBodyDef"], "allowSleep", false)
	_scope23["box2dBody"] = JS.invoke_method(_scope23["b2dworld"], "CreateBody", [_scope23["trapBodyDef"]])
	JS.invoke_method(_scope23["box2dBody"], "CreateFixture", [_scope23["trapFixtureDef"]])
	JS.invoke_method(_scope23["box2dBody"], "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.invoke_method(_scope23["trap"], "getX", []), JS.invoke_method(_scope23["trap"], "getY", [])])])
	JS.invoke_method(_scope23["box2dBody"], "SetLinearVelocity", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.invoke_method(_scope23["trap"], "getSpeedX", []), JS.invoke_method(_scope23["trap"], "getSpeedY", [])])])
	return _scope23["box2dBody"]
	return null

static func original_createCrateBody(_arg0 = null, _arg1 = null):
	var _scope24: Dictionary = {"b2dworld": _arg0, "collectible": _arg1, "crateFixtureDef": null, "crateBodyDef": null, "box2dBody": null}
	_scope24["crateFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope24["crateFixtureDef"], "density", 0.1)
	JS.set_property(_scope24["crateFixtureDef"], "friction", 0)
	JS.set_property(_scope24["crateFixtureDef"], "restitution", 1)
	JS.set_property(_scope24["crateFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsBox"), [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "CRATE"), "WIDTH"), "m")) / JS.number(2)), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "CRATE"), "HEIGHT"), "m")) / JS.number(2))]))
	JS.set_property(_scope24["crateFixtureDef"], "userData", {"gameObject": _scope24["collectible"]})
	JS.set_property(_scope24["crateFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope24["crateFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE"))
	JS.set_property(JS.get_property(_scope24["crateFixtureDef"], "filter"), "maskBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	_scope24["crateBodyDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2BodyDef"), [])
	JS.set_property(_scope24["crateBodyDef"], "type", JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2Body"), "b2_dynamicBody"))
	JS.set_property(_scope24["crateBodyDef"], "angle", JS.invoke_method(_scope24["collectible"], "getRotation", []))
	JS.set_property(_scope24["crateBodyDef"], "linearDamping", 4)
	JS.set_property(_scope24["crateBodyDef"], "angularDamping", 4)
	JS.set_property(_scope24["crateBodyDef"], "fixedRotation", false)
	JS.set_property(_scope24["crateBodyDef"], "active", true)
	JS.set_property(_scope24["crateBodyDef"], "allowSleep", false)
	_scope24["box2dBody"] = JS.invoke_method(_scope24["b2dworld"], "CreateBody", [_scope24["crateBodyDef"]])
	JS.invoke_method(_scope24["box2dBody"], "CreateFixture", [_scope24["crateFixtureDef"]])
	JS.invoke_method(_scope24["box2dBody"], "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.invoke_method(_scope24["collectible"], "getX", []), JS.invoke_method(_scope24["collectible"], "getY", [])])])
	return _scope24["box2dBody"]
	return null

static func original_createGoldBody(_arg0 = null, _arg1 = null):
	var _scope25: Dictionary = {"b2dworld": _arg0, "collectible": _arg1, "goldFixtureDef": null, "goldBodyDef": null, "box2dBody": null}
	_scope25["goldFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope25["goldFixtureDef"], "density", 0.1)
	JS.set_property(_scope25["goldFixtureDef"], "friction", 0)
	JS.set_property(_scope25["goldFixtureDef"], "restitution", 1)
	JS.set_property(_scope25["goldFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2CircleShape"), [JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GOLD"), "RADIUS"), "m")]))
	JS.set_property(_scope25["goldFixtureDef"], "userData", {"gameObject": _scope25["collectible"]})
	JS.set_property(_scope25["goldFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope25["goldFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE"))
	JS.set_property(JS.get_property(_scope25["goldFixtureDef"], "filter"), "maskBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	_scope25["goldBodyDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2BodyDef"), [])
	JS.set_property(_scope25["goldBodyDef"], "type", JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2Body"), "b2_dynamicBody"))
	JS.set_property(_scope25["goldBodyDef"], "linearDamping", 4)
	JS.set_property(_scope25["goldBodyDef"], "fixedRotation", true)
	JS.set_property(_scope25["goldBodyDef"], "active", true)
	JS.set_property(_scope25["goldBodyDef"], "allowSleep", false)
	_scope25["box2dBody"] = JS.invoke_method(_scope25["b2dworld"], "CreateBody", [_scope25["goldBodyDef"]])
	JS.invoke_method(_scope25["box2dBody"], "CreateFixture", [_scope25["goldFixtureDef"]])
	JS.invoke_method(_scope25["box2dBody"], "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.invoke_method(_scope25["collectible"], "getX", []), JS.invoke_method(_scope25["collectible"], "getY", [])])])
	return _scope25["box2dBody"]
	return null

static func original_createDiamondBody(_arg0 = null, _arg1 = null):
	var _scope26: Dictionary = {"b2dworld": _arg0, "collectible": _arg1, "diamondFixtureDef": null, "diamondVertices": null, "diamondBodyDef": null, "box2dBody": null}
	_scope26["diamondFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope26["diamondFixtureDef"], "density", 0.1)
	JS.set_property(_scope26["diamondFixtureDef"], "friction", 0)
	JS.set_property(_scope26["diamondFixtureDef"], "restitution", 1)
	_scope26["diamondVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [0, (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "HEIGHT"), "m")) / JS.number(2))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(-(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "WIDTH"), "m"))) / JS.number(2)), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "MIDDLE_HEIGHT"), "m")) / JS.number(2))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(-(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "WIDTH"), "m"))) / JS.number(2)), (JS.number(-(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "MIDDLE_HEIGHT"), "m"))) / JS.number(2))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [0, (JS.number(-(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "HEIGHT"), "m"))) / JS.number(2))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "WIDTH"), "m")) / JS.number(2)), (JS.number(-(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "MIDDLE_HEIGHT"), "m"))) / JS.number(2))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "WIDTH"), "m")) / JS.number(2)), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DIAMOND"), "MIDDLE_HEIGHT"), "m")) / JS.number(2))])]
	JS.set_property(_scope26["diamondFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope26["diamondVertices"]]))
	JS.set_property(_scope26["diamondFixtureDef"], "userData", {"gameObject": _scope26["collectible"]})
	JS.set_property(_scope26["diamondFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope26["diamondFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE"))
	JS.set_property(JS.get_property(_scope26["diamondFixtureDef"], "filter"), "maskBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	_scope26["diamondBodyDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2BodyDef"), [])
	JS.set_property(_scope26["diamondBodyDef"], "type", JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2Body"), "b2_dynamicBody"))
	JS.set_property(_scope26["diamondBodyDef"], "angle", JS.invoke_method(_scope26["collectible"], "getRotation", []))
	JS.set_property(_scope26["diamondBodyDef"], "linearDamping", 4)
	JS.set_property(_scope26["diamondBodyDef"], "fixedRotation", true)
	JS.set_property(_scope26["diamondBodyDef"], "active", true)
	JS.set_property(_scope26["diamondBodyDef"], "allowSleep", false)
	_scope26["box2dBody"] = JS.invoke_method(_scope26["b2dworld"], "CreateBody", [_scope26["diamondBodyDef"]])
	JS.invoke_method(_scope26["box2dBody"], "CreateFixture", [_scope26["diamondFixtureDef"]])
	JS.invoke_method(_scope26["box2dBody"], "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.invoke_method(_scope26["collectible"], "getX", []), JS.invoke_method(_scope26["collectible"], "getY", [])])])
	return _scope26["box2dBody"]
	return null

static func original_createSpawnZoneBody(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope27: Dictionary = {"b2dworld": _arg0, "zone": _arg1, "radius": _arg2, "spawnZoneFixtureDef": null, "spawnZoneBodyDef": null, "box2dBody": null, "position": null}
	_scope27["spawnZoneFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope27["spawnZoneFixtureDef"], "density", 0)
	JS.set_property(_scope27["spawnZoneFixtureDef"], "friction", 0)
	JS.set_property(_scope27["spawnZoneFixtureDef"], "restitution", 1)
	JS.set_property(_scope27["spawnZoneFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2CircleShape"), [_scope27["radius"]]))
	JS.set_property(_scope27["spawnZoneFixtureDef"], "userData", {"gameObject": _scope27["zone"]})
	JS.set_property(_scope27["spawnZoneFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope27["spawnZoneFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE"))
	JS.set_property(JS.get_property(_scope27["spawnZoneFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")))
	_scope27["spawnZoneBodyDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2BodyDef"), [])
	JS.set_property(_scope27["spawnZoneBodyDef"], "type", JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2Body"), "b2_staticBody"))
	_scope27["box2dBody"] = JS.invoke_method(_scope27["b2dworld"], "CreateBody", [_scope27["spawnZoneBodyDef"]])
	JS.invoke_method(_scope27["box2dBody"], "CreateFixture", [_scope27["spawnZoneFixtureDef"]])
	_scope27["position"] = JS.get_property(JS.invoke_method(_scope27["zone"], "getTiles", []), 0)
	JS.invoke_method(_scope27["box2dBody"], "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.add(JS.get_property(_scope27["position"], "x"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m"))), (JS.number(JS.add(JS.get_property(_scope27["position"], "y"), 0.5)) * JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])])
	return _scope27["box2dBody"]
	return null

static func original_updateSpawnZoneBody(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope28: Dictionary = {"b2body": _arg0, "zone": _arg1, "radius": _arg2, "fixture": null, "spawnZoneFixtureDef": null}
	_scope28["fixture"] = JS.invoke_method(_scope28["b2body"], "GetFixtureList", [])
	JS.invoke_method(_scope28["b2body"], "DestroyFixture", [_scope28["fixture"]])
	_scope28["spawnZoneFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope28["spawnZoneFixtureDef"], "density", 0)
	JS.set_property(_scope28["spawnZoneFixtureDef"], "friction", 0)
	JS.set_property(_scope28["spawnZoneFixtureDef"], "restitution", 1)
	JS.set_property(_scope28["spawnZoneFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2CircleShape"), [_scope28["radius"]]))
	JS.set_property(_scope28["spawnZoneFixtureDef"], "userData", {"gameObject": _scope28["zone"]})
	JS.set_property(_scope28["spawnZoneFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope28["spawnZoneFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE"))
	JS.set_property(JS.get_property(_scope28["spawnZoneFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")))
	JS.invoke_method(_scope28["b2body"], "CreateFixture", [_scope28["spawnZoneFixtureDef"]])
	return null

static func original_createStormZoneBody(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null):
	var _scope29: Dictionary = {"b2dworld": _arg0, "zone": _arg1, "stormStartRight": _arg2, "stormEndRight": _arg3, "stormStartBottom": _arg4, "stormEndBottom": _arg5, "stormStartLeft": _arg6, "stormEndLeft": _arg7, "stormStartTop": _arg8, "stormEndTop": _arg9, "stormZoneRightFixtureDef": null, "stormZoneBottomFixtureDef": null, "stormZoneLeftFixtureDef": null, "stormZoneTopFixtureDef": null, "stormZoneBodyDef": null, "box2dBody": null}
	_scope29["stormZoneRightFixtureDef"] = JS.invoke_method(JS.module("B2DUtils"), "_createStormZoneFixtureDef", [_scope29["zone"], _scope29["stormStartRight"], _scope29["stormStartTop"], _scope29["stormEndRight"], _scope29["stormEndBottom"]])
	_scope29["stormZoneBottomFixtureDef"] = JS.invoke_method(JS.module("B2DUtils"), "_createStormZoneFixtureDef", [_scope29["zone"], _scope29["stormStartLeft"], _scope29["stormStartBottom"], _scope29["stormEndRight"], _scope29["stormEndBottom"]])
	_scope29["stormZoneLeftFixtureDef"] = JS.invoke_method(JS.module("B2DUtils"), "_createStormZoneFixtureDef", [_scope29["zone"], _scope29["stormStartLeft"], _scope29["stormStartTop"], _scope29["stormEndLeft"], _scope29["stormEndBottom"]])
	_scope29["stormZoneTopFixtureDef"] = JS.invoke_method(JS.module("B2DUtils"), "_createStormZoneFixtureDef", [_scope29["zone"], _scope29["stormStartLeft"], _scope29["stormStartTop"], _scope29["stormEndRight"], _scope29["stormEndTop"]])
	_scope29["stormZoneBodyDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2BodyDef"), [])
	JS.set_property(_scope29["stormZoneBodyDef"], "type", JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2Body"), "b2_staticBody"))
	_scope29["box2dBody"] = JS.invoke_method(_scope29["b2dworld"], "CreateBody", [_scope29["stormZoneBodyDef"]])
	JS.invoke_method(_scope29["box2dBody"], "CreateFixture", [_scope29["stormZoneRightFixtureDef"]])
	JS.invoke_method(_scope29["box2dBody"], "CreateFixture", [_scope29["stormZoneBottomFixtureDef"]])
	JS.invoke_method(_scope29["box2dBody"], "CreateFixture", [_scope29["stormZoneLeftFixtureDef"]])
	JS.invoke_method(_scope29["box2dBody"], "CreateFixture", [_scope29["stormZoneTopFixtureDef"]])
	JS.invoke_method(_scope29["box2dBody"], "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [0, 0])])
	return _scope29["box2dBody"]
	return null

static func original_updateStormZoneBody(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null):
	var _scope30: Dictionary = {"b2body": _arg0, "zone": _arg1, "stormStartRight": _arg2, "stormEndRight": _arg3, "stormStartBottom": _arg4, "stormEndBottom": _arg5, "stormStartLeft": _arg6, "stormEndLeft": _arg7, "stormStartTop": _arg8, "stormEndTop": _arg9, "currentFixture": null, "nextFixture": null, "stormZoneRightFixtureDef": null, "stormZoneBottomFixtureDef": null, "stormZoneLeftFixtureDef": null, "stormZoneTopFixtureDef": null}
	_scope30["currentFixture"] = JS.invoke_method(_scope30["b2body"], "GetFixtureList", [])
	while JS.truthy(not JS.equal(_scope30["currentFixture"], null, true)):
		_scope30["nextFixture"] = JS.invoke_method(_scope30["currentFixture"], "GetNext", [])
		JS.invoke_method(_scope30["b2body"], "DestroyFixture", [_scope30["currentFixture"]])
		JS.set_property(_scope30, "currentFixture", _scope30["nextFixture"])
	_scope30["stormZoneRightFixtureDef"] = JS.invoke_method(JS.module("B2DUtils"), "_createStormZoneFixtureDef", [_scope30["zone"], _scope30["stormStartRight"], _scope30["stormStartTop"], _scope30["stormEndRight"], _scope30["stormEndBottom"]])
	_scope30["stormZoneBottomFixtureDef"] = JS.invoke_method(JS.module("B2DUtils"), "_createStormZoneFixtureDef", [_scope30["zone"], _scope30["stormStartLeft"], _scope30["stormStartBottom"], _scope30["stormEndRight"], _scope30["stormEndBottom"]])
	_scope30["stormZoneLeftFixtureDef"] = JS.invoke_method(JS.module("B2DUtils"), "_createStormZoneFixtureDef", [_scope30["zone"], _scope30["stormStartLeft"], _scope30["stormStartTop"], _scope30["stormEndLeft"], _scope30["stormEndBottom"]])
	_scope30["stormZoneTopFixtureDef"] = JS.invoke_method(JS.module("B2DUtils"), "_createStormZoneFixtureDef", [_scope30["zone"], _scope30["stormStartLeft"], _scope30["stormStartTop"], _scope30["stormEndRight"], _scope30["stormEndTop"]])
	JS.invoke_method(_scope30["b2body"], "CreateFixture", [_scope30["stormZoneRightFixtureDef"]])
	JS.invoke_method(_scope30["b2body"], "CreateFixture", [_scope30["stormZoneBottomFixtureDef"]])
	JS.invoke_method(_scope30["b2body"], "CreateFixture", [_scope30["stormZoneLeftFixtureDef"]])
	JS.invoke_method(_scope30["b2body"], "CreateFixture", [_scope30["stormZoneTopFixtureDef"]])
	return null

static func original__createStormZoneFixtureDef(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope31: Dictionary = {"zone": _arg0, "topLeftX": _arg1, "topLeftY": _arg2, "bottomRightX": _arg3, "bottomRightY": _arg4, "stormZoneFixtureDef": null, "vertices": null}
	_scope31["stormZoneFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope31["stormZoneFixtureDef"], "density", 0)
	JS.set_property(_scope31["stormZoneFixtureDef"], "friction", 0)
	JS.set_property(_scope31["stormZoneFixtureDef"], "restitution", 1)
	_scope31["vertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [_scope31["topLeftX"], _scope31["topLeftY"]]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [_scope31["bottomRightX"], _scope31["topLeftY"]]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [_scope31["bottomRightX"], _scope31["bottomRightY"]]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [_scope31["topLeftX"], _scope31["bottomRightY"]])]
	JS.set_property(_scope31["stormZoneFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope31["vertices"]]))
	JS.set_property(_scope31["stormZoneFixtureDef"], "userData", {"gameObject": _scope31["zone"]})
	JS.set_property(_scope31["stormZoneFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope31["stormZoneFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE"))
	JS.set_property(JS.get_property(_scope31["stormZoneFixtureDef"], "filter"), "maskBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	return _scope31["stormZoneFixtureDef"]
	return null

static func original_addTankBodyUpgrade(_arg0 = null, _arg1 = null):
	var _scope32: Dictionary = {"b2body": _arg0, "upgrade": _arg1, "newFixtureDefs": null, "i": null}
	JS.invoke_method(JS.module("B2DUtils"), "removeTankBodyUpgrade", [_scope32["b2body"], JS.invoke_method(_scope32["upgrade"], "getType", [])])
	_scope32["newFixtureDefs"] = []
	var _switch0 = JS.invoke_method(_scope32["upgrade"], "getType", [])
	var _switch0_start = -1
	if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "LASER_AIMER"), true): _switch0_start = 0
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "AIMER"), true): _switch0_start = 1
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SPEED_BOOST"), true): _switch0_start = 2
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SPAWN_SHIELD"), true): _switch0_start = 3
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "SHIELD"), true): _switch0_start = 4
	while true:
		if _switch0_start >= 0 and _switch0_start <= 2:
			break
		if _switch0_start >= 0 and _switch0_start <= 4:
			JS.set_property(_scope32, "newFixtureDefs", JS.invoke_method(JS.module("B2DUtils"), "_createShieldFixtureDefs", [_scope32["upgrade"]]))
			break
		break
	_scope32["i"] = 0
	while JS.truthy(JS.compare("<", _scope32["i"], JS.get_property(_scope32["newFixtureDefs"], "length"))):
		JS.invoke_method(_scope32["b2body"], "CreateFixture", [JS.get_property(_scope32["newFixtureDefs"], _scope32["i"])])
		JS.increment(_scope32, "i", 1, false)
	return null

static func original_removeTankBodyUpgrade(_arg0 = null, _arg1 = null):
	var _scope33: Dictionary = {"b2body": _arg0, "upgradeType": _arg1, "currentFixture": null, "nextFixture": null}
	_scope33["currentFixture"] = JS.invoke_method(_scope33["b2body"], "GetFixtureList", [])
	while JS.truthy(not JS.equal(_scope33["currentFixture"], null, true)):
		if JS.truthy(JS.equal(JS.get_property(JS.invoke_method(_scope33["currentFixture"], "GetUserData", []), "type"), _scope33["upgradeType"], true)):
			_scope33["nextFixture"] = JS.invoke_method(_scope33["currentFixture"], "GetNext", [])
			JS.invoke_method(_scope33["b2body"], "DestroyFixture", [_scope33["currentFixture"]])
			JS.set_property(_scope33, "currentFixture", _scope33["nextFixture"])
		else:
			JS.set_property(_scope33, "currentFixture", JS.invoke_method(_scope33["currentFixture"], "GetNext", []))
	return null

static func original__createShieldFixtureDefs(_arg0 = null):
	var _scope34: Dictionary = {"upgrade": _arg0, "shieldFixtureDef": null}
	_scope34["shieldFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope34["shieldFixtureDef"], "density", 10)
	JS.set_property(_scope34["shieldFixtureDef"], "friction", 0)
	JS.set_property(_scope34["shieldFixtureDef"], "restitution", 1)
	JS.set_property(_scope34["shieldFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2CircleShape"), [JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHIELD"), "RADIUS"), "m")]))
	JS.set_property(_scope34["shieldFixtureDef"], "userData", {"type": JS.invoke_method(_scope34["upgrade"], "getType", []), "gameObject": _scope34["upgrade"]})
	JS.set_property(_scope34["shieldFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope34["shieldFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD"))
	JS.set_property(JS.get_property(_scope34["shieldFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	return [_scope34["shieldFixtureDef"]]
	return null

static func original_updateTankBodyTurret(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope35: Dictionary = {"b2body": _arg0, "tank": _arg1, "weapon": _arg2, "currentFixture": null, "nextFixture": null, "newFixtureDefs": null, "i": null}
	_scope35["currentFixture"] = JS.invoke_method(_scope35["b2body"], "GetFixtureList", [])
	while JS.truthy(not JS.equal(_scope35["currentFixture"], null, true)):
		if JS.truthy(JS.equal(JS.get_property(JS.invoke_method(_scope35["currentFixture"], "GetUserData", []), "type"), "turret", true)):
			_scope35["nextFixture"] = JS.invoke_method(_scope35["currentFixture"], "GetNext", [])
			JS.invoke_method(_scope35["b2body"], "DestroyFixture", [_scope35["currentFixture"]])
			JS.set_property(_scope35, "currentFixture", _scope35["nextFixture"])
		else:
			JS.set_property(_scope35, "currentFixture", JS.invoke_method(_scope35["currentFixture"], "GetNext", []))
	_scope35["newFixtureDefs"] = []
	var _switch1 = JS.invoke_method(_scope35["weapon"], "getType", [])
	var _switch1_start = -1
	if JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "BULLET"), true): _switch1_start = 0
	elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "LASER"), true): _switch1_start = 1
	elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "DOUBLE_BARREL"), true): _switch1_start = 2
	elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "SHOTGUN"), true): _switch1_start = 3
	elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "HOMING_MISSILE"), true): _switch1_start = 4
	elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "GATLING_GUN"), true): _switch1_start = 5
	elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("Constants"), "WEAPON_TYPES"), "MINE"), true): _switch1_start = 6
	while true:
		if _switch1_start >= 0 and _switch1_start <= 0:
			JS.set_property(_scope35, "newFixtureDefs", JS.invoke_method(JS.module("B2DUtils"), "_createBulletTurretFixtureDefs", [_scope35["tank"]]))
			break
		if _switch1_start >= 0 and _switch1_start <= 1:
			JS.set_property(_scope35, "newFixtureDefs", JS.invoke_method(JS.module("B2DUtils"), "_createLaserTurretFixtureDefs", [_scope35["tank"]]))
			break
		if _switch1_start >= 0 and _switch1_start <= 2:
			JS.set_property(_scope35, "newFixtureDefs", JS.invoke_method(JS.module("B2DUtils"), "_createDoubleBarrelTurretFixtureDefs", [_scope35["tank"]]))
			break
		if _switch1_start >= 0 and _switch1_start <= 3:
			JS.set_property(_scope35, "newFixtureDefs", JS.invoke_method(JS.module("B2DUtils"), "_createShotgunTurretFixtureDef", [_scope35["tank"]]))
			break
		if _switch1_start >= 0 and _switch1_start <= 4:
			if JS.truthy((not JS.truthy(JS.invoke_method(_scope35["weapon"], "getField", ["launched"])))):
				JS.set_property(_scope35, "newFixtureDefs", JS.invoke_method(JS.module("B2DUtils"), "_createMissileTurretFixtureDef", [_scope35["tank"]]))
			break
		if _switch1_start >= 0 and _switch1_start <= 5:
			JS.set_property(_scope35, "newFixtureDefs", JS.invoke_method(JS.module("B2DUtils"), "_createGatlingGunTurretFixtureDefs", [_scope35["tank"]]))
			break
		if _switch1_start >= 0 and _switch1_start <= 6:
			break
		break
	_scope35["i"] = 0
	while JS.truthy(JS.compare("<", _scope35["i"], JS.get_property(_scope35["newFixtureDefs"], "length"))):
		JS.invoke_method(_scope35["b2body"], "CreateFixture", [JS.get_property(_scope35["newFixtureDefs"], _scope35["i"])])
		JS.increment(_scope35, "i", 1, false)
	return null

static func original__createBulletTurretFixtureDefs(_arg0 = null):
	var _scope36: Dictionary = {"tank": _arg0, "turretFixtureDef": null, "turretVertices": null}
	_scope36["turretFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope36["turretFixtureDef"], "density", 0)
	JS.set_property(_scope36["turretFixtureDef"], "friction", 0.25)
	JS.set_property(_scope36["turretFixtureDef"], "restitution", 0)
	_scope36["turretVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "WIDTH"), "m")) / JS.number(2))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "WIDTH"), "m")) / JS.number(2)))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "WIDTH"), "m")) / JS.number(2)))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "HEIGHT"), "m")) / JS.number(2))))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "WIDTH"), "m")) / JS.number(2))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "BULLET_TURRET"), "HEIGHT"), "m")) / JS.number(2))))])]
	JS.set_property(_scope36["turretFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope36["turretVertices"]]))
	JS.set_property(_scope36["turretFixtureDef"], "userData", {"type": "turret", "gameObject": _scope36["tank"]})
	JS.set_property(_scope36["turretFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope36["turretFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	JS.set_property(JS.get_property(_scope36["turretFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	return [_scope36["turretFixtureDef"]]
	return null

static func original__createLaserTurretFixtureDefs(_arg0 = null):
	var _scope37: Dictionary = {"tank": _arg0, "dishFixtureDef": null, "dishVertices": null, "antennaFixtureDef": null, "antennaVertices": null}
	_scope37["dishFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope37["dishFixtureDef"], "density", 0)
	JS.set_property(_scope37["dishFixtureDef"], "friction", 0.25)
	JS.set_property(_scope37["dishFixtureDef"], "restitution", 0)
	_scope37["dishVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_WIDTH"), "m")) / JS.number(2))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_WIDTH"), "m")) / JS.number(2)))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_WIDTH"), "m")) / JS.number(2)))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_HEIGHT"), "m")) / JS.number(2))))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_WIDTH"), "m")) / JS.number(2))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "DISH_HEIGHT"), "m")) / JS.number(2))))])]
	JS.set_property(_scope37["dishFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope37["dishVertices"]]))
	JS.set_property(_scope37["dishFixtureDef"], "userData", {"type": "turret", "gameObject": _scope37["tank"]})
	JS.set_property(_scope37["dishFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope37["dishFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	JS.set_property(JS.get_property(_scope37["dishFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	_scope37["antennaFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope37["antennaFixtureDef"], "density", 0)
	JS.set_property(_scope37["antennaFixtureDef"], "friction", 0.25)
	JS.set_property(_scope37["antennaFixtureDef"], "restitution", 0)
	_scope37["antennaVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_WIDTH"), "m")) / JS.number(2))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_WIDTH"), "m")) / JS.number(2)))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_WIDTH"), "m")) / JS.number(2)))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_HEIGHT"), "m")) / JS.number(2))))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_WIDTH"), "m")) / JS.number(2))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "LASER_TURRET"), "ANTENNA_HEIGHT"), "m")) / JS.number(2))))])]
	JS.set_property(_scope37["antennaFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope37["antennaVertices"]]))
	JS.set_property(_scope37["antennaFixtureDef"], "userData", {"type": "turret", "gameObject": _scope37["tank"]})
	JS.set_property(_scope37["antennaFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope37["antennaFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	JS.set_property(JS.get_property(_scope37["antennaFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	return [_scope37["dishFixtureDef"], _scope37["antennaFixtureDef"]]
	return null

static func original__createDoubleBarrelTurretFixtureDefs(_arg0 = null):
	var _scope38: Dictionary = {"tank": _arg0, "turretFixtureDef": null, "turretVertices": null}
	_scope38["turretFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope38["turretFixtureDef"], "density", 0)
	JS.set_property(_scope38["turretFixtureDef"], "friction", 0.25)
	JS.set_property(_scope38["turretFixtureDef"], "restitution", 0)
	_scope38["turretVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "WIDTH"), "m")) / JS.number(2))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "WIDTH"), "m")) / JS.number(2)))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "WIDTH"), "m")) / JS.number(2)))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "HEIGHT"), "m")) / JS.number(2))))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "WIDTH"), "m")) / JS.number(2))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "DOUBLE_BARREL_TURRET"), "HEIGHT"), "m")) / JS.number(2))))])]
	JS.set_property(_scope38["turretFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope38["turretVertices"]]))
	JS.set_property(_scope38["turretFixtureDef"], "userData", {"type": "turret", "gameObject": _scope38["tank"]})
	JS.set_property(_scope38["turretFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope38["turretFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	JS.set_property(JS.get_property(_scope38["turretFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	return [_scope38["turretFixtureDef"]]
	return null

static func original__createShotgunTurretFixtureDef(_arg0 = null):
	var _scope39: Dictionary = {"tank": _arg0, "turretFixtureDef": null, "turretVertices": null}
	_scope39["turretFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope39["turretFixtureDef"], "density", 0)
	JS.set_property(_scope39["turretFixtureDef"], "friction", 0.25)
	JS.set_property(_scope39["turretFixtureDef"], "restitution", 0)
	_scope39["turretVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "WIDTH"), "m")) / JS.number(2))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "WIDTH"), "m")) / JS.number(2)))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "WIDTH"), "m")) / JS.number(2)))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "HEIGHT"), "m")) / JS.number(2))))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "WIDTH"), "m")) / JS.number(2))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "SHOTGUN_TURRET"), "HEIGHT"), "m")) / JS.number(2))))])]
	JS.set_property(_scope39["turretFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope39["turretVertices"]]))
	JS.set_property(_scope39["turretFixtureDef"], "userData", {"type": "turret", "gameObject": _scope39["tank"]})
	JS.set_property(_scope39["turretFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope39["turretFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	JS.set_property(JS.get_property(_scope39["turretFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	return [_scope39["turretFixtureDef"]]
	return null

static func original__createMissileTurretFixtureDef(_arg0 = null):
	var _scope40: Dictionary = {"tank": _arg0, "turretFixtureDef": null, "turretVertices": null}
	_scope40["turretFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope40["turretFixtureDef"], "density", 0)
	JS.set_property(_scope40["turretFixtureDef"], "friction", 0.25)
	JS.set_property(_scope40["turretFixtureDef"], "restitution", 0)
	_scope40["turretVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "WIDTH"), "m")) / JS.number(2))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "CENTER_HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "WIDTH"), "m")) / JS.number(2)))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "CENTER_HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "WIDTH"), "m")) / JS.number(2)))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "SIDE_HEIGHT"), "m")) / JS.number(2))))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "CENTER_HEIGHT"), "m")) / JS.number(2))))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "WIDTH"), "m")) / JS.number(2))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MISSILE_TURRET"), "SIDE_HEIGHT"), "m")) / JS.number(2))))])]
	JS.set_property(_scope40["turretFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope40["turretVertices"]]))
	JS.set_property(_scope40["turretFixtureDef"], "userData", {"type": "turret", "gameObject": _scope40["tank"]})
	JS.set_property(_scope40["turretFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope40["turretFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	JS.set_property(JS.get_property(_scope40["turretFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	return [_scope40["turretFixtureDef"]]
	return null

static func original__createGatlingGunTurretFixtureDefs(_arg0 = null):
	var _scope41: Dictionary = {"tank": _arg0, "turretFixtureDef": null, "turretVertices": null}
	_scope41["turretFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope41["turretFixtureDef"], "density", 0)
	JS.set_property(_scope41["turretFixtureDef"], "friction", 0.25)
	JS.set_property(_scope41["turretFixtureDef"], "restitution", 0)
	_scope41["turretVertices"] = [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "WIDTH"), "m")) / JS.number(2))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "WIDTH"), "m")) / JS.number(2)))), JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "OFFSET_Y"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "HEIGHT"), "m")) / JS.number(2)))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "OFFSET_X"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "WIDTH"), "m")) / JS.number(2)))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "HEIGHT"), "m")) / JS.number(2))))]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.add(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "OFFSET_X"), "m"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "WIDTH"), "m")) / JS.number(2))), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "OFFSET_Y"), "m")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "GATLING_GUN_TURRET"), "HEIGHT"), "m")) / JS.number(2))))])]
	JS.set_property(_scope41["turretFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsArray"), [_scope41["turretVertices"]]))
	JS.set_property(_scope41["turretFixtureDef"], "userData", {"type": "turret", "gameObject": _scope41["tank"]})
	JS.set_property(_scope41["turretFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope41["turretFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	JS.set_property(JS.get_property(_scope41["turretFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	return [_scope41["turretFixtureDef"]]
	return null

static func original_createTankBody(_arg0 = null, _arg1 = null):
	var _scope42: Dictionary = {"b2dworld": _arg0, "tank": _arg1, "tankBaseFixtureDef": null, "tankBodyDef": null, "box2dBody": null}
	_scope42["tankBaseFixtureDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FixtureDef"), [])
	JS.set_property(_scope42["tankBaseFixtureDef"], "density", 1)
	JS.set_property(_scope42["tankBaseFixtureDef"], "friction", 0.25)
	JS.set_property(_scope42["tankBaseFixtureDef"], "restitution", 0)
	JS.set_property(_scope42["tankBaseFixtureDef"], "shape", JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "Shapes"), "b2PolygonShape"), "AsBox"), [(JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "WIDTH"), "m")) / JS.number(2)), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "HEIGHT"), "m")) / JS.number(2))]))
	JS.set_property(_scope42["tankBaseFixtureDef"], "userData", {"type": "base", "gameObject": _scope42["tank"]})
	JS.set_property(_scope42["tankBaseFixtureDef"], "filter", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2FilterData"), []))
	JS.set_property(JS.get_property(_scope42["tankBaseFixtureDef"], "filter"), "categoryBits", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"))
	JS.set_property(JS.get_property(_scope42["tankBaseFixtureDef"], "filter"), "maskBits", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD")), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE")))
	_scope42["tankBodyDef"] = JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2BodyDef"), [])
	JS.set_property(_scope42["tankBodyDef"], "type", JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Dynamics"), "b2Body"), "b2_dynamicBody"))
	JS.set_property(_scope42["tankBodyDef"], "angle", JS.invoke_method(_scope42["tank"], "getRotation", []))
	JS.set_property(_scope42["tankBodyDef"], "linearDamping", 0)
	JS.set_property(_scope42["tankBodyDef"], "fixedRotation", false)
	JS.set_property(_scope42["tankBodyDef"], "active", true)
	JS.set_property(_scope42["tankBodyDef"], "allowSleep", false)
	_scope42["box2dBody"] = JS.invoke_method(_scope42["b2dworld"], "CreateBody", [_scope42["tankBodyDef"]])
	JS.invoke_method(_scope42["box2dBody"], "CreateFixture", [_scope42["tankBaseFixtureDef"]])
	JS.invoke_method(_scope42["box2dBody"], "CreateFixture", [JS.get_property(JS.invoke_method(JS.module("B2DUtils"), "_createBulletTurretFixtureDefs", [_scope42["tank"]]), 0)])
	JS.invoke_method(_scope42["box2dBody"], "SetPosition", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.invoke_method(_scope42["tank"], "getX", []), JS.invoke_method(_scope42["tank"], "getY", [])])])
	return _scope42["box2dBody"]
	return null

static func original_getWorldManifold():
	var _scope43: Dictionary = {}
	if JS.truthy(JS.equal(JS.get_property(JS.module("B2DUtils"), "_manifoldInstance"), null, true)):
		JS.set_property(JS.module("B2DUtils"), "_manifoldInstance", JS.construct(JS.get_property(JS.get_property(JS.module("Box2D"), "Collision"), "b2WorldManifold"), []))
	return JS.get_property(JS.module("B2DUtils"), "_manifoldInstance")
	return null

static func original_getContactData(_arg0 = null):
	var _scope44: Dictionary = {"b2dcontact": _arg0, "categoryBitsA": null, "categoryBitsB": null, "fixtureA": null, "fixtureB": null, "data": null, "worldManifold": null}
	_scope44["categoryBitsA"] = JS.get_property(JS.invoke_method(JS.invoke_method(_scope44["b2dcontact"], "GetFixtureA", []), "GetFilterData", []), "categoryBits")
	_scope44["categoryBitsB"] = JS.get_property(JS.invoke_method(JS.invoke_method(_scope44["b2dcontact"], "GetFixtureB", []), "GetFilterData", []), "categoryBits")
	_scope44["fixtureA"] = JS.invoke_method(_scope44["b2dcontact"], "GetFixtureA", [])
	_scope44["fixtureB"] = JS.invoke_method(_scope44["b2dcontact"], "GetFixtureB", [])
	_scope44["data"] = {}
	JS.set_property(_scope44["data"], "contactBits", JS.bitwise("|", _scope44["categoryBitsA"], _scope44["categoryBitsB"]))
	_scope44["worldManifold"] = JS.invoke_method(JS.module("B2DUtils"), "getWorldManifold", [])
	JS.invoke_method(_scope44["b2dcontact"], "GetWorldManifold", [_scope44["worldManifold"]])
	JS.set_property(_scope44["data"], "collisionPoint", JS.invoke_method(JS.get_property(JS.get_property(_scope44["worldManifold"], "m_points"), 0), "Copy", []))
	JS.set_property(_scope44["data"], "collisionNormal", JS.invoke_method(JS.get_property(_scope44["worldManifold"], "m_normal"), "Copy", []))
	var _switch2 = _scope44["categoryBitsA"]
	var _switch2_start = 7
	if JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), true): _switch2_start = 0
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE"), true): _switch2_start = 1
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE"), true): _switch2_start = 2
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP"), true): _switch2_start = 3
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE"), true): _switch2_start = 4
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD"), true): _switch2_start = 5
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE"), true): _switch2_start = 6
	while true:
		if _switch2_start >= 0 and _switch2_start <= 0:
			JS.set_property(_scope44["data"], "tankA", JS.get_property(JS.invoke_method(_scope44["fixtureA"], "GetUserData", []), "gameObject"))
			break
		if _switch2_start >= 0 and _switch2_start <= 1:
			JS.set_property(_scope44["data"], "maze", JS.get_property(JS.invoke_method(_scope44["fixtureA"], "GetUserData", []), "gameObject"))
			break
		if _switch2_start >= 0 and _switch2_start <= 2:
			JS.set_property(_scope44["data"], "projectile", JS.get_property(JS.invoke_method(_scope44["fixtureA"], "GetUserData", []), "gameObject"))
			break
		if _switch2_start >= 0 and _switch2_start <= 3:
			JS.set_property(_scope44["data"], "trap", JS.get_property(JS.invoke_method(_scope44["fixtureA"], "GetUserData", []), "gameObject"))
			break
		if _switch2_start >= 0 and _switch2_start <= 4:
			JS.set_property(_scope44["data"], "collectible", JS.get_property(JS.invoke_method(_scope44["fixtureA"], "GetUserData", []), "gameObject"))
			break
		if _switch2_start >= 0 and _switch2_start <= 5:
			JS.set_property(_scope44["data"], "shieldA", JS.get_property(JS.invoke_method(_scope44["fixtureA"], "GetUserData", []), "gameObject"))
			break
		if _switch2_start >= 0 and _switch2_start <= 6:
			JS.set_property(_scope44["data"], "zone", JS.get_property(JS.invoke_method(_scope44["fixtureA"], "GetUserData", []), "gameObject"))
			break
		if _switch2_start >= 0 and _switch2_start <= 7:
			JS.invoke_method("@console", "log", ["Unknown collision category in B2DUtils.getContactData"])
		break
	var _switch3 = _scope44["categoryBitsB"]
	var _switch3_start = 7
	if JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), true): _switch3_start = 0
	elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE"), true): _switch3_start = 1
	elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE"), true): _switch3_start = 2
	elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TRAP"), true): _switch3_start = 3
	elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE"), true): _switch3_start = 4
	elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD"), true): _switch3_start = 5
	elif JS.equal(_switch3, JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "ZONE"), true): _switch3_start = 6
	while true:
		if _switch3_start >= 0 and _switch3_start <= 0:
			if JS.truthy(JS.get_property(_scope44["data"], "tankA")):
				JS.set_property(_scope44["data"], "tankB", JS.get_property(JS.invoke_method(_scope44["fixtureB"], "GetUserData", []), "gameObject"))
			else:
				JS.set_property(_scope44["data"], "tankA", JS.get_property(JS.invoke_method(_scope44["fixtureB"], "GetUserData", []), "gameObject"))
			break
		if _switch3_start >= 0 and _switch3_start <= 1:
			JS.set_property(_scope44["data"], "maze", JS.get_property(JS.invoke_method(_scope44["fixtureB"], "GetUserData", []), "gameObject"))
			break
		if _switch3_start >= 0 and _switch3_start <= 2:
			JS.set_property(_scope44["data"], "projectile", JS.get_property(JS.invoke_method(_scope44["fixtureB"], "GetUserData", []), "gameObject"))
			break
		if _switch3_start >= 0 and _switch3_start <= 3:
			JS.set_property(_scope44["data"], "trap", JS.get_property(JS.invoke_method(_scope44["fixtureB"], "GetUserData", []), "gameObject"))
			break
		if _switch3_start >= 0 and _switch3_start <= 4:
			JS.set_property(_scope44["data"], "collectible", JS.get_property(JS.invoke_method(_scope44["fixtureB"], "GetUserData", []), "gameObject"))
			break
		if _switch3_start >= 0 and _switch3_start <= 5:
			if JS.truthy(JS.get_property(_scope44["data"], "shieldA")):
				JS.set_property(_scope44["data"], "shieldB", JS.get_property(JS.invoke_method(_scope44["fixtureB"], "GetUserData", []), "gameObject"))
			else:
				JS.set_property(_scope44["data"], "shieldA", JS.get_property(JS.invoke_method(_scope44["fixtureB"], "GetUserData", []), "gameObject"))
			break
		if _switch3_start >= 0 and _switch3_start <= 6:
			JS.set_property(_scope44["data"], "zone", JS.get_property(JS.invoke_method(_scope44["fixtureB"], "GetUserData", []), "gameObject"))
			break
		if _switch3_start >= 0 and _switch3_start <= 7:
			JS.invoke_method("@console", "log", ["Unknown collision category in B2DUtils.getContactData"])
		break
	return _scope44["data"]
	return null

static func original_calculateProjectilePath(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope45: Dictionary = {"b2dworld": _arg0, "projectile": _arg1, "maxBounces": _arg2, "maxLength": _arg3, "collideWithTanks": _arg4, "b2body": null}
	_scope45["b2body"] = JS.invoke_method(_scope45["projectile"], "getB2DBody", [])
	return JS.invoke_method(JS.module("B2DUtils"), "calculatePath", [_scope45["b2dworld"], JS.invoke_method(_scope45["b2body"], "GetPosition", []), JS.invoke_method(_scope45["b2body"], "GetLinearVelocity", []), _scope45["maxBounces"], _scope45["maxLength"], _scope45["collideWithTanks"]])
	return null

static func original_calculateFiringPath(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope46: Dictionary = {"b2dworld": _arg0, "tank": _arg1, "angle": _arg2, "maxBounces": _arg3, "maxLength": _arg4, "collideWithTanks": _arg5, "b2body": null, "direction": null, "position": null}
	_scope46["b2body"] = JS.invoke_method(_scope46["tank"], "getB2DBody", [])
	_scope46["direction"] = JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Math"), "MulMV", [JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Mat22"), "FromAngle", [JS.add(JS.invoke_method(_scope46["b2body"], "GetAngle", []), _scope46["angle"])]), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [0, (JS.number(-(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "HEIGHT"), "m"))) * JS.number(0.5))])])
	_scope46["position"] = JS.invoke_method(JS.invoke_method(_scope46["b2body"], "GetPosition", []), "Copy", [])
	JS.set_property(_scope46["position"], "x", JS.add(JS.get_property(_scope46["position"], "x"), JS.get_property(_scope46["direction"], "x")))
	JS.set_property(_scope46["position"], "y", JS.add(JS.get_property(_scope46["position"], "y"), JS.get_property(_scope46["direction"], "y")))
	return JS.invoke_method(JS.module("B2DUtils"), "calculatePath", [_scope46["b2dworld"], _scope46["position"], _scope46["direction"], _scope46["maxBounces"], _scope46["maxLength"], _scope46["collideWithTanks"]])
	return null

static func original_calculatePath(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope47: Dictionary = {"b2dworld": _arg0, "position": _arg1, "direction": _arg2, "maxBounces": _arg3, "maxLength": _arg4, "collideWithTanks": _arg5, "path": null, "hit": null, "pathLength": null, "firstSegmentLength": null, "remainingLength": null, "bounces": null, "currentDirection": null, "currentPosition": null, "nextPosition": null, "closestFixture": null, "closestPoint": null, "closestNormal": null, "closestFraction": null, "rayLength": null}
	_scope47["path"] = []
	_scope47["hit"] = null
	_scope47["pathLength"] = 0
	_scope47["firstSegmentLength"] = 0
	JS.invoke_method(_scope47["path"], "push", [_scope47["position"]])
	_scope47["remainingLength"] = _scope47["maxLength"]
	_scope47["bounces"] = 0
	_scope47["currentDirection"] = JS.invoke_method(_scope47["direction"], "Copy", [])
	JS.invoke_method(_scope47["currentDirection"], "Normalize", [])
	_scope47["currentPosition"] = JS.invoke_method(_scope47["position"], "Copy", [])
	_scope47["nextPosition"] = JS.invoke_method(_scope47["currentPosition"], "Copy", [])
	JS.set_property(_scope47["nextPosition"], "x", JS.add(JS.get_property(_scope47["nextPosition"], "x"), (JS.number(JS.get_property(_scope47["currentDirection"], "x")) * JS.number(_scope47["remainingLength"]))))
	JS.set_property(_scope47["nextPosition"], "y", JS.add(JS.get_property(_scope47["nextPosition"], "y"), (JS.number(JS.get_property(_scope47["currentDirection"], "y")) * JS.number(_scope47["remainingLength"]))))
	_scope47["closestFixture"] = null
	_scope47["closestPoint"] = JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [0, 0])
	_scope47["closestNormal"] = JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [0, 0])
	_scope47["closestFraction"] = 1
	while JS.truthy(JS.logical("&&", func():
		var _scope48: Dictionary = {}
		return JS.compare(">", _scope47["remainingLength"], 0)
		return null, func():
		var _scope49: Dictionary = {}
		return JS.compare("<=", _scope47["bounces"], _scope47["maxBounces"])
		return null)):
		JS.invoke_method(_scope47["b2dworld"], "RayCast", [func(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
			var _scope50: Dictionary = {"fixture": _arg0, "point": _arg1, "normal": _arg2, "fraction": _arg3}
			if JS.truthy(JS.logical("||", func():
				var _scope51: Dictionary = {}
				return JS.equal(JS.get_property(JS.invoke_method(_scope50["fixture"], "GetFilterData", []), "categoryBits"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "PROJECTILE"), true)
				return null, func():
				var _scope52: Dictionary = {}
				return JS.equal(JS.get_property(JS.invoke_method(_scope50["fixture"], "GetFilterData", []), "categoryBits"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "COLLECTIBLE"), true)
				return null)):
				return _scope47["closestFraction"]
			if JS.truthy(JS.logical("&&", func():
				var _scope53: Dictionary = {}
				return (not JS.truthy(_scope47["collideWithTanks"]))
				return null, func():
				var _scope54: Dictionary = {}
				return JS.equal(JS.get_property(JS.invoke_method(_scope50["fixture"], "GetFilterData", []), "categoryBits"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), true)
				return null)):
				return _scope47["closestFraction"]
			if JS.truthy(JS.compare("<", _scope50["fraction"], _scope47["closestFraction"])):
				JS.set_property(_scope47, "closestFixture", _scope50["fixture"])
				JS.invoke_method(_scope47["closestPoint"], "SetV", [_scope50["point"]])
				JS.invoke_method(_scope47["closestNormal"], "SetV", [_scope50["normal"]])
				JS.set_property(_scope47, "closestFraction", _scope50["fraction"])
			return _scope47["closestFraction"]
			return null, _scope47["currentPosition"], _scope47["nextPosition"]])
		if JS.truthy(_scope47["closestFixture"]):
			JS.invoke_method(_scope47["path"], "push", [JS.invoke_method(_scope47["closestPoint"], "Copy", [])])
			if JS.truthy(JS.logical("||", func():
				var _scope55: Dictionary = {}
				return JS.equal(JS.get_property(JS.invoke_method(_scope47["closestFixture"], "GetFilterData", []), "categoryBits"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE"), true)
				return null, func():
				var _scope56: Dictionary = {}
				return JS.equal(JS.get_property(JS.invoke_method(_scope47["closestFixture"], "GetFilterData", []), "categoryBits"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "SHIELD"), true)
				return null)):
				_scope47["rayLength"] = JS.invoke_method("@Math", "max", [JS.get_property(JS.module("Constants"), "PATH_MIN_STEP_LENGTH"), (JS.number(_scope47["closestFraction"]) * JS.number(_scope47["remainingLength"]))])
				JS.set_property(_scope47, "pathLength", JS.add(_scope47["pathLength"], _scope47["rayLength"]))
				JS.set_property(_scope47, "remainingLength", (JS.number(_scope47["remainingLength"]) - JS.number(_scope47["rayLength"])))
				JS.invoke_method(_scope47["closestNormal"], "Multiply", [(JS.number(-(2)) * JS.number(JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Math"), "Dot", [_scope47["currentDirection"], _scope47["closestNormal"]])))])
				JS.set_property(_scope47["currentDirection"], "x", JS.add(JS.get_property(_scope47["currentDirection"], "x"), JS.get_property(_scope47["closestNormal"], "x")))
				JS.set_property(_scope47["currentDirection"], "y", JS.add(JS.get_property(_scope47["currentDirection"], "y"), JS.get_property(_scope47["closestNormal"], "y")))
				JS.invoke_method(_scope47["currentPosition"], "SetV", [_scope47["closestPoint"]])
				JS.invoke_method(_scope47["nextPosition"], "SetV", [_scope47["currentPosition"]])
				JS.set_property(_scope47["nextPosition"], "x", JS.add(JS.get_property(_scope47["nextPosition"], "x"), (JS.number(JS.get_property(_scope47["currentDirection"], "x")) * JS.number(_scope47["remainingLength"]))))
				JS.set_property(_scope47["nextPosition"], "y", JS.add(JS.get_property(_scope47["nextPosition"], "y"), (JS.number(JS.get_property(_scope47["currentDirection"], "y")) * JS.number(_scope47["remainingLength"]))))
			else:
				JS.set_property(_scope47, "pathLength", JS.add(_scope47["pathLength"], (JS.number(_scope47["closestFraction"]) * JS.number(_scope47["remainingLength"]))))
				JS.set_property(_scope47, "remainingLength", 0)
				if JS.truthy(JS.equal(JS.get_property(JS.invoke_method(_scope47["closestFixture"], "GetFilterData", []), "categoryBits"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "TANK"), true)):
					JS.set_property(_scope47, "hit", JS.get_property(JS.invoke_method(_scope47["closestFixture"], "GetUserData", []), "gameObject"))
		else:
			JS.set_property(_scope47, "pathLength", JS.add(_scope47["pathLength"], _scope47["remainingLength"]))
			JS.set_property(_scope47, "remainingLength", 0)
			JS.invoke_method(_scope47["path"], "push", [_scope47["nextPosition"]])
		if JS.truthy(JS.equal(_scope47["bounces"], 0, true)):
			JS.set_property(_scope47, "firstSegmentLength", _scope47["pathLength"])
		JS.set_property(_scope47, "closestFraction", 1)
		JS.set_property(_scope47, "closestFixture", null)
		JS.increment(_scope47, "bounces", 1, false)
	return {"path": _scope47["path"], "hit": _scope47["hit"], "firstSegmentLength": _scope47["firstSegmentLength"], "length": _scope47["pathLength"], "direction": _scope47["direction"]}
	return null

static func original_splatPathUntoMazeMap(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope57: Dictionary = {"map": _arg0, "path": _arg1, "stepSize": _arg2, "splatFn": _arg3, "mapData": null, "i": null, "tile": null, "totalLength": null, "segmentSample": null, "segmentStart": null, "segmentEnd": null, "segmentDir": null, "segmentLength": null, "current": null}
	_scope57["mapData"] = JS.invoke_method(_scope57["map"], "data", [])
	_scope57["i"] = 0
	while JS.truthy(JS.compare("<", _scope57["i"], JS.get_property(_scope57["path"], "length"))):
		_scope57["tile"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(JS.get_property(_scope57["path"], _scope57["i"]), "x")) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(JS.get_property(_scope57["path"], _scope57["i"]), "x")) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
		if JS.truthy((not JS.truthy(JS.invoke_method(_scope57["map"], "isPositionInsideMap", [_scope57["tile"]])))):
			return null
		JS.increment(_scope57, "i", 1, false)
	_scope57["totalLength"] = 0
	_scope57["segmentSample"] = 0
	_scope57["tile"] = JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [0, 0])
	_scope57["i"] = 1
	while JS.truthy(JS.compare("<", _scope57["i"], JS.get_property(_scope57["path"], "length"))):
		_scope57["segmentStart"] = JS.get_property(_scope57["path"], (JS.number(_scope57["i"]) - JS.number(1)))
		_scope57["segmentEnd"] = JS.get_property(_scope57["path"], _scope57["i"])
		_scope57["segmentDir"] = JS.invoke_method(_scope57["segmentEnd"], "Copy", [])
		JS.invoke_method(_scope57["segmentDir"], "Subtract", [_scope57["segmentStart"]])
		_scope57["segmentLength"] = JS.invoke_method(_scope57["segmentDir"], "Normalize", [])
		while JS.truthy(JS.compare("<", _scope57["segmentSample"], _scope57["segmentLength"])):
			_scope57["current"] = JS.invoke_method(_scope57["segmentDir"], "Copy", [])
			JS.invoke_method(_scope57["current"], "Multiply", [_scope57["segmentSample"]])
			JS.invoke_method(_scope57["current"], "Add", [_scope57["segmentStart"]])
			JS.invoke_method(_scope57["tile"], "Set", [JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(_scope57["current"], "x")) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), JS.invoke_method("@Math", "floor", [(JS.number(JS.get_property(_scope57["current"], "y")) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])])
			JS.set_property(JS.get_property(_scope57["mapData"], JS.get_property(_scope57["tile"], "x")), JS.get_property(_scope57["tile"], "y"), JS.add(JS.get_property(JS.get_property(_scope57["mapData"], JS.get_property(_scope57["tile"], "x")), JS.get_property(_scope57["tile"], "y")), JS.invoke(_scope57["splatFn"], [_scope57["tile"], JS.add(_scope57["totalLength"], _scope57["segmentSample"]), _scope57["stepSize"]])))
			JS.set_property(_scope57, "segmentSample", JS.add(_scope57["segmentSample"], _scope57["stepSize"]))
		JS.set_property(_scope57, "totalLength", JS.add(_scope57["totalLength"], _scope57["segmentLength"]))
		JS.set_property(_scope57, "segmentSample", (JS.number(_scope57["segmentSample"]) - JS.number(_scope57["segmentLength"])))
		JS.increment(_scope57, "i", 1, false)
	return null

static func original_checkLineForMazeCollision(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope58: Dictionary = {"b2dworld": _arg0, "startPosition": _arg1, "endPosition": _arg2, "hitMaze": null}
	_scope58["hitMaze"] = false
	JS.invoke_method(_scope58["b2dworld"], "RayCast", [func(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
		var _scope59: Dictionary = {"fixture": _arg0, "point": _arg1, "normal": _arg2, "fraction": _arg3}
		if JS.truthy(not JS.equal(JS.get_property(JS.invoke_method(_scope59["fixture"], "GetFilterData", []), "categoryBits"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE"), true)):
			return 1
		JS.set_property(_scope58, "hitMaze", true)
		return 0
		return null, _scope58["startPosition"], _scope58["endPosition"]])
	return _scope58["hitMaze"]
	return null

static func original_toLocalSpace(_arg0 = null, _arg1 = null):
	var _scope60: Dictionary = {"b2body": _arg0, "position": _arg1, "worldPoint": null, "localPoint": null}
	_scope60["worldPoint"] = JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.get_property(_scope60["position"], "x"), JS.get_property(_scope60["position"], "y")])
	_scope60["localPoint"] = JS.invoke_method(_scope60["b2body"], "GetLocalPoint", [_scope60["worldPoint"]])
	return _scope60["localPoint"]
	return null

static func original_directionToLocalSpace(_arg0 = null, _arg1 = null):
	var _scope61: Dictionary = {"b2body": _arg0, "direction": _arg1, "worldPoint": null, "localPoint": null}
	_scope61["worldPoint"] = JS.invoke_method(JS.invoke_method(_scope61["b2body"], "GetPosition", []), "Copy", [])
	JS.invoke_method(_scope61["worldPoint"], "Add", [_scope61["direction"]])
	_scope61["localPoint"] = JS.invoke_method(_scope61["b2body"], "GetLocalPoint", [_scope61["worldPoint"]])
	return _scope61["localPoint"]
	return null

static func original_verifyTankStatePhysics(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope62: Dictionary = {"b2dworld": _arg0, "b2body": _arg1, "tankState": _arg2, "tankStatePosition": null, "tankStateRotation": null, "tankStateTransform": null, "foundOverlap": null, "currentFixture": null, "shape": null}
	_scope62["tankStatePosition"] = JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Vec2"), "Make", [JS.invoke_method(_scope62["tankState"], "getX", []), JS.invoke_method(_scope62["tankState"], "getY", [])])
	_scope62["tankStateRotation"] = JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Mat22"), "FromAngle", [JS.invoke_method(_scope62["tankState"], "getRotation", [])])
	_scope62["tankStateTransform"] = JS.construct(JS.get_property(JS.get_property(JS.get_property(JS.module("Box2D"), "Common"), "Math"), "b2Transform"), [_scope62["tankStatePosition"], _scope62["tankStateRotation"]])
	_scope62["foundOverlap"] = false
	_scope62["currentFixture"] = JS.invoke_method(_scope62["b2body"], "GetFixtureList", [])
	while JS.truthy(JS.logical("&&", func():
		var _scope63: Dictionary = {}
		return (not JS.truthy(_scope62["foundOverlap"]))
		return null, func():
		var _scope64: Dictionary = {}
		return not JS.equal(_scope62["currentFixture"], null, false)
		return null)):
		_scope62["shape"] = JS.invoke_method(_scope62["currentFixture"], "GetShape", [])
		JS.invoke_method(_scope62["b2dworld"], "QueryShape", [func(_arg0 = null):
			var _scope65: Dictionary = {"fixture": _arg0}
			if JS.truthy(JS.equal(JS.get_property(JS.invoke_method(_scope65["fixture"], "GetFilterData", []), "categoryBits"), JS.get_property(JS.get_property(JS.module("Constants"), "COLLISION_CATEGORIES"), "MAZE"), true)):
				JS.set_property(_scope62, "foundOverlap", true)
				return false
			return true
			return null, _scope62["shape"], _scope62["tankStateTransform"]])
		JS.set_property(_scope62, "currentFixture", JS.invoke_method(_scope62["currentFixture"], "GetNext", []))
	return (not JS.truthy(_scope62["foundOverlap"]))
	return null
