# 由原版 MazeThemeManager 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_MazeThemeManager: Dictionary = {}
static var _initialized_MazeThemeManager = false
static func initialize_original_static():
	if _initialized_MazeThemeManager: return
	_initialized_MazeThemeManager = true
	_static_MazeThemeManager["preparedThemes"] = {}
static func original_static_get(key):
	initialize_original_static()
	if _static_MazeThemeManager.has(key): return _static_MazeThemeManager[key]
	return null
static func original_static_set(key, value):
	_static_MazeThemeManager[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/world/mazethememanager.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

static func original__prepareTheme(_arg0 = null):
	var _scope0: Dictionary = {"theme": _arg0, "newTheme": null, "i": null, "themeInfo": null, "config": null, "requiredWalls": null, "missingWalls": null, "rotation": null, "rotatedRequiredWalls": null, "rotatedMissingWalls": null, "j": null}
	_scope0["newTheme"] = {}
	JS.set_property(_scope0["newTheme"], "wallConfigurationToFloors", [])
	JS.set_property(_scope0["newTheme"], "wallConfigurationToFloorWeightSum", [])
	JS.set_property(_scope0["newTheme"], "wallConfigurationToSpaces", [])
	JS.set_property(_scope0["newTheme"], "wallConfigurationToSpaceWeightSum", [])
	JS.set_property(_scope0["newTheme"], "wallConfigurationToWallDecorations", [])
	JS.set_property(_scope0["newTheme"], "wallConfigurationToWallDecorationWeightSum", [])
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], 16)):
		JS.invoke_method(JS.get_property(_scope0["newTheme"], "wallConfigurationToFloors"), "push", [[]])
		JS.invoke_method(JS.get_property(_scope0["newTheme"], "wallConfigurationToFloorWeightSum"), "push", [0])
		JS.invoke_method(JS.get_property(_scope0["newTheme"], "wallConfigurationToSpaces"), "push", [[]])
		JS.invoke_method(JS.get_property(_scope0["newTheme"], "wallConfigurationToSpaceWeightSum"), "push", [0])
		JS.invoke_method(JS.get_property(_scope0["newTheme"], "wallConfigurationToWallDecorations"), "push", [[]])
		JS.invoke_method(JS.get_property(_scope0["newTheme"], "wallConfigurationToWallDecorationWeightSum"), "push", [0])
		JS.increment(_scope0, "i", 1, false)
	_scope0["themeInfo"] = JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEME_INFO"), _scope0["theme"])
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.get_property(_scope0["themeInfo"], "FLOOR_CONFIG"), "length"))):
		_scope0["config"] = JS.get_property(JS.get_property(_scope0["themeInfo"], "FLOOR_CONFIG"), _scope0["i"])
		_scope0["requiredWalls"] = JS.get_property(_scope0["config"], "required")
		_scope0["missingWalls"] = JS.get_property(_scope0["config"], "missing")
		_scope0["rotation"] = 0
		while JS.truthy(JS.compare("<", _scope0["rotation"], 4)):
			_scope0["rotatedRequiredWalls"] = JS.bitwise("|", JS.bitwise(">>>", _scope0["requiredWalls"], _scope0["rotation"]), JS.bitwise("&", JS.bitwise("<<", _scope0["requiredWalls"], (JS.number(4) - JS.number(_scope0["rotation"]))), 15))
			_scope0["rotatedMissingWalls"] = JS.bitwise("|", JS.bitwise(">>>", _scope0["missingWalls"], _scope0["rotation"]), JS.bitwise("&", JS.bitwise("<<", _scope0["missingWalls"], (JS.number(4) - JS.number(_scope0["rotation"]))), 15))
			_scope0["j"] = 0
			while JS.truthy(JS.compare("<", _scope0["j"], 16)):
				if JS.truthy(JS.logical("&&", func():
					var _scope1: Dictionary = {}
					return JS.equal(JS.bitwise("&", _scope0["j"], _scope0["rotatedRequiredWalls"]), _scope0["rotatedRequiredWalls"], false)
					return null, func():
					var _scope2: Dictionary = {}
					return JS.equal(JS.bitwise("&", _scope0["j"], _scope0["rotatedMissingWalls"]), 0, false)
					return null)):
					JS.invoke_method(JS.get_property(JS.get_property(_scope0["newTheme"], "wallConfigurationToFloors"), _scope0["j"]), "push", [{"number": _scope0["i"], "orientation": _scope0["rotation"], "weight": JS.get_property(_scope0["config"], "weight")}])
					JS.set_property(JS.get_property(_scope0["newTheme"], "wallConfigurationToFloorWeightSum"), _scope0["j"], JS.add(JS.get_property(JS.get_property(_scope0["newTheme"], "wallConfigurationToFloorWeightSum"), _scope0["j"]), JS.get_property(_scope0["config"], "weight")))
				JS.increment(_scope0, "j", 1, false)
			JS.increment(_scope0, "rotation", 1, false)
		JS.increment(_scope0, "i", 1, false)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.get_property(_scope0["themeInfo"], "SPACE_CONFIG"), "length"))):
		_scope0["config"] = JS.get_property(JS.get_property(_scope0["themeInfo"], "SPACE_CONFIG"), _scope0["i"])
		_scope0["requiredWalls"] = JS.get_property(_scope0["config"], "required")
		_scope0["missingWalls"] = JS.get_property(_scope0["config"], "missing")
		_scope0["rotation"] = 0
		while JS.truthy(JS.compare("<", _scope0["rotation"], 4)):
			_scope0["rotatedRequiredWalls"] = JS.bitwise("|", JS.bitwise(">>>", _scope0["requiredWalls"], _scope0["rotation"]), JS.bitwise("&", JS.bitwise("<<", _scope0["requiredWalls"], (JS.number(4) - JS.number(_scope0["rotation"]))), 15))
			_scope0["rotatedMissingWalls"] = JS.bitwise("|", JS.bitwise(">>>", _scope0["missingWalls"], _scope0["rotation"]), JS.bitwise("&", JS.bitwise("<<", _scope0["missingWalls"], (JS.number(4) - JS.number(_scope0["rotation"]))), 15))
			_scope0["j"] = 0
			while JS.truthy(JS.compare("<", _scope0["j"], 16)):
				if JS.truthy(JS.logical("&&", func():
					var _scope3: Dictionary = {}
					return JS.equal(JS.bitwise("&", _scope0["j"], _scope0["rotatedRequiredWalls"]), _scope0["rotatedRequiredWalls"], false)
					return null, func():
					var _scope4: Dictionary = {}
					return JS.equal(JS.bitwise("&", _scope0["j"], _scope0["rotatedMissingWalls"]), 0, false)
					return null)):
					JS.invoke_method(JS.get_property(JS.get_property(_scope0["newTheme"], "wallConfigurationToSpaces"), _scope0["j"]), "push", [{"number": _scope0["i"], "orientation": _scope0["rotation"], "weight": JS.get_property(_scope0["config"], "weight")}])
					JS.set_property(JS.get_property(_scope0["newTheme"], "wallConfigurationToSpaceWeightSum"), _scope0["j"], JS.add(JS.get_property(JS.get_property(_scope0["newTheme"], "wallConfigurationToSpaceWeightSum"), _scope0["j"]), JS.get_property(_scope0["config"], "weight")))
				JS.increment(_scope0, "j", 1, false)
			JS.increment(_scope0, "rotation", 1, false)
		JS.increment(_scope0, "i", 1, false)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.get_property(_scope0["themeInfo"], "WALL_DECORATION_CONFIG"), "length"))):
		_scope0["config"] = JS.get_property(JS.get_property(_scope0["themeInfo"], "WALL_DECORATION_CONFIG"), _scope0["i"])
		_scope0["requiredWalls"] = JS.get_property(_scope0["config"], "required")
		_scope0["missingWalls"] = JS.get_property(_scope0["config"], "missing")
		_scope0["rotation"] = 0
		while JS.truthy(JS.compare("<", _scope0["rotation"], 4)):
			_scope0["rotatedRequiredWalls"] = JS.bitwise("|", JS.bitwise(">>>", _scope0["requiredWalls"], _scope0["rotation"]), JS.bitwise("&", JS.bitwise("<<", _scope0["requiredWalls"], (JS.number(4) - JS.number(_scope0["rotation"]))), 15))
			_scope0["rotatedMissingWalls"] = JS.bitwise("|", JS.bitwise(">>>", _scope0["missingWalls"], _scope0["rotation"]), JS.bitwise("&", JS.bitwise("<<", _scope0["missingWalls"], (JS.number(4) - JS.number(_scope0["rotation"]))), 15))
			_scope0["j"] = 0
			while JS.truthy(JS.compare("<", _scope0["j"], 16)):
				if JS.truthy(JS.logical("&&", func():
					var _scope5: Dictionary = {}
					return JS.equal(JS.bitwise("&", _scope0["j"], _scope0["rotatedRequiredWalls"]), _scope0["rotatedRequiredWalls"], false)
					return null, func():
					var _scope6: Dictionary = {}
					return JS.equal(JS.bitwise("&", _scope0["j"], _scope0["rotatedMissingWalls"]), 0, false)
					return null)):
					JS.invoke_method(JS.get_property(JS.get_property(_scope0["newTheme"], "wallConfigurationToWallDecorations"), _scope0["j"]), "push", [{"number": _scope0["i"], "orientation": _scope0["rotation"], "weight": JS.get_property(_scope0["config"], "weight")}])
					JS.set_property(JS.get_property(_scope0["newTheme"], "wallConfigurationToWallDecorationWeightSum"), _scope0["j"], JS.add(JS.get_property(JS.get_property(_scope0["newTheme"], "wallConfigurationToWallDecorationWeightSum"), _scope0["j"]), JS.get_property(_scope0["config"], "weight")))
				JS.increment(_scope0, "j", 1, false)
			JS.increment(_scope0, "rotation", 1, false)
		JS.increment(_scope0, "i", 1, false)
	JS.set_property(_scope0["newTheme"], "borders", [])
	JS.set_property(_scope0["newTheme"], "borderWeightSum", 0)
	JS.set_property(_scope0["newTheme"], "walls", [])
	JS.set_property(_scope0["newTheme"], "wallWeightSum", 0)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.get_property(_scope0["themeInfo"], "BORDER_CONFIG"), "length"))):
		_scope0["config"] = JS.get_property(JS.get_property(_scope0["themeInfo"], "BORDER_CONFIG"), _scope0["i"])
		JS.invoke_method(JS.get_property(_scope0["newTheme"], "borders"), "push", [{"number": _scope0["i"], "flip": JS.get_property(_scope0["config"], "flip"), "weight": JS.get_property(_scope0["config"], "weight")}])
		JS.set_property(_scope0["newTheme"], "borderWeightSum", JS.add(JS.get_property(_scope0["newTheme"], "borderWeightSum"), JS.get_property(_scope0["config"], "weight")))
		JS.increment(_scope0, "i", 1, false)
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.get_property(_scope0["themeInfo"], "WALL_CONFIG"), "length"))):
		_scope0["config"] = JS.get_property(JS.get_property(_scope0["themeInfo"], "WALL_CONFIG"), _scope0["i"])
		JS.invoke_method(JS.get_property(_scope0["newTheme"], "walls"), "push", [{"number": _scope0["i"], "flipX": JS.get_property(_scope0["config"], "flipX"), "flipY": JS.get_property(_scope0["config"], "flipY"), "weight": JS.get_property(_scope0["config"], "weight")}])
		JS.set_property(_scope0["newTheme"], "wallWeightSum", JS.add(JS.get_property(_scope0["newTheme"], "wallWeightSum"), JS.get_property(_scope0["config"], "weight")))
		JS.increment(_scope0, "i", 1, false)
	JS.set_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope0["theme"], _scope0["newTheme"])
	return null

