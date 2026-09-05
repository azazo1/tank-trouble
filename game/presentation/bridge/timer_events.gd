extends RefCounted

const JS = preload("res://game/runtime/js_support.gd")
var pending: Array = []
var now = 0.0

func original_add(delay, callback, context = null):
	var event = {"at": now + delay, "callback": callback, "context": weakref(context) if context is Object else null, "cancelled": false}
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
			JS.invoke_context(event.callback, event.context.get_ref() if event.context != null else null, [])
