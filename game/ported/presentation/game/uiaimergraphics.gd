# 由原版 UIAimerGraphics 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/graphics.gd"

static var _static_UIAimerGraphics: Dictionary = {}
static var _initialized_UIAimerGraphics = false
static func initialize_original_static():
	if _initialized_UIAimerGraphics: return
	_initialized_UIAimerGraphics = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIAimerGraphics.has(key): return _static_UIAimerGraphics[key]
	return JS.get_property(JS.module("Phaser.Graphics"), key)
static func original_static_set(key, value):
	_static_UIAimerGraphics[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1}
	super._construct_create(_scope0["game"], 0, 0)
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.set_property(self, "colour", 65280)
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uiaimergraphics.gd").new()
	instance._construct_create(_arg0, _arg1)
	return instance

func original__castRay(_arg0 = null, _arg1 = null):
	var _scope1: Dictionary = {"start": _arg0, "end": _arg1, "ray": null, "result": null, "returnResult": null, "hitPoint": null}
	_scope1["ray"] = JS.construct(JS.module("p2.Ray"), [{"mode": JS.get_property(JS.module("p2.Ray"), "CLOSEST"), "from": [-(JS.get_property(_scope1["start"], "x")), -(JS.get_property(_scope1["start"], "y"))], "to": [-(JS.get_property(_scope1["end"], "x")), -(JS.get_property(_scope1["end"], "y"))], "skipBackfaces": true, "collisionMask": JS.bitwise("|", JS.bitwise("|", JS.bitwise("|", JS.get_property(JS.get_property(JS.module("UIUtils"), "wallCollisionGroup"), "mask"), JS.get_property(JS.get_property(JS.module("UIUtils"), "tankCollisionGroup"), "mask")), JS.get_property(JS.get_property(JS.module("UIUtils"), "shieldCollisionGroup"), "mask")), JS.get_property(JS.get_property(JS.module("UIUtils"), "spawnCollisionGroup"), "mask")), "collisionGroup": JS.get_property(JS.get_property(JS.module("UIUtils"), "rayCollisionGroup"), "mask")}])
	_scope1["result"] = JS.construct(JS.module("p2.RaycastResult"), [])
	JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "world"), "raycast", [_scope1["result"], _scope1["ray"]])
	_scope1["returnResult"] = {}
	JS.set_property(_scope1["returnResult"], "hasHit", JS.invoke_method(_scope1["result"], "hasHit", []))
	if JS.truthy(JS.invoke_method(_scope1["result"], "hasHit", [])):
		_scope1["hitPoint"] = [0, 0]
		JS.invoke_method(_scope1["result"], "getHitPoint", [_scope1["hitPoint"], _scope1["ray"]])
		JS.set_property(_scope1["returnResult"], "hitPoint", JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [-(JS.get_property(_scope1["hitPoint"], 0)), -(JS.get_property(_scope1["hitPoint"], 1))]))
		JS.set_property(_scope1["returnResult"], "hitNormal", JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [-(JS.get_property(JS.get_property(_scope1["result"], "normal"), 0)), -(JS.get_property(JS.get_property(_scope1["result"], "normal"), 1))]))
		JS.set_property(_scope1["returnResult"], "hitDistance", JS.invoke_method(_scope1["result"], "getHitDistance", [_scope1["ray"]]))
		JS.set_property(_scope1["returnResult"], "hasHitTank", JS.equal(JS.get_property(JS.get_property(_scope1["result"], "shape"), "collisionGroup"), JS.get_property(JS.get_property(JS.module("UIUtils"), "tankCollisionGroup"), "mask"), false))
		JS.set_property(_scope1["returnResult"], "hasHitSpawn", JS.equal(JS.get_property(JS.get_property(_scope1["result"], "shape"), "collisionGroup"), JS.get_property(JS.get_property(JS.module("UIUtils"), "spawnCollisionGroup"), "mask"), false))
	return _scope1["returnResult"]
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null):
	var _scope2: Dictionary = {"playerId": _arg0, "maxLength": _arg1, "activated": _arg2, "self": null}
	JS.invoke_method(self, "revive", [])
	JS.invoke_method(self, "clear", [])
	JS.set_property(self, "playerId", _scope2["playerId"])
	JS.set_property(self, "maxLength", _scope2["maxLength"])
	JS.set_property(self, "activated", _scope2["activated"])
	_scope2["self"] = self
	JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
		var _scope3: Dictionary = {"result": _arg0}
		if JS.truthy(JS.equal(JS.type_of(_scope3["result"]), "object", false)):
			JS.set_property(_scope2["self"], "colour", JS.get_property(JS.invoke_method(_scope3["result"], "getTurretColour", []), "numericValue"))
		else:
			JS.set_property(_scope2["self"], "colour", JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_UNAVAILABLE_COLOUR"), "numericValue"))
		return null, func(_arg0 = null):
		var _scope4: Dictionary = {"result": _arg0}
		return null, func(_arg0 = null):
		var _scope5: Dictionary = {"result": _arg0}
		return null, JS.get_property(self, "playerId"), JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
	return null

func original_update():
	var _scope6: Dictionary = {"aimerPositions": null, "remainingLength": null, "tank": null, "rayDir": null, "rayStart": null, "rayEnd": null, "result": null, "beamPosition": null, "beamOn": null, "segmentSample": null, "minSegmentLength": null, "maxOffSegmentLength": null, "maxOnSegmentLength": null, "i": null, "segmentStart": null, "segmentEnd": null, "segmentDir": null, "segmentLength": null}
	if JS.truthy(JS.logical("||", func():
		var _scope7: Dictionary = {}
		return (not JS.truthy(JS.get_property(self, "exists")))
		return null, func():
		var _scope8: Dictionary = {}
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "arcade"), "isPaused")
		return null)):
		return null
	if JS.truthy((not JS.truthy(JS.get_property(self, "activated")))):
		return null
	_scope6["aimerPositions"] = []
	_scope6["remainingLength"] = JS.get_property(self, "maxLength")
	_scope6["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "playerId")])
	if JS.truthy(_scope6["tank"]):
		JS.invoke_method(_scope6["aimerPositions"], "push", [JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [JS.add(JS.invoke_method(_scope6["tank"], "getX", []), (JS.number(JS.invoke_method("@Math", "sin", [JS.invoke_method(_scope6["tank"], "getRotation", [])])) * JS.number(JS.invoke_method(JS.module("UIUtils"), "pxm", [JS.get_property(JS.module("UIConstants"), "AIMER_OFFSET")])))), (JS.number(JS.invoke_method(_scope6["tank"], "getY", [])) - JS.number((JS.number(JS.invoke_method("@Math", "cos", [JS.invoke_method(_scope6["tank"], "getRotation", [])])) * JS.number(JS.invoke_method(JS.module("UIUtils"), "pxm", [JS.get_property(JS.module("UIConstants"), "AIMER_OFFSET")])))))])])
		_scope6["rayDir"] = JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [JS.invoke_method("@Math", "sin", [JS.invoke_method(_scope6["tank"], "getRotation", [])]), -(JS.invoke_method("@Math", "cos", [JS.invoke_method(_scope6["tank"], "getRotation", [])]))])
		_scope6["rayStart"] = JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [0, 0])
		_scope6["rayEnd"] = JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [0, 0])
		while JS.truthy(JS.compare(">", _scope6["remainingLength"], 0)):
			JS.set_property(_scope6["rayStart"], "x", JS.get_property(JS.get_property(_scope6["aimerPositions"], (JS.number(JS.get_property(_scope6["aimerPositions"], "length")) - JS.number(1))), "x"))
			JS.set_property(_scope6["rayStart"], "y", JS.get_property(JS.get_property(_scope6["aimerPositions"], (JS.number(JS.get_property(_scope6["aimerPositions"], "length")) - JS.number(1))), "y"))
			JS.invoke_method(JS.module("UIAimerGraphics"), "_multiplyAdd", [_scope6["rayStart"], _scope6["rayDir"], _scope6["remainingLength"], _scope6["rayEnd"]])
			_scope6["result"] = JS.invoke_method(self, "_castRay", [_scope6["rayStart"], _scope6["rayEnd"]])
			if JS.truthy(JS.get_property(_scope6["result"], "hasHit")):
				JS.invoke_method(_scope6["aimerPositions"], "push", [JS.get_property(_scope6["result"], "hitPoint")])
				if JS.truthy(JS.logical("||", func():
					var _scope9: Dictionary = {}
					return JS.get_property(_scope6["result"], "hasHitTank")
					return null, func():
					var _scope10: Dictionary = {}
					return JS.get_property(_scope6["result"], "hasHitSpawn")
					return null)):
					break
				else:
					JS.set_property(_scope6, "remainingLength", (JS.number(_scope6["remainingLength"]) - JS.number(JS.invoke_method("@Math", "max", [JS.get_property(JS.module("UIConstants"), "AIMER_MIN_STEP_LENGTH"), JS.get_property(_scope6["result"], "hitDistance")]))))
					JS.invoke_method(JS.module("UIAimerGraphics"), "_multiplyAdd", [_scope6["rayDir"], JS.get_property(_scope6["result"], "hitNormal"), (JS.number(-(2)) * JS.number(JS.invoke_method(_scope6["rayDir"], "dot", [JS.get_property(_scope6["result"], "hitNormal")]))), _scope6["rayDir"]])
					JS.invoke_method(_scope6["rayDir"], "normalize", [])
			else:
				JS.invoke_method(_scope6["aimerPositions"], "push", [_scope6["rayEnd"]])
				break
	JS.invoke_method(self, "clear", [])
	JS.invoke_method(self, "lineStyle", [JS.get_property(JS.module("UIConstants"), "AIMER_WIDTH"), JS.get_property(self, "colour"), 1])
	_scope6["beamPosition"] = JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [0, 0])
	_scope6["beamOn"] = JS.compare(">", JS.invoke_method("@Math", "random", []), 0.5)
	_scope6["segmentSample"] = 0
	if JS.truthy(JS.compare(">=", JS.get_property(_scope6["aimerPositions"], "length"), 2)):
		_scope6["minSegmentLength"] = JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "AIMER_MIN_SEGMENT_LENGTH")])
		_scope6["maxOffSegmentLength"] = JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "AIMER_OFF_MAX_SEGMENT_LENGTH")])
		_scope6["maxOnSegmentLength"] = JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "AIMER_ON_MAX_SEGMENT_LENGTH")])
		JS.invoke_method(self, "moveTo", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(JS.get_property(_scope6["aimerPositions"], 0), "x")]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(JS.get_property(_scope6["aimerPositions"], 0), "y")])])
		_scope6["i"] = 1
		while JS.truthy(JS.compare("<", _scope6["i"], JS.get_property(_scope6["aimerPositions"], "length"))):
			_scope6["segmentStart"] = JS.get_property(_scope6["aimerPositions"], (JS.number(_scope6["i"]) - JS.number(1)))
			_scope6["segmentEnd"] = JS.get_property(_scope6["aimerPositions"], _scope6["i"])
			_scope6["segmentDir"] = JS.invoke_method(JS.get_property(JS.module("Phaser"), "Point"), "subtract", [_scope6["segmentEnd"], _scope6["segmentStart"]])
			_scope6["segmentLength"] = JS.invoke_method(_scope6["segmentDir"], "getMagnitude", [])
			JS.invoke_method(_scope6["segmentDir"], "normalize", [])
			while JS.truthy(JS.compare("<", _scope6["segmentSample"], _scope6["segmentLength"])):
				JS.invoke_method(JS.module("UIAimerGraphics"), "_multiplyAdd", [_scope6["segmentStart"], _scope6["segmentDir"], _scope6["segmentSample"], _scope6["beamPosition"]])
				if JS.truthy(_scope6["beamOn"]):
					JS.invoke_method(self, "lineTo", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope6["beamPosition"], "x")]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope6["beamPosition"], "y")])])
					JS.set_property(_scope6, "segmentSample", JS.add(_scope6["segmentSample"], JS.add(_scope6["minSegmentLength"], (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(_scope6["maxOffSegmentLength"]) - JS.number(_scope6["minSegmentLength"])))))))
				else:
					JS.invoke_method(self, "moveTo", [JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope6["beamPosition"], "x")]), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.get_property(_scope6["beamPosition"], "y")])])
					JS.set_property(_scope6, "segmentSample", JS.add(_scope6["segmentSample"], JS.add(_scope6["minSegmentLength"], (JS.number(JS.invoke_method("@Math", "random", [])) * JS.number((JS.number(_scope6["maxOnSegmentLength"]) - JS.number(_scope6["minSegmentLength"])))))))
				JS.set_property(_scope6, "beamOn", (not JS.truthy(_scope6["beamOn"])))
			JS.set_property(_scope6, "segmentSample", (JS.number(_scope6["segmentSample"]) - JS.number(_scope6["segmentLength"])))
			JS.increment(_scope6, "i", 1, false)
	return null

func original_getPlayerId():
	var _scope11: Dictionary = {}
	return JS.get_property(self, "playerId")
	return null

func original_activate():
	var _scope12: Dictionary = {}
	JS.set_property(self, "activated", true)
	return null

func original_weaken():
	var _scope13: Dictionary = {}
	return null

func original_strengthen():
	var _scope14: Dictionary = {}
	return null

func original_remove():
	var _scope15: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null

func original_retire():
	var _scope16: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null

static func original__multiplyAdd(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null):
	var _scope17: Dictionary = {"a": _arg0, "b": _arg1, "s": _arg2, "out": _arg3}
	if JS.truthy(JS.equal(_scope17["out"], null, true)):
		JS.set_property(_scope17, "out", JS.construct(JS.get_property(JS.module("Phaser"), "Point"), []))
	return JS.invoke_method(_scope17["out"], "setTo", [JS.add(JS.get_property(_scope17["a"], "x"), (JS.number(JS.get_property(_scope17["b"], "x")) * JS.number(_scope17["s"]))), JS.add(JS.get_property(_scope17["a"], "y"), (JS.number(JS.get_property(_scope17["b"], "y")) * JS.number(_scope17["s"])))])
	return null