static func original_getRandomFloor(_arg0 = null, _arg1 = null):
	var _scope7: Dictionary = {"theme": _arg0, "wallConfiguration": _arg1}
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope7["theme"]), null, true)):
		JS.invoke_method(JS.module("MazeThemeManager"), "_prepareTheme", [_scope7["theme"]])
	return JS.invoke_method(JS.module("MazeThemeManager"), "_getWeightedRandomElement", [JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope7["theme"]), "wallConfigurationToFloors"), _scope7["wallConfiguration"]), JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope7["theme"]), "wallConfigurationToFloorWeightSum"), _scope7["wallConfiguration"])])
	return null

static func original_getRandomSpace(_arg0 = null, _arg1 = null):
	var _scope8: Dictionary = {"theme": _arg0, "wallConfiguration": _arg1}
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope8["theme"]), null, true)):
		JS.invoke_method(JS.module("MazeThemeManager"), "_prepareTheme", [_scope8["theme"]])
	return JS.invoke_method(JS.module("MazeThemeManager"), "_getWeightedRandomElement", [JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope8["theme"]), "wallConfigurationToSpaces"), _scope8["wallConfiguration"]), JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope8["theme"]), "wallConfigurationToSpaceWeightSum"), _scope8["wallConfiguration"])])
	return null

