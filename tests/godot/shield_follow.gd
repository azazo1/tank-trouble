extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")
var log = preload("res://game/runtime/original_log.gd").create("ShieldFollow")
var checks = 0

func _initialize(): call_deferred("_run")

func _check_follow(application, shield):
	var tank = application.session.controller.original_getTank(shield.playerId)
	if tank == null: return true
	var ui = JS.module("UIUtils")
	var local = Vector2(ui.original_mpx(tank.original_getX()), ui.original_mpx(tank.original_getY()))
	var expected = application.battle.gameGroup.view.to_global(local)
	var actual = shield.layer1Shield.view.global_position
	var registered = application.host.physics.p2.bodies.has(shield.body)
	var sample = {"tank": str(local), "body": str(Vector2(shield.body.x, shield.body.y)), "sprite": str(shield.position.value()), "expected_screen": str(expected), "actual_screen": str(actual), "registered": registered}
	if not registered or expected.distance_to(actual) > 0.001 or shield.layer2Shield.view.global_position.distance_to(expected) > 0.001:
		log.error("护盾没有跟随坦克", sample)
		push_error(JSON.stringify(sample))
		return false
	checks += 1
	return true

func _advance(application, frames):
	for frame in range(frames):
		JS.clock_milliseconds += 1000.0 / 60.0
		application._process(1.0 / 60.0)
		for shield in application.battle.shieldGroup.children:
			if shield.exists and not _check_follow(application, shield): return false
	return true

func _run():
	root.size = Vector2i(1000, 760)
	var application = preload("res://game/application/main.gd").new()
	application.settings = preload("res://game/application/settings_store.gd").new("res://.tmp/shield-settings.json")
	root.add_child(application)
	application.set_process(false)
	JS.clock_milliseconds = 1788609600000.0
	seed(41)
	application._start_battle(["WASDKeys", "arrowKeys"])
	log.info("等待本地对局开始")
	assert(_advance(application, 360))
	var controller = application.session.controller.roundController
	var previous = controller.original_getCollectibles().keys()
	controller.original_spawnCrate(6, {"x": -100, "y": -100, "rotation": 0})
	var id = controller.original_getCollectibles().keys().filter(func(key): return not previous.has(key))[0]
	var pickup = JS.module("Pickup").create(application.session.human_ids[0], id)
	controller.original_pickUpCrate(pickup)
	controller.original_destroyCollectible(pickup)
	var shield = application.battle.shieldGroup.children.filter(func(item): return item.exists and item.playerId == application.session.human_ids[0])[0]
	var initial = Vector2(shield.body.x, shield.body.y)
	log.info("检查拾取护盾, 移动和窗口缩放")
	var movement = InputEventKey.new()
	movement.physical_keycode = KEY_W
	movement.pressed = true
	application.host.handle_input(movement)
	for dimensions in [Vector2i(1000, 760), Vector2i(2048, 1246), Vector2i(640, 480)]:
		root.size = dimensions
		for frame in range(3): await process_frame
		assert(_advance(application, 12))
	log.info("检查护盾对象复用和物理体登记")
	shield.original_kill()
	assert(not application.host.physics.p2.bodies.has(shield.body))
	assert(not shield.visible)
	assert(_advance(application, 12))
	shield.original_spawn(application.session.human_ids[0], false, false)
	assert(_advance(application, 1))
	assert(application.host.physics.p2.bodies.count(shield.body) == 1)
	shield.exists = false
	assert(not application.host.physics.p2.bodies.has(shield.body))
	shield.exists = true
	shield.original_revive()
	assert(_advance(application, 1))
	assert(application.host.physics.p2.bodies.count(shield.body) == 1)
	assert(initial.distance_to(Vector2(shield.body.x, shield.body.y)) > 0.1)
	shield.original_remove()
	assert(_advance(application, int(ceil(JS.get_property(JS.module("UIConstants"), "SHIELD_BREAK_TIME") * 0.06)) + 1))
	assert(not shield.exists and not application.host.physics.p2.bodies.has(shield.body))
	var result = {"checks": checks, "density": application.host.pixel_ratio}
	application.queue_free()
	await process_frame
	# 让音频线程消费停止播放指令, 再结束无窗口测试进程.
	await create_timer(0.1).timeout
	var output = FileAccess.open("res://.tmp/shield-follow.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify(result))
	quit(0)
