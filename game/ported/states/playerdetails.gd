# 由原版 PlayerDetails 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var data = {"playerId": null, "username": null, "victories": 0, "kills": 0, "deaths": 0, "suicides": 0, "surrenders": 0, "experience": 0, "turretColour": null, "treadColour": null, "baseColour": null, "turretAccessory": null, "barrelAccessory": null, "frontAccessory": null, "backAccessory": null, "treadAccessory": null, "backgroundAccessory": null, "badge": null, "email": null, "lastLogin": null, "created": null, "realName": null, "birthYear": null, "country": null, "newsSubscriber": false, "gmLevel": 0, "beta": false, "verified": false, "banned": null, "usernameApproved": null, "premium": false, "guest": false, "rank": 0, "xp": 0, "lastForumPost": 0}
static var _static_PlayerDetails: Dictionary = {}
static var _initialized_PlayerDetails = false
static func initialize_original_static():
	if _initialized_PlayerDetails: return
	_initialized_PlayerDetails = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_PlayerDetails.has(key): return _static_PlayerDetails[key]
	return null
static func original_static_set(key, value):
	_static_PlayerDetails[key] = value
	return value
func original_own_fields():
	return ["data"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {}
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/states/playerdetails.gd").new()
	instance._construct_create()
	return instance

func _construct_withObject(_arg0 = null):
	var _scope1: Dictionary = {"obj": _arg0}
	JS.set_property(self, "data", _scope1["obj"])
	return null
static func withObject(_arg0 = null):
	var instance = load("res://game/ported/states/playerdetails.gd").new()
	instance._construct_withObject(_arg0)
	return instance

func original_getPlayerId():
	var _scope2: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "playerId")
	return null

func original_getUsername():
	var _scope3: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "username")
	return null

func original_getVictories():
	var _scope4: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "victories")
	return null

func original_getKills():
	var _scope5: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "kills")
	return null

func original_getDeaths():
	var _scope6: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "deaths")
	return null

func original_getSuicides():
	var _scope7: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "suicides")
	return null

func original_getSurrenders():
	var _scope8: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "surrenders")
	return null

func original_getExperience():
	var _scope9: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "experience")
	return null

func original_getTurretColour():
	var _scope10: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "turretColour")
	return null

func original_getTreadColour():
	var _scope11: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "treadColour")
	return null

func original_getBaseColour():
	var _scope12: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "baseColour")
	return null

func original_getTurretAccessory():
	var _scope13: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "turretAccessory")
	return null

func original_getBarrelAccessory():
	var _scope14: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "barrelAccessory")
	return null

func original_getFrontAccessory():
	var _scope15: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "frontAccessory")
	return null

func original_getBackAccessory():
	var _scope16: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "backAccessory")
	return null

func original_getTreadAccessory():
	var _scope17: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "treadAccessory")
	return null

func original_getBackgroundAccessory():
	var _scope18: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "backgroundAccessory")
	return null

func original_getBadge():
	var _scope19: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "badge")
	return null

func original_getEmail():
	var _scope20: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "email")
	return null

func original_getLastLogin():
	var _scope21: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "lastLogin")
	return null

func original_getCreated():
	var _scope22: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "created")
	return null

func original_getRealName():
	var _scope23: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "realName")
	return null

func original_getBirthYear():
	var _scope24: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "birthYear")
	return null

func original_getCountry():
	var _scope25: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "country")
	return null

func original_getNewsSubscriber():
	var _scope26: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "newsSubscriber")
	return null

func original_getGmLevel():
	var _scope27: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "gmLevel")
	return null

func original_getBeta():
	var _scope28: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "beta")
	return null

func original_getVerified():
	var _scope29: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "verified")
	return null

func original_getBanned():
	var _scope30: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "banned")
	return null

func original_getUsernameApproved():
	var _scope31: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "usernameApproved")
	return null

func original_getPremium():
	var _scope32: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "premium")
	return null

func original_getGuest():
	var _scope33: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "guest")
	return null

func original_getRank():
	var _scope34: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "rank")
	return null

func original_getXP():
	var _scope35: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "xp")
	return null

func original_getLastForumPost():
	var _scope36: Dictionary = {}
	return JS.get_property(JS.get_property(self, "data"), "lastForumPost")
	return null

func original_toObj():
	var _scope37: Dictionary = {}
	return JS.get_property(self, "data")
	return null
