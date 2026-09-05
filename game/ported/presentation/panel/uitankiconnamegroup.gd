# 由原版 UITankIconNameGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UITankIconNameGroup: Dictionary = {}
static var _initialized_UITankIconNameGroup = false
static func initialize_original_static():
	if _initialized_UITankIconNameGroup: return
	_initialized_UITankIconNameGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UITankIconNameGroup.has(key): return _static_UITankIconNameGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UITankIconNameGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "maxNameWidth": _arg1, "iconsBelow": _arg2}
	super._construct_create(_scope0["game"], null)
	JS.set_property(self, "maxNameWidth", _scope0["maxNameWidth"])
	JS.set_property(self, "iconsBelow", JS.logical("||", func():
		var _scope1: Dictionary = {}
		return _scope0["iconsBelow"]
		return null, func():
		var _scope2: Dictionary = {}
		return false
		return null))
	JS.set_property(self, "tankName", JS.invoke_method(self, "addChild", [JS.construct(JS.module("Phaser.Text"), [_scope0["game"], 0, 0, "", {"font": JS.add(JS.get_property(JS.module("UIConstants"), "USERNAME_FONT_SIZE"), "px TankTrouble"), "fill": "#fff", "strokeThickness": JS.get_property(JS.module("UIConstants"), "USERNAME_STROKE_WIDTH")}])]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "tankName"), "anchor"), "setTo", [0.5, 0.5])
	JS.invoke_method(JS.get_property(self, "tankName"), "kill", [])
	JS.set_property(self, "playerId", null)
	JS.set_property(self, "favourite", false)
	JS.set_property(self, "showRank", false)
	JS.set_property(self, "fitScale", 1)
	JS.set_property(self, "spawnTween", null)
	JS.set_property(self, "removeTween", null)
	JS.set_property(self, "updateHideTween", null)
	JS.set_property(self, "updateShowTween", null)
	JS.invoke_method(JS.get_property(self, "scale"), "set", [0, 0])
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UITankIconNameGroup"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/panel/uitankiconnamegroup.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_update():
	var _scope3: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_update()
	return null

func original_postUpdate():
	var _scope4: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope5: Dictionary = {"x": _arg0, "y": _arg1, "playerId": _arg2, "targetScale": _arg3, "showRank": _arg4, "self": null}
	JS.set_property(self, "exists", true)
	JS.set_property(self, "visible", true)
	JS.set_property(self, "x", _scope5["x"])
	JS.set_property(self, "y", _scope5["y"])
	JS.set_property(self, "playerId", _scope5["playerId"])
	JS.set_property(self, "showRank", false)
	JS.set_property(self, "fitScale", 1)
	JS.set_property(self, "targetScale", JS.logical("||", func():
		var _scope6: Dictionary = {}
		return _scope5["targetScale"]
		return null, func():
		var _scope7: Dictionary = {}
		return 1
		return null))
	JS.invoke_method(JS.get_property(self, "tankName"), "setText", [""])
	if JS.truthy(JS.get_property(self, "removeTween")):
		JS.invoke_method(JS.get_property(self, "removeTween"), "stop", [])
		JS.set_property(self, "removeTween", null)
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
		JS.set_property(self, "spawnTween", null)
	_scope5["self"] = self
	JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
		var _scope8: Dictionary = {"result": _arg0, "username": null}
		if JS.truthy(JS.equal(JS.type_of(_scope8["result"]), "object", false)):
			_scope8["username"] = JS.invoke_method(JS.module("Utils"), "maskUnapprovedUsername", [_scope8["result"]])
			JS.invoke_method(_scope5["self"], "_updateUsernameAndRankLevel", [_scope8["username"], JS.invoke_method(_scope8["result"], "getRank", [])])
			JS.invoke_method(_scope5["self"], "_updateRanked", [_scope5["showRank"]])
		JS.invoke_method(_scope5["self"], "_updateFavouriteStatus", [])
		return null, func(_arg0 = null):
		var _scope9: Dictionary = {"result": _arg0}
		return null, func(_arg0 = null):
		var _scope10: Dictionary = {"result": _arg0}
		return null, JS.get_property(self, "playerId"), JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
	return null

