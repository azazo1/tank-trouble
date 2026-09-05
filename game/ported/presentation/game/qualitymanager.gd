# 由原版 QualityManager 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_QualityManager: Dictionary = {}
static var _initialized_QualityManager = false
static func initialize_original_static():
	if _initialized_QualityManager: return
	_initialized_QualityManager = true
	_static_QualityManager["quality"] = null
	_static_QualityManager["numFpsSamples"] = 0
	_static_QualityManager["avgFps"] = 0
	_static_QualityManager["fpsTime"] = 0
	_static_QualityManager["QUALITY_SETTINGS"] = {"AUTO": "auto", "HIGH": "high", "LOW": "low"}
	_static_QualityManager["QUALITY_PARAMETERS"] = {"TANK_EXPLOSION_SMOKE_COUNT": "tank explosion smoke count", "TANK_EXPLOSION_FRAGMENT_COUNT": "tank explosion fragment count", "MISSILE_LAUNCH_SMOKE_COUNT": "missile launch smoke count", "MISSILE_SMOKE_FREQUENCY": "missile smoke frequency", "MINE_EXPLOSION_SMOKE_COUNT": "mine explosion smoke count", "CRATE_LAND_DUST_COUNT": "crate land dust count", "AIMER_MIN_SEGMENT_LENGTH": "aimer min segment length", "AIMER_OFF_MAX_SEGMENT_LENGTH": "aimer off max segment length", "AIMER_ON_MAX_SEGMENT_LENGTH": "aimer on max segment length", "BULLET_PUFF_COUNT": "bullet puff count", "SHIELD_INVERSE_BOLT_PROBABILITY": "shield inverse bolt probability", "SHIELD_SPARK_PARTICLES_PER_EMIT": "shield spark particles per emit", "SPAWN_ZONE_INVERSE_UNSTABLE_PARTICLE_PROBABILITY": "spawn zone inverse unstable particle probability", "SPAWN_ZONE_NUM_COLLAPSE_PARTICLES": "spawn zone num collapse particles", "STORM_ZONE_NUM_STORM_PARTICLES": "storm zone num storm particles"}
	_static_QualityManager["QUALITY_VALUES"] = {"auto": {"tank explosion smoke count": 5, "tank explosion fragment count": 15, "missile launch smoke count": 20, "missile smoke frequency": 50, "mine explosion smoke count": 3, "crate land dust count": 20, "aimer min segment length": 0, "aimer off max segment length": 1, "aimer on max segment length": 0.3, "bullet puff count": 10, "shield inverse bolt probability": 0.95, "shield spark particles per emit": 4, "spawn zone inverse unstable particle probability": 0.5, "spawn zone num collapse particles": 40, "storm zone num storm particles": 100}, "high": {"tank explosion smoke count": 5, "tank explosion fragment count": 15, "missile launch smoke count": 20, "missile smoke frequency": 50, "mine explosion smoke count": 3, "crate land dust count": 20, "aimer min segment length": 0, "aimer off max segment length": 1, "aimer on max segment length": 0.3, "bullet puff count": 10, "shield inverse bolt probability": 0.95, "shield spark particles per emit": 4, "spawn zone inverse unstable particle probability": 0.5, "spawn zone num collapse particles": 40, "storm zone num storm particles": 100}, "low": {"tank explosion smoke count": 2, "tank explosion fragment count": 7, "missile launch smoke count": 10, "missile smoke frequency": 120, "mine explosion smoke count": 1, "crate land dust count": 10, "aimer min segment length": 0.5, "aimer off max segment length": 2, "aimer on max segment length": 1, "bullet puff count": 4, "shield inverse bolt probability": 0.99, "shield spark particles per emit": 1, "spawn zone inverse unstable particle probability": 0.9, "spawn zone num collapse particles": 20, "storm zone num storm particles": 40}}
	_static_QualityManager["eventListeners"] = []
	_static_QualityManager["EVENTS"] = {"QUALITY_SET": "quality set", "FPS_UPDATED": "fps updated"}
static func original_static_get(key):
	initialize_original_static()
	if _static_QualityManager.has(key): return _static_QualityManager[key]
	return null
static func original_static_set(key, value):
	_static_QualityManager[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/qualitymanager.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

static func original_addEventListener(_arg0 = null, _arg1 = null):
	var _scope0: Dictionary = {"callback": _arg0, "context": _arg1}
	JS.invoke_method(JS.get_property(JS.module("QualityManager"), "eventListeners"), "push", [{"cb": _scope0["callback"], "ctxt": JS.weak(_scope0["context"])}])
	return null

static func original_removeEventListener(_arg0 = null, _arg1 = null):
	var _scope1: Dictionary = {"callback": _arg0, "context": _arg1, "i": null}
	_scope1["i"] = 0
	while JS.truthy(JS.compare("<", _scope1["i"], JS.get_property(JS.get_property(JS.module("QualityManager"), "eventListeners"), "length"))):
		if JS.truthy(JS.logical("&&", func():
			var _scope2: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.module("QualityManager"), "eventListeners"), _scope1["i"]), "cb"), _scope1["callback"], true)
			return null, func():
			var _scope3: Dictionary = {}
			return JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.module("QualityManager"), "eventListeners"), _scope1["i"]), "ctxt"), _scope1["context"], true)
			return null)):
			JS.invoke_method(JS.get_property(JS.module("QualityManager"), "eventListeners"), "splice", [_scope1["i"], 1])
			return null
		JS.increment(_scope1, "i", 1, true)
	return null

