# 由原版 UILaikaSpine 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/animation/spine_actor.gd"

static var _static_UILaikaSpine: Dictionary = {}
static var _initialized_UILaikaSpine = false
static func initialize_original_static():
	if _initialized_UILaikaSpine: return
	_initialized_UILaikaSpine = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UILaikaSpine.has(key): return _static_UILaikaSpine[key]
	return JS.get_property(JS.module("PhaserSpine.Spine"), key)
static func original_static_set(key, value):
	_static_UILaikaSpine[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"game": _arg0, "x": _arg1, "y": _arg2, "playerId": _arg3, "flipX": _arg4}
	JS.set_property(_scope0, "flipX", (false if JS.truthy(JS.equal(_scope0["flipX"], null, true)) else _scope0["flipX"]))
	super._construct_create(_scope0["game"], _scope0["x"], _scope0["y"], "laika", true, _scope0["flipX"])
	JS.set_property(self, "playerId", (null if JS.truthy(JS.equal(_scope0["playerId"], null, true)) else _scope0["playerId"]))
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "SPINE_SCALE")])
	JS.invoke_method(self, "setMixByName", ["torso breathe", "torso tense", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso breathe", "torso relax", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso breathe", "torso excite", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso tense", "torso breathe", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso tense", "torso relax", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso tense", "torso excite", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso relax", "torso breathe", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso relax", "torso tense", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso relax", "torso excite", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso excite", "torso breathe", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso excite", "torso tense", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso excite", "torso relax", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["head normalise", "head lower", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["head normalise", "head raise", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["head lower", "head normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["head lower", "head raise", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["head raise", "head normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["head raise", "head lower", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["mouth howl", "mouth howl", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "HOWL_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["ears normalise", "ears tense", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["ears normalise", "ears relax", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["ears tense", "ears normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["ears tense", "ears relax", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["ears relax", "ears normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["ears relax", "ears tense", JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "DEFAULT_MIX_TIME")])
	JS.set_property(self, "isIdle", false)
	JS.set_property(self, "isAiming", false)
	JS.set_property(self, "aimers", {})
	JS.set_property(self, "idleToeRollDelay", JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MIN_TOE_ROLL_DELAY"), JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MAX_TOE_ROLL_DELAY")]))
	JS.set_property(self, "idleBlinkDelay", JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MIN_BLINK_DELAY"), JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MAX_BLINK_DELAY")]))
	JS.set_property(self, "chainRattleEvent", null)
	JS.set_property(self, "endAnimationEvent", null)
	JS.invoke_method(JS.module("GameManager"), "addGameEventListener", [JS.get_property(self, "_gameEventHandler"), self])
	JS.invoke_method(JS.module("GameManager"), "addRoundEventListener", [JS.get_property(self, "_roundEventHandler"), self])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UILaikaSpine"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/presentation/uilaikaspine.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4)
	return instance

func original__clearEvents():
	var _scope1: Dictionary = {}
	if JS.truthy(JS.get_property(self, "chainRattleEvent")):
		JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "remove", [JS.get_property(self, "chainRattleEvent")])
		JS.set_property(self, "chainRattleEvent", null)
	if JS.truthy(JS.get_property(self, "endAnimationEvent")):
		JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "remove", [JS.get_property(self, "endAnimationEvent")])
		JS.set_property(self, "endAnimationEvent", null)
	return null

func original__clearCustomTracks():
	var _scope2: Dictionary = {}
	JS.invoke_method(self, "clearTrack", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "HOWL")])
	return null

func original__rattleChain():
	var _scope3: Dictionary = {}
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "CHAIN"), "chain rattle"])
	return null

