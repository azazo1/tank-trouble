extends SceneTree

const JS = preload("res://game/runtime/js_support.gd")

func _initialize():
	call_deferred("_run")

func _run():
	root.size = Vector2i(1000, 760)
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	JS.clock_milliseconds = 1788609600000.0
	var node = Node2D.new()
	root.add_child(node)
	var host = preload("res://game/presentation/bridge/game_host.gd").new(node)
	JS.module("UIUtils").original_initUIGamePhysics(host)
	JS.module("QualityManager").original_setQuality("high")
	var session = preload("res://game/application/local_session.gd").new()
	session.initialize(["WASDKeys", "arrowKeys"])
	session.controller.original__initializeRound()
	session.controller.original_startRound()
	var maze = JS.module("UIMazeView").create(host)
	host.world.addChild(maze)
	maze.mazeFloorGroup = host.add.group(maze)
	var tanks = host.add.group(maze)
	maze.mazeWallGroup = host.add.group(maze)
	maze.mazeWallDecorationGroup = host.add.group(maze)
	maze.original__createMaze(session.controller.original_getMaze())
	assert(maze.mazeFloorGroup.children.size() > 0)
	assert(maze.mazeWallGroup.children.size() > 0)
	var sprites = []
	for id in session.human_ids:
		var tank = session.controller.original_getTank(id)
		var sprite = JS.module("UITankSprite").create(host, session.controller, [], [], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
		tanks.addChild(sprite)
		sprite.original_spawn(JS.module("UIUtils").original_mpx(tank.original_getX()), JS.module("UIUtils").original_mpx(tank.original_getY()), tank.original_getRotation(), id, false, 0)
		sprites.append(sprite)
	for frame in range(120):
		session.controller.original_setInputState(JS.module("InputState").withState(session.human_ids[0], true, false, true, false, false))
		JS.clock_milliseconds += 1000.0 / 60.0
		session.advance(1000.0 / 60.0)
		host.physics.p2.advance()
		host.advance(1.0 / 60.0)
	var states = []
	for sprite in sprites:
		var tank = session.controller.original_getTank(sprite.playerId)
		assert(abs(sprite.body.x - JS.module("UIUtils").original_mpx(tank.original_getX())) < 0.001)
		assert(sprite.turret.sprite.texture != null)
		states.append({"x": sprite.x, "y": sprite.y, "leftTread": sprite.leftTreadShade.frameName, "rightTread": sprite.rightTreadShade.frameName})
	var output = FileAccess.open("res://.tmp/battle-view.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify({"floors": maze.mazeFloorGroup.children.size(), "walls": maze.mazeWallGroup.children.size(), "tanks": states}))
	session.shutdown()
	host.world.original_destroy()
	host.sound.destroy()
	host.physics.p2.clear()
	host = null
	node.queue_free()
	await process_frame
	quit(0)
