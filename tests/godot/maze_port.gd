extends SceneTree

func _initialize():
	call_deferred("_run")

func _run():
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	var support = load("res://game/runtime/js_support.gd")
	if support == null or not support.can_instantiate():
		quit(1)
		return
	for seed in [1, 17, 413]:
		var fixture = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/maze-%s.json" % seed))
		support.set_random_tape(fixture.random_tape)
		var script = support.module("Maze")
		if script == null or not script.can_instantiate():
			quit(1)
			return
		var players := []
		for i in range(int(fixture.players)): players.append("player-%s" % i)
		var maze = script.createRandom(fixture.width, fixture.height, players, fixture.theme)
		var actual := {"maze": maze.original_toObj(), "tanks": maze.original_getTankPositions(), "distances": maze.distances, "dead_end_penalties": maze.deadEndPenalties, "random_count": support.random_index}
		var output := FileAccess.open("res://.tmp/maze-%s.actual.json" % seed, FileAccess.WRITE)
		output.store_string(JSON.stringify(actual))
	quit(0)