static func original_setQuality(_arg0 = null):
	var _scope4: Dictionary = {"quality": _arg0}
	JS.set_property(JS.module("QualityManager"), "quality", _scope4["quality"])
	JS.invoke_method(JS.module("QualityManager"), "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("QualityManager"), "EVENTS"), "QUALITY_SET"), _scope4["quality"]])
	JS.invoke_method(JS.module("QualityManager"), "reset", [])
	return null

static func original_getQuality():
	var _scope5: Dictionary = {}
	return JS.get_property(JS.module("QualityManager"), "quality")
	return null

static func original_getQualityValue(_arg0 = null):
	var _scope6: Dictionary = {"qualityParameter": _arg0}
	return JS.get_property(JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_VALUES"), JS.get_property(JS.module("QualityManager"), "quality")), _scope6["qualityParameter"])
	return null

static func original_update():
	var _scope7: Dictionary = {"time": null, "currentFps": null}
	if JS.truthy(JS.equal(JS.get_property(JS.module("QualityManager"), "quality"), JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_SETTINGS"), "AUTO"), true)):
		_scope7["time"] = JS.invoke_method("@Date", "now", [])
		if JS.truthy(JS.compare(">", JS.get_property(JS.module("QualityManager"), "fpsTime"), 0)):
			_scope7["currentFps"] = (JS.number(1000) / JS.number((JS.number(_scope7["time"]) - JS.number(JS.get_property(JS.module("QualityManager"), "fpsTime")))))
			JS.set_property(JS.module("QualityManager"), "avgFps", (JS.number(JS.get_property(JS.module("QualityManager"), "avgFps")) * JS.number((JS.number(1) - JS.number(JS.get_property(JS.module("UIConstants"), "SETTINGS_QUALITY_FPS_AVG_WEIGHT"))))))
			JS.set_property(JS.module("QualityManager"), "avgFps", JS.add(JS.get_property(JS.module("QualityManager"), "avgFps"), (JS.number(_scope7["currentFps"]) * JS.number(JS.get_property(JS.module("UIConstants"), "SETTINGS_QUALITY_FPS_AVG_WEIGHT")))))
			JS.increment(JS.module("QualityManager"), "numFpsSamples", 1, true)
		JS.set_property(JS.module("QualityManager"), "fpsTime", _scope7["time"])
		if JS.truthy(JS.compare(">", JS.get_property(JS.module("QualityManager"), "numFpsSamples"), JS.get_property(JS.module("UIConstants"), "SETTINGS_QUALITY_FPS_MIN_SAMPLES"))):
			if JS.truthy(JS.equal(fmod(JS.get_property(JS.module("QualityManager"), "numFpsSamples"), JS.get_property(JS.module("UIConstants"), "SETTINGS_QUALITY_FPS_SAMPLE_UPDATE_INTERVAL")), 0, true)):
				JS.invoke_method(JS.module("QualityManager"), "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("QualityManager"), "EVENTS"), "FPS_UPDATED"), JS.get_property(JS.module("QualityManager"), "avgFps")])
			if JS.truthy(JS.compare("<", JS.get_property(JS.module("QualityManager"), "avgFps"), JS.get_property(JS.module("UIConstants"), "SETTINGS_QUALITY_FPS_CHANGE_TO_LOW"))):
				JS.invoke_method(JS.module("QualityManager"), "setQuality", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_SETTINGS"), "LOW")])
	return null

static func original_reset():
	var _scope8: Dictionary = {}
	JS.set_property(JS.module("QualityManager"), "numFpsSamples", 0)
	JS.set_property(JS.module("QualityManager"), "avgFps", 0)
	JS.set_property(JS.module("QualityManager"), "fpsTime", 0)
	JS.invoke_method(JS.module("QualityManager"), "_notifyEventListeners", [JS.get_property(JS.get_property(JS.module("QualityManager"), "EVENTS"), "FPS_UPDATED"), null])
	return null

static func original__notifyEventListeners(_arg0 = null, _arg1 = null):
	var _scope9: Dictionary = {"evt": _arg0, "data": _arg1, "i": null}
	_scope9["i"] = 0
	while JS.truthy(JS.compare("<", _scope9["i"], JS.get_property(JS.get_property(JS.module("QualityManager"), "eventListeners"), "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(JS.module("QualityManager"), "eventListeners"), _scope9["i"]), "cb", [JS.get_property(JS.get_property(JS.get_property(JS.module("QualityManager"), "eventListeners"), _scope9["i"]), "ctxt"), _scope9["evt"], _scope9["data"]])
		JS.increment(_scope9, "i", 1, true)
	return null
