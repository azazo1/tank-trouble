extends "res://game/presentation/bridge/display_object.gd"

var patch = NinePatchRect.new()
var input = {"useHandCursor": false}
var inputEnabled = false
var on_pressed: Callable
var on_released: Callable
var on_clicked: Callable
var callback_context: WeakRef

static func create(host, horizontal, vertical, key, _frame = null, initial_width = 1, initial_height = 1):
	var instance = load("res://game/presentation/bridge/nine_slice.gd").new()
	instance.game = host
	instance.x = horizontal
	instance.y = vertical
	instance.patch.texture = host.assets.texture(key)
	instance.patch.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]: instance.patch.set_patch_margin(side, 11 * host.assets.resolution)
	instance.view.add_child(instance.patch)
	instance.resize(initial_width, initial_height)
	host.buttons.append(weakref(instance))
	return instance

func resize(new_width, new_height):
	intrinsic_size = Vector2(new_width, new_height)
	return null

func sync_view():
	super.sync_view()
	patch.size = intrinsic_size
	patch.position = -anchor.value() * intrinsic_size

func contains(global_position):
	return Rect2(-anchor.value() * intrinsic_size, intrinsic_size).has_point(view.to_local(global_position))
