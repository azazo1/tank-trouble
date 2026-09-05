# 由原版 ChatPost 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var from = []
var to = []
var message = ""
var chatMessageId = 0
var sendReceipt = ""
static var _static_ChatPost: Dictionary = {}
static var _initialized_ChatPost = false
static func initialize_original_static():
	if _initialized_ChatPost: return
	_initialized_ChatPost = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_ChatPost.has(key): return _static_ChatPost[key]
	return null
static func original_static_set(key, value):
	_static_ChatPost[key] = value
	return value
func original_own_fields():
	return ["from","to","message","chatMessageId","sendReceipt"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var _scope0: Dictionary = {"from": _arg0, "to": _arg1, "message": _arg2, "chatMessageId": _arg3, "sendReceipt": _arg4}
	JS.set_property(self, "from", _scope0["from"])
	JS.set_property(self, "to", _scope0["to"])
	JS.set_property(self, "message", _scope0["message"])
	JS.set_property(self, "chatMessageId", _scope0["chatMessageId"])
	JS.set_property(self, "sendReceipt", _scope0["sendReceipt"])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null, _arg16 = null, _arg17 = null, _arg18 = null, _arg19 = null, _arg20 = null, _arg21 = null, _arg22 = null, _arg23 = null):
	var instance = load("res://game/ported/events/chatpost.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2, _arg3, _arg4)
	return instance

func original_getFrom():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "from")
	return null

func original_getTo():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "to")
	return null

func original_getMessage():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "message")
	return null

func original_getChatMessageId():
	var _scope4: Dictionary = {}
	return JS.get_property(self, "chatMessageId")
	return null

func original_getSendReceipt():
	var _scope5: Dictionary = {}
	return JS.get_property(self, "sendReceipt")
	return null