func original_update():
	var _scope4: Dictionary = {"i": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	if JS.truthy(JS.get_property(self, "isIdle")):
		JS.set_property(self, "idleToeRollDelay", (JS.number(JS.get_property(self, "idleToeRollDelay")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000)))))
		if JS.truthy(JS.compare("<", JS.get_property(self, "idleToeRollDelay"), 0)):
			JS.set_property(self, "idleToeRollDelay", JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MIN_TOE_ROLL_DELAY"), JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MAX_TOE_ROLL_DELAY")]))
			JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "TOES"), "toes roll"])
		if JS.truthy((not JS.truthy(JS.get_property(self, "isAiming")))):
			JS.set_property(self, "idleBlinkDelay", (JS.number(JS.get_property(self, "idleBlinkDelay")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000)))))
			if JS.truthy(JS.compare("<", JS.get_property(self, "idleBlinkDelay"), 0)):
				JS.set_property(self, "idleBlinkDelay", JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MIN_BLINK_DELAY"), JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MAX_BLINK_DELAY")]))
				if JS.truthy(JS.compare("<=", JS.invoke_method("@Math", "random", []), JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_PROBABILITY"))):
					JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close"])
					_scope4["i"] = 1
					while JS.truthy(JS.compare("<", _scope4["i"], JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_NUM_BLINKS"))):
						JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes normalise", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
						JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
						JS.increment(_scope4, "i", 1, false)
					JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes laser", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
					JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_TIME")])
					JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes normalise", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
				else:
					JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close"])
					JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes normalise", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "BLINK_TIME")])
	super.original_update()
	return null

func original__updateAiming():
	var _scope5: Dictionary = {"foundActiveAimer": null, "aimerId": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "isAiming")))):
		_scope5["foundActiveAimer"] = false
		for _iteration0 in JS.keys(JS.get_property(self, "aimers")):
			JS.set_property(_scope5, "aimerId", _iteration0)
			if JS.truthy(JS.get_property(JS.get_property(self, "aimers"), _scope5["aimerId"])):
				JS.set_property(_scope5, "foundActiveAimer", true)
				break
		if JS.truthy(_scope5["foundActiveAimer"]):
			JS.set_property(self, "isAiming", true)
			if JS.truthy(not JS.equal(JS.invoke_method(self, "getCurrentAnimationForTrack", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES")]), "eyes laser", true)):
				JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close"])
				JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes laser", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
	else:
		_scope5["foundActiveAimer"] = false
		for _iteration1 in JS.keys(JS.get_property(self, "aimers")):
			JS.set_property(_scope5, "aimerId", _iteration1)
			if JS.truthy(JS.get_property(JS.get_property(self, "aimers"), _scope5["aimerId"])):
				JS.set_property(_scope5, "foundActiveAimer", true)
				break
		if JS.truthy((not JS.truthy(_scope5["foundActiveAimer"]))):
			JS.set_property(self, "isAiming", false)
			JS.set_property(self, "idleBlinkDelay", JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MIN_BLINK_DELAY"), JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MAX_BLINK_DELAY")]))
			if JS.truthy(JS.equal(JS.invoke_method(self, "getCurrentAnimationForTrack", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES")]), "eyes laser", false)):
				JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close"])
				JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes normalise", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
	return null

func original_idle():
	var _scope6: Dictionary = {}
	JS.set_property(self, "isIdle", true)
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "_clearCustomTracks", [])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "TORSO"), "torso breathe", true])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "HEAD"), "head normalise"])
	if JS.truthy(JS.equal(JS.invoke_method(self, "getCurrentAnimationForTrack", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES")]), "eyes laser", false)):
		JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close"])
		JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes normalise", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
	else:
		JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "MOUTH"), "mouth normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EARS"), "ears normalise"])
	JS.invoke_method(self, "_updateAiming", [])
	return null

