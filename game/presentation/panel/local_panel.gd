extends "res://game/ported/presentation/panel/uilocalpanellayout.gd"

var panel_node: Node2D
var primary: WeakRef
var panel_height = 180.0

func initialize(host, session):
	primary = weakref(host)
	panel_node = Node2D.new()
	host.root.get_ref().add_child(panel_node)
	var panel_host = preload("res://game/presentation/bridge/game_host.gd").new(panel_node, false)
	fields["panel_host"] = panel_host
	game = panel_host
	game.assets = host.assets
	game.canvas_size = Vector2(host.width, panel_height)
	_init_physics()
	tankIconGroup = game.add.group()
	tankNameGroup = game.add.group()
	tankScoreGroup = game.add.group()
	tankIconPool = JS.module("UIPool").create()
	tankAvatarPool = JS.module("UIPool").create()
	log = JS.module("Log").create("PlayerPanel")
	localPlayerIds = session.human_ids.duplicate()
	onlinePlayerIds = [JS.module("Backend").captured.ai.playerId] if session.ai_manager != null else []
	for index in range(localPlayerIds.size() + onlinePlayerIds.size()):
		var icon = JS.module("UITankIconImage").create(game, false, "medium")
		tankIconPool.original_add(icon)
		tankIconGroup.addChild(icon)
		var avatar = JS.module("UITankAvatarGroup").create(game)
		tankAvatarPool.original_add(avatar)
		tankIconGroup.addChild(avatar)
		tankNameGroup.addChild(JS.module("UITankIconNameGroup").create(game, JS.get_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_MEDIUM")))
		tankScoreGroup.addChild(JS.module("UITankIconScoreGroup").create(game))
	original__updateUI()
	resize()
	log.info("原版玩家面板已创建", {"humans": localPlayerIds.size(), "ai": onlinePlayerIds.size()})

func _init_physics():
	var constants = JS.module("UIConstants")
	var ui = JS.module("UIUtils")
	game.physics.p2 = preload("res://game/presentation/physics/p2_world.gd").new(game)
	var physics = game.physics.p2
	physics.set_native(physics.world.data, "gravity", [0, -0.05 * JS.get_property(constants, "PLAYER_PANEL_GRAVITY")])
	for part in ["playerPanelFloor", "scoreFragment"]:
		ui.physics_fields[part + "CollisionGroup"] = physics.createCollisionGroup()
		ui.physics_fields[part + "Material"] = physics.createMaterial(part)
	var material = physics.createContactMaterial(ui.physics_fields.playerPanelFloorMaterial, ui.physics_fields.scoreFragmentMaterial)
	physics.set_native(material, "restitution", 0.35)
	physics.set_native(material, "friction", 1.0)
	ui.physics_fields.floorScoreFragmentContactMaterial = material
	var floor_body = preload("res://game/presentation/physics/p2_body.gd").create(game, null, 0, 0)
	floor_body._set("static", true)
	floor_body.addPlane(0, JS.get_property(constants, "SCORE_EXPLOSION_Y"), 0)
	floor_body.setMaterial(ui.physics_fields.playerPanelFloorMaterial)
	floor_body.setCollisionGroup(ui.physics_fields.playerPanelFloorCollisionGroup)
	floor_body.collides([ui.physics_fields.scoreFragmentCollisionGroup])
	physics.addBody(floor_body)

func resize():
	var host = primary.get_ref()
	game.canvas_size.x = host.width
	panel_node.position.y = host.height
	original__onSizeChangeHandler()

func advance(delta):
	game.advance(delta)

func shutdown():
	for group in [tankIconGroup, tankNameGroup, tankScoreGroup]: group.callAll("retire")
	game.world.original_destroy()
	game.sound.destroy()
	game.physics.p2.clear()
	game.tweens.clear()
	game.time.events.pending.clear()
	fields.erase("panel_host")
	panel_node.queue_free()
	original_destroy()
