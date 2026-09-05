extends Node2D

const JS = preload("res://game/runtime/js_support.gd")
var host
var menu
var controls
var session
var battle
var panel
var log = preload("res://game/runtime/original_log.gd").create("Application")

func _ready():
	var started = Time.get_ticks_msec()
	RenderingServer.set_default_clear_color(Color.WHITE)
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	JS.strict_random = false
	JS.clock_milliseconds = null
	host = preload("res://game/presentation/bridge/game_host.gd").new(self)
	_show_menu()
	get_viewport().size_changed.connect(_resize)
	log.info("原版本地菜单启动", {"milliseconds": Time.get_ticks_msec() - started, "godot": Engine.get_version_info().string})

func _process(delta):
	if host != null: host.advance(delta)
	if panel != null: panel.advance(delta)

func _input(event):
	if controls != null: return
	if host != null: host.handle_input(event)
	if battle != null and event is InputEventKey and event.physical_keycode == KEY_ESCAPE and not event.pressed: call_deferred("_leave_battle")

func _resize():
	if menu != null: menu.original__onSizeChangeHandler()
	if battle != null and battle.maze != null: battle.original__onSizeChangeHandler()
	if panel != null: panel.resize()

func _select_players(count):
	if controls != null: return
	log.info("选择本地人数", {"players": count})
	controls = preload("res://game/presentation/menu/controls_overlay.gd").new()
	add_child(controls)
	controls.initialize(host, count)
	controls.completed.connect(_start_battle, CONNECT_DEFERRED)

func _show_menu():
	menu = preload("res://game/presentation/menu/local_menu.gd").new()
	menu.players_selected.connect(_select_players)
	menu.initialize(host)

func _start_battle(assignments):
	controls.queue_free()
	controls = null
	menu.shutdown()
	menu = null
	host.reset_input()
	session = preload("res://game/application/local_session.gd").new()
	session.initialize(assignments)
	host.bottom_inset = 180.0
	battle = preload("res://game/presentation/battle/local_battle.gd").new()
	battle.leave_requested.connect(_leave_battle, CONNECT_DEFERRED)
	battle.initialize(host, session.controller)
	panel = preload("res://game/presentation/panel/local_panel.gd").new()
	panel.initialize(host, session)
	log.info("进入原版本地战斗", {"players": assignments.size()})

func _leave_battle():
	if battle == null: return
	panel.shutdown()
	panel = null
	battle.shutdown()
	battle = null
	session.shutdown()
	session = null
	host.bottom_inset = 0.0
	_show_menu()

func _exit_tree():
	if menu != null:
		menu.shutdown()
		menu = null
	if battle != null: battle.shutdown()
	if panel != null: panel.shutdown()
	if session != null: session.shutdown()
	if host != null:
		host.world.original_destroy()
		host.sound.destroy()
		host = null
