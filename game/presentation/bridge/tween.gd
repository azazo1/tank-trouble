extends RefCounted

const JS = preload("res://game/runtime/js_support.gd")
var target
var host: WeakRef
var start: Dictionary = {}
var destination: Dictionary = {}
var duration = 0.0
var delay = 0.0
var elapsed = 0.0
var easing = "Linear.None"
var active = false
var onComplete = preload("res://game/presentation/bridge/event_signal.gd").new()

func original_to(values, milliseconds, curve, auto_start = false, wait = 0.0):
	destination = values
	duration = milliseconds
	delay = wait
	easing = curve
	for key in values: start[key] = JS.get_property(target, key)
	active = auto_start
	return self

func original_stop():
	active = false
	return self

func advance(milliseconds):
	if not active: return
	elapsed += milliseconds
	if elapsed < delay: return
	var progress = minf((elapsed - delay) / duration, 1.0)
	var value = progress
	if easing == "Back.Out":
		var k = progress - 1.0
		value = k * k * (2.70158 * k + 1.70158) + 1.0
	elif easing == "Quadratic.InOut":
		var k = progress * 2.0
		value = 0.5 * k * k if k < 1 else -0.5 * ((k - 1) * (k - 3) - 1)
	for key in destination: JS.set_property(target, key, start[key] + (destination[key] - start[key]) * value)
	if progress == 1.0:
		active = false
		onComplete.dispatch()
		onComplete.removeAll()
