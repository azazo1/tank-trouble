# 由原版 PhaserEmitter 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/particles/emitter_base.gd"

static var _static_PhaserEmitter: Dictionary = {}
static var _initialized_PhaserEmitter = false
static func initialize_original_static():
	if _initialized_PhaserEmitter: return
	_initialized_PhaserEmitter = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_PhaserEmitter.has(key): return _static_PhaserEmitter[key]
	return JS.get_property(JS.module("PhaserEmitterBase"), key)
static func original_static_set(key, value):
	_static_PhaserEmitter[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"t": _arg0, "e": _arg1, "i": _arg2, "s": _arg3}
	JS.sequence([JS.set_property(self, "maxParticles", JS.logical("||", func():
		var _scope1: Dictionary = {}
		return _scope0["s"]
		return null, func():
		var _scope2: Dictionary = {}
		return 50
		return null)), super._construct_create(_scope0["t"]), JS.set_property(self, "_id", JS.increment(JS.get_property(JS.get_property(self, "game"), "particles"), "ID", 1, true)), JS.set_property(self, "name", JS.add("emitter", JS.get_property(self, "id"))), JS.set_property(self, "type", JS.get_property(JS.module("X"), "EMITTER")), JS.set_property(self, "physicsType", JS.get_property(JS.module("X"), "GROUP")), JS.set_property(self, "area", JS.construct(JS.module("X.Rectangle"), [_scope0["e"], _scope0["i"], 1, 1])), JS.set_property(self, "minAngle", null), JS.set_property(self, "maxAngle", null), JS.set_property(self, "minSpeed", 0), JS.set_property(self, "maxSpeed", 100), JS.set_property(self, "minParticleSpeed", JS.construct(JS.module("X.Point"), [-(100), -(100)])), JS.set_property(self, "maxParticleSpeed", JS.construct(JS.module("X.Point"), [100, 100])), JS.set_property(self, "minParticleScale", 1), JS.set_property(self, "maxParticleScale", 1), JS.set_property(self, "scaleData", null), JS.set_property(self, "minRotation", -(360)), JS.set_property(self, "maxRotation", 360), JS.set_property(self, "minParticleAlpha", 1), JS.set_property(self, "maxParticleAlpha", 1), JS.set_property(self, "alphaData", null), JS.set_property(self, "particleClass", JS.module("X.Particle")), JS.set_property(self, "particleDrag", JS.construct(JS.module("X.Point"), [])), JS.set_property(self, "angularDrag", 0), JS.set_property(self, "frequency", 100), JS.set_property(self, "lifespan", 2000), JS.set_property(self, "bounce", JS.construct(JS.module("X.Point"), [])), JS.set_property(self, "on", (not JS.truthy(1))), JS.set_property(self, "particleAnchor", JS.construct(JS.module("X.Point"), [0.5, 0.5])), JS.set_property(self, "blendMode", JS.get_property(JS.get_property(JS.module("X"), "blendModes"), "NORMAL")), JS.set_property(self, "emitX", _scope0["e"]), JS.set_property(self, "emitY", _scope0["i"]), JS.set_property(self, "autoScale", (not JS.truthy(1))), JS.set_property(self, "autoScaleFps", JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "desiredFps")), JS.set_property(self, "autoAlpha", (not JS.truthy(1))), JS.set_property(self, "autoAlphaFps", JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "desiredFps")), JS.set_property(self, "particleBringToTop", (not JS.truthy(1))), JS.set_property(self, "particleSendToBack", (not JS.truthy(1))), JS.set_property(self, "counts", {"emitted": 0, "failed": 0, "totalEmitted": 0, "totalFailed": 0}), JS.set_property(self, "_gravity", JS.construct(JS.module("X.Point"), [0, 100])), JS.set_property(self, "_minParticleScale", JS.construct(JS.module("X.Point"), [1, 1])), JS.set_property(self, "_maxParticleScale", JS.construct(JS.module("X.Point"), [1, 1])), JS.set_property(self, "_total", 0), JS.set_property(self, "_timer", 0), JS.set_property(self, "_counter", 0), JS.set_property(self, "_flowQuantity", 0), JS.set_property(self, "_flowTotal", 0), JS.set_property(self, "_explode", (not JS.truthy(0))), JS.set_property(self, "_frames", null)])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/engine/phaseremitter.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3)
	return instance

