extends Control

signal completed(assignments)
signal canceled
const JS = preload("res://game/runtime/js_support.gd")
var host: WeakRef
var count = 1
var assignments: Array = []
var options: Dictionary = {}
var headline: Label
var username: Label
var icon: Control
var shade: ColorRect
var stack: VBoxContainer
var selected = ""
var down = false
var elapsed = 0.0
var selected_elapsed = 0.0
var log = preload("res://game/runtime/original_log.gd").create("Controls")

func initialize(game, player_count):
	host = weakref(game)
	count = player_count
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade = ColorRect.new()
	shade.color = Color(0, 0, 0, 0.8)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	stack = VBoxContainer.new()
	stack.add_theme_constant_override("separation", 10)
	add_child(stack)
	resized.connect(_layout)
	stack.minimum_size_changed.connect(_layout, CONNECT_DEFERRED)
	var font = SystemFont.new()
	font.font_names = PackedStringArray(["Arial"])
	stack.add_theme_font_override("font", font)
	headline = _label(stack, "", 28)
	username = _label(stack, "", 42)
	var icon_center = CenterContainer.new()
	stack.add_child(icon_center)
	icon = preload("res://game/presentation/menu/icon_canvas.gd").new()
	icon.custom_minimum_size = Vector2(320, 192)
	icon_center.add_child(icon)
	_label(stack, "Select your controls", 28)
	var row = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 0)
	stack.add_child(row)
	for id in ["WASDKeys", "arrowKeys", "mouse"]:
		var option = TextureButton.new()
		option.ignore_texture_size = true
		option.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		option.custom_minimum_size = Vector2({"WASDKeys": 245, "arrowKeys": 365, "mouse": 190}[id], 140)
		option.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		option.focus_mode = Control.FOCUS_NONE
		option.pressed.connect(_select.bind(id))
		row.add_child(option)
		options[id] = option
	_show_player()
	call_deferred("_layout")
	log.info("打开原版操作选择", {"players": count})

func _layout():
	if stack == null: return
	var content_size = stack.get_combined_minimum_size()
	var available = (size - Vector2(32, 32)).max(Vector2.ONE)
	var content_scale = minf(1.0, minf(available.x / maxf(content_size.x, 1.0), available.y / maxf(content_size.y, 1.0)))
	stack.size = content_size
	stack.scale = Vector2.ONE * content_scale
	stack.position = (size - content_size * content_scale) * 0.5

func _label(parent, contents, font_size):
	var label = Label.new()
	label.text = contents
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color.WHITE)
	parent.add_child(label)
	return label

func _show_player():
	var catalog = JS.module("Backend")
	catalog._load_captured()
	var profile = catalog.captured.guests[assignments.size()]
	headline.text = ("Player %d:\n" % [assignments.size() + 1] if count > 1 else "") + "The scientists have named you"
	username.text = profile.username
	icon.texture = preload("res://game/presentation/assets/tank_icon.gd").texture(profile, 320, host.get_ref().assets.resolution)
	icon.queue_redraw()
	selected = ""
	selected_elapsed = 0.0
	_update_options()

func _update_options():
	var game = host.get_ref()
	var suffix = "@2x" if game.assets.resolution == 2 else ""
	for id in options:
		var button = options[id]
		var used = assignments.has(id)
		button.disabled = used or not selected.is_empty()
		button.modulate.a = 0.2 if used else 1.0
		var state = "Selected" if id == selected else ("Down" if down and not used else "")
		button.texture_normal = game.assets.load_texture("res://assets/original/images/inputs/%s%s%s.png" % [id, state, suffix])
		button.texture_disabled = button.texture_normal
		button.texture_pressed = game.assets.load_texture("res://assets/original/images/inputs/%sActive%s.png" % [id, suffix])

func _select(id):
	if assignments.has(id) or not selected.is_empty(): return
	selected = id
	selected_elapsed = 0.0
	_update_options()
	log.info("选择操作方案", {"player": assignments.size() + 1, "controls": id})

func _input(event):
	if not event is InputEventKey or event.echo: return
	if assignments.size() == count: return
	if event.physical_keycode == KEY_ESCAPE and not event.pressed:
		set_process(false)
		set_process_input(false)
		get_viewport().set_input_as_handled()
		canceled.emit()
		return
	var id = "WASDKeys" if event.physical_keycode == KEY_Q else ("arrowKeys" if event.physical_keycode == KEY_SPACE else "")
	if id.is_empty() or assignments.has(id) or not selected.is_empty(): return
	options[id].set_pressed_no_signal(event.pressed)
	if not event.pressed: _select(id)
	get_viewport().set_input_as_handled()

func _process(delta):
	elapsed += delta
	if elapsed >= 0.5:
		elapsed -= 0.5
		down = not down
		_update_options()
	if selected.is_empty(): return
	selected_elapsed += delta * 1000.0
	if selected_elapsed < JS.get_property(JS.module("UIConstants"), "CONTROL_SELECTED_WAIT_TIME"): return
	assignments.append(selected)
	if assignments.size() == count:
		set_process(false)
		completed.emit(assignments.duplicate())
	else: _show_player()