func original_refresh(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope11: Dictionary = {"x": _arg0, "y": _arg1, "targetScale": _arg2, "showRank": _arg3}
	if JS.truthy(not JS.equal(_scope11["x"], null, true)):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"x": _scope11["x"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	if JS.truthy(not JS.equal(_scope11["y"], null, true)):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"y": _scope11["y"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	if JS.truthy(not JS.equal(_scope11["showRank"], null, true)):
		JS.invoke_method(self, "_updateRanked", [_scope11["showRank"]])
	JS.invoke_method(self, "_updateFavouriteStatus", [])
	return null

func original_updateName():
	var _scope12: Dictionary = {}
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
	if JS.truthy((not JS.truthy(JS.get_property(self, "removeTween")))):
		if JS.truthy(JS.get_property(self, "updateHideTween")):
			JS.invoke_method(JS.get_property(self, "updateHideTween"), "stop", [])
		if JS.truthy(JS.get_property(self, "updateShowTween")):
			JS.invoke_method(JS.get_property(self, "updateShowTween"), "stop", [])
		JS.set_property(self, "updateHideTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 0, "y": 0}, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None")]))
		JS.invoke_method(JS.get_property(JS.get_property(self, "updateHideTween"), "onComplete"), "add", [func():
			var _scope13: Dictionary = {"self": null}
			_scope13["self"] = JS.callback_receiver(self)
			JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
				var _scope14: Dictionary = {"result": _arg0, "username": null}
				if JS.truthy(JS.equal(JS.type_of(_scope14["result"]), "object", false)):
					_scope14["username"] = JS.invoke_method(JS.module("Utils"), "maskUnapprovedUsername", [_scope14["result"]])
					JS.invoke_method(_scope13["self"], "_updateUsernameAndRankLevel", [_scope14["username"], JS.invoke_method(_scope14["result"], "getRank", [])])
				JS.invoke_method(_scope13["self"], "_updateFavouriteStatus", [])
				JS.set_property(_scope13["self"], "updateShowTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(_scope13["self"], "game"), "add"), "tween", [JS.get_property(_scope13["self"], "scale")]), "to", [{"x": (JS.number(JS.get_property(_scope13["self"], "fitScale")) * JS.number(JS.get_property(_scope13["self"], "targetScale"))), "y": (JS.number(JS.get_property(_scope13["self"], "fitScale")) * JS.number(JS.get_property(_scope13["self"], "targetScale")))}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out")]))
				JS.invoke_method(JS.get_property(_scope13["self"], "updateShowTween"), "start", [])
				return null, func(_arg0 = null):
				var _scope15: Dictionary = {"result": _arg0}
				return null, func(_arg0 = null):
				var _scope16: Dictionary = {"result": _arg0}
				return null, JS.get_property(JS.callback_receiver(self), "playerId"), JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
			return null, self])
		JS.invoke_method(JS.get_property(self, "updateHideTween"), "start", [])
	return null

func original_updateRank(_arg0 = null, _arg1 = null):
	var _scope17: Dictionary = {"rank": _arg0, "rankChange": _arg1}
	JS.invoke_method(self, "_updateUsernameAndRankLevel", [JS.get_property(JS.get_property(self, "tankName"), "text"), _scope17["rank"], _scope17["rankChange"]])
	JS.invoke_method(self, "_updateRanked", [JS.get_property(self, "showRank")])
	return null