func original_update():
	var _scope3: Dictionary = {"t": null}
	if JS.truthy(JS.sequence([JS.set_property(JS.get_property(self, "counts"), "emitted", 0), JS.set_property(JS.get_property(self, "counts"), "failed", 0), JS.logical("&&", func():
		var _scope4: Dictionary = {}
		return JS.get_property(self, "on")
		return null, func():
		var _scope5: Dictionary = {}
		return JS.compare(">=", JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "deltaTotal"), JS.get_property(self, "_timer"))
		return null)])):
		if JS.truthy(JS.sequence([JS.set_property(self, "_timer", JS.add(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "deltaTotal"), JS.get_property(self, "frequency"))), not JS.equal(0, JS.get_property(self, "_flowTotal"), true)])):
			if JS.truthy(JS.compare("<", 0, JS.get_property(self, "_flowQuantity"))):
				_scope3["t"] = 0
				while JS.truthy(JS.compare("<", _scope3["t"], JS.get_property(self, "_flowQuantity"))):
					if JS.truthy(JS.logical("&&", func():
						var _scope6: Dictionary = {}
						return JS.invoke_method(self, "emitParticle", [])
						return null, func():
						var _scope7: Dictionary = {}
						return JS.sequence([JS.increment(self, "_counter", 1, true), JS.logical("&&", func():
							var _scope8: Dictionary = {}
							return not JS.equal(-(1), JS.get_property(self, "_flowTotal"), true)
							return null, func():
							var _scope9: Dictionary = {}
							return JS.compare(">=", JS.get_property(self, "_counter"), JS.get_property(self, "_flowTotal"))
							return null)])
						return null)):
						JS.set_property(self, "on", (not JS.truthy(1)))
						break
					JS.increment(_scope3, "t", 1, true)
			else:
				JS.logical("&&", func():
					var _scope10: Dictionary = {}
					return JS.invoke_method(self, "emitParticle", [])
					return null, func():
					var _scope11: Dictionary = {}
					return JS.sequence([JS.increment(self, "_counter", 1, true), JS.logical("&&", func():
						var _scope12: Dictionary = {}
						return JS.logical("&&", func():
							var _scope13: Dictionary = {}
							return not JS.equal(-(1), JS.get_property(self, "_flowTotal"), true)
							return null, func():
							var _scope14: Dictionary = {}
							return JS.compare(">=", JS.get_property(self, "_counter"), JS.get_property(self, "_flowTotal"))
							return null)
						return null, func():
						var _scope15: Dictionary = {}
						return JS.set_property(self, "on", (not JS.truthy(1)))
						return null)])
					return null)
		else:
			JS.logical("&&", func():
				var _scope16: Dictionary = {}
				return JS.invoke_method(self, "emitParticle", [])
				return null, func():
				var _scope17: Dictionary = {}
				return JS.sequence([JS.increment(self, "_counter", 1, true), JS.logical("&&", func():
					var _scope18: Dictionary = {}
					return JS.logical("&&", func():
						var _scope19: Dictionary = {}
						return JS.compare("<", 0, JS.get_property(self, "_total"))
						return null, func():
						var _scope20: Dictionary = {}
						return JS.compare(">=", JS.get_property(self, "_counter"), JS.get_property(self, "_total"))
						return null)
					return null, func():
					var _scope21: Dictionary = {}
					return JS.set_property(self, "on", (not JS.truthy(1)))
					return null)])
				return null)
	JS.set_property(_scope3, "t", JS.get_property(JS.get_property(self, "children"), "length"))
	while JS.truthy(JS.increment(_scope3, "t", -1, true)):
		JS.logical("&&", func():
			var _scope22: Dictionary = {}
			return JS.get_property(JS.get_property(JS.get_property(self, "children"), _scope3["t"]), "exists")
			return null, func():
			var _scope23: Dictionary = {}
			return JS.invoke_method(JS.get_property(JS.get_property(self, "children"), _scope3["t"]), "update", [])
			return null)
	return null

