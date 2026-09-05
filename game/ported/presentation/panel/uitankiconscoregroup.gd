# 由原版 UITankIconScoreGroup 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/group.gd"

static var _static_UITankIconScoreGroup: Dictionary = {}
static var _initialized_UITankIconScoreGroup = false
static func initialize_original_static():
	if _initialized_UITankIconScoreGroup: return
	_initialized_UITankIconScoreGroup = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UITankIconScoreGroup.has(key): return _static_UITankIconScoreGroup[key]
	return JS.get_property(JS.module("Phaser.Group"), key)
static func original_static_set(key, value):
	_static_UITankIconScoreGroup[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "i": null}
	super._construct_create(_scope0["game"], null)
	JS.invoke_method(JS.module("GameManager"), "addGameEventListener", [JS.get_property(self, "_gameEventHandler"), self])
	JS.set_property(self, "itemGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [self]))
	JS.set_property(self, "fragmentGroup", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "group", [self]))
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_POOL_SIZE"))):
		JS.invoke_method(JS.get_property(self, "fragmentGroup"), "add", [JS.construct(JS.module("UIScoreExplosionFragmentSprite"), [_scope0["game"]])])
		JS.increment(_scope0, "i", 1, false)
	JS.set_property(self, "emitter", JS.invoke_method(self, "addChild", [JS.construct(JS.module("UIScoreExplosionEmitter"), [_scope0["game"]])]))
	JS.set_property(self, "playerId", null)
	JS.set_property(self, "removeTween", null)
	JS.invoke_method(JS.get_property(self, "scale"), "set", [0, 0])
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.set_property(self, "latestGameState", null)
	JS.set_property(self, "items", null)
	JS.set_property(self, "centerIndex", null)
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UITankIconScoreGroup"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/panel/uitankiconscoregroup.gd").new()
	instance._construct_create(_arg0)
	return instance

func original__gameEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope1: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3}
	var _switch0 = _scope1["evt"]
	var _switch0_start = -1
	if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_STATE_CHANGED"), true): _switch0_start = 0
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("GameModel"), "_EVENTS"), "GAME_ENDED"), true): _switch0_start = 1
	while true:
		if _switch0_start >= 0 and _switch0_start <= 0:
			JS.set_property(_scope1["self"], "latestGameState", _scope1["data"])
			JS.invoke_method(_scope1["self"], "_updateItemsWithLatestGameState", [])
			break
		if _switch0_start >= 0 and _switch0_start <= 1:
			JS.invoke_method(_scope1["self"], "_clearItems", [])
			break
		break
	return null

