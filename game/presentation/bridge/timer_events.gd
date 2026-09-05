extends RefCounted

const JS = preload("res://game/runtime/js_support.gd")
var pending: Array = []
var now = 0.0

func original_add(delay, callback, _context = null):
	var event = {"at": now + delay, "callback": callback, "cancelled": false}
	pending.append(event)
	return event

func original_remove(event):
	event.cancelled = true

func advance(milliseconds):
	now += milliseconds
	for event in pending.duplicate():
		if event.cancelled: pending.erase(event)
		elif event.at <= now:
			pending.erase(event)
			JS.invoke(event.callback, [])
