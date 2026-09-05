extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")

func _initialize(): call_deferred("_run")

func _run():
	root.size = Vector2i(1000, 760)
	var node = Node2D.new()
	root.add_child(node)
	var host = preload("res://game/presentation/bridge/game_host.gd").new(node)
	var oracle = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/particles.json"))
	host.rnd.original_sow([oracle.seed])
	for sample in oracle.samples:
		var actual = host.rnd.original_frac()
		assert(abs(actual - sample) < 1e-12, "Phaser 随机数不匹配: %.17f / %.17f, 初始散列 %.17f" % [actual, sample, host.rnd.original_hash(" ")])
	JS.module("QualityManager").original_setQuality("high")
	var group = host.add.group()
	group.position.setTo(170, 85)
	group.scale.setTo(0.7)
	var reports = []
	for name in ["UIDustEmitter", "UIRubbleEmitter", "UIMissileLaunchEmitter"]:
		var emitter = JS.module(name).create(host)
		group.addChild(emitter)
		if name == "UIRubbleEmitter": emitter.original_emit(500, 350, 0.0, 2.0)
		elif name == "UIMissileLaunchEmitter": emitter.original_spawn(500, 350, 0.0)
		else: emitter.original_spawn(500, 350)
		emitter.original_kill()
		for particle in emitter.children: particle.original_kill()
		emitter.original_revive()
		emitter.fields.minParticleSpeed.setTo(0)
		emitter.fields.maxParticleSpeed.setTo(0)
		emitter.original_emitParticle()
		host.world.sync_view()
		var positions = []
		for particle in emitter.children:
			if particle.exists:
				assert(abs(particle.x - emitter.x) < 1e-9)
				assert(abs(particle.y - emitter.y) < 1e-9)
				var expected = Vector2(170, 85) + Vector2(emitter.x, emitter.y) * 0.7
				assert(particle.view.global_position.distance_to(expected) < 0.0001)
				positions.append({"x": particle.x, "y": particle.y, "drawX": particle.view.global_position.x, "drawY": particle.view.global_position.y})
		reports.append({"module": name, "emitX": emitter.x, "emitY": emitter.y, "particles": positions})
	var motion = _check_motion(host, group)
	var explosion = _check_explosion(host, group)
	var output = FileAccess.open("res://.tmp/emitter-coordinates.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify({"randomSamples": oracle.samples.size(), "emitters": reports, "motion": motion, "explosion": explosion}))
	host.world.original_destroy()
	host.sound.destroy()
	host = null
	node.queue_free()
	await process_frame
	quit(0)

func _check_motion(host, group):
	var log = preload("res://game/runtime/original_log.gd").create("ParticleCoordinates")
	var target = host.add.image(500, 350, "game", "dust0", group)
	var reports = []
	for name in ["UIRubbleEmitter", "UISmokeEmitter", "UIColouredSmokeEmitter", "UIMissileLaunchEmitter"]:
		var emitter = JS.construct(JS.module(name), [host, target, 0x888888])
		group.addChild(emitter)
		target.position.setTo(500, 350)
		if name == "UIRubbleEmitter": emitter.original_emit(target.x, target.y, 0.0, 2.0)
		elif name == "UIMissileLaunchEmitter": emitter.original_spawn(target.x, target.y, 0.0)
		elif name == "UIColouredSmokeEmitter": emitter.original_spawn(target.x, target.y, 30, 0x888888)
		else: emitter.original_spawn(target.x, target.y)
		var frames = []
		for frame in range(60):
			target.x += 1.0
			target.y += 0.5
			host.advance(1.0 / 60.0)
			for particle in emitter.children:
				if not particle.exists: continue
				var local = Vector2(particle.x, particle.y)
				var expected = group.view.to_global(local)
				assert(particle.view.global_position.distance_to(expected) < 0.0001)
				assert(local.distance_to(Vector2(500, 350)) < 200, "烟雾离开发射区域: " + str(local))
			if frame in [0, 1, 30, 59]:
				var particle = emitter.children.filter(func(item): return item.exists).front()
				frames.append({"frame": frame, "emit": [emitter.x, emitter.y], "particle": [particle.x, particle.y], "draw": [particle.view.global_position.x, particle.view.global_position.y]})
		log.info("烟雾运动坐标", {"module": name, "frames": frames})
		reports.append({"module": name, "frames": frames})
		emitter.original_retire()
	return reports

func _check_explosion(host, group):
	var fragment_group = host.add.group(group)
	var target = host.add.image(500, 350, "game", "fragment0", fragment_group)
	var smoke = JS.construct(JS.module("UISmokeEmitter"), [host, target])
	fragment_group.addChild(smoke)
	smoke.original_spawn(target.x, target.y)
	var reports = []
	for frame in range(12):
		host.advance(1.0 / 60.0)
		for particle in smoke.children:
			if not particle.exists: continue
			var expected = fragment_group.view.to_global(Vector2(particle.x, particle.y))
			assert(particle.view.global_position.distance_to(expected) < 0.0001)
		reports.append({"frame": frame, "target": [target.x, target.y], "emitter": [smoke.x, smoke.y]})
	smoke.original_retire()
	return reports.slice(0, 8)
