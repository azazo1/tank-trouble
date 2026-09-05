extends RefCounted

var host: WeakRef

func _init(game = null):
	if game != null: host = weakref(game)

func existing(object):
	return host.get_ref().world.addChild(object)

func image(x, y, key, _frame = null, parent = null):
	var game = host.get_ref()
	var sprite = preload("res://game/presentation/bridge/image.gd").new().initialize(game, x, y, game.assets.texture(key))
	return (parent if parent != null else game.world).addChild(sprite)

func tween(target):
	var result = preload("res://game/presentation/bridge/tween.gd").new()
	result.target = target
	result.host = host
	host.get_ref().tweens.append(result)
	return result

func group(parent = null):
	var game = host.get_ref()
	var result = preload("res://game/presentation/bridge/group.gd").create(game)
	return (parent if parent != null else game.world).addChild(result)
