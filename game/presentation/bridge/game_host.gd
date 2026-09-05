extends RefCounted

const JS = preload("res://game/runtime/js_support.gd")
var root: WeakRef
var world
var camera
var assets = preload("res://game/presentation/assets/library.gd").new()
var pixel_ratio = 1.0
var add
var sound
var physics = {"arcade": preload("res://game/presentation/particles/arcade_world.gd").new()}
var particles = {"ID": 0}
var rnd
var buttons: Array = []
var tweens: Array = []
var time = {"delta": 0.0, "elapsed": 0.0, "deltaTotal": 0.0, "desiredFps": 60, "events": preload("res://game/presentation/bridge/timer_events.gd").new()}
var input = {"enabled": true, "mousePointer": {"leftButton": {"isDown": false, "reset": func(): return null}}, "keyboard": preload("res://game/presentation/bridge/keyboard.gd").new()}
var scale = {"bounds": {"x": 0, "y": 0}, "scaleFactor": {"x": 1, "y": 1}}
var active_state
var canvas_size = Vector2.ZERO
var state
var pressed_button: WeakRef
var width:
	get: return canvas_size.x if canvas_size.x > 0 else root.get_ref().get_viewport_rect().size.x
var height:
	get: return canvas_size.y if canvas_size.y > 0 else root.get_ref().get_viewport_rect().size.y

func _init(node = null, primary = true):
	if node == null: return
	root = weakref(node)
	state = preload("res://game/presentation/bridge/state_access.gd").new(self)
	if primary: JS.module("GameManager").host = weakref(self)
	pixel_ratio = maxf(1.0, DisplayServer.screen_get_scale()) if DisplayServer.get_name() != "headless" else 1.0
	assets.resolution = 2 if pixel_ratio > 1.0 else 1
	if primary: JS.module("UIConstants").original_scaleForHighDensity(pixel_ratio)
	world = preload("res://game/presentation/bridge/group.gd").create(self)
	node.add_child(world.view)
	camera = preload("res://game/presentation/bridge/camera.gd").new(self)
	add = preload("res://game/presentation/bridge/factory.gd").new(self)
	sound = preload("res://game/presentation/audio/sound_bank.gd").new(node)
	rnd = JS.module("PhaserRandom").create([str(Time.get_ticks_usec())])

func advance(delta):
	time.delta = delta * 1000.0
	time.elapsed = time.delta
	time.deltaTotal += time.delta
	time.events.advance(time.delta)
	world.pre_update(time.delta)
	if active_state != null: active_state.original_update()
	world.original_update()
	for tween in tweens.duplicate():
		tween.advance(time.delta)
		if not tween.active: tweens.erase(tween)
	if physics.has("p2"): physics.p2.advance()
	camera.resize()
	camera.original_update()
	world.original_postUpdate()
	if physics.has("p2"): physics.p2.post_update()
	world.sync_view()

func handle_input(event):
	input.keyboard.handle(event)
	var mouse = JS.module("MouseInputManager")
	if event is InputEventMouseMotion or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		mouse.original_static_set("mouseActivated", true)
		mouse.original_static_set("mousePageX", event.position.x)
		mouse.original_static_set("mousePageY", event.position.y)
	if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT: return
	input.mousePointer.leftButton.isDown = event.pressed
	mouse.original_static_set("mouseActivated", true)
	mouse.original_static_set("mouseDown", event.pressed)
	if event.pressed:
		for index in range(buttons.size() - 1, -1, -1):
			var button = buttons[index].get_ref()
			if button == null: buttons.remove_at(index); continue
			if button.inputEnabled and button.view.is_visible_in_tree() and button.contains(event.position):
				pressed_button = weakref(button)
				if button.on_pressed.is_valid(): JS.invoke(button.on_pressed, [button.callback_context.get_ref()])
				break
	elif pressed_button:
		var button = pressed_button.get_ref()
		pressed_button = null
		if button != null:
			if button.on_released.is_valid(): JS.invoke(button.on_released, [button.callback_context.get_ref()])
			if button.contains(event.position) and button.on_clicked.is_valid(): JS.invoke(button.on_clicked, [button.callback_context.get_ref()])
	world.sync_view()

func reset_input():
	input.keyboard.reset()
	input.mousePointer.leftButton.isDown = false
	JS.module("MouseInputManager").original_static_set("mouseDown", false)
	var enabled = input.enabled
	input.enabled = false
	# 先发送释放状态, 再清除原版输入管理器的变化检测缓存.
	JS.module("Inputs").original_update()
	input.enabled = enabled
	JS.module("Inputs").original_reset()
	if pressed_button != null:
		var button = pressed_button.get_ref()
		pressed_button = null
		if button != null and button.on_released.is_valid(): JS.invoke(button.on_released, [button.callback_context.get_ref()])
