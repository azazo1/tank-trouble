extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")
var log = preload("res://game/runtime/original_log.gd").create("ApplicationFlow")

func _initialize(): call_deferred("_run")

func _check_input_pause(application):
	var host = application.host
	var tanks = application.session.human_ids.map(func(id): return application.session.controller.original_getTank(id))
	for code in [KEY_W, KEY_Q, KEY_UP, KEY_SPACE]:
		var event = InputEventKey.new()
		event.physical_keycode = code
		event.pressed = true
		host.handle_input(event)
	var sprite = application.battle.tankSprites[application.session.human_ids[2]]
	var click = InputEventMouseButton.new()
	click.position = sprite.view.to_global(Vector2(0, -200))
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	host.handle_input(click)
	JS.module("Inputs").original_update()
	assert(tanks.all(func(tank): return tank.forward and tank.fireDown))
	application._show_settings()
	var paused_time = host.time.deltaTotal
	JS.clock_milliseconds += 5000.0
	application._process(5.0)
	assert(host.time.deltaTotal == paused_time)
	application.settings_window.dismiss()
	assert(application.session.controller.lastUpdate == floor(JS.clock_milliseconds))
	JS.module("Inputs").original_update()
	var states = tanks.map(func(tank): return {"forward": tank.forward, "fire": tank.fireDown})
	log.info("检查设置恢复后的输入释放", {"states": states})
	assert(tanks.all(func(tank): return not tank.forward and not tank.fireDown), JSON.stringify(states))
	host.handle_input(click)
	JS.module("Inputs").original_update()
	assert(tanks[2].fireDown)
	application._notification(Node.NOTIFICATION_WM_WINDOW_FOCUS_OUT)
	assert(not tanks[2].fireDown and not tanks[2].forward)
	var quality = JS.module("QualityManager")
	quality.original_setQuality("auto")
	for frame in range(3):
		JS.clock_milliseconds += 1000.0 / 60.0
		application._process(1.0 / 60.0)
	assert(quality.original_static_get("numFpsSamples") == 2)
	assert(quality.original_static_get("avgFps") > 0)

func _run():
	root.size = Vector2i(1000, 760)
	var application = preload("res://game/application/main.gd").new()
	application.settings = preload("res://game/application/settings_store.gd").new("res://.tmp/application-settings.json")
	root.add_child(application)
	application.set_process(false)
	JS.clock_milliseconds = 1788609600000.0
	application._select_players(3)
	var cancel = InputEventKey.new()
	cancel.physical_keycode = KEY_ESCAPE
	cancel.pressed = false
	application.controls._input(cancel)
	await process_frame
	assert(application.controls == null and application.menu != null)
	assert(application.session == null)
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
		assert(application.panel.localTankIcons.size() == count)
		for frame in range(360):
			JS.clock_milliseconds += 1000.0 / 60.0
			application._process(1.0 / 60.0)
		assert(application.battle.maze != null)
		if count == 3: _check_input_pause(application)
		if count == 1:
			var avatar = application.panel.onlineTankIcons.values()[0].avatar.avatarSpine
			assert(avatar != null and not avatar.mesh_view.geometry.is_empty())
			assert(avatar.skeleton.flipX == avatar.applied_flip_x)
		var score_group = application.panel.localTankIcons.values()[0].score
		assert(score_group.items != null and not score_group.items.is_empty())
		var categories = JS.get_property(JS.module("UIConstants"), "SCORE_CATEGORIES")
		for item in score_group.items:
			if item.category != categories.SCORE: continue
			var score = application.session.controller.original_getScoreByPlayerIdAndType(score_group.playerId, item.type)
			var target = score.original_getValue() + 1
			application.session.controller.original_adjustScore(score.original_getId(), 1)
			application.session.controller.model.original_emitGameState(application.session.controller.original_getGameState())
			assert(float(item.displayObject.text) == float(target))
			assert(score_group.fragmentGroup.children.any(func(fragment): return fragment.exists))
			break
		scenarios.append({"humans": count, "tanks": application.battle.tankSprites.size(), "round": application.session.controller.original_getRoundId()})
		application._leave_battle()
		await process_frame
		assert(application.battle == null)
		assert(application.menu != null)
		assert(JS.module("GameManager").game_listeners.size() == 2)
	application._show_settings()
	var previous_time = application.host.time.deltaTotal
	application._process(0.1)
	assert(application.host.time.deltaTotal == previous_time)
	application.settings_window.volume_slider.value = 0.25
	assert(is_equal_approx(AudioServer.get_bus_volume_linear(0), 0.25))
	application.settings_window.quality_selector.item_selected.emit(2)
	application.settings_window.dismiss()
	assert(not application.settings_window.visible)
	assert(application.settings.values.quality == "low")
	application._replay()
	assert(application.session.assignments == ["WASDKeys", "arrowKeys", "mouse"])
	assert(JS.module("QualityManager").original_getQuality() == "low")
	application._leave_battle()
	application.queue_free()
	await process_frame
	var output = FileAccess.open("res://.tmp/application-flow.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify(scenarios))
	quit(0)
