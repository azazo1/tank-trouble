extends RefCounted

var isPaused = false

func enable(sprite, _children = false):
	if sprite.body == null: sprite.body = preload("res://game/presentation/particles/arcade_body.gd").new(sprite)

func velocityFromAngle(angle, speed, output):
	return output.setTo(cos(deg_to_rad(angle)) * speed, sin(deg_to_rad(angle)) * speed)
