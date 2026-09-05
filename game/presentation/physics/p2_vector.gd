extends RefCounted

var owner: WeakRef
var property: String
var factor: float
var x:
	get: return owner.get_ref()._get(property)[0] * factor
	set(value): _write(0, value)
var y:
	get: return owner.get_ref()._get(property)[1] * factor
	set(value): _write(1, value)

func _init(body, key, conversion = -20.0):
	owner = weakref(body)
	property = key
	factor = conversion

func _write(index, value):
	var body = owner.get_ref()
	body.world.get_ref().engine.write_component(body.data["$p2"], property, index, value / factor)

func setTo(horizontal = 0, vertical = null):
	x = horizontal
	y = horizontal if vertical == null else vertical
	return self
