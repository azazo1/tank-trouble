extends SceneTree

func _initialize(): call_deferred("_run")

func _run():
	var scenarios = JSON.parse_string(FileAccess.get_file_as_string("res://.tmp/camera.expected.json"))
	var node = Node2D.new()
	root.add_child(node)
	var host = preload("res://game/presentation/bridge/game_host.gd").new(node)
	var maximum = 0.0
	var moved = false
	for scenario in scenarios:
		host.canvas_size = Vector2(scenario.size[0], scenario.size[1])
		host.camera.reset()
		for frame in scenario.frames:
			var bounds = frame.bounds
			host.world.setBounds(bounds[0], bounds[1], bounds[2], bounds[3])
			host.advance(1.0 / 60.0)
			var actual = [host.camera.view.x, host.camera.view.y, host.world.view.position.x, host.world.view.position.y]
			var expected = frame.camera + frame.world
			for index in range(4):
				var error = absf(actual[index] - expected[index])
				maximum = maxf(maximum, error)
				assert(error < 1e-6, JSON.stringify({"actual": actual, "expected": expected}))
			moved = moved or host.world.view.position != Vector2.ZERO
		assert(host.world.view.position == Vector2.ZERO)
	assert(moved)
	host.camera.reset()
	host.world.sync_view()
	assert(host.world.view.position == Vector2.ZERO)
	host.world.original_destroy()
	host.sound.destroy()
	host = null
	node.queue_free()
	await process_frame
	var output = FileAccess.open("res://.tmp/camera.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify({"scenarios": scenarios.size(), "frames": 180, "maximum": maximum}))
	quit(0)
