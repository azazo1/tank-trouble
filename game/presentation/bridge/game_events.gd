extends RefCounted

static var game_listeners: Array = []
static var round_listeners: Array = []
static var host: WeakRef
static var controller: WeakRef

static func original_getGame():
	return host.get_ref() if host != null else null

static func original_getGameController():
	return controller.get_ref() if controller != null else null

static func original_setGameController(value):
	var previous = original_getGameController()
	if previous != null:
		previous.original_removeGameEventListener(_game_event, null)
		previous.original_removeRoundEventListener(_round_event, null)
	controller = weakref(value) if value != null else null
	if value != null:
		value.original_addGameEventListener(_game_event, null)
		value.original_addRoundEventListener(_round_event, null)

static func _game_event(_context, id, event, data):
	dispatch(game_listeners, id, event, data)

static func _round_event(_context, id, event, data):
	dispatch(round_listeners, id, event, data)

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
