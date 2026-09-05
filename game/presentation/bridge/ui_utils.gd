extends RefCounted

static func original_getLoadedAssetResolutionScale(pixel_ratio):
	return 2.0 if pixel_ratio > 1.0 else 1.0

static func original_computeButtonTextY(_size, _font_baseline):
	var constants = load("res://game/runtime/js_support.gd").module("UIConstants")
	return (constants.original_static_get("BUTTON_SHADOW_HEIGHT_TOP") - constants.original_static_get("BUTTON_SHADOW_HEIGHT_BOTTOM")) / 2.0

static func original_addButton(button, pressed, released, clicked, context):
	button.on_pressed = pressed
	button.on_released = released
	button.on_clicked = clicked
	button.callback_context = weakref(context)