func original__updateItemsWithLatestGameState():
	var _scope2: Dictionary = {"info": null, "i": null, "config": null, "newDisplayObject": null, "item": null, "emblemFound": null, "emblemStates": null, "j": null, "scoreStates": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "game")))):
		return null
	if JS.truthy(JS.get_property(self, "latestGameState")):
		if JS.truthy((not JS.truthy(JS.get_property(self, "items")))):
			_scope2["info"] = JS.get_property(JS.get_property(JS.module("UIConstants"), "GAME_MODE_SCORE_ITEM_INFO"), JS.invoke_method(JS.get_property(self, "latestGameState"), "getMode", []))
			JS.set_property(self, "items", [])
			JS.set_property(self, "centerIndex", JS.get_property(_scope2["info"], "CENTER_ITEM"))
			_scope2["i"] = 0
			while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(_scope2["info"], "ITEM_CONFIG"), "length"))):
				_scope2["config"] = JS.get_property(JS.get_property(_scope2["info"], "ITEM_CONFIG"), _scope2["i"])
				_scope2["newDisplayObject"] = null
				var _switch1 = JS.get_property(_scope2["config"], "category")
				var _switch1_start = -1
				if JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_CATEGORIES"), "EMBLEM"), true): _switch1_start = 0
				elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_CATEGORIES"), "SCORE"), true): _switch1_start = 1
				elif JS.equal(_switch1, JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_CATEGORIES"), "SEPARATOR"), true): _switch1_start = 2
				while true:
					if _switch1_start >= 0 and _switch1_start <= 0:
						JS.set_property(_scope2, "newDisplayObject", JS.invoke_method(JS.get_property(self, "itemGroup"), "addChild", [JS.construct(JS.module("Phaser.Image"), [JS.get_property(self, "game"), 0, 0, "playerpanel", JS.add("emblem", JS.get_property(_scope2["config"], "type"))])]))
						JS.invoke_method(JS.get_property(_scope2["newDisplayObject"], "scale"), "setTo", [0, 0])
						break
					if _switch1_start >= 0 and _switch1_start <= 1:
						JS.set_property(_scope2, "newDisplayObject", JS.invoke_method(JS.get_property(self, "itemGroup"), "addChild", [JS.construct(JS.module("Phaser.Text"), [JS.get_property(self, "game"), 0, 0, "", {"font": JS.add(JS.get_property(JS.module("UIConstants"), "SCORE_FONT_SIZE"), "px Arial black"), "fill": "#ffffff", "stroke": "#000000", "strokeThickness": JS.get_property(JS.module("UIConstants"), "SCORE_STROKE_WIDTH")}])]))
						break
					if _switch1_start >= 0 and _switch1_start <= 2:
						JS.set_property(_scope2, "newDisplayObject", JS.invoke_method(JS.get_property(self, "itemGroup"), "addChild", [JS.construct(JS.module("Phaser.Image"), [JS.get_property(self, "game"), 0, 0, "playerpanel", "separator"])]))
						break
					break
				JS.invoke_method(JS.get_property(_scope2["newDisplayObject"], "anchor"), "set", [JS.get_property(_scope2["config"], "anchorX"), 0.5])
				JS.set_property(_scope2["newDisplayObject"], "y", JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), JS.get_property(_scope2["config"], "category")), "offsetY"))
				JS.invoke_method(JS.get_property(self, "items"), "push", [{"category": JS.get_property(_scope2["config"], "category"), "type": JS.get_property(_scope2["config"], "type"), "displayObject": _scope2["newDisplayObject"], "spawnTween": null, "removeTween": null}])
				JS.increment(_scope2, "i", 1, false)
			JS.invoke_method(self, "_updateItemPositions", [false])
		_scope2["i"] = 0
		while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(self, "items"), "length"))):
			_scope2["item"] = JS.get_property(JS.get_property(self, "items"), _scope2["i"])
			var _switch2 = JS.get_property(_scope2["item"], "category")
			var _switch2_start = -1
			if JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_CATEGORIES"), "EMBLEM"), true): _switch2_start = 0
			elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_CATEGORIES"), "SCORE"), true): _switch2_start = 1
			elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_CATEGORIES"), "SEPARATOR"), true): _switch2_start = 2
			while true:
				if _switch2_start >= 0 and _switch2_start <= 0:
					_scope2["emblemFound"] = false
					_scope2["emblemStates"] = JS.invoke_method(JS.get_property(self, "latestGameState"), "getEmblemStates", [])
					_scope2["j"] = 0
					while JS.truthy(JS.compare("<", _scope2["j"], JS.get_property(_scope2["emblemStates"], "length"))):
						if JS.truthy(JS.equal(JS.get_property(self, "playerId"), JS.invoke_method(JS.get_property(_scope2["emblemStates"], _scope2["j"]), "getPlayerId", []), false)):
							if JS.truthy(JS.equal(JS.get_property(_scope2["item"], "type"), JS.invoke_method(JS.get_property(_scope2["emblemStates"], _scope2["j"]), "getType", []), false)):
								JS.set_property(_scope2, "emblemFound", true)
								break
						JS.increment(_scope2, "j", 1, false)
					JS.invoke_method(self, "_updateEmblem", [_scope2["item"], _scope2["emblemFound"]])
					break
				if _switch2_start >= 0 and _switch2_start <= 1:
					_scope2["scoreStates"] = JS.invoke_method(JS.get_property(self, "latestGameState"), "getScoreStates", [])
					_scope2["j"] = 0
					while JS.truthy(JS.compare("<", _scope2["j"], JS.get_property(_scope2["scoreStates"], "length"))):
						if JS.truthy(JS.equal(JS.get_property(self, "playerId"), JS.invoke_method(JS.get_property(_scope2["scoreStates"], _scope2["j"]), "getPlayerId", []), false)):
							if JS.truthy(JS.equal(JS.get_property(_scope2["item"], "type"), JS.invoke_method(JS.get_property(_scope2["scoreStates"], _scope2["j"]), "getType", []), false)):
								JS.invoke_method(self, "_updateScore", [_scope2["item"], JS.invoke_method(JS.get_property(_scope2["scoreStates"], _scope2["j"]), "getValue", [])])
								break
						JS.increment(_scope2, "j", 1, false)
					break
				if _switch2_start >= 0 and _switch2_start <= 2:
					JS.invoke_method(JS.get_property(_scope2["item"], "displayObject"), "revive", [])
					break
				break
			JS.increment(_scope2, "i", 1, false)
		JS.invoke_method(self, "_updateItemPositions", [true])
	return null

