extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")
const Host = preload("res://game/presentation/bridge/game_host.gd")
const Session = preload("res://game/application/local_session.gd")
const Battle = preload("res://game/presentation/battle/local_battle.gd")
var log = preload("res://game/runtime/original_log.gd").create("BattleParticles")

func _initialize(): call_deferred("_run")

func _run():
	root.size = Vector2i(2048, 1246)
	JS.clock_milliseconds = 1788609600000.0
	var node = Node2D.new()
	root.add_child(node)
	var reports = []
	for density in [1, 2]:
		var host = Host.new(node)
		host.pixel_ratio = density
		host.assets.resolution = density
		JS.module("UIConstants").original_scaleForHighDensity(density)
		var session = Session.new()
		session.initialize(["WASDKeys", "arrowKeys"])
		var battle = Battle.new()
		battle.initialize(host, session.controller)
		for frame in range(180):
			JS.clock_milliseconds += 1000.0 / 60.0
			host.advance(1.0 / 60.0)
		for key in [KEY_W, KEY_DOWN]:
			var event = InputEventKey.new()
			event.physical_keycode = key
			event.pressed = true
			host.handle_input(event)
		var samples = []
		var emitter = battle.rubbleGroup.emitter
		var emissions = emitter.fields.counts.totalEmitted
		for frame in range(180):
			JS.clock_milliseconds += 1000.0 / 60.0
			host.advance(1.0 / 60.0)
			if emitter.fields.counts.totalEmitted == emissions: continue
			emissions = emitter.fields.counts.totalEmitted
			var tank_positions = []
			for tank in session.controller.original_getTanks().values():
				tank_positions.append(Vector2(JS.module("UIUtils").original_mpx(tank.original_getX()), JS.module("UIUtils").original_mpx(tank.original_getY())))
			var last_particle = emitter.children[emitter.cursor_index]
			var emit_position = Vector2(emitter.x, emitter.y)
			var local = Vector2(last_particle.x, last_particle.y)
			var expected = battle.gameGroup.view.to_global(local)
			var nearest = tank_positions.map(func(position): return position.distance_to(emit_position)).min()
			assert(nearest < 30, "履带烟雾发射点脱离坦克: " + str(emit_position))
			assert(local.distance_to(emit_position) < 150, "履带烟雾初始化位置异常: " + str(local))
			assert(last_particle.view.global_position.distance_to(expected) < 0.001, "履带烟雾绘制位置异常")
			if samples.size() < 4:
				samples.append({"frame": frame, "tanks": tank_positions.map(func(position): return [position.x, position.y]), "emit": [emitter.x, emitter.y], "particle": [last_particle.x, last_particle.y], "draw": [last_particle.view.global_position.x, last_particle.view.global_position.y], "mapPosition": [battle.gameGroup.x, battle.gameGroup.y], "mapScale": battle.gameGroup.scale.x})
		assert(emissions > 0, "未触发履带烟雾")
		reports.append({"density": density, "emissions": emissions, "samples": samples})
		log.info("真实对局烟雾坐标", reports.back())
		battle.shutdown()
		session.shutdown()
		host.world.original_destroy()
		host.sound.destroy()
		await process_frame
	var output = FileAccess.open("res://.tmp/battle-particles.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify(reports))
	node.queue_free()
	await process_frame
	quit(0)
