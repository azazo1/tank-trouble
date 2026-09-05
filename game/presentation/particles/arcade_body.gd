extends RefCounted

const Point = preload("res://game/presentation/bridge/point.gd")
var actor: WeakRef
var velocity = Point.create()
var acceleration = Point.create()
var drag = Point.create()
var gravity = Point.create()
var bounce = Point.create()
var angularVelocity = 0.0
var angularDrag = 0.0
var checkCollision = {"none": true}
var collideWorldBounds = false
var skipQuadTree = true
var x:
	get: return actor.get_ref().x
	set(value): actor.get_ref().x = value
var y:
	get: return actor.get_ref().y
	set(value): actor.get_ref().y = value

func _init(sprite):
	actor = weakref(sprite)

func updateBounds(): pass
func addToWorld(): pass
func removeFromWorld(): pass

func reset(horizontal, vertical):
	velocity.setTo(0)
	x = horizontal
	y = vertical

func advance(delta):
	velocity.x = _compute_velocity(velocity.x, acceleration.x, drag.x, gravity.x, delta)
	velocity.y = _compute_velocity(velocity.y, acceleration.y, drag.y, gravity.y, delta)
	angularVelocity = _compute_velocity(angularVelocity, 0.0, angularDrag, 0.0, delta)
	x += velocity.x * delta
	y += velocity.y * delta
	actor.get_ref().angle += angularVelocity * delta

func _compute_velocity(speed, accel, resistance, grav, delta):
	speed += grav * delta
	if accel != 0: speed += accel * delta
	elif resistance != 0:
		var change = resistance * delta
		if speed - change > 0: speed -= change
		elif speed + change < 0: speed += change
		else: speed = 0.0
	return clampf(speed, -10000.0, 10000.0)
