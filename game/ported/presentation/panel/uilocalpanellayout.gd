# 由原版 UILocalPanelLayout 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

var tankAvatarPool = null
var tankIconPool = null
var tankIconGroup = null
var tankNameGroup = null
var tankScoreGroup = null
var tankIconLoginSprite = null
var localPlayerIdsToAdd = []
var addingLocalPlayer = false
var addingLocalPlayerDuration = 0
var updateScheduled = false
var showLoginIcon = false
var loginIconWasHidden = false
var inRankedGame = false
var localTankIcons = {}
var loginTankIcon = null
var onlineTankIcons = {}
var localPlayerIds = []
var onlinePlayerIds = []
var positionReliabilityDelay = 0
var log = null
static var _static_UILocalPanelLayout: Dictionary = {}
static var _initialized_UILocalPanelLayout = false
static func initialize_original_static():
	if _initialized_UILocalPanelLayout: return
	_initialized_UILocalPanelLayout = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UILocalPanelLayout.has(key): return _static_UILocalPanelLayout[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UILocalPanelLayout[key] = value
	return value
func original_own_fields():
	return ["tankAvatarPool","tankIconPool","tankIconGroup","tankNameGroup","tankScoreGroup","tankIconLoginSprite","localPlayerIdsToAdd","addingLocalPlayer","addingLocalPlayerDuration","updateScheduled","showLoginIcon","loginIconWasHidden","inRankedGame","localTankIcons","loginTankIcon","onlineTankIcons","localPlayerIds","onlinePlayerIds","positionReliabilityDelay","log"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {}
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/panel/uilocalpanellayout.gd").new()
	instance._construct_create()
	return instance

func original__onSizeChangeHandler():
	var _scope1: Dictionary = {"iconScale": null}
	JS.invoke_method(JS.get_property(self, "log"), "debug", ["SIZE CHANGE!"])
	_scope1["iconScale"] = JS.invoke_method("@Math", "min", [1, JS.invoke_method("@Math", "min", [(JS.number(JS.get_property(JS.get_property(self, "game"), "width")) / JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_WIDTH"))), (JS.number(JS.get_property(JS.get_property(self, "game"), "height")) / JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))))])])
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankIconGroup"), "scale"), "setTo", [(JS.number(_scope1["iconScale"]) * JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE")))])
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankIconGroup"), "position"), "set", [(JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "width")) - JS.number((JS.number(_scope1["iconScale"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_WIDTH")))))) / JS.number(2)), (JS.number(JS.get_property(JS.get_property(self, "game"), "height")) - JS.number((JS.number(_scope1["iconScale"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")))))])
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankNameGroup"), "scale"), "setTo", [(JS.number(_scope1["iconScale"]) * JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE")))])
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankNameGroup"), "position"), "set", [(JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "width")) - JS.number((JS.number(_scope1["iconScale"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_WIDTH")))))) / JS.number(2)), (JS.number(JS.get_property(JS.get_property(self, "game"), "height")) - JS.number((JS.number(_scope1["iconScale"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_NAME_BOTTOM_MARGIN")))))])
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankScoreGroup"), "scale"), "setTo", [(JS.number(_scope1["iconScale"]) * JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE")))])
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankScoreGroup"), "position"), "set", [(JS.number((JS.number(JS.get_property(JS.get_property(self, "game"), "width")) - JS.number((JS.number(_scope1["iconScale"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_WIDTH")))))) / JS.number(2)), (JS.number(JS.get_property(JS.get_property(self, "game"), "height")) - JS.number((JS.number(_scope1["iconScale"]) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_SCORE_BOTTOM_MARGIN")))))])
	return null

func original__updateUI():
	var _scope2: Dictionary = {"tankIconSpriteId": null, "tankIconStillNeeded": null, "i": null, "showTankIconLogin": null, "index": null, "totalPlayerIds": null, "widthPerUser": null, "scale": null, "interleaved": null, "scoreY": null, "x": null, "y": null, "iconScale": null, "animatePopIn": null, "tankAvatarSprite": null, "tankIconSprite": null, "tankNameSprite": null, "tankScoreSprite": null}
	for _iteration0 in JS.keys(JS.get_property(self, "localTankIcons")):
		JS.set_property(_scope2, "tankIconSpriteId", _iteration0)
		_scope2["tankIconStillNeeded"] = false
		_scope2["i"] = 0
		while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(self, "localPlayerIds"), "length"))):
			if JS.truthy(JS.equal(_scope2["tankIconSpriteId"], JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"]), false)):
				JS.set_property(_scope2, "tankIconStillNeeded", true)
				break
			JS.increment(_scope2, "i", 1, false)
		if JS.truthy((not JS.truthy(_scope2["tankIconStillNeeded"]))):
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "localTankIcons"), _scope2["tankIconSpriteId"]), "icon"), "remove", [])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "localTankIcons"), _scope2["tankIconSpriteId"]), "name"), "remove", [])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "localTankIcons"), _scope2["tankIconSpriteId"]), "score"), "remove", [])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "localTankIcons"), _scope2["tankIconSpriteId"]), "avatar"), "remove", [])
			JS.delete_property(JS.get_property(self, "localTankIcons"), _scope2["tankIconSpriteId"])
	for _iteration1 in JS.keys(JS.get_property(self, "onlineTankIcons")):
		JS.set_property(_scope2, "tankIconSpriteId", _iteration1)
		_scope2["tankIconStillNeeded"] = false
		_scope2["i"] = 0
		while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(self, "onlinePlayerIds"), "length"))):
			if JS.truthy(JS.equal(_scope2["tankIconSpriteId"], JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"]), false)):
				JS.set_property(_scope2, "tankIconStillNeeded", true)
				break
			JS.increment(_scope2, "i", 1, false)
		if JS.truthy((not JS.truthy(_scope2["tankIconStillNeeded"]))):
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "onlineTankIcons"), _scope2["tankIconSpriteId"]), "icon"), "remove", [])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "onlineTankIcons"), _scope2["tankIconSpriteId"]), "name"), "remove", [])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "onlineTankIcons"), _scope2["tankIconSpriteId"]), "score"), "remove", [])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "onlineTankIcons"), _scope2["tankIconSpriteId"]), "avatar"), "remove", [])
			JS.delete_property(JS.get_property(self, "onlineTankIcons"), _scope2["tankIconSpriteId"])
	_scope2["showTankIconLogin"] = JS.logical("&&", func():
		var _scope3: Dictionary = {}
		return JS.logical("&&", func():
			var _scope4: Dictionary = {}
			return JS.get_property(self, "showLoginIcon")
			return null, func():
			var _scope5: Dictionary = {}
			return JS.compare("<", JS.get_property(JS.get_property(self, "localPlayerIds"), "length"), JS.get_property(JS.get_property(JS.module("Constants"), "CLIENT"), "MAX_PLAYERS"))
			return null)
		return null, func():
		var _scope6: Dictionary = {}
		return JS.logical("||", func():
			var _scope7: Dictionary = {}
			return (not JS.truthy(JS.get_property(self, "addingLocalPlayer")))
			return null, func():
			var _scope8: Dictionary = {}
			return JS.compare(">", JS.get_property(JS.get_property(self, "onlinePlayerIds"), "length"), 0)
			return null)
		return null)
	if JS.truthy((not JS.truthy(_scope2["showTankIconLogin"]))):
		if JS.truthy(JS.get_property(self, "loginTankIcon")):
			JS.invoke_method(JS.get_property(self, "loginTankIcon"), "remove", [JS.logical("||", func():
				var _scope9: Dictionary = {}
				return JS.compare(">", JS.get_property(JS.get_property(self, "onlinePlayerIds"), "length"), 0)
				return null, func():
				var _scope10: Dictionary = {}
				return (not JS.truthy(JS.get_property(self, "showLoginIcon")))
				return null)])
			JS.set_property(self, "loginTankIcon", null)
	_scope2["index"] = 0
	_scope2["totalPlayerIds"] = JS.add(JS.add(JS.get_property(JS.get_property(self, "localPlayerIds"), "length"), JS.get_property(JS.get_property(self, "onlinePlayerIds"), "length")), (1 if JS.truthy(_scope2["showTankIconLogin"]) else 0))
	_scope2["widthPerUser"] = (JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_WIDTH")) - JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_SIDE_MARGIN")) * JS.number(2))))) / JS.number(_scope2["totalPlayerIds"]))
	_scope2["scale"] = JS.invoke_method("@Math", "min", [1, (JS.number(_scope2["widthPerUser"]) / JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MIN_WIDTH_PER_ICON")))])
	_scope2["interleaved"] = JS.compare(">", _scope2["totalPlayerIds"], JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_ICONS_BEFORE_INTERLEAVING"))
	_scope2["scoreY"] = ((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_OFFSET"))) if JS.truthy(_scope2["interleaved"]) else 0)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(self, "localPlayerIds"), "length"))):
		_scope2["x"] = JS.add((JS.number(JS.add(_scope2["index"], 0.5)) * JS.number(_scope2["widthPerUser"])), JS.get_property(JS.module("UIConstants"), "TANK_PANEL_SIDE_MARGIN"))
		_scope2["y"] = ((JS.number((JS.number((JS.number(1) - JS.number(fmod(_scope2["index"], 2)))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_HEIGHT")))) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_OFFSET"))) if JS.truthy(_scope2["interleaved"]) else 0)
		_scope2["iconScale"] = ((JS.number(_scope2["scale"]) * JS.number((JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_INTERLEAVE_SCALE") if JS.truthy(JS.equal(fmod(_scope2["index"], 2), 1, false)) else 1))) if JS.truthy(_scope2["interleaved"]) else 1)
		_scope2["animatePopIn"] = JS.logical("||", func():
			var _scope11: Dictionary = {}
			return (not JS.truthy(JS.logical("&&", func():
				var _scope12: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"]), JS.get_property(self, "newlyAddedPlayerId"), false)
				return null, func():
				var _scope13: Dictionary = {}
				return JS.equal(JS.get_property(JS.get_property(self, "onlinePlayerIds"), "length"), 0, false)
				return null)))
			return null, func():
			var _scope14: Dictionary = {}
			return JS.get_property(self, "loginIconWasHidden")
			return null)
		if JS.truthy(JS.has_property(JS.get_property(self, "localTankIcons"), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"]))):
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "localTankIcons"), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"])), "avatar"), "refresh", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), _scope2["iconScale"]])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "localTankIcons"), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"])), "icon"), "refresh", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), _scope2["iconScale"]])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "localTankIcons"), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"])), "name"), "refresh", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(_scope2["y"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), _scope2["scale"], JS.get_property(self, "inRankedGame")])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "localTankIcons"), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"])), "score"), "refresh", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(_scope2["scoreY"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE")))])
		else:
			_scope2["tankAvatarSprite"] = JS.invoke_method(JS.get_property(self, "tankAvatarPool"), "getFirstExists", [false])
			_scope2["tankIconSprite"] = JS.invoke_method(JS.get_property(self, "tankIconPool"), "getFirstExists", [false])
			_scope2["tankNameSprite"] = JS.invoke_method(JS.get_property(self, "tankNameGroup"), "getFirstExists", [false])
			_scope2["tankScoreSprite"] = JS.invoke_method(JS.get_property(self, "tankScoreGroup"), "getFirstExists", [false])
			if JS.truthy(JS.logical("&&", func():
				var _scope15: Dictionary = {}
				return JS.logical("&&", func():
					var _scope16: Dictionary = {}
					return JS.logical("&&", func():
						var _scope17: Dictionary = {}
						return _scope2["tankAvatarSprite"]
						return null, func():
						var _scope18: Dictionary = {}
						return _scope2["tankIconSprite"]
						return null)
					return null, func():
					var _scope19: Dictionary = {}
					return _scope2["tankNameSprite"]
					return null)
				return null, func():
				var _scope20: Dictionary = {}
				return _scope2["tankScoreSprite"]
				return null)):
				JS.set_property(JS.get_property(self, "localTankIcons"), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"]), {"avatar": _scope2["tankAvatarSprite"], "icon": _scope2["tankIconSprite"], "name": _scope2["tankNameSprite"], "score": _scope2["tankScoreSprite"]})
				JS.invoke_method(_scope2["tankAvatarSprite"], "spawn", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"]), _scope2["animatePopIn"], _scope2["iconScale"]])
				JS.invoke_method(_scope2["tankIconSprite"], "spawn", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"]), false, _scope2["animatePopIn"], _scope2["iconScale"]])
				JS.invoke_method(_scope2["tankNameSprite"], "spawn", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(_scope2["y"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"]), _scope2["scale"], JS.get_property(self, "inRankedGame")])
				JS.invoke_method(_scope2["tankScoreSprite"], "spawn", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(_scope2["scoreY"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), JS.get_property(JS.get_property(self, "localPlayerIds"), _scope2["i"])])
			else:
				JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create tank icon sprite, tank name sprite or tank score sprite. No sprite available."])
		JS.increment(_scope2, "index", 1, false)
		JS.increment(_scope2, "i", 1, false)
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(self, "onlinePlayerIds"), "length"))):
		_scope2["x"] = JS.add((JS.number(JS.add(_scope2["index"], 0.5)) * JS.number(_scope2["widthPerUser"])), JS.get_property(JS.module("UIConstants"), "TANK_PANEL_SIDE_MARGIN"))
		_scope2["y"] = ((JS.number((JS.number((JS.number(1) - JS.number(fmod(_scope2["index"], 2)))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_HEIGHT")))) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_OFFSET"))) if JS.truthy(_scope2["interleaved"]) else 0)
		_scope2["iconScale"] = ((JS.number(_scope2["scale"]) * JS.number((JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_INTERLEAVE_SCALE") if JS.truthy(JS.equal(fmod(_scope2["index"], 2), 1, false)) else 1))) if JS.truthy(_scope2["interleaved"]) else 1)
		if JS.truthy(JS.has_property(JS.get_property(self, "onlineTankIcons"), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"]))):
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "onlineTankIcons"), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"])), "avatar"), "refresh", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), _scope2["iconScale"]])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "onlineTankIcons"), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"])), "icon"), "refresh", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), _scope2["iconScale"]])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "onlineTankIcons"), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"])), "name"), "refresh", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(_scope2["y"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), _scope2["scale"], JS.get_property(self, "inRankedGame")])
			JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "onlineTankIcons"), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"])), "score"), "refresh", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(_scope2["scoreY"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE")))])
		else:
			_scope2["tankAvatarSprite"] = JS.invoke_method(JS.get_property(self, "tankAvatarPool"), "getFirstExists", [false])
			_scope2["tankIconSprite"] = JS.invoke_method(JS.get_property(self, "tankIconPool"), "getFirstExists", [false])
			_scope2["tankNameSprite"] = JS.invoke_method(JS.get_property(self, "tankNameGroup"), "getFirstExists", [false])
			_scope2["tankScoreSprite"] = JS.invoke_method(JS.get_property(self, "tankScoreGroup"), "getFirstExists", [false])
			if JS.truthy(JS.logical("&&", func():
				var _scope21: Dictionary = {}
				return JS.logical("&&", func():
					var _scope22: Dictionary = {}
					return JS.logical("&&", func():
						var _scope23: Dictionary = {}
						return _scope2["tankAvatarSprite"]
						return null, func():
						var _scope24: Dictionary = {}
						return _scope2["tankIconSprite"]
						return null)
					return null, func():
					var _scope25: Dictionary = {}
					return _scope2["tankNameSprite"]
					return null)
				return null, func():
				var _scope26: Dictionary = {}
				return _scope2["tankScoreSprite"]
				return null)):
				JS.set_property(JS.get_property(self, "onlineTankIcons"), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"]), {"avatar": _scope2["tankAvatarSprite"], "icon": _scope2["tankIconSprite"], "name": _scope2["tankNameSprite"], "score": _scope2["tankScoreSprite"]})
				JS.invoke_method(_scope2["tankAvatarSprite"], "spawn", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"]), true, _scope2["iconScale"]])
				JS.invoke_method(_scope2["tankIconSprite"], "spawn", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"]), false, true, _scope2["iconScale"]])
				JS.invoke_method(_scope2["tankNameSprite"], "spawn", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(_scope2["y"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"]), _scope2["scale"], JS.get_property(self, "inRankedGame")])
				JS.invoke_method(_scope2["tankScoreSprite"], "spawn", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(_scope2["scoreY"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), JS.get_property(JS.get_property(self, "onlinePlayerIds"), _scope2["i"])])
			else:
				JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create tank icon sprite, tank name sprite or tank score sprite. No sprite available."])
		JS.increment(_scope2, "index", 1, false)
		JS.increment(_scope2, "i", 1, false)
	if JS.truthy(_scope2["showTankIconLogin"]):
		_scope2["x"] = JS.add((JS.number(JS.add(_scope2["index"], 0.5)) * JS.number(_scope2["widthPerUser"])), JS.get_property(JS.module("UIConstants"), "TANK_PANEL_SIDE_MARGIN"))
		_scope2["y"] = ((JS.number((JS.number((JS.number(1) - JS.number(fmod(_scope2["index"], 2)))) * JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_HEIGHT")))) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_OFFSET"))) if JS.truthy(_scope2["interleaved"]) else 0)
		_scope2["iconScale"] = ((JS.number(_scope2["scale"]) * JS.number((JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_INTERLEAVE_SCALE") if JS.truthy(JS.equal(fmod(_scope2["index"], 2), 1, false)) else 1))) if JS.truthy(_scope2["interleaved"]) else 1)
		if JS.truthy(JS.get_property(self, "loginTankIcon")):
			JS.invoke_method(JS.get_property(self, "loginTankIcon"), "refresh", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), _scope2["iconScale"]])
		else:
			JS.set_property(self, "loginTankIcon", JS.get_property(self, "tankIconLoginSprite"))
			JS.invoke_method(JS.get_property(self, "tankIconLoginSprite"), "spawn", [(JS.number(_scope2["x"]) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), (JS.number(JS.add((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) - JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")))) / JS.number(2)), _scope2["y"])) / JS.number(JS.get_property(JS.module("UIConstants"), "ASSET_SCALE"))), _scope2["iconScale"]])
		JS.increment(_scope2, "index", 1, false)
	JS.set_property(self, "newlyAddedPlayerId", null)
	return null
