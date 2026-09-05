# 由原版 UIWeaponSymbolGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UIWeaponSymbolGroup: Dictionary = {}
static var _initialized_UIWeaponSymbolGroup = false
static func initialize_original_static():
	if _initialized_UIWeaponSymbolGroup: return
	_initialized_UIWeaponSymbolGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIWeaponSymbolGroup.has(key): return _static_UIWeaponSymbolGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UIWeaponSymbolGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1, "i": null, "weaponIcon": null}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.invoke_method(JS.get_property(self, "scale"), "set", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.set_property(self, "weaponIconGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [self]))
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.add(JS.get_property(JS.module("Constants"), "MAX_WEAPON_QUEUE"), 1))):
		_scope0["weaponIcon"] = JS.invoke_method(JS.get_property(self, "weaponIconGroup"), "add", [JS.construct(JS.module("UIWeaponIconImage"), [_scope0["game"]])])
		JS.increment(_scope0, "i", 1, false)
	JS.set_property(self, "theme", 0)
	JS.set_property(self, "weapons", null)
	JS.set_property(self, "weaponIcons", {})
	JS.set_property(self, "removeTimeout", null)
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UIWeaponSymbolGroup"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uiweaponsymbolgroup.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original_setTheme(_arg0 = null):
	var _scope1: Dictionary = {"theme": _arg0}
	JS.invoke_method(JS.get_property(self, "weaponIconGroup"), "callAll", ["setTheme", null, _scope1["theme"]])
	return null

func original_update():
	var _scope2: Dictionary = {"tank": null}
	if JS.truthy(JS.logical("||", func():
		var _scope3: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope4: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return null
	_scope2["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope2["tank"]):
		JS.set_property(self, "x", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope2["tank"], "getX", [])]))
		JS.set_property(self, "y", JS.add(JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope2["tank"], "getY", [])]), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "HEIGHT"), "px")) * JS.number(1.3))))
	super.original_update()
	return null

func original_postUpdate():
	var _scope5: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null):
	var _scope6: Dictionary = {"playerId": _arg0, "tank": null, "position": null}
	_scope6["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [_scope6["playerId"]])
	if JS.truthy(_scope6["tank"]):
		if JS.truthy(JS.get_property(self, "removeTimeout")):
			JS.global_call("clearTimeout", [JS.get_property(self, "removeTimeout")])
			JS.set_property(self, "removeTimeout", null)
		JS.set_property(self, "exists", true)
		JS.set_property(self, "visible", true)
		_scope6["position"] = {"x": JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope6["tank"], "getX", [])]), "y": JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope6["tank"], "getY", [])])}
		JS.invoke_method(JS.get_property(self, "position"), "set", [JS.get_property(_scope6["position"], "x"), JS.add(JS.get_property(_scope6["position"], "y"), (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "TANK"), "HEIGHT"), "px")) * JS.number(1.3)))])
	JS.set_property(self, "playerId", _scope6["playerId"])
	JS.set_property(self, "weapons", JS.invoke_method(JS.get_property(self, "gameController"), "getQueuedWeapons", [_scope6["playerId"]]))
	JS.invoke_method(self, "_updateUI", [])
	return null

