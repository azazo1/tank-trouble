class_name Projectile
extends Node2D

var velocity := Vector2.ZERO
var owner_id := -1
var lifetime := 8.0
var bounce_count := 0
var tint := Color("#ffd166")
var radius := 5.0
var max_bounces := 8
var trail: Array[Vector2] = []
var projectile_type := "bullet"
var homing_target: Node2D
var homing_acceleration := 40.0
var homing_activation := 2.0
var homing_max_speed := 360.0
var age := 0.0
var maze_hit := false
var atlas: Texture2D

func setup(start: Vector2, direction: Vector2, shooter: int, color: Color, speed: float = 360.0, lifetime_seconds: float = 10.0) -> void:
	position = start
	velocity = direction.normalized() * speed
	owner_id = shooter
	tint = color
	trail = [position]
	projectile_type = "bullet"
	homing_target = null
	age = 0.0
	lifetime = lifetime_seconds
	maze_hit = false
	atlas = load("res://assets/sprites/game_atlas.png")

func setup_homing(start: Vector2, direction: Vector2, shooter: int, color: Color, speed: float, target: Node2D) -> void:
	setup(start, direction, shooter, color, speed, 10.0)
	projectile_type = "homing"
	homing_target = target
	homing_max_speed = speed

func setup_shrapnel(start: Vector2, direction: Vector2, shooter: int, color: Color, speed: float) -> void:
	setup(start, direction, shooter, color, speed, 2.0)
	projectile_type = "shrapnel"
	lifetime = 1.0
	max_bounces = 0

func advance(delta: float, maze: Maze) -> bool:
	lifetime -= delta
	age += delta
	if lifetime <= 0.0:
		return false
	if projectile_type == "homing" and age >= homing_activation and is_instance_valid(homing_target):
		var to_target := (homing_target.global_position - global_position).normalized()
		var desired_velocity := to_target * homing_max_speed
		velocity = velocity.move_toward(desired_velocity, homing_acceleration * delta)
	var next := position
	var hit_x := false
	var hit_y := false
	next.x += velocity.x * delta
	if maze.is_circle_blocked(next, radius):
		next.x = position.x
		hit_x = true
	next.y += velocity.y * delta
	if maze.is_circle_blocked(next, radius):
		next.y = position.y
		hit_y = true
	position = next
	if hit_x:
		velocity.x *= -1.0
		bounce_count += 1
	if hit_y:
		velocity.y *= -1.0
		bounce_count += 1
		maze_hit = true
	if hit_x:
		maze_hit = true
	trail.push_front(position)
	if trail.size() > 8:
		trail.pop_back()
	if bounce_count > max_bounces:
		return false
	queue_redraw()
	return true

func _draw() -> void:
	if atlas:
		var frame := Rect2(251.0, 413.0, 20.0, 20.0)
		if projectile_type == "shrapnel":
			frame = Rect2(771.0, 259.0, 20.0, 20.0)
		var size := frame.size * 0.5
		draw_texture_rect_region(atlas, Rect2(-size * 0.5, size), frame, Color.WHITE)
		return
	for i in range(trail.size() - 1, -1, -1):
		var point: Vector2 = trail[i] - position
		var alpha := 0.05 + 0.08 * float(trail.size() - i)
		draw_circle(point, radius * (0.55 + float(i) * 0.05), Color(tint, alpha))
	draw_circle(Vector2.ZERO, radius + 2.0, Color(1.0, 0.94, 0.68, 0.18))
	draw_circle(Vector2.ZERO, radius, tint)