func original_growl(_arg0 = null):
	var _scope7: Dictionary = {"time": _arg0}
	JS.set_property(self, "isIdle", false)
	JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "sound"), "play", ["laikaGrowl"])
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "_clearCustomTracks", [])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "TORSO"), "torso tense"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "HEAD"), "head lower"])
	if JS.truthy(JS.equal(JS.invoke_method(self, "getCurrentAnimationForTrack", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES")]), "eyes laser", false)):
		JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close"])
		JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes normalise", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
	else:
		JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "MOUTH"), "mouth anger", true])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EARS"), "ears tense"])
	JS.set_property(self, "endAnimationEvent", JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "add", [_scope7["time"], JS.get_property(self, "idle"), self]))
	return null

func original_howl(_arg0 = null):
	var _scope8: Dictionary = {"time": _arg0, "i": null, "howlTime": null}
	JS.set_property(self, "isIdle", false)
	JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "sound"), "play", [JS.add("laikaHowl", JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "LAIKA_HOWL_AUDIO_COUNT")))]))])
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "_clearCustomTracks", [])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "TORSO"), "torso tense"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "HEAD"), "head raise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "MOUTH"), "mouth oh"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "HOWL"), "mouth oh"])
	_scope8["i"] = 0
	while JS.truthy(JS.compare("<", _scope8["i"], JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "NUM_HOWLS"))):
		_scope8["howlTime"] = JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MIN_HOWL_TIME"), JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "MAX_HOWL_TIME")])
		JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "HOWL"), "mouth howl", false, _scope8["howlTime"]])
		JS.increment(_scope8, "i", 1, false)
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EARS"), "ears relax"])
	JS.set_property(self, "chainRattleEvent", JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "add", [JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "CHAIN_RATTLE_DELAY"), JS.get_property(self, "_rattleChain"), self]))
	JS.set_property(self, "endAnimationEvent", JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "add", [_scope8["time"], JS.get_property(self, "idle"), self]))
	return null

func original_whimper(_arg0 = null):
	var _scope9: Dictionary = {"time": _arg0}
	JS.set_property(self, "isIdle", false)
	JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "sound"), "play", ["laikaWhine"])
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "_clearCustomTracks", [])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "TORSO"), "torso relax"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "HEAD"), "head lower"])
	if JS.truthy(JS.equal(JS.invoke_method(self, "getCurrentAnimationForTrack", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES")]), "eyes laser", false)):
		JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close"])
		JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes sad", true, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
	else:
		JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes sad", true])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "MOUTH"), "mouth sad", true])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EARS"), "ears sad"])
	JS.set_property(self, "endAnimationEvent", JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "add", [_scope9["time"], JS.get_property(self, "idle"), self]))
	return null