static func original_getRandomWallDecoration(_arg0 = null, _arg1 = null):
	var _scope9: Dictionary = {"theme": _arg0, "wallConfiguration": _arg1}
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope9["theme"]), null, true)):
		JS.invoke_method(JS.module("MazeThemeManager"), "_prepareTheme", [_scope9["theme"]])
	if JS.truthy(JS.compare(">=", JS.invoke_method("@Math", "random", []), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEME_INFO"), _scope9["theme"]), "WALL_DECORATION_PROBABILITY"))):
		return null
	return JS.invoke_method(JS.module("MazeThemeManager"), "_getWeightedRandomElement", [JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope9["theme"]), "wallConfigurationToWallDecorations"), _scope9["wallConfiguration"]), JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope9["theme"]), "wallConfigurationToWallDecorationWeightSum"), _scope9["wallConfiguration"])])
	return null

static func original_getRandomBorders(_arg0 = null, _arg1 = null):
	var _scope10: Dictionary = {"theme": _arg0, "wallConfiguration": _arg1, "result": null, "border": null}
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope10["theme"]), null, true)):
		JS.invoke_method(JS.module("MazeThemeManager"), "_prepareTheme", [_scope10["theme"]])
	_scope10["result"] = []
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEME_INFO"), _scope10["theme"]), "BORDER_CONFIG"), "length"), 0, false)):
		return _scope10["result"]
	if JS.truthy(JS.bitwise("&", _scope10["wallConfiguration"], JS.bitwise("<<", 1, 0))):
		_scope10["border"] = JS.invoke_method(JS.module("MazeThemeManager"), "_getWeightedRandomElement", [JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope10["theme"]), "borders"), JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope10["theme"]), "borderWeightSum")])
		JS.invoke_method(_scope10["result"], "push", [{"number": JS.get_property(_scope10["border"], "number"), "orientation": 2, "flip": (JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5) if JS.truthy(JS.get_property(_scope10["border"], "flip")) else false)}])
	if JS.truthy(JS.bitwise("&", _scope10["wallConfiguration"], JS.bitwise("<<", 1, 1))):
		_scope10["border"] = JS.invoke_method(JS.module("MazeThemeManager"), "_getWeightedRandomElement", [JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope10["theme"]), "borders"), JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope10["theme"]), "borderWeightSum")])
		JS.invoke_method(_scope10["result"], "push", [{"number": JS.get_property(_scope10["border"], "number"), "orientation": 1, "flip": (JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5) if JS.truthy(JS.get_property(_scope10["border"], "flip")) else false)}])
	if JS.truthy(JS.bitwise("&", _scope10["wallConfiguration"], JS.bitwise("<<", 1, 2))):
		_scope10["border"] = JS.invoke_method(JS.module("MazeThemeManager"), "_getWeightedRandomElement", [JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope10["theme"]), "borders"), JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope10["theme"]), "borderWeightSum")])
		JS.invoke_method(_scope10["result"], "push", [{"number": JS.get_property(_scope10["border"], "number"), "orientation": 0, "flip": (JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5) if JS.truthy(JS.get_property(_scope10["border"], "flip")) else false)}])
	if JS.truthy(JS.bitwise("&", _scope10["wallConfiguration"], JS.bitwise("<<", 1, 3))):
		_scope10["border"] = JS.invoke_method(JS.module("MazeThemeManager"), "_getWeightedRandomElement", [JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope10["theme"]), "borders"), JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope10["theme"]), "borderWeightSum")])
		JS.invoke_method(_scope10["result"], "push", [{"number": JS.get_property(_scope10["border"], "number"), "orientation": -(1), "flip": (JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5) if JS.truthy(JS.get_property(_scope10["border"], "flip")) else false)}])
	return _scope10["result"]
	return null

