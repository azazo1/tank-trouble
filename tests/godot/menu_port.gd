extends SceneTree

var selected: Array = []

func _initialize():
	call_deferred("_run")

func _run():
	root.size = Vector2i(1000, 760)
	var main = load("res://game/application/main.tscn").instantiate()
	root.add_child(main)
	main.set_process(false)
	main.menu.players_selected.connect(func(count): selected.append(count))
	for frame in range(60): main.host.advance(1.0 / 60.0)
	var buttons = [main.menu.onePlayerButton, main.menu.twoPlayerButton, main.menu.threePlayerButton]
	var measurements: Array = []
	for button in buttons:
		var text = button.fields.buttonText
		assert(text.intrinsic_size.x > 50.0)
		assert(text.intrinsic_size.x < button.width)
		assert(button.x - button.width * 0.5 >= 0 and button.x + button.width * 0.5 <= 1000)
		var click = InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.position = button.view.global_position
		click.pressed = true
		main.host.handle_input(click)
		click.pressed = false
		main.host.handle_input(click)
		measurements.append({"position": [button.x, button.y], "width": button.width, "textWidth": text.intrinsic_size.x})
	assert(selected == [1, 2, 3])
	var output = FileAccess.open("res://.tmp/menu.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify({"buttons": measurements, "selected": selected}))
	main.queue_free()
	await process_frame
	quit(0)
