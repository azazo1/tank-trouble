extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")

func _initialize(): call_deferred("_run")

func _run():
	root.size = Vector2i(1000, 760)
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	JS.clock_milliseconds = 1788609600000.0
	var node = Node2D.new()
	root.add_child(node)
	var host = preload("res://game/presentation/bridge/game_host.gd").new(node)
	var session = preload("res://game/application/local_session.gd").new()
	session.initialize(["WASDKeys"])
	var battle = preload("res://game/presentation/battle/local_battle.gd").new()
	battle.initialize(host, session.controller)
	var input = InputEventKey.new()
	input.physical_keycode = KEY_Q
	input.pressed = true
	host.handle_input(input)
	for frame in range(900):
		JS.clock_milliseconds += 1000.0 / 60.0
		host.advance(1.0 / 60.0)
	assert(battle.maze != null)
	assert(battle.mazeFloorGroup.children.size() > 0)
	assert(battle.tankGroup.children.size() > 0)
	var result = {"round": session.controller.original_getRoundId(), "floors": battle.mazeFloorGroup.children.size(), "tanks": battle.tankSprites.size(), "bodies": host.physics.p2.bodies.size()}
	battle.shutdown()
	session.shutdown()
	host.world.original_destroy()
	host.sound.destroy()
	battle = null
	host = null
	node.queue_free()
	await process_frame
	var output = FileAccess.open("res://.tmp/battle-flow.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify(result))
	quit(0)
