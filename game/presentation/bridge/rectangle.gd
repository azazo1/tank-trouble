extends RefCounted

var x = 0.0
var y = 0.0
var width = 0.0
var height = 0.0
var empty:
	get: return width <= 0 or height <= 0

static func create(horizontal = 0, vertical = 0, horizontal_size = 0, vertical_size = 0):
	var result = load("res://game/presentation/bridge/rectangle.gd").new()
	result.x = horizontal
	result.y = vertical
	result.width = horizontal_size
	result.height = vertical_size
	return result

static func union(first, second):
	var left = min(first.x, second.x)
	var top = min(first.y, second.y)
	return create(left, top, max(first.x + first.width, second.x + second.width) - left, max(first.y + first.height, second.y + second.height) - top)

func inflate(horizontal, vertical):
	x -= horizontal
	y -= vertical
	width += horizontal * 2
	height += vertical * 2
	return self
