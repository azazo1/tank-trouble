# 由原版 UILaserGraphics 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/graphics.gd"

static var _static_UILaserGraphics: Dictionary = {}
static var _initialized_UILaserGraphics = false
static func initialize_original_static():
	if _initialized_UILaserGraphics: return
	_initialized_UILaserGraphics = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UILaserGraphics.has(key): return _static_UILaserGraphics[key]
	return JS.get_property(JS.module("Phaser.Graphics"), key)
static func original_static_set(key, value):
	_static_UILaserGraphics[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1}
	super._construct_create(_scope0["game"], 0, 0)
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.set_property(self, "laserPositions", [])
	JS.set_property(self, "retracting", false)
	JS.set_property(self, "expanding", true)
	JS.set_property(self, "colour", 65280)
	JS.set_property(self, "timeAlive", 0)
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uilasergraphics.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_update():
	var _scope1: Dictionary = {"laser": null, "i": null}
	if JS.truthy(JS.logical("||", func():
		var _scope2: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope3: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return null
	JS.set_property(self, "timeAlive", JS.add(JS.get_property(self, "timeAlive"), (JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000))))
	if JS.truthy(JS.get_property(self, "retracting")):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(self, "laserPositions"), "length"), 0, false)):
			JS.invoke_method(self, "kill", [])
		else:
			JS.invoke_method(JS.get_property(self, "laserPositions"), "shift", [])
			while JS.truthy(JS.compare(">", JS.get_property(JS.get_property(self, "laserPositions"), "length"), 0)):
				if JS.truthy(JS.get_property(JS.get_property(JS.get_property(self, "laserPositions"), 0), "updatePoint")):
					break
				JS.invoke_method(JS.get_property(self, "laserPositions"), "shift", [])
	else:
		if JS.truthy(JS.compare(">=", JS.get_property(self, "timeAlive"), JS.get_property(JS.module("UIConstants"), "LASER_RETRACTION_TIME"))):
			JS.set_property(self, "retracting", true)
	if JS.truthy(JS.get_property(self, "expanding")):
		_scope1["laser"] = JS.invoke_method(JS.get_property(self, "gameController"), "getProjectile", [JS.get_property(self, "laserId")])
		if JS.truthy(_scope1["laser"]):
			JS.invoke_method(JS.get_property(self, "laserPositions"), "push", [{"x": JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["laser"], "getX", [])]), "y": JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["laser"], "getY", [])]), "updatePoint": true}])
	JS.invoke_method(self, "clear", [])
	JS.invoke_method(self, "lineStyle", [JS.get_property(JS.module("UIConstants"), "LASER_WIDTH"), JS.get_property(self, "colour"), 1])
	if JS.truthy(JS.compare(">=", JS.get_property(JS.get_property(self, "laserPositions"), "length"), 2)):
		JS.invoke_method(self, "moveTo", [JS.get_property(JS.get_property(JS.get_property(self, "laserPositions"), 0), "x"), JS.get_property(JS.get_property(JS.get_property(self, "laserPositions"), 0), "y")])
		_scope1["i"] = 1
		while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(JS.get_property(self, "laserPositions"), "length"))):
			JS.invoke_method(self, "lineTo", [JS.get_property(JS.get_property(JS.get_property(self, "laserPositions"), _scope1["i"]), "x"), JS.get_property(JS.get_property(JS.get_property(self, "laserPositions"), _scope1["i"]), "y")])
			JS.increment(_scope1, "i", 1, false)
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope4: Dictionary = {"x": _arg0, "y": _arg1, "laserId": _arg2, "playerId": _arg3, "tank": null, "self": null}
	JS.invoke_method(self, "revive", [])
	JS.set_property(self, "laserId", _scope4["laserId"])
	JS.set_property(self, "playerId", _scope4["playerId"])
	JS.set_property(self, "laserPositions", [])
	_scope4["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope4["tank"]):
		JS.invoke_method(JS.get_property(self, "laserPositions"), "push", [{"x": JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope4["tank"], "getX", [])]), "y": JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope4["tank"], "getY", [])]), "updatePoint": false}])
	JS.invoke_method(JS.get_property(self, "laserPositions"), "push", [{"x": _scope4["x"], "y": _scope4["y"], "updatePoint": true}])
	JS.set_property(self, "expanding", true)
	JS.set_property(self, "retracting", false)
	JS.set_property(self, "colour", 65280)
	JS.set_property(self, "timeAlive", 0)
	_scope4["self"] = self
	JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
		var _scope5: Dictionary = {"result": _arg0}
		if JS.truthy(JS.equal(JS.type_of(_scope5["result"]), "object", false)):
			JS.set_property(_scope4["self"], "colour", JS.get_property(JS.invoke_method(_scope5["result"], "getTurretColour", []), "numericValue"))
		else:
			JS.set_property(_scope4["self"], "colour", JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_UNAVAILABLE_COLOUR"), "numericValue"))
		return null, func(_arg0 = null):
		var _scope6: Dictionary = {"result": _arg0}
		return null, func(_arg0 = null):
		var _scope7: Dictionary = {"result": _arg0}
		return null, JS.get_property(self, "playerId"), JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
	return null

func original_addPoint(_arg0 = null, _arg1 = null):
	var _scope8: Dictionary = {"x": _arg0, "y": _arg1}
	if JS.truthy(JS.get_property(self, "expanding")):
		JS.invoke_method(JS.get_property(self, "laserPositions"), "push", [{"x": _scope8["x"], "y": _scope8["y"], "updatePoint": false}])
	return null

func original_remove():
	var _scope9: Dictionary = {}
	JS.set_property(self, "expanding", false)
	JS.set_property(self, "retracting", true)
	return null

func original_retire():
	var _scope10: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
