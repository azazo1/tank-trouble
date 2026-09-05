extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")
var log = preload("res://game/runtime/original_log.gd").create("BattleWeapons")

func _initialize(): call_deferred("_run")

func _advance(host, count):
	for frame in range(count):
		JS.clock_milliseconds += 1000.0 / 60.0
		host.advance(1.0 / 60.0)

func _run():
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	JS.clock_milliseconds = 1788609600000.0
	root.size = Vector2i(1000, 760)
	var node = Node2D.new()
	root.add_child(node)
	var results = []
	for crate in range(7):
		log.info("检查原版武器战斗表现", {"crate": crate})
		seed(41)
		var host = preload("res://game/presentation/bridge/game_host.gd").new(node)
		var session = preload("res://game/application/local_session.gd").new()
		session.initialize(["WASDKeys", "arrowKeys"])
		var battle = preload("res://game/presentation/battle/local_battle.gd").new()
		battle.initialize(host, session.controller)
		_advance(host, 180)
		var controller = session.controller.roundController
		var previous = controller.original_getCollectibles().keys()
		controller.original_spawnCrate(crate, {"x": -100, "y": -100, "rotation": 0})
		var id = controller.original_getCollectibles().keys().filter(func(key): return not previous.has(key))[0]
		var pickup = JS.module("Pickup").create(session.human_ids[0], id)
		controller.original_pickUpCrate(pickup)
		controller.original_destroyCollectible(pickup)
		if crate < 6:
			assert(controller.original_getActiveWeapon(session.human_ids[0]).original_getType() == crate)
		var effect = [battle.laserGroup, battle.projectileGroup, battle.projectileGroup, battle.missileGroup, battle.mineGroup, battle.projectileGroup, battle.shieldGroup][crate]
		var fire = InputEventKey.new()
		fire.physical_keycode = KEY_Q
		fire.pressed = true
		host.handle_input(fire)
		var peak = 0
		for frame in range(240):
			_advance(host, 1)
			peak = maxi(peak, effect.children.filter(func(child): return child.exists).size())
		assert(peak > 0, "未出现对应武器的原版表现: " + str(crate))
		results.append({"crate": crate, "peak": peak})
		battle.shutdown()
		session.shutdown()
		host.world.original_destroy()
		host.sound.destroy()
		battle = null
		host = null
		await process_frame
	node.queue_free()
	await process_frame
	var file = FileAccess.open("res://.tmp/battle-weapons.actual.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(results))
	quit(0)