func original__updateUsernameAndRankLevel(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope18: Dictionary = {"username": _arg0, "rank": _arg1, "rankChange": _arg2, "delay": null, "centerX": null}
	JS.invoke_method(JS.get_property(self, "tankName"), "revive", [])
	JS.invoke_method(JS.get_property(self, "tankName"), "setText", [_scope18["username"]])
	JS.set_property(self, "fitScale", JS.invoke_method("@Math", "min", [1, (JS.number(JS.get_property(self, "maxNameWidth")) / JS.number(JS.add(JS.add(JS.get_property(JS.get_property(self, "tankName"), "width"), JS.get_property(JS.module("UIConstants"), "FAVOURITE_ICON_WIDTH")), JS.get_property(JS.module("UIConstants"), "RANK_ICON_WIDTH"))))]))
	if JS.truthy((not JS.truthy(JS.get_property(self, "spawnTween")))):
		_scope18["delay"] = JS.add(50, (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(200)))
		JS.set_property(self, "spawnTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": (JS.number(JS.get_property(self, "fitScale")) * JS.number(JS.get_property(self, "targetScale"))), "y": (JS.number(JS.get_property(self, "fitScale")) * JS.number(JS.get_property(self, "targetScale")))}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true, _scope18["delay"]]))
	_scope18["centerX"] = 0
	if JS.truthy(JS.get_property(self, "favourite")):
		JS.set_property(_scope18, "centerX", JS.add(_scope18["centerX"], (JS.number((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "FAVOURITE_ICON_WIDTH")) / JS.number(2))) / JS.number(JS.get_property(self, "fitScale")))) / JS.number(JS.get_property(self, "targetScale")))))
	if JS.truthy(JS.logical("&&", func():
		var _scope19: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "iconsBelow")))
		return null, func():
		var _scope20: Dictionary = {}
		return JS.get_property(self, "showRank")
		return null)):
		JS.set_property(_scope18, "centerX", (JS.number(_scope18["centerX"]) - JS.number((JS.number((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "RANK_ICON_WIDTH")) / JS.number(2))) / JS.number(JS.get_property(self, "fitScale")))) / JS.number(JS.get_property(self, "targetScale"))))))
	return null

func original__updateRanked(_arg0 = null):
	var _scope21: Dictionary = {"newShowRank": _arg0, "centerX": null}
	JS.set_property(self, "showRank", _scope21["newShowRank"])
	_scope21["centerX"] = 0
	if JS.truthy(JS.get_property(self, "favourite")):
		JS.set_property(_scope21, "centerX", JS.add(_scope21["centerX"], (JS.number((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "FAVOURITE_ICON_WIDTH")) / JS.number(2))) / JS.number(JS.get_property(self, "fitScale")))) / JS.number(JS.get_property(self, "targetScale")))))
	if JS.truthy(JS.logical("&&", func():
		var _scope22: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "iconsBelow")))
		return null, func():
		var _scope23: Dictionary = {}
		return JS.get_property(self, "showRank")
		return null)):
		JS.set_property(_scope21, "centerX", (JS.number(_scope21["centerX"]) - JS.number((JS.number((JS.number((JS.number(JS.get_property(JS.module("UIConstants"), "RANK_ICON_WIDTH")) / JS.number(2))) / JS.number(JS.get_property(self, "fitScale")))) / JS.number(JS.get_property(self, "targetScale"))))))
	return null

func original__updateFavouriteStatus():
	var _scope24: Dictionary = {}
	return null

func original_remove():
	var _scope25: Dictionary = {}
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
	if JS.truthy(JS.get_property(self, "updateHideTween")):
		JS.invoke_method(JS.get_property(self, "updateHideTween"), "stop", [])
	if JS.truthy(JS.get_property(self, "updateShowTween")):
		JS.invoke_method(JS.get_property(self, "updateShowTween"), "stop", [])
	JS.set_property(self, "removeTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 0, "y": 0}, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]))
	return null

func original_retire():
	var _scope26: Dictionary = {}
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.invoke_method(JS.get_property(self, "tankName"), "kill", [])
	return null
