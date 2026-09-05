extends RefCounted

const JS = preload("res://game/runtime/js_support.gd")
var root: WeakRef
var world
var assets = preload("res://game/presentation/assets/library.gd").new()
var pixel_ratio = 1.0
var add
var sound
var physics = {}
var buttons: Array = []
var tweens: Array = []
var time = {"delta": 0.0, "elapsed": 0.0, "events": preload("res://game/presentation/bridge/timer_events.gd").new()}
var input = {"enabled": true, "mousePointer": {"leftButton": {"isDown": false, "reset": func(): return null}}, "keyboard": preload("res://game/presentation/bridge/keyboard.gd").new()}
var scale = {"bounds": {"x": 0, "y": 0}, "scaleFactor": {"x": 1, "y": 1}}
var active_state
var state
var pressed_button: WeakRef
var width:
	get: return root.get_ref().get_viewport_rect().size.x
var height:
	get: return root.get_ref().get_viewport_rect().size.y

func _init(node = null):
	if node == null: return
	root = weakref(node)
	state = preload("res://game/presentation/bridge/state_access.gd").new(self)
	JS.module("GameManager").host = weakref(self)
	pixel_ratio = maxf(1.0, DisplayServer.screen_get_scale()) if DisplayServer.get_name() != "headless" else 1.0
	assets.resolution = 2 if pixel_ratio > 1.0 else 1
	JS.module("UIConstants").original_scaleForHighDensity(pixel_ratio)
	world = preload("res://game/presentation/bridge/group.gd").create(self)
	node.add_child(world.view)
	add = preload("res://game/presentation/bridge/factory.gd").new(self)
	sound = preload("res://game/presentation/audio/sound_bank.gd").new(node)

func advance(delta):
	time.delta = delta * 1000.0
	time.elapsed = time.delta
	world.pre_update(time.delta)
	time.events.advance(time.delta)
	for tween in tweens.duplicate():
		tween.advance(time.delta)
		if not tween.active: tweens.erase(tween)
	world.original_update()
	world.sync_view()

func handle_input(event):
	input.keyboard.handle(event)
	var mouse = JS.module("MouseInputManager")
	if event is InputEventMouseMotion:
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
	JS.module("Inputs").original_reset()
