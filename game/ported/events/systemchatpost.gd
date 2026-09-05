# 由原版 SystemChatPost 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

var involvedPlayerIds = []
var message = ""
var sendReceipt = ""
static var _static_SystemChatPost: Dictionary = {}
static var _initialized_SystemChatPost = false
static func initialize_original_static():
	if _initialized_SystemChatPost: return
	_initialized_SystemChatPost = true
	pass
static func original_static_get(key):
	initialize_original_static()
	if _static_SystemChatPost.has(key): return _static_SystemChatPost[key]
	return null
static func original_static_set(key, value):
	_static_SystemChatPost[key] = value
	return value
func original_own_fields():
	return ["involvedPlayerIds","message","sendReceipt"]

func _construct_create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var _scope0: Dictionary = {"involvedPlayerIds": _arg0, "message": _arg1, "sendReceipt": _arg2}
	JS.set_property(self, "involvedPlayerIds", _scope0["involvedPlayerIds"])
	JS.set_property(self, "message", _scope0["message"])
	JS.set_property(self, "sendReceipt", _scope0["sendReceipt"])
	return null
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/events/systemchatpost.gd").new()
	instance._construct_create(_arg0, _arg1, _arg2)
	return instance

func original_getInvolvedPlayerIds():
	var _scope1: Dictionary = {}
	return JS.get_property(self, "involvedPlayerIds")
	return null

func original_getMessage():
	var _scope2: Dictionary = {}
	return JS.get_property(self, "message")
	return null

func original_getSendReceipt():
	var _scope3: Dictionary = {}
	return JS.get_property(self, "sendReceipt")
	return null
