extends RefCounted

static var profiles: Dictionary = {}
static var instance
static var captured: Dictionary = {}

static func register_guest(id, index):
	_load_captured()
	var profile = captured.guests[index].duplicate(true)
	profile.playerId = id
	profiles[id] = profile

static func _load_captured():
	if not captured.is_empty(): return
	captured = JSON.parse_string(FileAccess.get_file_as_string("res://assets/data/player-appearances.json"))
	profiles[captured.ai.playerId] = captured.ai

static func original_getInstance():
	if instance == null: instance = load("res://game/offline/player_catalog.gd").new()
	return instance

static func original_getPlayerDetailsCache():
	return profiles

static func original_maskUnapprovedUsername(details):
	return details.original_getUsername()

func original_getPlayerDetails(success, _failure, complete, id, _cache):
	var js = load("res://game/runtime/js_support.gd")
	assert(profiles.has(id), "缺少离线玩家公开外观: " + str(id))
	var details = js.module("PlayerDetails").withObject(profiles[id])
	js.invoke(success, [details])
	if complete is Callable: js.invoke(complete, [details])
