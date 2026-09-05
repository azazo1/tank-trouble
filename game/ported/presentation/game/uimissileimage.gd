# 由原版 UIMissileImage 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/presentation/bridge/image.gd"

static var _static_UIMissileImage: Dictionary = {}
static var _initialized_UIMissileImage = false
static func initialize_original_static():
	if _initialized_UIMissileImage: return
	_initialized_UIMissileImage = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_UIMissileImage.has(key): return _static_UIMissileImage[key]
	return JS.get_property(JS.module("Phaser.Image"), key)
static func original_static_set(key, value):
	_static_UIMissileImage[key] = value
	return value
func original_own_fields():
	return []

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"game": _arg0, "gameController": _arg1, "targetingSounds": _arg2}
	super._construct_create(_scope0["game"], 0, 0, "game", "")
	JS.set_property(self, "gameController", _scope0["gameController"])
	JS.set_property(self, "targetingSounds", _scope0["targetingSounds"])
	JS.set_property(self, "targetId", null)
	JS.set_property(self, "targetTime", 0)
	JS.invoke_method(JS.get_property(self, "anchor"), "setTo", [0.5, 0.5])
	JS.invoke_method(JS.get_property(self, "scale"), "setTo", [JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE"), JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")])
	JS.invoke_method(self, "kill", [])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/presentation/game/uimissileimage.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_update():
	var _scope1: Dictionary = {"projectile": null, "tank": null, "maze": null, "projectilePosition": null, "tankPosition": null, "distanceToTarget": null}
	if JS.truthy((not JS.truthy(JS.get_property(self, "exists")))):
		return null
	super.original_update()
	JS.invoke_method(JS.get_property(self, "smokeEmitter"), "update", [])
	if JS.truthy(not JS.equal(JS.get_property(self, "targetId"), null, true)):
		_scope1["projectile"] = JS.invoke_method(JS.get_property(self, "gameController"), "getProjectile", [JS.get_property(self, "projectileId")])
		_scope1["tank"] = JS.invoke_method(JS.get_property(self, "gameController"), "getTank", [JS.get_property(self, "targetId")])
		_scope1["maze"] = JS.invoke_method(JS.get_property(self, "gameController"), "getMaze", [])
		if JS.truthy(JS.logical("&&", func():
			var _scope2: Dictionary = {}
			return JS.logical("&&", func():
				var _scope3: Dictionary = {}
				return _scope1["projectile"]
				return null, func():
				var _scope4: Dictionary = {}
				return _scope1["tank"]
				return null)
			return null, func():
			var _scope5: Dictionary = {}
			return _scope1["maze"]
			return null)):
			JS.set_property(self, "targetTime", JS.add(JS.get_property(self, "targetTime"), (JS.number(JS.get_property(JS.get_property(JS.get_property(self, "game"), "time"), "delta")) / JS.number(1000))))
			_scope1["projectilePosition"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope1["projectile"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope1["projectile"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
			_scope1["tankPosition"] = {"x": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope1["tank"], "getX", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))]), "y": JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method(_scope1["tank"], "getY", [])) / JS.number(JS.get_property(JS.get_property(JS.module("Constants"), "MAZE_TILE_SIZE"), "m")))])}
			_scope1["distanceToTarget"] = JS.invoke_method(_scope1["maze"], "getDistanceBetweenPositions", [_scope1["projectilePosition"], _scope1["tankPosition"]])
			if JS.truthy(not JS.equal(_scope1["distanceToTarget"], false, true)):
				if JS.truthy(JS.compare(">", JS.get_property(self, "targetTime"), (JS.number(JS.add(_scope1["distanceToTarget"], 1)) * JS.number(JS.get_property(JS.module("UIConstants"), "MISSILE_TARGETING_SOUND_INTERVAL_PER_TILE"))))):
					JS.set_property(self, "targetTime", 0)
					JS.invoke_method(JS.get_property(JS.get_property(self, "targetingSounds"), JS.invoke_method("@Math", "floor", [(JS.number(JS.invoke_method("@Math", "random", [])) * JS.number(JS.get_property(JS.module("UIConstants"), "MISSILE_TARGETING_AUDIO_COUNT")))])), "play", [])
	_scope1["projectile"] = JS.invoke_method(JS.get_property(self, "gameController"), "getProjectile", [JS.get_property(self, "projectileId")])
	if JS.truthy(_scope1["projectile"]):
		JS.set_property(self, "x", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["projectile"], "getX", [])]))
		JS.set_property(self, "y", JS.invoke_method(JS.module("UIUtils"), "mpx", [JS.invoke_method(_scope1["projectile"], "getY", [])]))
		JS.set_property(self, "rotation", JS.add(JS.invoke_method("@Math", "atan2", [JS.invoke_method(_scope1["projectile"], "getSpeedY", []), JS.invoke_method(_scope1["projectile"], "getSpeedX", [])]), (JS.number(JS.get_property("@Math", "PI")) * JS.number(0.5))))
	return null

