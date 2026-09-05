# 由原版 UITankNameGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UITankNameGroup: Dictionary = {}
static var _initialized_UITankNameGroup = false
static func initialize_original_static():
	if _initialized_UITankNameGroup: return
	_initialized_UITankNameGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UITankNameGroup.has(key): return _static_UITankNameGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UITankNameGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.set_property(self, "tankName", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Text"), [_scope0["game"], 0, 0, "", {"font": JS.add(JS.get_property(JS.module("UIConstants"), "TANK_NAME_FONT_SIZE"), "px TankTrouble"), "fill": "#fff", "strokeThickness": JS.get_property(JS.module("UIConstants"), "TANK_NAME_STROKE_WIDTH")}])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankName"), "anchor"), "setTo", [0.5, 0])
	JS.set_property(self, "playerId", null)
	JS.set_property(self, "timeAlive", 0)
	JS.set_property(self, "fading", false)
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UITankNameGroup"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uitanknamegroup.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_update():
	var _scope1: Dictionary = {"tank": null, "halfWorldWidth": null, "worldPosition": null}
	if JS.truthy(JS.logical("||", func():
		var _scope2: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope3: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return null
	_scope1["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope1["tank"]):
		JS.set_property(self, "x", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["tank"], "getX", [])]))
		JS.set_property(self, "y", JS.add(JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["tank"], "getY", [])]), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "HEIGHT"), "px")) * JS.number(0.7))))
		_scope1["halfWorldWidth"] = (JS.number((JS.number(JS.get_property(JS.get_property(self, "tankName"), "width")) * JS.number(JS.get_property(JS.get_property(JS.get_property(self, "tankName"), "worldScale"), "x")))) * JS.number(0.5))
		_scope1["worldPosition"] = JS.invoke_method(JS.get_property(self, "parent"), "toGlobal", [JS.get_property(self, "position")])
		if JS.truthy(JS.compare("<", (JS.number(JS.get_property(_scope1["worldPosition"], "x")) - JS.number(_scope1["halfWorldWidth"])), JS.get_property(JS.module("UIConstants"), "TANK_NAME_MARGIN"))):
			JS.set_property(self, "x", JS.get_property(JS.invoke_method(JS.get_property(self, "parent"), "toLocal", [{"x": JS.add(JS.get_property(JS.module("UIConstants"), "TANK_NAME_MARGIN"), _scope1["halfWorldWidth"]), "y": JS.get_property(_scope1["worldPosition"], "y")}]), "x"))
		else:
			if JS.truthy(JS.compare(">", JS.add(JS.get_property(_scope1["worldPosition"], "x"), _scope1["halfWorldWidth"]), (JS.number(JS.get_property(JS.get_property(self, "game"), "width")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_NAME_MARGIN"))))):
				JS.set_property(self, "x", JS.get_property(JS.invoke_method(JS.get_property(self, "parent"), "toLocal", [{"x": (JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "width")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_NAME_MARGIN")))) - JS.number(_scope1["halfWorldWidth"])), "y": JS.get_property(_scope1["worldPosition"], "y")}]), "x"))
		JS.set_property(self, "timeAlive", JS.add(JS.get_property(self, "timeAlive"), (JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000))))
		if JS.truthy(JS.logical("&&", func():
			var _scope4: Dictionary = {}
			return (not JS.truthy(JS.get_property(self, "fading")))
			return null, func():
			var _scope5: Dictionary = {}
			return JS.compare(">", JS.get_property(self, "timeAlive"), JS.get_property(JS.module("UIConstants"), "TANK_NAME_DISPLAY_TIME"))
			return null)):
			JS.set_property(self, "fading", true)
	else:
		JS.set_property(self, "fading", true)
	if JS.truthy(JS.get_property(self, "fading")):
		JS.set_property(self, "alpha", JS.invoke_method("@Math", "max", [0, (JS.number(JS.get_property(self, "alpha")) - JS.number(0.025))]))
	if JS.truthy(JS.equal(JS.get_property(self, "alpha"), 0, false)):
		JS.set_property(self, "exists", false)
		JS.set_property(self, "visible", false)
	return null

func original_postUpdate():
	var _scope6: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null):
	var _scope7: Dictionary = {"playerId": _arg0, "tank": null, "self": null}
	_scope7["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [_scope7["playerId"]])
	if JS.truthy(_scope7["tank"]):
		JS.set_property(self, "x", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope7["tank"], "getX", [])]))
		JS.set_property(self, "y", JS.add(JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope7["tank"], "getY", [])]), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "HEIGHT"), "px")) * JS.number(0.7))))
		JS.set_property(self, "exists", true)
		JS.set_property(self, "visible", true)
		JS.set_property(self, "alpha", 1)
		JS.invoke_method(JS.get_property(self, "tankName"), "setText", [""])
	JS.set_property(self, "playerId", _scope7["playerId"])
	JS.set_property(self, "timeAlive", 0)
	JS.set_property(self, "fading", false)
	_scope7["self"] = self
	JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
		var _scope8: Dictionary = {"result": _arg0, "username": null}
		if JS.truthy(JS.equal(JS.type_of(_scope8["result"]), "object", false)):
			_scope8["username"] = JS.invoke_method(JS.module("Utils"), "maskUnapprovedUsername", [_scope8["result"]])
			JS.invoke_method(JS.get_property(_scope7["self"], "tankName"), "setText", [_scope8["username"]])
		return null, func(_arg0 = null):
		var _scope9: Dictionary = {"result": _arg0}
		return null, func(_arg0 = null):
		var _scope10: Dictionary = {"result": _arg0}
		return null, JS.get_property(self, "playerId"), JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
	return null

func original_retire():
	var _scope11: Dictionary = {}
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	return null
