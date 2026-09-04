class_name Tank
extends RefCounted

const RADIUS := 18.0
const MAX_SPEED := 184.0
const ACCELERATION := 540.0
const TURN_SPEED := 3.35

var id: int
var label: String
var color: Color
var position := Vector2.ZERO
var angle := 0.0
var velocity := Vector2.ZERO
var score := 0
var alive := true
var is_ai := false
var controls: Dictionary = {}
var weapon := "BULLET"
var weapon_time := 0.0
var shield_time := 0.0
var fire_cooldown := 0.0
var ai_phase := 0.0

func _init(tank_id: int, tank_label: String, tank_color: Color, ai: bool = false) -> void:
	id = tank_id
	label = tank_label
	color = tank_color
	is_ai = ai
	ai_phase = float(tank_id) * 0.9

func reset(at: Vector2, facing: float) -> void:
	position = at
	angle = facing
	velocity = Vector2.ZERO
	alive = true
	weapon = "BULLET"
	weapon_time = 0.0
	shield_time = 0.0
	fire_cooldown = 0.5

func tick_timers(delta: float) -> void:
	fire_cooldown = maxf(0.0, fire_cooldown - delta)
	weapon_time = maxf(0.0, weapon_time - delta)
	shield_time = maxf(0.0, shield_time - delta)
	if weapon_time <= 0.0 and weapon != "BULLET" and weapon != "SHIELD":
		weapon = "BULLET"

func physics_step(delta: float, command: Vector2, walls: Array, tanks: Array, bounds: Rect2) -> void:
	if not alive:
		return
	var turn := clampf(command.x, -1.0, 1.0)
	var drive := clampf(command.y, -1.0, 1.0)
	angle += turn * TURN_SPEED * delta * (0.72 if drive < -0.2 else 1.0)
	var forward := Vector2.RIGHT.rotated(angle)
	var target_velocity := forward * drive * MAX_SPEED
	velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)
	if absf(drive) < 0.05:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * 1.35 * delta)
	var next := position + velocity * delta
	var candidate_x := Vector2(next.x, position.y)
	if not _blocked(candidate_x, walls, tanks, self, bounds):
		position.x = candidate_x.x
	else:
		velocity.x = 0.0
	var candidate_y := Vector2(position.x, next.y)
	if not _blocked(candidate_y, walls, tanks, self, bounds):
		position.y = candidate_y.y
	else:
		velocity.y = 0.0

func receive_hit() -> bool:
	if not alive:
		return false
	if shield_time > 0.0:
		shield_time = 0.0
		return false
	alive = false
	velocity = Vector2.ZERO
	return true

func arm_weapon(kind: String) -> void:
	if kind == "SHIELD":
		shield_time = 8.0
		return
	weapon = kind
	weapon_time = 12.0

func _blocked(point: Vector2, walls: Array, tanks: Array, self_tank: Tank, bounds: Rect2) -> bool:
	if not bounds.grow(-RADIUS - 2.0).has_point(point):
		return true
	for wall in walls:
		if wall.grow(RADIUS).has_point(point):
			return true
	for other in tanks:
		if other == self_tank or not other.alive:
			continue
		if point.distance_to(other.position) < RADIUS * 1.7:
			return true
	return false