func original_makeParticles(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope24: Dictionary = {"t": _arg0, "e": _arg1, "i": _arg2, "s": _arg3, "n": _arg4, "r": _arg5, "o": null, "a": null, "h": null, "l": null}
	JS.sequence([JS.logical("&&", func():
		var _scope25: Dictionary = {}
		return JS.equal(null, _scope24["e"], true)
		return null, func():
		var _scope26: Dictionary = {}
		return JS.set_property(_scope24, "e", 0)
		return null), JS.logical("&&", func():
		var _scope27: Dictionary = {}
		return JS.equal(null, _scope24["i"], true)
		return null, func():
		var _scope28: Dictionary = {}
		return JS.set_property(_scope24, "i", JS.get_property(self, "maxParticles"))
		return null), JS.logical("&&", func():
		var _scope29: Dictionary = {}
		return JS.equal(null, _scope24["s"], true)
		return null, func():
		var _scope30: Dictionary = {}
		return JS.set_property(_scope24, "s", (not JS.truthy(1)))
		return null), JS.logical("&&", func():
		var _scope31: Dictionary = {}
		return JS.equal(null, _scope24["n"], true)
		return null, func():
		var _scope32: Dictionary = {}
		return JS.set_property(_scope24, "n", (not JS.truthy(1)))
		return null), JS.logical("&&", func():
		var _scope33: Dictionary = {}
		return JS.equal(null, _scope24["r"], true)
		return null, func():
		var _scope34: Dictionary = {}
		return JS.set_property(_scope24, "r", null)
		return null)])
	_scope24["a"] = 0
	_scope24["h"] = _scope24["t"]
	_scope24["l"] = _scope24["e"]
	JS.sequence([JS.set_property(self, "_frames", _scope24["e"]), JS.logical("&&", func():
		var _scope35: Dictionary = {}
		return JS.compare(">", _scope24["i"], JS.get_property(self, "maxParticles"))
		return null, func():
		var _scope36: Dictionary = {}
		return JS.set_property(self, "maxParticles", _scope24["i"])
		return null)])
	while JS.truthy(JS.compare("<", _scope24["a"], _scope24["i"])):
		JS.sequence([JS.logical("&&", func():
			var _scope37: Dictionary = {}
			return JS.invoke_method("@Array", "isArray", [_scope24["t"]])
			return null, func():
			var _scope38: Dictionary = {}
			return JS.set_property(_scope24, "h", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "rnd"), "pick", [_scope24["t"]]))
			return null), JS.logical("&&", func():
			var _scope39: Dictionary = {}
			return JS.invoke_method("@Array", "isArray", [_scope24["e"]])
			return null, func():
			var _scope40: Dictionary = {}
			return JS.set_property(_scope24, "l", JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "rnd"), "pick", [_scope24["e"]]))
			return null), JS.set_property(_scope24, "o", JS.construct(JS.get_property(self, "particleClass"), [JS.get_property(self, "game"), 0, 0, _scope24["h"], _scope24["l"], _scope24["r"]])), JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "enable", [_scope24["o"], (not JS.truthy(1))]), JS.set_property(JS.get_property(JS.get_property(_scope24["o"], "body"), "checkCollision"), "none", (not JS.truthy(_scope24["s"]))), JS.set_property(JS.get_property(_scope24["o"], "body"), "collideWorldBounds", _scope24["n"]), JS.set_property(JS.get_property(_scope24["o"], "body"), "skipQuadTree", (not JS.truthy(0))), JS.set_property(_scope24["o"], "exists", (not JS.truthy(1))), JS.set_property(_scope24["o"], "visible", (not JS.truthy(1))), JS.invoke_method(JS.get_property(_scope24["o"], "anchor"), "copyFrom", [JS.get_property(self, "particleAnchor")]), JS.invoke_method(self, "add", [_scope24["o"]]), JS.increment(_scope24, "a", 1, true)])
	return self
	return null

func original_explode(_arg0 = null, _arg1 = null):
	var _scope41: Dictionary = {"t": _arg0, "e": _arg1}
	return JS.sequence([JS.logical("&&", func():
		var _scope42: Dictionary = {}
		return JS.equal(null, _scope41["e"], true)
		return null, func():
		var _scope43: Dictionary = {}
		return JS.set_property(_scope41, "e", JS.get_property(self, "maxParticles"))
		return null), JS.set_property(self, "_flowTotal", 0), JS.invoke_method(self, "start", [(not JS.truthy(0)), _scope41["t"], 0, _scope41["e"], (not JS.truthy(1))]), self])
	return null

