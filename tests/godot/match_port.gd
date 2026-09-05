extends SceneTree

func _initialize():
	call_deferred("_run")

func _run():
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	var support = load("res://game/runtime/js_support.gd")
	var arguments = OS.get_cmdline_user_args()
	var fixture_name = arguments[0] if arguments.size() else "match-17"
	var fixture = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/%s.json" % fixture_name))
	support.clock_milliseconds = fixture.timestamp
	support.set_random_tape(fixture.random_tape)
	var constants = support.module("Constants")
	constants.original_setMode(support.get_property(constants, "MODE_CLIENT_LOCAL"))
	var mode = support.module("BootCampGameMode").create()
	var game = support.module("GameController").create(mode, false, false, false, 3, fixture.crates, false, 0)
	var players = fixture.get("players", ["player-0", "player-1"])
	for player in players: game.original_addPlayer(player)
	var manager = null
	if fixture.get("ai") != null: manager = support.module("AIManager").create(fixture.ai.id, fixture.ai, game)
	game.original__initializeRound()
	game.original_startRound()
	if fixture.get("forced_crate") != null:
		var controller = game.roundController
		controller.original_spawnCrate(fixture.forced_crate, {"x": -100, "y": -100, "rotation": 0})
		var id = controller.original_getCollectibles().keys()[0]
		var pickup = support.module("Pickup").create(players[0], id)
		controller.original_pickUpCrate(pickup)
		controller.original_destroyCollectible(pickup)
	var frames: Array = []
	var decisions: Array = []
	for inputs in fixture.inputs:
		for state in inputs:
			game.original_setInputState(support.invoke_method(support.module("InputState"), "withState", state))
		support.clock_milliseconds += 1000.0 / 60.0
		if manager != null: manager.original_update(1.0 / 60.0)
		game.original_update()
		frames.append(JSON.parse_string(JSON.stringify(game.original_getRoundState(true).original_toObj(), "", false, true)))
		if manager != null: decisions.append(JSON.parse_string(JSON.stringify({"input": manager.ai.original_getInputState().original_toObj(), "goal": manager.ai.goal, "actions": manager.ai.actions}, "", false, true)))
	var output = FileAccess.open("res://.tmp/%s.actual.json" % fixture_name, FileAccess.WRITE)
	output.store_string(JSON.stringify({"frames": frames, "decisions": decisions, "random_count": support.random_index}, "", false, true))
	quit(0)
