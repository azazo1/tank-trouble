class_name BulletWeapon
extends Weapon

var num_bullets := 0
var trigger_pulled := false
var bullets_fired := 0
var time_alive := 0.0

func _init(weapon_id: String, owner_id: int, model: Node, bullets: int = GameConstants.BULLET_AMMO_COUNT) -> void:
	super._init(weapon_id, owner_id, -1, model)
	num_bullets = bullets

func fire() -> bool:
	if not trigger_pulled:
		trigger_pulled = true
		if bullets_fired < num_bullets:
			bullets_fired += 1
			weapon_fired.emit(self)
			return true
		weapon_empty.emit(self)
	return false

func get_projectile_specs(tank: Tank, _rng: RandomNumberGenerator) -> Array[Dictionary]:
	var sin_rot := sin(tank.rotation)
	var cos_rot := cos(tank.rotation)
	return [{"position": tank.position + Vector2(sin_rot, -cos_rot) * GameConstants.BULLET_OFFSET, "velocity": Vector2(sin_rot, -cos_rot) * GameConstants.BULLET_SPEED, "radius": GameConstants.BULLET_RADIUS, "lifetime": GameConstants.BULLET_MAX_LIFETIME, "kind": "bullet"}]

func release() -> void:
	trigger_pulled = false

func reload(projectile: Projectile) -> void:
	if time_alive >= projectile.age:
		bullets_fired -= 1

func update(delta_time: float) -> void:
	time_alive += delta_time

func is_default() -> bool:
	return true
