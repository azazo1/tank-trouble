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
	var output = FileAccess.open("res://.tmp/emitter-coordinates.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify({"randomSamples": oracle.samples.size(), "emitters": reports}))
	host.world.original_destroy()
	host.sound.destroy()
	host = null
	node.queue_free()
	await process_frame
	quit(0)