static func original_getRandomWalls(_arg0 = null, _arg1 = null):
	var _scope11: Dictionary = {"theme": _arg0, "wallConfiguration": _arg1, "result": null, "wall": null}
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope11["theme"]), null, true)):
		JS.invoke_method(JS.module("MazeThemeManager"), "_prepareTheme", [_scope11["theme"]])
	_scope11["result"] = []
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEME_INFO"), _scope11["theme"]), "WALL_CONFIG"), "length"), 0, false)):
		return _scope11["result"]
	if JS.truthy(JS.bitwise("&", _scope11["wallConfiguration"], JS.bitwise("<<", 1, 0))):
		_scope11["wall"] = JS.invoke_method(JS.module("MazeThemeManager"), "_getWeightedRandomElement", [JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope11["theme"]), "walls"), JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope11["theme"]), "wallWeightSum")])
		JS.invoke_method(_scope11["result"], "push", [{"number": JS.get_property(_scope11["wall"], "number"), "rotate": false, "flipX": (JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5) if JS.truthy(JS.get_property(_scope11["wall"], "flipX")) else false), "flipY": (JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5) if JS.truthy(JS.get_property(_scope11["wall"], "flipY")) else false)}])
	if JS.truthy(JS.bitwise("&", _scope11["wallConfiguration"], JS.bitwise("<<", 1, 1))):
		_scope11["wall"] = JS.invoke_method(JS.module("MazeThemeManager"), "_getWeightedRandomElement", [JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope11["theme"]), "walls"), JS.get_property(JS.get_property(JS.get_property(JS.module("MazeThemeManager"), "preparedThemes"), _scope11["theme"]), "wallWeightSum")])
		JS.invoke_method(_scope11["result"], "push", [{"number": JS.get_property(_scope11["wall"], "number"), "rotate": true, "flipX": (JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5) if JS.truthy(JS.get_property(_scope11["wall"], "flipX")) else false), "flipY": (JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5) if JS.truthy(JS.get_property(_scope11["wall"], "flipY")) else false)}])
	return _scope11["result"]
	return null