func original_gasp(_arg0 = null):
	var _scope10: Dictionary = {"time": _arg0}
	JS.set_property(self, "isIdle", false)
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "TORSO"), "torso excite"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "HEAD"), "head normalise"])
	if JS.truthy(JS.equal(JS.invoke_method(self, "getCurrentAnimationForTrack", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES")]), "eyes laser", false)):
		JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes close"])
		JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes open", false, JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "LASER_BLINK_TIME")])
	else:
		JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EYES"), "eyes open"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "MOUTH"), "mouth oh"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "LAIKA"), "TRACKS"), "EARS"), "ears tense"])
	JS.set_property(self, "endAnimationEvent", JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "add", [_scope10["time"], JS.get_property(self, "idle"), self]))
	return null

func original__gameEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope11: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3}
	return null

func original__roundEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope12: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3, "randomValue": null}
	var _switch2 = _scope12["evt"]
	var _switch2_start = -1
	if JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_KILLED"), true): _switch2_start = 0
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_CREATED"), true): _switch2_start = 1
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "UPGRADE_DESTROYED"), true): _switch2_start = 2
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "ROUND_ENDED"), true): _switch2_start = 3
	elif JS.equal(_switch2, JS.get_property(JS.get_property(JS.module("Upgrade"), "_EVENTS"), "UPGRADE_ACTIVATED"), true): _switch2_start = 4
	while true:
		if _switch2_start >= 0 and _switch2_start <= 0:
			if JS.truthy(JS.equal(JS.invoke_method(_scope12["data"], "getVictimPlayerId", []), JS.get_property(_scope12["self"], "playerId"), true)):
				_scope12["randomValue"] = JS.invoke_method("@Math", "random", [])
				if JS.truthy(JS.compare(">", _scope12["randomValue"], 0.66)):
					JS.invoke_method(_scope12["self"], "growl", [JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_GROWL_TIME")])
				else:
					if JS.truthy(JS.compare(">", _scope12["randomValue"], 0.33)):
						JS.invoke_method(_scope12["self"], "whimper", [JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_WHIMPER_TIME")])
					else:
						JS.invoke_method(_scope12["self"], "gasp", [JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_GASP_TIME")])
			else:
				if JS.truthy(JS.equal(JS.invoke_method(_scope12["data"], "getKillerPlayerId", []), JS.get_property(_scope12["self"], "playerId"), true)):
					if JS.truthy(JS.compare("<", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_GLOAT_CHANCE"))):
						JS.invoke_method(_scope12["self"], "howl", [JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_HOWL_TIME")])
			break
		if _switch2_start >= 0 and _switch2_start <= 1:
			if JS.truthy(JS.equal(JS.invoke_method(_scope12["data"], "getPlayerId", []), JS.get_property(_scope12["self"], "playerId"), false)):
				if JS.truthy(JS.logical("||", func():
					var _scope13: Dictionary = {}
					return JS.equal(JS.invoke_method(_scope12["data"], "getType", []), JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "AIMER"), false)
					return null, func():
					var _scope14: Dictionary = {}
					return JS.equal(JS.invoke_method(_scope12["data"], "getType", []), JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "LASER_AIMER"), false)
					return null)):
					if JS.truthy(JS.equal(JS.invoke_method(_scope12["data"], "getType", []), JS.get_property(JS.get_property(JS.module("Constants"), "UPGRADE_TYPES"), "LASER_AIMER"), false)):
						JS.set_property(JS.get_property(_scope12["self"], "aimers"), JS.invoke_method(_scope12["data"], "getId", []), JS.invoke_method(_scope12["data"], "getField", ["activated"]))
					else:
						JS.set_property(JS.get_property(_scope12["self"], "aimers"), JS.invoke_method(_scope12["data"], "getId", []), true)
					JS.invoke_method(_scope12["self"], "_updateAiming", [])
			break
		if _switch2_start >= 0 and _switch2_start <= 2:
			if JS.truthy(JS.equal(JS.invoke_method(_scope12["data"], "getPlayerId", []), JS.get_property(_scope12["self"], "playerId"), false)):
				JS.delete_property(JS.get_property(_scope12["self"], "aimers"), JS.invoke_method(_scope12["data"], "getUpgradeId", []))
				JS.invoke_method(_scope12["self"], "_updateAiming", [])
			break
		if _switch2_start >= 0 and _switch2_start <= 3:
			JS.set_property(_scope12["self"], "aimers", {})
			JS.invoke_method(_scope12["self"], "_updateAiming", [])
			break
		if _switch2_start >= 0 and _switch2_start <= 4:
			if JS.truthy(not JS.equal(JS.get_property(JS.get_property(_scope12["self"], "aimers"), _scope12["data"]), null, true)):
				JS.set_property(JS.get_property(_scope12["self"], "aimers"), _scope12["data"], true)
				JS.invoke_method(_scope12["self"], "_updateAiming", [])
			break
		break
	return null

func original_retire():
	var _scope15: Dictionary = {}
	JS.invoke_method(JS.module("GameManager"), "removeGameEventListener", [JS.get_property(self, "_gameEventHandler"), self])
	JS.invoke_method(JS.module("GameManager"), "removeRoundEventListener", [JS.get_property(self, "_roundEventHandler"), self])
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "kill", [])
	return null