func original_refresh():
	var _scope7: Dictionary = {"tank": null}
	_scope7["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope7["tank"]):
		JS.set_property(self, "weapons", JS.invoke_method(JS.get_property(self, "gameController"), "getQueuedWeapons", [JS.get_property(self, "playerId")]))
		JS.invoke_method(self, "_updateUI", [])
	return null

func original__updateUI():
	var _scope8: Dictionary = {"weaponIconId": null, "weaponIconStillNeeded": null, "i": null, "totalWidth": null, "scale": null, "x": null, "weaponIcon": null}
	for _iteration0 in JS.keys(JS.get_property(self, "weaponIcons")):
		JS.set_property(_scope8, "weaponIconId", _iteration0)
		_scope8["weaponIconStillNeeded"] = false
		_scope8["i"] = 0
		while JS.truthy(JS.compare("<", _scope8["i"], JS.get_property(JS.get_property(self, "weapons"), "length"))):
			if JS.truthy(JS.equal(_scope8["weaponIconId"], JS.invoke_method(JS.get_property(JS.get_property(self, "weapons"), _scope8["i"]), "getId", []), false)):
				JS.set_property(_scope8, "weaponIconStillNeeded", true)
				break
			JS.increment(_scope8, "i", 1, false)
		if JS.truthy((not JS.truthy(_scope8["weaponIconStillNeeded"]))):
			JS.invoke_method(JS.get_property(JS.get_property(self, "weaponIcons"), _scope8["weaponIconId"]), "remove", [])
			JS.delete_property(JS.get_property(self, "weaponIcons"), _scope8["weaponIconId"])
	_scope8["totalWidth"] = 0
	_scope8["i"] = (JS.number(JS.get_property(JS.get_property(self, "weapons"), "length")) - JS.number(1))
	while JS.truthy(JS.compare(">=", _scope8["i"], 0)):
		JS.set_property(_scope8, "totalWidth", JS.add(_scope8["totalWidth"], (JS.number(JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_WIDTH")) * JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_MAX_SCALE")) - JS.number((JS.number(_scope8["i"]) * JS.number(JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_SCALE_STEP")))))))))
		JS.increment(_scope8, "i", -1, false)
	_scope8["scale"] = (JS.number(JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_MAX_SCALE")) - JS.number((JS.number((JS.number(JS.get_property(JS.get_property(self, "weapons"), "length")) - JS.number(1))) * JS.number(JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_SCALE_STEP")))))
	_scope8["x"] = JS.add((JS.number(-(_scope8["totalWidth"])) * JS.number(0.5)), (JS.number((JS.number(0.5) * JS.number(_scope8["scale"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_WIDTH"))))
	_scope8["i"] = 0
	while JS.truthy(JS.compare("<", _scope8["i"], JS.get_property(JS.get_property(self, "weapons"), "length"))):
		if JS.truthy(JS.has_property(JS.get_property(self, "weaponIcons"), JS.invoke_method(JS.get_property(JS.get_property(self, "weapons"), _scope8["i"]), "getId", []))):
			JS.invoke_method(JS.get_property(JS.get_property(self, "weaponIcons"), JS.invoke_method(JS.get_property(JS.get_property(self, "weapons"), _scope8["i"]), "getId", [])), "refresh", [_scope8["x"], _scope8["scale"]])
		else:
			_scope8["weaponIcon"] = JS.invoke_method(JS.get_property(self, "weaponIconGroup"), "getFirstExists", [false])
			if JS.truthy(_scope8["weaponIcon"]):
				JS.set_property(JS.get_property(self, "weaponIcons"), JS.invoke_method(JS.get_property(JS.get_property(self, "weapons"), _scope8["i"]), "getId", []), _scope8["weaponIcon"])
				JS.invoke_method(_scope8["weaponIcon"], "spawn", [_scope8["x"], 0, _scope8["scale"], JS.invoke_method(JS.get_property(JS.get_property(self, "weapons"), _scope8["i"]), "getType", [])])
			else:
				JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create weapon icon sprite. No sprite available."])
		JS.set_property(_scope8, "x", JS.add(_scope8["x"], (JS.number((JS.number(0.5) * JS.number(_scope8["scale"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_WIDTH")))))
		JS.set_property(_scope8, "scale", JS.add(_scope8["scale"], JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_SCALE_STEP")))
		JS.set_property(_scope8, "x", JS.add(_scope8["x"], (JS.number((JS.number(0.5) * JS.number(_scope8["scale"]))) * JS.number(JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_WIDTH")))))
		JS.increment(_scope8, "i", 1, false)
	return null

func original_remove():
	var _scope9: Dictionary = {"self": null}
	JS.set_property(self, "exists", false)
	_scope9["self"] = self
	JS.set_property(self, "removeTimeout", JS.global_call("setTimeout", [func():
		var _scope10: Dictionary = {}
		JS.set_property(_scope9["self"], "visible", false)
		return null, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME")]))
	JS.invoke_method(JS.get_property(self, "weaponIconGroup"), "callAll", ["remove"])
	return null

func original_retire():
	var _scope11: Dictionary = {}
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.invoke_method(JS.get_property(self, "weaponIconGroup"), "callAll", ["retire"])
	return null