func original__updateItemPositions(_arg0 = null):
	var _scope3: Dictionary = {"animate": _arg0, "centerItem": null, "centerItemWidth": null, "offsetX": null, "i": null, "item": null, "itemWidth": null, "itemPadding": null, "itemX": null}
	_scope3["centerItem"] = JS.get_property(JS.get_property(self, "items"), JS.get_property(self, "centerIndex"))
	JS.invoke_method(self, "_updateItemPosition", [_scope3["centerItem"], 0, _scope3["animate"]])
	_scope3["centerItemWidth"] = JS.get_property(JS.invoke_method(JS.get_property(_scope3["centerItem"], "displayObject"), "getLocalBounds", []), "width")
	_scope3["offsetX"] = (JS.number((JS.number(-(_scope3["centerItemWidth"])) * JS.number(JS.get_property(JS.get_property(JS.get_property(_scope3["centerItem"], "displayObject"), "anchor"), "x")))) - JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), JS.get_property(_scope3["centerItem"], "category")), "paddingX")))
	_scope3["i"] = (JS.number(JS.get_property(self, "centerIndex")) - JS.number(1))
	while JS.truthy(JS.compare(">=", _scope3["i"], 0)):
		_scope3["item"] = JS.get_property(JS.get_property(self, "items"), _scope3["i"])
		_scope3["itemWidth"] = JS.get_property(JS.invoke_method(JS.get_property(_scope3["item"], "displayObject"), "getLocalBounds", []), "width")
		_scope3["itemPadding"] = JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), JS.get_property(_scope3["item"], "category")), "paddingX")
		_scope3["itemX"] = (JS.number((JS.number(_scope3["offsetX"]) - JS.number((JS.number(_scope3["itemWidth"]) * JS.number((JS.number(1) - JS.number(JS.get_property(JS.get_property(JS.get_property(_scope3["item"], "displayObject"), "anchor"), "x")))))))) - JS.number(_scope3["itemPadding"]))
		JS.invoke_method(self, "_updateItemPosition", [_scope3["item"], _scope3["itemX"], _scope3["animate"]])
		JS.set_property(_scope3, "offsetX", (JS.number(_scope3["offsetX"]) - JS.number(JS.add(_scope3["itemWidth"], (JS.number(2) * JS.number(_scope3["itemPadding"]))))))
		JS.increment(_scope3, "i", -1, false)
	JS.set_property(_scope3, "offsetX", JS.add((JS.number(_scope3["centerItemWidth"]) * JS.number((JS.number(1) - JS.number(JS.get_property(JS.get_property(JS.get_property(_scope3["centerItem"], "displayObject"), "anchor"), "x"))))), JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), JS.get_property(_scope3["centerItem"], "category")), "paddingX")))
	_scope3["i"] = JS.add(JS.get_property(self, "centerIndex"), 1)
	while JS.truthy(JS.compare("<", _scope3["i"], JS.get_property(JS.get_property(self, "items"), "length"))):
		_scope3["item"] = JS.get_property(JS.get_property(self, "items"), _scope3["i"])
		_scope3["itemWidth"] = JS.get_property(JS.invoke_method(JS.get_property(_scope3["item"], "displayObject"), "getLocalBounds", []), "width")
		_scope3["itemPadding"] = JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), JS.get_property(_scope3["item"], "category")), "paddingX")
		_scope3["itemX"] = JS.add(JS.add(_scope3["offsetX"], (JS.number(_scope3["itemWidth"]) * JS.number(JS.get_property(JS.get_property(JS.get_property(_scope3["item"], "displayObject"), "anchor"), "x")))), _scope3["itemPadding"])
		JS.invoke_method(self, "_updateItemPosition", [_scope3["item"], _scope3["itemX"], _scope3["animate"]])
		JS.set_property(_scope3, "offsetX", JS.add(_scope3["offsetX"], JS.add(_scope3["itemWidth"], (JS.number(2) * JS.number(_scope3["itemPadding"])))))
		JS.increment(_scope3, "i", 1, false)
	return null

