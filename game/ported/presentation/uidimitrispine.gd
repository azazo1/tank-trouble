# 由原版 UIDimitriSpine 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/animation/spine_actor.gd"

static var _static_UIDimitriSpine: Dictionary = {}
static var _initialized_UIDimitriSpine = false
static func initialize_original_static():
	if _initialized_UIDimitriSpine: return
	_initialized_UIDimitriSpine = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIDimitriSpine.has(key): return _static_UIDimitriSpine[key]
	return JS.get_property(JS.module("PhaserSpine.Spine"), key)
static func original_static_set(key, value):
	_static_UIDimitriSpine[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"game": _arg0, "x": _arg1, "y": _arg2, "playerId": _arg3, "flipX": _arg4}
	JS.set_property(_scope0, "flipX", (false if JS.truthy(JS.equal(_scope0["flipX"], null, true)) else _scope0["flipX"]))
	super._construct_create(_scope0["game"], _scope0["x"], _scope0["y"], "dimitri", true, _scope0["flipX"])
	JS.set_property(self, "playerId", (null if JS.truthy(JS.equal(_scope0["playerId"], null, true)) else _scope0["playerId"]))
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "SPINE_SCALE")])
	JS.invoke_method(self, "setMixByName", ["torso breathe", "torso tense", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["torso tense", "torso breathe", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["head normalise", "head lower", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["head lower", "head normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["eyes normalise", "eyes anger", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["eyes normalise", "eyes surprise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["eyes anger", "eyes normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["eyes anger", "eyes surprise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["eyes surprise", "eyes normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["eyes surprise", "eyes anger", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["schnurrbart normalise", "schnurrbart breathe", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["schnurrbart normalise", "schnurrbart wiggle", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["schnurrbart breathe", "schnurrbart normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["schnurrbart breathe", "schnurrbart wiggle", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["schnurrbart wiggle", "schnurrbart normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["schnurrbart wiggle", "schnurrbart breathe", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hands normalise", "hands rub", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hands rub", "hands normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip normalise", "hip bounce", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip normalise", "hip lower", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip normalise", "hip lean backwards", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip normalise", "hip lean forwards", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip bounce", "hip normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip bounce", "hip lower", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip bounce", "hip lean backwards", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip bounce", "hip lean forwards", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lower", "hip normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lower", "hip bounce", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lower", "hip lean backwards", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lower", "hip lean forwards", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lean backwards", "hip normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lean backwards", "hip bounce", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lean backwards", "hip lower", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lean backwards", "hip lean forwards", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lean forwards", "hip normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lean forwards", "hip bounce", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lean forwards", "hip lower", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["hip lean forwards", "hip lean backwards", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["left foot normalise", "left foot scratch", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["left foot normalise", "left foot tap", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "FOOT_TAP_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["left foot scratch", "left foot normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "DEFAULT_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["left foot scratch", "left foot tap", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "FOOT_TAP_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["left foot tap", "left foot normalise", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "FOOT_TAP_MIX_TIME")])
	JS.invoke_method(self, "setMixByName", ["left foot tap", "left foot scratch", JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "FOOT_TAP_MIX_TIME")])
	JS.set_property(self, "isIdle", false)
	JS.set_property(self, "idleLegsDelay", JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "MIN_LEGS_DELAY"), JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "MAX_LEGS_DELAY")]))
	JS.set_property(self, "idleWiggleDelay", JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "MIN_WIGGLE_DELAY"), JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "MAX_WIGGLE_DELAY")]))
	JS.set_property(self, "endAnimationEvent", null)
	JS.invoke_method(JS.module("GameManager"), "addGameEventListener", [JS.get_property(self, "_gameEventHandler"), self])
	JS.invoke_method(JS.module("GameManager"), "addRoundEventListener", [JS.get_property(self, "_roundEventHandler"), self])
	JS.set_property(self, "log", JS.invoke_method(JS.module("Log"), "create", ["UIDimitriSpine"]))
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/presentation/uidimitrispine.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4)
	return instance

func original__clearEvents():
	var _scope1: Dictionary = {}
	if JS.truthy(JS.get_property(self, "endAnimationEvent")):
		JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "remove", [JS.get_property(self, "endAnimationEvent")])
		JS.set_property(self, "endAnimationEvent", null)
	return null