func original_start(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope44: Dictionary = {"t": _arg0, "e": _arg1, "i": _arg2, "s": _arg3, "n": _arg4, "r": null}
	if JS.truthy(JS.sequence([JS.logical("&&", func():
		var _scope45: Dictionary = {}
		return JS.equal(null, _scope44["t"], true)
		return null, func():
		var _scope46: Dictionary = {}
		return JS.set_property(_scope44, "t", (not JS.truthy(0)))
		return null), JS.logical("&&", func():
		var _scope47: Dictionary = {}
		return JS.equal(null, _scope44["e"], true)
		return null, func():
		var _scope48: Dictionary = {}
		return JS.set_property(_scope44, "e", 0)
		return null), JS.logical("&&", func():
		var _scope49: Dictionary = {}
		return JS.equal(null, _scope44["i"], false)
		return null, func():
		var _scope50: Dictionary = {}
		return JS.set_property(_scope44, "i", 250)
		return null), JS.logical("&&", func():
		var _scope51: Dictionary = {}
		return JS.equal(null, _scope44["s"], true)
		return null, func():
		var _scope52: Dictionary = {}
		return JS.set_property(_scope44, "s", 0)
		return null), JS.logical("&&", func():
		var _scope53: Dictionary = {}
		return JS.equal(null, _scope44["n"], true)
		return null, func():
		var _scope54: Dictionary = {}
		return JS.set_property(_scope44, "n", (not JS.truthy(1)))
		return null), JS.logical("&&", func():
		var _scope55: Dictionary = {}
		return JS.compare(">", _scope44["s"], JS.get_property(self, "maxParticles"))
		return null, func():
		var _scope56: Dictionary = {}
		return JS.set_property(_scope44, "s", JS.get_property(self, "maxParticles"))
		return null), JS.invoke_method(self, "revive", []), JS.set_property(self, "visible", (not JS.truthy(0))), JS.set_property(self, "lifespan", _scope44["e"]), JS.set_property(self, "frequency", _scope44["i"]), JS.logical("||", func():
		var _scope57: Dictionary = {}
		return _scope44["t"]
		return null, func():
		var _scope58: Dictionary = {}
		return _scope44["n"]
		return null)])):
		_scope44["r"] = 0
		while JS.truthy(JS.compare("<", _scope44["r"], _scope44["s"])):
			JS.invoke_method(self, "emitParticle", [])
			JS.increment(_scope44, "r", 1, true)
	else:
		JS.sequence([JS.set_property(self, "on", (not JS.truthy(0))), JS.set_property(self, "_total", _scope44["s"]), JS.set_property(self, "_counter", 0), JS.set_property(self, "_timer", JS.add(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "deltaTotal"), _scope44["i"]))])
	return self
	return null

