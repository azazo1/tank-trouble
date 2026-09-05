extends RefCounted

static var manager: WeakRef

static func original_isReady(): return true

static func original_isAI(id):
	return id == load("res://game/offline/player_catalog.gd").captured.ai.playerId

static func original_getAI(_id):
	return {"name": "Laika"}

static func original_update(milliseconds):
	if manager != null and manager.get_ref() != null: manager.get_ref().original_update(milliseconds)

static func original_reset():
	if manager != null and manager.get_ref() != null: manager.get_ref().original_reset()

static func original_removeAllAIManagers():
	manager = null
