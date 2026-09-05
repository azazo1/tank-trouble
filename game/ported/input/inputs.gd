# 由原版 Inputs 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_Inputs: Dictionary = {}
static var _initialized_Inputs = false
static func initialize_original_static():
	if _initialized_Inputs: return
	_initialized_Inputs = true
	_static_Inputs["inputManagers"] = []
	_static_Inputs["INPUT_TYPES"] = {"KEYBOARD": "keyboard", "MOUSE": "mouse", "TOUCH": "touch"}
	_static_Inputs["_inputSets"] = {"WASDKeys": {"type": "keyboard", "data": {"forwardKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "W"), "backKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "S"), "leftKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "A"), "rightKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "D"), "fireKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "Q")}}, "arrowKeys": {"type": "keyboard", "data": {"forwardKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "UP"), "backKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "DOWN"), "leftKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "LEFT"), "rightKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "RIGHT"), "fireKey": JS.get_property(JS.get_property(JS.module("Phaser"), "Keyboard"), "SPACEBAR")}}, "mouse": {"type": "mouse", "data": null}}
	_static_Inputs["_unassignedPlayerIds"] = []
	_static_Inputs["_inputSetsInUse"] = {}
	_static_Inputs["_playerIdInputSetId"] = {}
static func original_static_get(key):
	initialize_original_static()
	if _static_Inputs.has(key): return _static_Inputs[key]
	return null
static func original_static_set(key, value):
	_static_Inputs[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/input/inputs.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15, _arg16, _arg17, _arg18, _arg19, _arg20, _arg21, _arg22, _arg23])
	return instance

static func original_getAvailableInputSetId():
	var _scope0: Dictionary = {"inputSetIds": null, "i": null}
	_scope0["inputSetIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(JS.module("Inputs"), "_inputSets")])
	_scope0["i"] = 0
	while JS.truthy(JS.compare("<", _scope0["i"], JS.get_property(_scope0["inputSetIds"], "length"))):
		if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.module("Inputs"), "_inputSetsInUse"), JS.get_property(_scope0["inputSetIds"], _scope0["i"])), null, false)):
			return JS.get_property(_scope0["inputSetIds"], _scope0["i"])
		JS.increment(_scope0, "i", 1, false)
	return null
	return null