func original_emitParticle(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope59: Dictionary = {"t": _arg0, "e": _arg1, "i": _arg2, "s": _arg3, "n": null, "r": null, "o": null, "a": null}
	JS.sequence([JS.logical("&&", func():
		var _scope60: Dictionary = {}
		return JS.equal(null, _scope59["t"], true)
		return null, func():
		var _scope61: Dictionary = {}
		return JS.set_property(_scope59, "t", null)
		return null), JS.logical("&&", func():
		var _scope62: Dictionary = {}
		return JS.equal(null, _scope59["e"], true)
		return null, func():
		var _scope63: Dictionary = {}
		return JS.set_property(_scope59, "e", null)
		return null)])
	_scope59["n"] = JS.invoke_method(self, "getNextParticle", [])
	if JS.truthy(JS.equal(null, _scope59["n"], true)):
		return JS.sequence([JS.increment(JS.get_property(self, "counts"), "failed", 1, true), JS.increment(JS.get_property(self, "counts"), "totalFailed", 1, true), (not JS.truthy(1))])
	JS.sequence([JS.increment(JS.get_property(self, "counts"), "emitted", 1, true), JS.increment(JS.get_property(self, "counts"), "totalEmitted", 1, true)])
	_scope59["r"] = JS.get_property(JS.get_property(self, "game"), "rnd")
	(JS.invoke_method(_scope59["n"], "loadTexture", [_scope59["i"], _scope59["s"]]) if JS.truthy(JS.logical("&&", func():
		var _scope64: Dictionary = {}
		return not JS.equal(null, _scope59["i"], true)
		return null, func():
		var _scope65: Dictionary = {}
		return not JS.equal(null, _scope59["s"], true)
		return null)) else JS.logical("&&", func():
		var _scope66: Dictionary = {}
		return not JS.equal(null, _scope59["i"], true)
		return null, func():
		var _scope67: Dictionary = {}
		return JS.sequence([JS.invoke_method(_scope59["n"], "loadTexture", [_scope59["i"]]), JS.set_property(_scope59["n"], "frame", (JS.invoke_method(_scope59["r"], "pick", [JS.get_property(self, "_frames")]) if JS.truthy(JS.invoke_method("@Array", "isArray", [JS.get_property(self, "_frames")])) else JS.get_property(self, "_frames")))])
		return null))
	_scope59["o"] = JS.get_property(self, "emitX")
	_scope59["a"] = JS.get_property(self, "emitY")
	return JS.sequence([(JS.set_property(_scope59, "o", _scope59["t"]) if JS.truthy(not JS.equal(null, _scope59["t"], true)) else JS.logical("&&", func():
		var _scope68: Dictionary = {}
		return JS.compare("<", 1, JS.get_property(self, "width"))
		return null, func():
		var _scope69: Dictionary = {}
		return JS.set_property(_scope59, "o", JS.invoke_method(_scope59["r"], "between", [JS.get_property(self, "left"), JS.get_property(self, "right")]))
		return null)), (JS.set_property(_scope59, "a", _scope59["e"]) if JS.truthy(not JS.equal(null, _scope59["e"], true)) else JS.logical("&&", func():
		var _scope70: Dictionary = {}
		return JS.compare("<", 1, JS.get_property(self, "height"))
		return null, func():
		var _scope71: Dictionary = {}
		return JS.set_property(_scope59, "a", JS.invoke_method(_scope59["r"], "between", [JS.get_property(self, "top"), JS.get_property(self, "bottom")]))
		return null)), JS.invoke_method(self, "resetParticle", [_scope59["n"], _scope59["o"], _scope59["a"]]), (not JS.truthy(0))])
	return null

func original_resetParticle(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope72: Dictionary = {"t": _arg0, "e": _arg1, "i": _arg2, "s": null, "n": null}
	_scope72["s"] = JS.get_property(JS.get_property(self, "game"), "rnd")
	JS.sequence([JS.invoke_method(_scope72["t"], "reset", [_scope72["e"], _scope72["i"]]), JS.set_property(_scope72["t"], "angle", 0), JS.set_property(_scope72["t"], "lifespan", JS.get_property(self, "lifespan")), (JS.invoke_method(self, "bringToTop", [_scope72["t"]]) if JS.truthy(JS.get_property(self, "particleBringToTop")) else JS.logical("&&", func():
		var _scope73: Dictionary = {}
		return JS.get_property(self, "particleSendToBack")
		return null, func():
		var _scope74: Dictionary = {}
		return JS.invoke_method(self, "sendToBack", [_scope72["t"]])
		return null)), (JS.invoke_method(_scope72["t"], "setScaleData", [JS.get_property(self, "scaleData"), JS.get_property(self, "autoScaleFps")]) if JS.truthy(JS.get_property(self, "autoScale")) else (JS.invoke_method(JS.get_property(_scope72["t"], "scale"), "set", [JS.invoke_method(_scope72["s"], "realInRange", [JS.get_property(self, "minParticleScale"), JS.get_property(self, "maxParticleScale")])]) if JS.truthy(JS.logical("||", func():
		var _scope75: Dictionary = {}
		return not JS.equal(1, JS.get_property(self, "minParticleScale"), true)
		return null, func():
		var _scope76: Dictionary = {}
		return not JS.equal(1, JS.get_property(self, "maxParticleScale"), true)
		return null)) else (JS.invoke_method(JS.get_property(_scope72["t"], "scale"), "set", [JS.invoke_method(_scope72["s"], "realInRange", [JS.get_property(JS.get_property(self, "_minParticleScale"), "x"), JS.get_property(JS.get_property(self, "_maxParticleScale"), "x")]), JS.invoke_method(_scope72["s"], "realInRange", [JS.get_property(JS.get_property(self, "_minParticleScale"), "y"), JS.get_property(JS.get_property(self, "_maxParticleScale"), "y")])]) if JS.truthy(JS.logical("||", func():
		var _scope77: Dictionary = {}
		return not JS.equal(JS.get_property(JS.get_property(self, "_minParticleScale"), "x"), JS.get_property(JS.get_property(self, "_maxParticleScale"), "x"), true)
		return null, func():
		var _scope78: Dictionary = {}
		return not JS.equal(JS.get_property(JS.get_property(self, "_minParticleScale"), "y"), JS.get_property(JS.get_property(self, "_maxParticleScale"), "y"), true)
		return null)) else JS.invoke_method(JS.get_property(_scope72["t"], "scale"), "set", [JS.get_property(JS.get_property(self, "_minParticleScale"), "x"), JS.get_property(JS.get_property(self, "_minParticleScale"), "y")])))), (JS.invoke_method(_scope72["t"], "setAlphaData", [JS.get_property(self, "alphaData"), JS.get_property(self, "autoAlphaFps")]) if JS.truthy(JS.get_property(self, "autoAlpha")) else JS.set_property(_scope72["t"], "alpha", JS.invoke_method(_scope72["s"], "realInRange", [JS.get_property(self, "minParticleAlpha"), JS.get_property(self, "maxParticleAlpha")]))), JS.set_property(_scope72["t"], "blendMode", JS.get_property(self, "blendMode"))])
	_scope72["n"] = JS.get_property(_scope72["t"], "body")
	JS.sequence([JS.invoke_method(_scope72["n"], "updateBounds", []), JS.invoke_method(JS.get_property(_scope72["n"], "bounce"), "copyFrom", [JS.get_property(self, "bounce")]), JS.invoke_method(JS.get_property(_scope72["n"], "drag"), "copyFrom", [JS.get_property(self, "particleDrag")]), (JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "velocityFromAngle", [(JS.get_property(self, "minAngle") if JS.truthy(JS.equal(JS.get_property(self, "minAngle"), JS.get_property(self, "maxAngle"), true)) else JS.invoke_method(_scope72["s"], "between", [JS.get_property(self, "minAngle"), JS.get_property(self, "maxAngle")])), (JS.get_property(self, "minSpeed") if JS.truthy(JS.equal(JS.get_property(self, "minSpeed"), JS.get_property(self, "maxSpeed"), true)) else JS.invoke_method(_scope72["s"], "between", [JS.get_property(self, "minSpeed"), JS.get_property(self, "maxSpeed")])), JS.get_property(_scope72["n"], "velocity")]) if JS.truthy(JS.logical("&&", func():
		var _scope79: Dictionary = {}
		return not JS.equal(null, JS.get_property(self, "minAngle"), false)
		return null, func():
		var _scope80: Dictionary = {}
		return not JS.equal(null, JS.get_property(self, "maxAngle"), false)
		return null)) else JS.sequence([JS.set_property(JS.get_property(_scope72["n"], "velocity"), "x", JS.invoke_method(_scope72["s"], "between", [JS.get_property(JS.get_property(self, "minParticleSpeed"), "x"), JS.get_property(JS.get_property(self, "maxParticleSpeed"), "x")])), JS.set_property(JS.get_property(_scope72["n"], "velocity"), "y", JS.invoke_method(_scope72["s"], "between", [JS.get_property(JS.get_property(self, "minParticleSpeed"), "y"), JS.get_property(JS.get_property(self, "maxParticleSpeed"), "y")]))])), JS.set_property(_scope72["n"], "angularVelocity", JS.invoke_method(_scope72["s"], "between", [JS.get_property(self, "minRotation"), JS.get_property(self, "maxRotation")])), JS.invoke_method(JS.get_property(_scope72["n"], "gravity"), "copyFrom", [JS.get_property(self, "gravity")]), JS.set_property(_scope72["n"], "angularDrag", JS.get_property(self, "angularDrag")), JS.invoke_method(_scope72["t"], "onEmit", [])])
	return null

func original_getNextParticle():
	var _scope81: Dictionary = {"t": null, "e": null}
	_scope81["t"] = JS.get_property(self, "length")
	while JS.truthy(JS.increment(_scope81, "t", -1, true)):
		_scope81["e"] = JS.invoke_method(self, "next", [])
		if JS.truthy((not JS.truthy(JS.get_property(_scope81["e"], "exists")))):
			return _scope81["e"]
	return null
	return null

func original_setRotation(_arg0 = null, _arg1 = null):
	var _scope82: Dictionary = {"t": _arg0, "e": _arg1}
	return JS.sequence([JS.set_property(_scope82, "t", JS.logical("||", func():
		var _scope83: Dictionary = {}
		return _scope82["t"]
		return null, func():
		var _scope84: Dictionary = {}
		return 0
		return null)), JS.set_property(_scope82, "e", JS.logical("||", func():
		var _scope85: Dictionary = {}
		return _scope82["e"]
		return null, func():
		var _scope86: Dictionary = {}
		return 0
		return null)), JS.set_property(self, "minRotation", _scope82["t"]), JS.set_property(self, "maxRotation", _scope82["e"]), self])
	return null

func original_setAlpha(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope87: Dictionary = {"t": _arg0, "e": _arg1, "i": _arg2, "s": _arg3, "n": _arg4, "r": null, "o": null}
	if JS.truthy(JS.sequence([JS.logical("&&", func():
		var _scope88: Dictionary = {}
		return JS.equal(null, _scope87["t"], true)
		return null, func():
		var _scope89: Dictionary = {}
		return JS.set_property(_scope87, "t", 1)
		return null), JS.logical("&&", func():
		var _scope90: Dictionary = {}
		return JS.equal(null, _scope87["e"], true)
		return null, func():
		var _scope91: Dictionary = {}
		return JS.set_property(_scope87, "e", 1)
		return null), JS.logical("&&", func():
		var _scope92: Dictionary = {}
		return JS.equal(null, _scope87["i"], true)
		return null, func():
		var _scope93: Dictionary = {}
		return JS.set_property(_scope87, "i", 0)
		return null), JS.logical("&&", func():
		var _scope94: Dictionary = {}
		return JS.equal(null, _scope87["s"], true)
		return null, func():
		var _scope95: Dictionary = {}
		return JS.set_property(_scope87, "s", JS.get_property(JS.get_property(JS.get_property(JS.module("X"), "Easing"), "Linear"), "None"))
		return null), JS.logical("&&", func():
		var _scope96: Dictionary = {}
		return JS.equal(null, _scope87["n"], true)
		return null, func():
		var _scope97: Dictionary = {}
		return JS.set_property(_scope87, "n", (not JS.truthy(1)))
		return null), JS.set_property(self, "minParticleAlpha", _scope87["t"]), JS.set_property(self, "maxParticleAlpha", _scope87["e"]), JS.set_property(self, "autoAlpha", (not JS.truthy(1))), JS.logical("&&", func():
		var _scope98: Dictionary = {}
		return JS.compare("<", 0, _scope87["i"])
		return null, func():
		var _scope99: Dictionary = {}
		return not JS.equal(_scope87["t"], _scope87["e"], true)
		return null)])):
		_scope87["r"] = {"v": _scope87["t"]}
		_scope87["o"] = JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "make"), "tween", [_scope87["r"]]), "to", [{"v": _scope87["e"]}, _scope87["i"], _scope87["s"]])
		JS.sequence([JS.invoke_method(_scope87["o"], "yoyo", [_scope87["n"]]), JS.set_property(self, "alphaData", JS.invoke_method(_scope87["o"], "generateData", [JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "desiredFps")])), JS.set_property(self, "autoAlphaFps", JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "desiredFps")), JS.invoke_method(JS.get_property(self, "alphaData"), "reverse", []), JS.set_property(self, "autoAlpha", (not JS.truthy(0)))])
	return self
	return null
