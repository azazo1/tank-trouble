extends RefCounted

var listeners: Array = []

func add(callback, context = null):
	listeners.append({"callback": callback, "context": weakref(context) if context is Object else null, "once": false})
	return self

func addOnce(callback, context = null):
	add(callback, context)
	listeners.back().once = true
	return self

func dispatch(arguments = []):
	for listener in listeners.duplicate():
		if listener.once: listeners.erase(listener)
		if listener.context == null or listener.context.get_ref() != null:
			var context = listener.context.get_ref() if listener.context != null else null
			preload("res://game/runtime/js_support.gd").invoke_context(listener.callback, context, arguments)

func removeAll():
	listeners.clear()
