extends Node2D

const JS = preload("res://game/runtime/js_support.gd")
var host
var menu
var log = preload("res://game/runtime/original_log.gd").create("Application")

func _ready():
	var started = Time.get_ticks_msec()
	RenderingServer.set_default_clear_color(Color.WHITE)
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	JS.strict_random = false
	JS.clock_milliseconds = null
	host = preload("res://game/presentation/bridge/game_host.gd").new(self)
	menu = preload("res://game/presentation/menu/local_menu.gd").new()
	menu.players_selected.connect(_select_players)
	menu.initialize(host)
	get_viewport().size_changed.connect(_resize)
	log.info("原版本地菜单启动", {"milliseconds": Time.get_ticks_msec() - started, "godot": Engine.get_version_info().string})

func _process(delta):
	if host != null: host.advance(delta)

func _input(event):
	if host != null: host.handle_input(event)

func _resize():
	if menu != null: menu.original__onSizeChangeHandler()

func _select_players(count):
	log.info("选择本地人数", {"players": count})

func _exit_tree():
	if menu != null:
		menu.original_shutdown()
		menu.original_destroy()
		menu = null
	if host != null:
		host.world.original_destroy()
		host = null