func original_update():
	var _scope2: Dictionary = {"i": null, "randomValue": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	if JS.truthy(JS.get_property(self, "isIdle")):
		JS.set_property(self, "idleWiggleDelay", (JS.number(JS.get_property(self, "idleWiggleDelay")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000)))))
		if JS.truthy(JS.compare("<", JS.get_property(self, "idleWiggleDelay"), 0)):
			JS.set_property(self, "idleWiggleDelay", JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "MIN_WIGGLE_DELAY"), JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "MAX_WIGGLE_DELAY")]))
			JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "SCHNURRBART"), "schnurrbart wiggle"])
			_scope2["i"] = 1
			while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "SCHNURRBART_NUM_WIGGLES"))):
				JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "SCHNURRBART"), "schnurrbart wiggle"])
				JS.increment(_scope2, "i", 1, false)
			JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "SCHNURRBART"), "schnurrbart breathe", true])
		JS.set_property(self, "idleLegsDelay", (JS.number(JS.get_property(self, "idleLegsDelay")) - JS.number((JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000)))))
		if JS.truthy(JS.compare("<", JS.get_property(self, "idleLegsDelay"), 0)):
			JS.set_property(self, "idleLegsDelay", JS.invoke_method(JS.module("MathUtils"), "randomRange", [JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "MIN_LEGS_DELAY"), JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "MAX_LEGS_DELAY")]))
			_scope2["randomValue"] = JS.invoke_method("@Math", "random", [])
			if JS.truthy(JS.compare("<=", _scope2["randomValue"], JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "HIP_BOUNCE_PROBABILITY"))):
				JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HIP"), "hip bounce"])
				_scope2["i"] = 1
				while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "HIP_NUM_BOUNCES"))):
					JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HIP"), "hip bounce"])
					JS.increment(_scope2, "i", 1, false)
				JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HIP"), "hip normalise"])
			else:
				if JS.truthy(JS.compare("<=", (JS.number(_scope2["randomValue"]) - JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "HIP_BOUNCE_PROBABILITY"))), JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "FOOT_SCRATCH_PROBABILITY"))):
					JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "FOOT"), "left foot scratch"])
					_scope2["i"] = 1
					while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "FOOT_NUM_SCRATCHES"))):
						JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "FOOT"), "left foot scratch"])
						JS.increment(_scope2, "i", 1, false)
					JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "FOOT"), "left foot normalise"])
				else:
					JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "FOOT"), "left foot tap"])
					_scope2["i"] = 1
					while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "FOOT_NUM_TAPS"))):
						JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "FOOT"), "left foot tap"])
						JS.increment(_scope2, "i", 1, false)
					JS.invoke_method(self, "addAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "FOOT"), "left foot normalise"])
	super.original_update()
	return null

func original_idle():
	var _scope3: Dictionary = {}
	JS.set_property(self, "isIdle", true)
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "TORSO"), "torso breathe", true])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HEAD"), "head normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "EYES"), "eyes normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "MOUTH"), "mouth normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "SCHNURRBART"), "schnurrbart breathe", true])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HANDS"), "hands normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HIP"), "hip normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "FOOT"), "left foot normalise"])
	return null

func original_scowl(_arg0 = null):
	var _scope4: Dictionary = {"time": _arg0}
	JS.set_property(self, "isIdle", false)
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "TORSO"), "torso tense"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HEAD"), "head lower"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "EYES"), "eyes anger"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "MOUTH"), "mouth normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "SCHNURRBART"), "schnurrbart normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HANDS"), "hands rub", true])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HIP"), "hip lower"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "FOOT"), "left foot normalise"])
	JS.set_property(self, "endAnimationEvent", JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "add", [_scope4["time"], JS.get_property(self, "idle"), self]))
	return null

func original_gasp(_arg0 = null):
	var _scope5: Dictionary = {"time": _arg0}
	JS.set_property(self, "isIdle", false)
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "TORSO"), "torso tense"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HEAD"), "head normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "EYES"), "eyes surprise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "MOUTH"), "mouth oh"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "SCHNURRBART"), "schnurrbart normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HANDS"), "hands normalise"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "HIP"), "hip lean backwards"])
	JS.invoke_method(self, "setAnimationByName", [JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "DIMITRI"), "TRACKS"), "FOOT"), "left foot normalise"])
	JS.set_property(self, "endAnimationEvent", JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "events"), "add", [_scope5["time"], JS.get_property(self, "idle"), self]))
	return null

func original__gameEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope6: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3}
	return null

func original__roundEventHandler(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope7: Dictionary = {"self": _arg0, "id": _arg1, "evt": _arg2, "data": _arg3}
	var _switch0 = _scope7["evt"]
	var _switch0_start = -1
	if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("RoundModel"), "_EVENTS"), "TANK_KILLED"), true): _switch0_start = 0
	while true:
		if _switch0_start >= 0 and _switch0_start <= 0:
			JS.invoke_method("@console", "log", [JS.get_property(_scope7["self"], "playerId")])
			if JS.truthy(JS.equal(JS.invoke_method(_scope7["data"], "getVictimPlayerId", []), JS.get_property(_scope7["self"], "playerId"), true)):
				if JS.truthy(JS.compare("<", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_GASP_CHANCE"))):
					JS.invoke_method(_scope7["self"], "gasp", [JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_GASP_TIME")])
			else:
				if JS.truthy(JS.equal(JS.invoke_method(_scope7["data"], "getKillerPlayerId", []), JS.get_property(_scope7["self"], "playerId"), true)):
					if JS.truthy(JS.compare("<", JS.invoke_method("@Math", "random", []), JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_GLOAT_CHANCE"))):
						JS.invoke_method(_scope7["self"], "scowl", [JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_SCOWL_TIME")])
			break
		break
	return null

func original_retire():
	var _scope8: Dictionary = {}
	JS.invoke_method(JS.module("GameManager"), "removeGameEventListener", [JS.get_property(self, "_gameEventHandler"), self])
	JS.invoke_method(JS.module("GameManager"), "removeRoundEventListener", [JS.get_property(self, "_roundEventHandler"), self])
	JS.invoke_method(self, "_clearEvents", [])
	JS.invoke_method(self, "kill", [])
	return null
