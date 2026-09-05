# 由原版 MouseInputManager 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/ported/input/inputmanager.gd"

var mouseX = 0
var mouseY = 0
var storedStates = {}
static var _static_MouseInputManager: Dictionary = {}
static var _initialized_MouseInputManager = false
static func initialize_original_static():
	if _initialized_MouseInputManager: return
	_initialized_MouseInputManager = true
	_static_MouseInputManager["mouseMoveListenerAdded"] = false
	_static_MouseInputManager["mousePageX"] = 0
	_static_MouseInputManager["mousePageY"] = 0
	_static_MouseInputManager["mouseActivated"] = false
	_static_MouseInputManager["mouseDown"] = false
static func original_static_get(key):
	initialize_original_static()
	if _static_MouseInputManager.has(key): return _static_MouseInputManager[key]
	return JS.get_property(JS.module("InputManager"), key)
static func original_static_set(key, value):
	_static_MouseInputManager[key] = value
	return value
func original_own_fields():
	return ["mouseX","mouseY","storedStates"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"playerId": _arg0}
	super._construct_create(_scope0["playerId"])
	JS.invoke_method(self, "reset", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/input/mouseinputmanager.gd").new()
	instance._construct_create(_arg0)
	return instance

func original_update():
	var _scope1: Dictionary = {"game": null, "forwardState": null, "backState": null, "leftState": null, "rightState": null, "fireState": null, "gameBounds": null, "gameScale": null, "tankSprite": null, "relativeToTank": null, "magnitude": null, "angle": null, "canReverse": null, "goInReverse": null, "stateChanged": null, "gameController": null, "inputState": null}
	super.original_update()
	_scope1["game"] = JS.invoke_method(JS.module("GameManager"), "getGame", [])
	if JS.truthy(_scope1["game"]):
		_scope1["forwardState"] = false
		_scope1["backState"] = false
		_scope1["leftState"] = false
		_scope1["rightState"] = false
		_scope1["fireState"] = false
		_scope1["gameBounds"] = JS.get_property(JS.get_property(_scope1["game"], "scale"), "bounds")
		_scope1["gameScale"] = JS.get_property(JS.get_property(_scope1["game"], "scale"), "scaleFactor")
		JS.set_property(self, "mouseX", (JS.number((JS.number(JS.get_property(JS.module("MouseInputManager"), "mousePageX")) - JS.number(JS.get_property(_scope1["gameBounds"], "x")))) * JS.number(JS.get_property(_scope1["gameScale"], "x"))))
		JS.set_property(self, "mouseY", (JS.number((JS.number(JS.get_property(JS.module("MouseInputManager"), "mousePageY")) - JS.number(JS.get_property(_scope1["gameBounds"], "y")))) * JS.number(JS.get_property(_scope1["gameScale"], "y"))))
		if JS.truthy(JS.logical("&&", func():
			var _scope2: Dictionary = {}
			return JS.get_property(JS.get_property(_scope1["game"], "input"), "enabled")
			return null, func():
			var _scope3: Dictionary = {}
			return JS.get_property(JS.module("MouseInputManager"), "mouseActivated")
			return null)):
			if JS.truthy(JS.get_property(JS.invoke_method(JS.get_property(_scope1["game"], "state"), "getCurrentState", []), "getTankSprite")):
				_scope1["tankSprite"] = JS.invoke_method(JS.invoke_method(JS.get_property(_scope1["game"], "state"), "getCurrentState", []), "getTankSprite", [JS.get_property(self, "playerId")])
				if JS.truthy(_scope1["tankSprite"]):
					_scope1["relativeToTank"] = JS.invoke_method(_scope1["tankSprite"], "toLocal", [JS.construct(JS.get_property(JS.module("Phaser"), "Point"), [JS.get_property(self, "mouseX"), JS.get_property(self, "mouseY")])])
					_scope1["magnitude"] = JS.invoke_method(_scope1["relativeToTank"], "getMagnitude", [])
					_scope1["angle"] = JS.invoke_method(JS.get_property(JS.module("Phaser"), "Math"), "angleBetween", [0, 0, JS.get_property(_scope1["relativeToTank"], "x"), JS.get_property(_scope1["relativeToTank"], "y")])
					_scope1["canReverse"] = JS.compare("<", _scope1["magnitude"], (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MOUSE_INPUT"), "MAX_REVERSE_DISTANCE")) / JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"))))
					_scope1["goInReverse"] = false
					if JS.truthy(JS.logical("||", func():
						var _scope4: Dictionary = {}
						return JS.compare(">", _scope1["angle"], JS.add((JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5)), JS.get_property(JS.get_property(JS.module("UIConstants"), "MOUSE_INPUT"), "ROTATION_DEAD_ANGLE")))
						return null, func():
						var _scope5: Dictionary = {}
						return JS.compare("<", _scope1["angle"], (JS.number((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5))) - JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MOUSE_INPUT"), "ROTATION_DEAD_ANGLE"))))
						return null)):
						if JS.truthy(JS.logical("&&", func():
							var _scope6: Dictionary = {}
							return JS.compare(">", _scope1["angle"], 0)
							return null, func():
							var _scope7: Dictionary = {}
							return _scope1["canReverse"]
							return null)):
							JS.set_property(_scope1, "rightState", true)
							JS.set_property(_scope1, "goInReverse", true)
						else:
							JS.set_property(_scope1, "leftState", true)
					else:
						if JS.truthy(JS.logical("&&", func():
							var _scope8: Dictionary = {}
							return JS.compare(">", _scope1["angle"], JS.add((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5)), JS.get_property(JS.get_property(JS.module("UIConstants"), "MOUSE_INPUT"), "ROTATION_DEAD_ANGLE")))
							return null, func():
							var _scope9: Dictionary = {}
							return JS.compare("<", _scope1["angle"], (JS.number((JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5))) - JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MOUSE_INPUT"), "ROTATION_DEAD_ANGLE"))))
							return null)):
							if JS.truthy(JS.logical("&&", func():
								var _scope10: Dictionary = {}
								return JS.compare(">", _scope1["angle"], 0)
								return null, func():
								var _scope11: Dictionary = {}
								return _scope1["canReverse"]
								return null)):
								JS.set_property(_scope1, "leftState", true)
								JS.set_property(_scope1, "goInReverse", true)
							else:
								JS.set_property(_scope1, "rightState", true)
						else:
							if JS.truthy(JS.compare(">", _scope1["angle"], 0)):
								if JS.truthy(_scope1["canReverse"]):
									JS.set_property(_scope1, "goInReverse", true)
								else:
									if JS.truthy(JS.compare(">", _scope1["angle"], (JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5)))):
										JS.set_property(_scope1, "leftState", true)
									else:
										JS.set_property(_scope1, "rightState", true)
					if JS.truthy(JS.compare(">", _scope1["magnitude"], (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MOUSE_INPUT"), "POSITION_DEAD_DISTANCE")) / JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"))))):
						if JS.truthy(_scope1["canReverse"]):
							JS.set_property(_scope1, "forwardState", (not JS.truthy(_scope1["goInReverse"])))
							JS.set_property(_scope1, "backState", _scope1["goInReverse"])
						else:
							if JS.truthy(JS.logical("&&", func():
								var _scope12: Dictionary = {}
								return JS.compare(">", _scope1["angle"], (JS.number((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5))) - JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MOUSE_INPUT"), "POSITION_DEAD_ANGLE"))))
								return null, func():
								var _scope13: Dictionary = {}
								return JS.compare("<", _scope1["angle"], JS.add((JS.number(-(JS.get_property("@Math", "PI"))) * JS.number(0.5)), JS.get_property(JS.get_property(JS.module("UIConstants"), "MOUSE_INPUT"), "POSITION_DEAD_ANGLE")))
								return null)):
								JS.set_property(_scope1, "forwardState", true)
			JS.set_property(_scope1, "fireState", JS.logical("||", func():
				var _scope14: Dictionary = {}
				return JS.get_property(JS.module("MouseInputManager"), "mouseDown")
				return null, func():
				var _scope15: Dictionary = {}
				return JS.get_property(JS.get_property(JS.get_property(JS.get_property(_scope1["game"], "input"), "mousePointer"), "leftButton"), "isDown")
				return null))
		_scope1["stateChanged"] = false
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "forward"), _scope1["forwardState"], true)))
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "back"), _scope1["backState"], true)))
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "left"), _scope1["leftState"], true)))
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "right"), _scope1["rightState"], true)))
		JS.set_property(_scope1, "stateChanged", JS.bitwise("|", _scope1["stateChanged"], not JS.equal(JS.get_property(JS.get_property(self, "storedStates"), "fire"), _scope1["fireState"], true)))
		_scope1["gameController"] = JS.invoke_method(JS.module("GameManager"), "getGameController", [])
		if JS.truthy(JS.logical("&&", func():
			var _scope16: Dictionary = {}
			return _scope1["stateChanged"]
			return null, func():
			var _scope17: Dictionary = {}
			return _scope1["gameController"]
			return null)):
			_scope1["inputState"] = JS.invoke_method(JS.module("InputState"), "withState", [JS.get_property(self, "playerId"), _scope1["forwardState"], _scope1["backState"], _scope1["leftState"], _scope1["rightState"], _scope1["fireState"]])
			JS.invoke_method(_scope1["gameController"], "setInputState", [_scope1["inputState"]])
		JS.set_property(JS.get_property(self, "storedStates"), "forward", _scope1["forwardState"])
		JS.set_property(JS.get_property(self, "storedStates"), "back", _scope1["backState"])
		JS.set_property(JS.get_property(self, "storedStates"), "left", _scope1["leftState"])
		JS.set_property(JS.get_property(self, "storedStates"), "right", _scope1["rightState"])
		JS.set_property(JS.get_property(self, "storedStates"), "fire", _scope1["fireState"])
	return null

func original_reset():
	var _scope18: Dictionary = {}
	JS.set_property(JS.module("MouseInputManager"), "mouseActivated", false)
	JS.set_property(JS.get_property(self, "storedStates"), "forward", false)
	JS.set_property(JS.get_property(self, "storedStates"), "back", false)
	JS.set_property(JS.get_property(self, "storedStates"), "left", false)
	JS.set_property(JS.get_property(self, "storedStates"), "right", false)
	JS.set_property(JS.get_property(self, "storedStates"), "fire", false)
	return null