func original__updateItemPosition(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope4: Dictionary = {"item": _arg0, "posX": _arg1, "animate": _arg2}
	if JS.truthy(_scope4["animate"]):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(_scope4["item"], "displayObject")]), "to", [{"x": _scope4["posX"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "Out"), true])
	else:
		JS.set_property(JS.get_property(_scope4["item"], "displayObject"), "x", _scope4["posX"])
	return null

func original__updateScore(_arg0 = null, _arg1 = null):
	var _scope5: Dictionary = {"item": _arg0, "newValue": _arg1, "textField": null, "oldValue": null, "centerX": null, "numFragments": null, "i": null, "fragment": null}
	_scope5["textField"] = JS.get_property(_scope5["item"], "displayObject")
	_scope5["oldValue"] = JS.get_property(_scope5["textField"], "text")
	if JS.truthy(JS.logical("&&", func():
		var _scope6: Dictionary = {}
		return not JS.equal(_scope5["newValue"], _scope5["oldValue"], false)
		return null, func():
		var _scope7: Dictionary = {}
		return not JS.equal(_scope5["oldValue"], "", false)
		return null)):
		_scope5["centerX"] = JS.add(JS.get_property(_scope5["textField"], "x"), (JS.number((JS.number(0.5) - JS.number(JS.get_property(JS.get_property(_scope5["textField"], "anchor"), "x")))) * JS.number(JS.get_property(_scope5["textField"], "width"))))
		JS.invoke_method(JS.get_property(self, "emitter"), "spawn", [_scope5["centerX"], JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_Y"), JS.get_property(_scope5["textField"], "width")])
		_scope5["numFragments"] = JS.invoke_method("@Math", "min", [JS.get_property(JS.module("UIConstants"), "MAX_SCORE_FRAGMENTS_PER_EXPLOSION"), JS.add((JS.number(JS.get_property(JS.module("UIConstants"), "MIN_SCORE_FRAGMENTS_PER_LETTER")) * JS.number(JS.get_property(_scope5["oldValue"], "length"))), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(3))]))])
		_scope5["i"] = 0
		while JS.truthy(JS.compare("<", _scope5["i"], _scope5["numFragments"])):
			_scope5["fragment"] = JS.invoke_method(JS.get_property(self, "fragmentGroup"), "getFirstExists", [false])
			if JS.truthy(_scope5["fragment"]):
				JS.invoke_method(_scope5["fragment"], "spawn", [_scope5["centerX"], JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_Y"), JS.get_property(_scope5["textField"], "width")])
			else:
				JS.invoke_method(JS.get_property(self, "log"), "error", ["Could not create score fragment sprite. No sprite available."])
			JS.increment(_scope5, "i", 1, false)
	JS.invoke_method(_scope5["textField"], "setText", [_scope5["newValue"]])
	return null

func original__updateEmblem(_arg0 = null, _arg1 = null):
	var _scope8: Dictionary = {"item": _arg0, "show": _arg1}
	if JS.truthy(_scope8["show"]):
		if JS.truthy(JS.get_property(_scope8["item"], "removeTween")):
			JS.invoke_method(JS.get_property(_scope8["item"], "removeTween"), "stop", [])
			JS.set_property(_scope8["item"], "removeTween", null)
		JS.set_property(_scope8["item"], "spawnTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(JS.get_property(_scope8["item"], "displayObject"), "scale")]), "to", [{"x": 1, "y": 1}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out")]))
		JS.invoke_method(JS.get_property(_scope8["item"], "spawnTween"), "start", [])
	else:
		if JS.truthy(JS.get_property(_scope8["item"], "spawnTween")):
			JS.invoke_method(JS.get_property(_scope8["item"], "spawnTween"), "stop", [])
			JS.set_property(_scope8["item"], "spawnTween", null)
		JS.set_property(_scope8["item"], "removeTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(JS.get_property(_scope8["item"], "displayObject"), "scale")]), "to", [{"x": 0, "y": 0}, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None")]))
		JS.invoke_method(JS.get_property(_scope8["item"], "removeTween"), "start", [])
	return null

