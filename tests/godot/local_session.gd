extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")
var rounds = 0
var ended = 0

func _initialize():
	call_deferred("_run")

func _event(_context, _id, event, _data):
	var events = JS.get_property(JS.module("RoundModel"), "_EVENTS")
	if event == events.ROUND_STARTED: rounds += 1
	if event == events.ROUND_ENDED: ended += 1

func _key(host, code, pressed):
	var event = InputEventKey.new()
	event.physical_keycode = code
	event.pressed = pressed
	host.handle_input(event)

func _run():
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	JS.clock_milliseconds = 1788609600000.0
	var node = Node2D.new()
	root.add_child(node)
	var host = preload("res://game/presentation/bridge/game_host.gd").new(node)
	var events = JS.module("GameManager")
	events.original_addRoundEventListener(_event, self)
	var results = []
	for count in [1, 2, 3]:
		rounds = 0
		ended = 0
		var session = preload("res://game/application/local_session.gd").new()
		session.initialize(["WASDKeys", "arrowKeys", "mouse"].slice(0, count))
		assert(session.controller.original_getTotalPlayerCount() == max(2, count))
		assert(JS.module("Inputs").original_static_get("inputManagers").size() == count)
		assert((session.ai_manager != null) == (count == 1))
		var moved = false
		var previous_position = null
		for frame in range(1080):
			_key(host, KEY_W, true)
			_key(host, KEY_A, frame % 120 < 60)
			_key(host, KEY_Q, frame % 60 < 30)
			JS.clock_milliseconds += 1000.0 / 60.0
			session.advance(1000.0 / 60.0)
			var tank = session.controller.original_getTank(session.human_ids[0])
			if tank != null:
				var current = [tank.original_getX(), tank.original_getY()]
				if previous_position != null and current != previous_position: moved = true
				previous_position = current
			if frame % 240 == 239 and session.controller.original_getState() == JS.get_property(JS.module("GameModel"), "_STATES").IN_ROUND:
				var tanks = session.controller.original_getTanks()
				var ids = tanks.keys()
				for id in ids.slice(1): session.controller.original_destroyTank(id)
		assert(moved)
		assert(rounds >= 2)
		assert(ended >= 1)
		results.append({"players": count, "rounds": rounds, "ended": ended, "moved": moved})
		session.shutdown()
		host.reset_input()
		assert(JS.module("Inputs").original_static_get("inputManagers").is_empty())
	events.original_removeRoundEventListener(_event, self)
	var output = FileAccess.open("res://.tmp/local-session.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify(results))
	host.world.original_destroy()
	host = null
	node.queue_free()
	await process_frame
	quit(0)