func original_setSmokeEmitter(_arg0 = null):
	var _scope6: Dictionary = {"smokeEmitter": _arg0}
	JS.set_property(self, "smokeEmitter", _scope6["smokeEmitter"])
	return null

func original_updateTarget(_arg0 = null):
	var _scope7: Dictionary = {"playerId": _arg0, "self": null}
	JS.set_property(self, "targetId", _scope7["playerId"])
	JS.set_property(self, "targetTime", 0)
	if JS.truthy(not JS.equal(_scope7["playerId"], null, true)):
		_scope7["self"] = self
		JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
			var _scope8: Dictionary = {"result": _arg0}
			if JS.truthy(JS.equal(JS.type_of(_scope8["result"]), "object", false)):
				JS.invoke_method(JS.get_property(_scope7["self"], "smokeEmitter"), "setSmokeColour", [JS.get_property(JS.invoke_method(_scope8["result"], "getBaseColour", []), "numericValue")])
			else:
				JS.invoke_method(JS.get_property(_scope7["self"], "smokeEmitter"), "setSmokeColour", [JS.get_property(JS.module("UIConstants"), "MISSILE_SMOKE_COLOUR")])
			return null, func(_arg0 = null):
			var _scope9: Dictionary = {"result": _arg0}
			return null, func(_arg0 = null):
			var _scope10: Dictionary = {"result": _arg0}
			return null, _scope7["playerId"], JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
	else:
		JS.invoke_method(JS.get_property(self, "smokeEmitter"), "setSmokeColour", [JS.get_property(JS.module("UIConstants"), "MISSILE_SMOKE_COLOUR")])
	return null

func original_spawn(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _scope11: Dictionary = {"x": _arg0, "y": _arg1, "projectileId": _arg2, "playerId": _arg3, "frameName": _arg4, "self": null}
	JS.set_property(self, "frameName", _scope11["frameName"])
	JS.invoke_method(self, "reset", [_scope11["x"], _scope11["y"]])
	JS.set_property(self, "projectileId", _scope11["projectileId"])
	JS.set_property(self, "playerId", _scope11["playerId"])
	JS.set_property(self, "targetId", null)
	JS.set_property(self, "targetTime", 0)
	_scope11["self"] = self
	JS.invoke_method(JS.invoke_method(JS.module("Backend"), "getInstance", []), "getPlayerDetails", [func(_arg0 = null):
		var _scope12: Dictionary = {"result": _arg0}
		if JS.truthy(JS.equal(JS.type_of(_scope12["result"]), "object", false)):
			JS.set_property(_scope11["self"], "tint", JS.get_property(JS.invoke_method(_scope12["result"], "getTurretColour", []), "numericValue"))
		else:
			JS.set_property(_scope11["self"], "tint", JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_UNAVAILABLE_COLOUR"), "numericValue"))
		return null, func(_arg0 = null):
		var _scope13: Dictionary = {"result": _arg0}
		return null, func(_arg0 = null):
		var _scope14: Dictionary = {"result": _arg0}
		return null, JS.get_property(self, "playerId"), JS.invoke_method(JS.module("Caches"), "getPlayerDetailsCache", [])])
	JS.invoke_method(JS.get_property(self, "smokeEmitter"), "spawn", [_scope11["x"], _scope11["y"], JS.invoke_method(JS.module("QualityManager"), "getQualityValue", [JS.get_property(JS.get_property(JS.module("QualityManager"), "QUALITY_PARAMETERS"), "MISSILE_SMOKE_FREQUENCY")]), JS.get_property(JS.module("UIConstants"), "MISSILE_SMOKE_COLOUR")])
	return null

func original_remove():
	var _scope15: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null

func original_retire():
	var _scope16: Dictionary = {}
	JS.invoke_method(self, "kill", [])
	return null
