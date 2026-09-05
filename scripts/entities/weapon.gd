class_name Weapon
extends RefCounted

signal weapon_fired(weapon: Weapon)
signal weapon_delayed_fire(player_id: int)
signal weapon_empty(weapon: Weapon)

var id := ""
var player_id := -1
var type := -1
var round_model: Node

func _init(weapon_id: String, owner_id: int, weapon_type: int, model: Node = null) -> void:
	id = weapon_id
	player_id = owner_id
	type = weapon_type
	round_model = model

func fire() -> bool:
	return false

func get_projectile_specs(_tank: Tank, _rng: RandomNumberGenerator) -> Array[Dictionary]:
	return []

func get_trap_specs(_tank: Tank) -> Array[Dictionary]:
	return []

func release() -> void:
	pass

func reload(_projectile: Projectile) -> void:
	pass

func movement_locked() -> bool:
	return false

func update(_delta_time: float) -> void:
	pass

func done() -> bool:
	return false

func is_default() -> bool:
	return false
