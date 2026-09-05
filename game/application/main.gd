extends Control

const JS = preload("res://game/runtime/js_support.gd")
var host
var menu
var controls
var session
var battle
var panel
var desktop_menu
var settings_window
var settings = preload("res://game/application/settings_store.gd").new()
var log = preload("res://game/runtime/original_log.gd").create("Application")

func _ready():
	var started = Time.get_ticks_msec()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	RenderingServer.set_default_clear_color(Color.WHITE)
	GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	JS.strict_random = false
	JS.clock_milliseconds = null
	settings.load_settings()
	AudioServer.set_bus_volume_db(0, linear_to_db(settings.values.volume))
	JS.module("QualityManager").original_setQuality(settings.values.quality)
	host = preload("res://game/presentation/bridge/game_host.gd").new(self)
	settings_window = preload("res://game/presentation/menu/settings_window.gd").new()
	settings_window.visible = false
	add_child(settings_window)
	settings_window.volume_changed.connect(_set_volume)
	settings_window.quality_changed.connect(_set_quality)
	settings_window.dismissed.connect(_close_settings)
	desktop_menu = preload("res://game/presentation/menu/desktop_menu.gd").new()
	add_child(desktop_menu)
	desktop_menu.replay_requested.connect(_replay, CONNECT_DEFERRED)
	desktop_menu.settings_requested.connect(_show_settings, CONNECT_DEFERRED)
	desktop_menu.leave_requested.connect(_leave_battle, CONNECT_DEFERRED)
	_show_menu()
	get_viewport().size_changed.connect(_resize)
	log.info("原版本地菜单启动", {"milliseconds": Time.get_ticks_msec() - started, "godot": Engine.get_version_info().string})

func _process(delta):
	if settings_window != null and settings_window.visible: return
	if host != null: host.advance(delta)
	if panel != null: panel.advance(delta)

func _input(event):
	if controls != null or (settings_window != null and settings_window.visible): return
	if host != null: host.handle_input(event)
	if battle != null and event is InputEventKey and event.physical_keycode == KEY_ESCAPE and not event.pressed: call_deferred("_leave_battle")

func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT and host != null:
		host.reset_input()
		log.debug("窗口失焦, 释放本地输入")

func _resize():
	if menu != null: menu.original__onSizeChangeHandler()
	if battle != null and battle.maze != null: battle.original__onSizeChangeHandler()
	if panel != null: panel.resize()
	if host != null:
		host.camera.resize()
		host.world.sync_view()

func _select_players(count):
	if controls != null: return
	log.info("选择本地人数", {"players": count})
	controls = preload("res://game/presentation/menu/controls_overlay.gd").new()
	add_child(controls)
	controls.initialize(host, count)
	controls.completed.connect(_start_battle, CONNECT_DEFERRED)
	controls.canceled.connect(_cancel_controls, CONNECT_DEFERRED)
	desktop_menu.update_state(false, true)

func _cancel_controls():
	if controls == null: return
	controls.queue_free()
	controls = null
	host.reset_input()
	desktop_menu.update_state(false, false)
	log.info("取消操作选择, 返回人数菜单")

func _show_menu():
	menu = preload("res://game/presentation/menu/local_menu.gd").new()
	menu.players_selected.connect(_select_players)
	menu.initialize(host)
	desktop_menu.update_state(false, false)

func _replay():
	if battle == null and controls == null: _start_battle(settings.values.assignments.duplicate())

func _show_settings():
	if controls != null: return
	host.reset_input()
	settings_window.present(settings.values)
	log.info("打开离线设置")

func _set_volume(value):
	settings.set_volume(value)
	AudioServer.set_bus_volume_db(0, linear_to_db(settings.values.volume))

func _set_quality(value):
	settings.set_quality(value)
	JS.module("QualityManager").original_setQuality(settings.values.quality)

func _close_settings():
	settings.save_settings()
	if session != null: session.controller.lastUpdate = JS.invoke_method("@Date", "now", [])
	JS.module("QualityManager").original_reset()
	host.reset_input()

func _start_battle(assignments):
	if controls != null: controls.queue_free()
	controls = null
	menu.shutdown()
	menu = null
	host.reset_input()
	session = preload("res://game/application/local_session.gd").new()
	session.initialize(assignments)
	settings.set_assignments(assignments)
	settings.save_settings()
	host.bottom_inset = 180.0
	battle = preload("res://game/presentation/battle/local_battle.gd").new()
	battle.leave_requested.connect(_leave_battle, CONNECT_DEFERRED)
	battle.initialize(host, session.controller)
	panel = preload("res://game/presentation/panel/local_panel.gd").new()
	panel.initialize(host, session)
	desktop_menu.update_state(true, false)
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
	settings.save_settings()
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
