extends RefCounted

static var game_listeners: Array = []
static var round_listeners: Array = []

static func original_addGameEventListener(callback, context):
	game_listeners.append({"method": callback.get_method(), "context": weakref(context)})

static func original_addRoundEventListener(callback, context):
	round_listeners.append({"method": callback.get_method(), "context": weakref(context)})

static func original_removeGameEventListener(callback, context):
	_remove(game_listeners, callback, context)

static func original_removeRoundEventListener(callback, context):
	_remove(round_listeners, callback, context)

static func _remove(listeners, callback, context):
	for i in range(listeners.size() - 1, -1, -1):
		if listeners[i].method == callback.get_method() and listeners[i].context.get_ref() == context: listeners.remove_at(i)

static func dispatch(listeners, id, event, data):
	for item in listeners.duplicate():
		var context = item.context.get_ref()
		if context != null: context.call(item.method, context, id, event, data)