static func original_getAllInputSetIds():
	var _scope1: Dictionary = {"inputSetIds": null}
	_scope1["inputSetIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(JS.module("Inputs"), "_inputSets")])
	return _scope1["inputSetIds"]
	return null

static func original_getUnavailableInputSetIds():
	var _scope2: Dictionary = {"unavilableInputSetIds": null, "inputSetIds": null, "i": null}
	_scope2["unavilableInputSetIds"] = []
	_scope2["inputSetIds"] = JS.invoke_method("@Object", "keys", [JS.get_property(JS.module("Inputs"), "_inputSets")])
	_scope2["i"] = 0
	while JS.truthy(JS.compare("<", _scope2["i"], JS.get_property(_scope2["inputSetIds"], "length"))):
		if JS.truthy(not JS.equal(JS.get_property(JS.get_property(JS.module("Inputs"), "_inputSetsInUse"), JS.get_property(_scope2["inputSetIds"], _scope2["i"])), null, true)):
			JS.invoke_method(_scope2["unavilableInputSetIds"], "push", [JS.get_property(_scope2["inputSetIds"], _scope2["i"])])
		JS.increment(_scope2, "i", 1, false)
	return _scope2["unavilableInputSetIds"]
	return null

static func original_getAssignedInputSetId(_arg0 = null):
	var _scope3: Dictionary = {"playerId": _arg0}
	return JS.get_property(JS.get_property(JS.module("Inputs"), "_playerIdInputSetId"), _scope3["playerId"])
	return null

static func original_getInputSetType(_arg0 = null):
	var _scope4: Dictionary = {"inputSetId": _arg0}
	return JS.get_property(JS.get_property(JS.get_property(JS.module("Inputs"), "_inputSets"), _scope4["inputSetId"]), "type")
	return null

static func original_getFireKey(_arg0 = null):
	var _scope5: Dictionary = {"inputSetId": _arg0}
	if JS.truthy(JS.equal(JS.get_property(JS.get_property(JS.get_property(JS.module("Inputs"), "_inputSets"), _scope5["inputSetId"]), "type"), "keyboard", false)):
		return JS.get_property(JS.get_property(JS.get_property(JS.get_property(JS.module("Inputs"), "_inputSets"), _scope5["inputSetId"]), "data"), "fireKey")
	return null
	return null

static func original_addInputManager(_arg0 = null, _arg1 = null):
	var _scope6: Dictionary = {"playerId": _arg0, "inputSetId": _arg1}
	JS.invoke_method(JS.module("Inputs"), "_releaseInput", [_scope6["playerId"]])
	JS.invoke_method(JS.module("Inputs"), "_assignInput", [_scope6["playerId"], _scope6["inputSetId"]])
	JS.invoke_method(JS.module("Inputs"), "_storeInputSetAssignments", [])
	return null

static func original_removeInputManager(_arg0 = null):
	var _scope7: Dictionary = {"playerId": _arg0}
	JS.invoke_method(JS.module("Inputs"), "_releaseInput", [_scope7["playerId"]])
	JS.invoke_method(JS.module("Inputs"), "_storeInputSetAssignments", [])
	return null

static func original_reassignInputManager(_arg0 = null, _arg1 = null):
	var _scope8: Dictionary = {"oldPlayerId": _arg0, "newPlayerId": _arg1, "inputSetId": null}
	_scope8["inputSetId"] = JS.get_property(JS.get_property(JS.module("Inputs"), "_playerIdInputSetId"), _scope8["oldPlayerId"])
	JS.invoke_method(JS.module("Inputs"), "_releaseInput", [_scope8["oldPlayerId"]])
	JS.invoke_method(JS.module("Inputs"), "_assignInput", [_scope8["newPlayerId"], _scope8["inputSetId"]])
	JS.invoke_method(JS.module("Inputs"), "_storeInputSetAssignments", [])
	return null

static func original_update():
	var _scope9: Dictionary = {"i": null}
	_scope9["i"] = 0
	while JS.truthy(JS.compare("<", _scope9["i"], JS.get_property(JS.get_property(JS.module("Inputs"), "inputManagers"), "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(JS.module("Inputs"), "inputManagers"), _scope9["i"]), "update", [])
		JS.increment(_scope9, "i", 1, false)
	return null

static func original_reset():
	var _scope10: Dictionary = {"i": null}
	_scope10["i"] = 0
	while JS.truthy(JS.compare("<", _scope10["i"], JS.get_property(JS.get_property(JS.module("Inputs"), "inputManagers"), "length"))):
		JS.invoke_method(JS.get_property(JS.get_property(JS.module("Inputs"), "inputManagers"), _scope10["i"]), "reset", [])
		JS.increment(_scope10, "i", 1, false)
	return null

static func original__assignInput(_arg0 = null, _arg1 = null):
	var _scope11: Dictionary = {"playerId": _arg0, "inputSetId": _arg1, "inputSet": null}
	_scope11["inputSet"] = JS.get_property(JS.get_property(JS.module("Inputs"), "_inputSets"), _scope11["inputSetId"])
	var _switch0 = JS.get_property(_scope11["inputSet"], "type")
	var _switch0_start = -1
	if JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Inputs"), "INPUT_TYPES"), "KEYBOARD"), true): _switch0_start = 0
	elif JS.equal(_switch0, JS.get_property(JS.get_property(JS.module("Inputs"), "INPUT_TYPES"), "MOUSE"), true): _switch0_start = 1
	while true:
		if _switch0_start >= 0 and _switch0_start <= 0:
			JS.invoke_method(JS.get_property(JS.module("Inputs"), "inputManagers"), "push", [JS.invoke_method(JS.module("KeyboardInputManager"), "create", [_scope11["playerId"], JS.get_property(_scope11["inputSet"], "data")])])
			break
		if _switch0_start >= 0 and _switch0_start <= 1:
			JS.invoke_method(JS.get_property(JS.module("Inputs"), "inputManagers"), "push", [JS.invoke_method(JS.module("MouseInputManager"), "create", [_scope11["playerId"]])])
			break
		break
	JS.set_property(JS.get_property(JS.module("Inputs"), "_inputSetsInUse"), _scope11["inputSetId"], true)
	JS.set_property(JS.get_property(JS.module("Inputs"), "_playerIdInputSetId"), _scope11["playerId"], _scope11["inputSetId"])
	return null

static func original__releaseInput(_arg0 = null):
	var _scope12: Dictionary = {"playerId": _arg0, "i": null, "inputManager": null}
	_scope12["i"] = 0
	while JS.truthy(JS.compare("<", _scope12["i"], JS.get_property(JS.get_property(JS.module("Inputs"), "inputManagers"), "length"))):
		_scope12["inputManager"] = JS.get_property(JS.get_property(JS.module("Inputs"), "inputManagers"), _scope12["i"])
		if JS.truthy(JS.equal(JS.invoke_method(_scope12["inputManager"], "getPlayerId", []), _scope12["playerId"], false)):
			JS.invoke_method(JS.get_property(JS.module("Inputs"), "inputManagers"), "splice", [_scope12["i"], 1])
			break
		JS.increment(_scope12, "i", 1, false)
	JS.delete_property(JS.get_property(JS.module("Inputs"), "_inputSetsInUse"), JS.get_property(JS.get_property(JS.module("Inputs"), "_playerIdInputSetId"), _scope12["playerId"]))
	JS.delete_property(JS.get_property(JS.module("Inputs"), "_playerIdInputSetId"), _scope12["playerId"])
	return null

static func original__storeInputSetAssignments():
	var _scope13: Dictionary = {}
	return null
