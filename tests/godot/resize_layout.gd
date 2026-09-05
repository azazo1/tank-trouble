extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")

func _initialize(): call_deferred("_run")

func _rect(control):
	var rect = control.get_global_rect()
	return [rect.position.x, rect.position.y, rect.size.x, rect.size.y]

func _display_rect(display):
	var bounds = display.getLocalBounds()
	return display.view.global_transform * Rect2(bounds.x, bounds.y, bounds.width, bounds.height)

func _advance(application, frames):
	for frame in range(frames):
		JS.clock_milliseconds += 1000.0 / 60.0
		application._process(1.0 / 60.0)

func _run():
	var application = preload("res://game/application/main.gd").new()
	application.settings = preload("res://game/application/settings_store.gd").new("res://.tmp/resize-settings.json")
	root.add_child(application)
	application.set_process(false)
	JS.clock_milliseconds = 1788609600000.0
	_advance(application, 60)
	application._select_players(3)
	application.controls.set_process(false)
	var samples = []
	for dimensions in [Vector2i(1000, 760), Vector2i(2048, 1246), Vector2i(800, 600), Vector2i(480, 360)]:
		root.size = dimensions
		for frame in range(3): await process_frame
		var controls = application.controls
		samples.append({"viewport": [root.size.x, root.size.y], "overlay": _rect(controls), "shade": _rect(controls.shade), "content": _rect(controls.stack), "icon": _rect(controls.icon), "options": controls.options.values().map(_rect)})
		assert(controls.size == Vector2(dimensions), JSON.stringify(samples.back()))
		assert(controls.shade.size == Vector2(dimensions))
		var content = controls.stack.get_global_rect()
		assert(content.get_center().distance_to(Vector2(dimensions) * 0.5) < 1.0)
		assert(Rect2(Vector2.ZERO, Vector2(dimensions)).encloses(content))
		for button in [application.menu.onePlayerButton, application.menu.twoPlayerButton, application.menu.threePlayerButton]:
			assert(Rect2(Vector2.ZERO, Vector2(dimensions)).encloses(_display_rect(button)))
	var click = InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.position = application.controls.options.mouse.get_global_rect().get_center()
	click.pressed = true
	Input.parse_input_event(click)
	click = click.duplicate()
	click.pressed = false
	Input.parse_input_event(click)
	await process_frame
	assert(application.controls.selected == "mouse")
	application._cancel_controls()
	application._start_battle(["WASDKeys", "arrowKeys", "mouse"])
	_advance(application, 180)
	var battle = application.battle
	var bounds_before = battle.gameGroup.getLocalBounds()
	var hidden_projectile = battle.projectileGroup.children.filter(func(child): return not child.visible)[0]
	var projectile_position = hidden_projectile.position.value()
	hidden_projectile.position.setTo(-100000, -100000)
	assert(battle.gameGroup.getLocalBounds() == bounds_before)
	hidden_projectile.position.setTo(projectile_position.x, projectile_position.y)
	var battle_samples = []
	for dimensions in [Vector2i(1000, 760), Vector2i(2048, 1246), Vector2i(800, 600), Vector2i(640, 480)]:
		root.size = dimensions
		for frame in range(3): await process_frame
		var host = application.host
		var maze_bounds = battle.original__getMazeLocalBounds()
		var maze = battle.gameGroup.view.global_transform * Rect2(maze_bounds.x, maze_bounds.y, maze_bounds.width, maze_bounds.height)
		var panel = application.panel
		battle_samples.append({"viewport": [root.size.x, root.size.y], "maze": [maze.position.x, maze.position.y, maze.size.x, maze.size.y], "panel": [panel.panel_node.position.y, panel.game.width, panel.game.height], "icons": panel.localTankIcons.values().map(func(item): return str(_display_rect(item.icon))), "names": str(_display_rect(panel.tankNameGroup)), "scores": str(_display_rect(panel.tankScoreGroup))})
		assert(Rect2(0, 0, host.width, host.height).grow(1.0).encloses(maze), JSON.stringify(battle_samples.back()))
		assert(panel.panel_node.position.y == host.height)
		assert(panel.game.width == host.width)
		assert(panel.game.height + host.height == root.size.y)
		assert(absf(battle.countDownGroup.x - host.width * 0.5) < 0.001)
		assert(absf(battle.countDownGroup.y - host.height * 0.5) < 0.001)
		var leave_position = battle.leaveGameGroup.view.global_position
		host.world.setBounds(8, 6, host.width + 8, host.height + 6)
		host.camera.original_update()
		host.world.original_postUpdate()
		host.world.sync_view()
		assert(battle.leaveGameGroup.view.global_position.distance_to(leave_position) < 0.001)
		host.camera.reset()
		host.world.original_postUpdate()
		host.world.sync_view()
	var output = FileAccess.open("res://.tmp/resize-layout.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify({"controls": samples, "battle": battle_samples, "density": application.host.pixel_ratio}))
	application.queue_free()
	await process_frame
	quit(0)
