class_name Shell
extends RefCounted

const RADIUS := 6.0
const SPEED := 520.0

var position := Vector2.ZERO
var velocity := Vector2.ZERO
var owner_id := -1
var age := 0.0
var lifetime := 12.0
var bounce_count := 0
var max_bounces := 8
var homing := false
var target_id := -1
var shell_color := Color.WHITE
var trail: Array[Vector2] = []

static func make(at: Vector2, facing: float, shell_owner: int, kind: String, target: int = -1) -> Shell:
	var shell := Shell.new()
	shell.position = at
	shell.velocity = Vector2.RIGHT.rotated(facing) * SPEED
	shell.owner_id = shell_owner
	shell.target_id = target
	shell.homing = kind == "MISSILE"
	shell.shell_color = Color("#ffe58a") if kind != "MISSILE" else Color("#ff796f")
	shell.max_bounces = 12 if kind == "BOUNCE" else (3 if kind == "SHOTGUN" else 8)
	if kind == "MISSILE":
		shell.max_bounces = 15
		shell.lifetime = 10.0
	return shell

func tick(delta: float, walls: Array, tanks: Array) -> Dictionary:
	age += delta
	if age > lifetime:
		return {"expired": true}
	if homing and target_id >= 0 and target_id < tanks.size():
		var target = tanks[target_id]
		if target.alive:
			var desired := position.angle_to_point(target.position)
			var current := velocity.angle()
			velocity = velocity.rotated(clampf(wrapf(desired - current, -PI, PI), -0.045, 0.045))

	var steps := 4
	var step_delta := delta / float(steps)
	for step in steps:
		trail.push_front(position)
		if trail.size() > 7:
			trail.pop_back()
		var next := position + velocity * step_delta
		var collision := _wall_collision(next, walls)
		if collision.has("normal"):
			position = collision.position
			velocity = velocity.bounce(collision.normal)
			bounce_count += 1
			if bounce_count > max_bounces:
				return {"expired": true, "bounce": true}
			return {"bounce": true}
		position = next
		for tank in tanks:
			if not tank.alive or tank.id == owner_id and age < 0.16:
				continue
			if position.distance_to(tank.position) < Tank.RADIUS + RADIUS:
				return {"hit": tank}
	return {}

func _wall_collision(next: Vector2, walls: Array) -> Dictionary:
	for wall in walls:
		var expanded := wall.grow(RADIUS)
		if not expanded.has_point(next):
			continue
		var left := absf(next.x - expanded.position.x)
		var right := absf(next.x - expanded.end.x)
		var top := absf(next.y - expanded.position.y)
		var bottom := absf(next.y - expanded.end.y)
		var distance := minf(minf(left, right), minf(top, bottom))
		var normal := Vector2.ZERO
		if distance == left:
			normal = Vector2.LEFT
		elif distance == right:
			normal = Vector2.RIGHT
		elif distance == top:
			normal = Vector2.UP
		else:
			normal = Vector2.DOWN
		return {"position": next + normal * 3.0, "normal": normal}
	return {}

