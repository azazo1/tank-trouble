extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")

func _initialize(): call_deferred("_run")

func _run():
	root.size = Vector2i(1000, 760)
	var application = preload("res://game/application/main.gd").new()
	root.add_child(application)
	application.set_process(false)
	JS.clock_milliseconds = 1788609600000.0
	var scenarios = []
	for count in [1, 2, 3]:
		application.menu.original__addGuests(count)
		assert(application.controls != null)
		application.controls.set_process(false)
		assert(application.controls.icon.texture != null)
		for index in range(count):
			if index < 2:
				var event = InputEventKey.new()
				event.physical_keycode = KEY_Q if index == 0 else KEY_SPACE
				event.pressed = false
				application.controls._input(event)
			else: application.controls.options.mouse.pressed.emit()
			application.controls._process(0.51)
		await process_frame
		assert(application.battle != null)
		assert(application.session.human_ids.size() == count)
		for frame in range(360):
			JS.clock_milliseconds += 1000.0 / 60.0
			application._process(1.0 / 60.0)
		assert(application.battle.maze != null)
		scenarios.append({"humans": count, "tanks": application.battle.tankSprites.size(), "round": application.session.controller.original_getRoundId()})
		application._leave_battle()
		await process_frame
		assert(application.battle == null)
		assert(application.menu != null)
		assert(JS.module("GameManager").game_listeners.size() == 2)
	application.queue_free()
	await process_frame
	var output = FileAccess.open("res://.tmp/application-flow.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify(scenarios))
	quit(0)
