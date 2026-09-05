extends SceneTree

func _initialize():
	call_deferred("_run")

func _run():
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	for character in ["laika", "dimitri"]:
		_progress(character, "initialize", -1)
		var fixture = JSON.parse_string(FileAccess.get_file_as_string("res://.tmp/spine-%s.expected.json" % character))
		var player = ClassDB.instantiate("TTOriginalSpine")
		var directory = "res://assets/original/images/%s/" % character
		var atlas = FileAccess.get_file_as_string(directory + character + ".atlas")
		var data = JSON.parse_string(FileAccess.get_file_as_string(directory + character + ".json"))
		if not player.initialize(atlas, data, fixture.images, false):
			quit(1)
			return
		var names = fixture.names
		_progress(character, "mixes", -1)
		for index in range(names.size()):
			player.set_mix(names[(index + names.size() - 1) % names.size()], names[index], 0.12)
		var frames: Array = []
		for frame in range(fixture.count):
			if frame % 6 == 0: _progress(character, "animation", frame)
			for command in fixture.commands:
				if command.frame != frame: continue
				match command.operation:
					"set": player.set_animation(command.track, command.name, command.loop)
					"add": player.add_animation(command.track, command.name, command.loop, command.delay)
					"clear": player.clear_track(command.track)
					"flip": player.set_flip_x(command.value)
			player.advance(1.0 / 60.0)
			if frame % 6 == 0: frames.append({"frame": frame, "bones": player.bone_transforms(), "geometry": player.geometry()})
		var output = FileAccess.open("res://.tmp/spine-%s.actual.json" % character, FileAccess.WRITE)
		output.store_string(JSON.stringify(frames, "", false, true))
	quit(0)

func _progress(character, phase, frame):
	var file = FileAccess.open("res://.tmp/spine-progress.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"character": character, "phase": phase, "frame": frame}))