static func original_getRandomActiveTheme():
	var _scope12: Dictionary = {"now": null, "activeThemes": null, "i": null, "start": null, "end": null}
	_scope12["now"] = JS.construct("@Date", [])
	JS.invoke_method(_scope12["now"], "setUTCFullYear", [1970])
	_scope12["activeThemes"] = []
	_scope12["i"] = 0
	while JS.truthy(JS.compare("<", _scope12["i"], JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEMES"), "COUNT"))):
		if JS.truthy(JS.logical("&&", func():
			var _scope13: Dictionary = {}
			return not JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEME_INFO"), _scope12["i"]), "ACTIVE_DURATION_START"), null, true)
			return null, func():
			var _scope14: Dictionary = {}
			return not JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEME_INFO"), _scope12["i"]), "ACTIVE_DURATION_END"), null, true)
			return null)):
			_scope12["start"] = JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEME_INFO"), _scope12["i"]), "ACTIVE_DURATION_START")
			_scope12["end"] = JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_THEME_INFO"), _scope12["i"]), "ACTIVE_DURATION_END")
			JS.invoke_method(_scope12["start"], "setUTCFullYear", [1970])
			JS.invoke_method(_scope12["end"], "setUTCFullYear", [1970])
			if JS.truthy(JS.logical("&&", func():
				var _scope15: Dictionary = {}
				return JS.compare(">=", _scope12["now"], _scope12["start"])
				return null, func():
				var _scope16: Dictionary = {}
				return JS.compare("<=", _scope12["now"], _scope12["end"])
				return null)):
				JS.invoke_method(_scope12["activeThemes"], "push", [_scope12["i"]])
		else:
			JS.invoke_method(_scope12["activeThemes"], "push", [_scope12["i"]])
		JS.increment(_scope12, "i", 1, false)
	return JS.get_property(_scope12["activeThemes"], JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(_scope12["activeThemes"], "length")))]))
	return null

static func original__getWeightedRandomElement(_arg0 = null, _arg1 = null):
	var _scope17: Dictionary = {"array": _arg0, "weightSum": _arg1, "randomValue": null, "accumWeight": null, "i": null}
	_scope17["randomValue"] = (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(_scope17["weightSum"]))
	_scope17["accumWeight"] = 0
	_scope17["i"] = 0
	while JS.truthy(JS.compare("<", _scope17["i"], JS.get_property(_scope17["array"], "length"))):
		if JS.truthy(JS.compare("<=", _scope17["randomValue"], JS.add(_scope17["accumWeight"], JS.get_property(JS.get_property(_scope17["array"], _scope17["i"]), "weight")))):
			return JS.get_property(_scope17["array"], _scope17["i"])
		JS.set_property(_scope17, "accumWeight", JS.add(_scope17["accumWeight"], JS.get_property(JS.get_property(_scope17["array"], _scope17["i"]), "weight")))
		JS.increment(_scope17, "i", 1, false)
	return null
	return null