func original__clearItems():
	var _scope9: Dictionary = {}
	JS.set_property(self, "latestGameState", null)
	JS.set_property(self, "items", null)
	JS.set_property(self, "centerIndex", null)
	JS.invoke_method(JS.get_property(self, "itemGroup"), "setAll", ["pendingDestroy", true])
	return null

func original_update():
	var _scope10: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_update()
	return null

func original_postUpdate():
	var _scope11: Dictionary = {}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_postUpdate()
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope12: Dictionary = {"x": _arg0, "y": _arg1, "playerId": _arg2, "delay": null}
	JS.set_property(self, "exists", true)
	JS.set_property(self, "visible", true)
	JS.set_property(self, "x", _scope12["x"])
	JS.set_property(self, "y", _scope12["y"])
	JS.set_property(self, "playerId", _scope12["playerId"])
	JS.invoke_method(self, "_updateItemsWithLatestGameState", [])
	_scope12["delay"] = JS.add(50, (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(200)))
	if JS.truthy(JS.get_property(self, "removeTween")):
		JS.invoke_method(JS.get_property(self, "removeTween"), "stop", [])
	JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 1, "y": 1}, JS.get_property(JS.module("UIConstants"), "ELEMENT_POP_IN_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Back"), "Out"), true, _scope12["delay"]])
	return null

func original_refresh(_arg0 = null, _arg1 = null):
	var _scope13: Dictionary = {"x": _arg0, "y": _arg1}
	if JS.truthy(not JS.equal(_scope13["x"], null, true)):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"x": _scope13["x"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	if JS.truthy(not JS.equal(_scope13["y"], null, true)):
		JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [self]), "to", [{"y": _scope13["y"]}, JS.get_property(JS.module("UIConstants"), "ELEMENT_MOVE_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Quadratic"), "InOut"), true])
	return null

func original_remove():
	var _scope14: Dictionary = {}
	JS.set_property(self, "removeTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": 0, "y": 0}, JS.get_property(JS.module("UIConstants"), "ELEMENT_GLIDE_OUT_TIME"), JS.get_property(JS.get_property(JS.get_property(JS.module("Phaser"), "Easing"), "Linear"), "None"), true]))
	JS.invoke_method(JS.get_property(JS.get_property(self, "removeTween"), "onComplete"), "add", [func():
		var _scope15: Dictionary = {}
		JS.invoke_method(JS.callback_receiver(self), "_clearItems", [])
		JS.set_property(JS.callback_receiver(self), "exists", false)
		JS.set_property(JS.callback_receiver(self), "visible", false)
		return null, self])
	return null

func original_retire():
	var _scope16: Dictionary = {}
	JS.invoke_method(self, "_clearItems", [])
	JS.set_property(self, "exists", false)
	JS.set_property(self, "visible", false)
	JS.invoke_method(JS.module("GameManager"), "removeGameEventListener", [JS.get_property(self, "_gameEventHandler"), self])
	return null
