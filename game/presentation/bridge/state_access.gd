extends RefCounted

var host: WeakRef

func _init(game):
	host = weakref(game)

func getCurrentState():
	return host.get_ref().active_state
