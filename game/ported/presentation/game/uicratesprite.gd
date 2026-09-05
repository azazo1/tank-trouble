# 由原版 UICrateSprite 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UICrateSprite: Dictionary = {}
static var _initialized_UICrateSprite = false
static func initialize_original_static():
	if _initialized_UICrateSprite: return
	_initialized_UICrateSprite = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UICrateSprite.has(key): return _static_UICrateSprite[key]
	return JS.get_property(JS.module("Phaser.Sprite"), key)
static func original_static_set(key, value):
	_static_UICrateSprite[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1, "dustEmitter": _arg2}
	super._construct_create(_scope0["game"], 0, 0, "game", "crate0-0")
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.set_property(self, "dustEmitter", _scope0["dustEmitter"])
	JS.invoke_method(JS.get_property(JS.get_property(JS.get_property(self, "game"), "physics"), "p2"), "enable", [self])
	JS.set_property(JS.get_property(self, "body"), "allowSleep", false)
	JS.set_property(JS.get_property(self, "body"), "kinematic", true)
	JS.invoke_method(JS.get_property(self, "body"), "setRectangle", [JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "CRATE"), "WIDTH"), "px"), JS.get_property(JS.get_property(JS.get_property(JS.module("Constants"), "CRATE"), "HEIGHT"), "px")])
	JS.invoke_method(JS.get_property(self, "body"), "setCollisionGroup", [JS.get_property(JS.module("UIUtils"), "crateCollisionGroup")])
	JS.invoke_method(JS.get_property(self, "body"), "collides", [[JS.get_property(JS.module("UIUtils"), "fragmentCollisionGroup"), JS.get_property(JS.module("UIUtils"), "crateCollisionGroup")]])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.set_property(self, "theme", 0)
	JS.set_property(self, "contentFrame", 0)
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uicratesprite.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_setTheme(_arg0 = null):
	var _scope1: Dictionary = {"theme": _arg0}
	JS.set_property(self, "theme", _scope1["theme"])
	JS.set_property(self, "frameName", JS.add(JS.add(JS.add("crate", JS.get_property(self, "theme")), "-"), JS.get_property(self, "contentFrame")))
	return null

func original_update():
	var _scope2: Dictionary = {"crate": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	_scope2["crate"] = JS.invoke_method(JS.get_property(self, "gameController"), "getCollectible", [JS.get_property(self, "crateId")])
	if JS.truthy(_scope2["crate"]):
		JS.set_property(self, "smoothedX", (JS.number(JS.add(JS.get_property(JS.get_property(self, "body"), "x"), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope2["crate"], "getX", [])]))) / JS.number(2)))
		JS.set_property(self, "smoothedY", (JS.number(JS.add(JS.get_property(JS.get_property(self, "body"), "y"), JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope2["crate"], "getY", [])]))) / JS.number(2)))
		JS.set_property(self, "smoothedRotation", (JS.number(JS.add(JS.get_property(JS.get_property(self, "body"), "rotation"), JS.invoke_method(_scope2["crate"], "getRotation", []))) / JS.number(2)))
	JS.set_property(JS.get_property(self, "body"), "x", JS.get_property(self, "smoothedX"))
	JS.set_property(JS.get_property(self, "body"), "y", JS.get_property(self, "smoothedY"))
	JS.set_property(JS.get_property(self, "body"), "rotation", JS.get_property(self, "smoothedRotation"))
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null):
	var _scope3: Dictionary = {"x": _arg0, "y": _arg1, "rotation": _arg2, "contentFrame": _arg3, "crateId": _arg4, "animate": _arg5}
	JS.set_property(self, "contentFrame", _scope3["contentFrame"])
	JS.invoke_method(self, "reset", [_scope3["x"], _scope3["y"]])
	JS.set_property(self, "frameName", JS.add(JS.add(JS.add("crate", JS.get_property(self, "theme")), "-"), JS.get_property(self, "contentFrame")))
	JS.set_property(JS.get_property(self, "body"), "rotation", _scope3["rotation"])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.set_property(self, "smoothedX", _scope3["x"])
	JS.set_property(self, "smoothedY", _scope3["y"])
	JS.set_property(self, "smoothedRotation", _scope3["rotation"])
	if JS.truthy(_scope3["animate"]):
		JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "sound"), "play", ["crateSpawn"])
		JS.invoke_method(JS.get_property(self, "scale"), "setTo", [0.01, 0.01])
		JS.set_property(self, "spawnTween", JS.invoke_method(JS.invoke_method(JS.get_property(JS.get_property(self, "game"), "add"), "tween", [JS.get_property(self, "scale")]), "to", [{"x": JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), "y": JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")}, JS.get_property(JS.module("UIConstants"), "CRATE_SPAWN_TIME"), JS.invoke_method(JS.module("UIUtils"), "easingCubicBezier", [0.01, 1.5, 1.5, 1]), true]))
		JS.invoke_method(JS.get_property(JS.get_property(self, "spawnTween"), "onComplete"), "add", [func():
			var _scope4: Dictionary = {}
			JS.invoke_method(JS.get_property(JS.get_property(JS.callback_receiver(self), "game"), "sound"), "play", ["crateLand"])
			JS.invoke_method(JS.get_property(JS.callback_receiver(self), "dustEmitter"), "spawn", [JS.get_property(JS.callback_receiver(self), "x"), JS.get_property(JS.callback_receiver(self), "y")])
			return null, self])
	JS.set_property(self, "crateId", _scope3["crateId"])
	return null

func original_getExtraPositionInfo():
	var _scope5: Dictionary = {}
	return null
	return null

func original_remove():
	var _scope6: Dictionary = {}
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
	JS.invoke_method(self, "kill", [])
	return null

func original_retire():
	var _scope7: Dictionary = {}
	if JS.truthy(JS.get_property(self, "spawnTween")):
		JS.invoke_method(JS.get_property(self, "spawnTween"), "stop", [])
	JS.invoke_method(self, "kill", [])
	return null
