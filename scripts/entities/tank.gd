class_name Tank
extends Node2D

const BODY_SIZE := Vector2(60.0, 80.0)
const TURN_SPEED := 5.0
const FORWARD_SPEED := 319.0
const BACK_SPEED := 256.0
const COLLISION_RADIUS := 30.0

var player_id := 0
var tank_color := Color("#29b6f6")
var accent_color := Color("#dff7ff")
var alive := true
var shield_time := 0.0
var spawn_shield_time := 0.0
var aimer_time := 0.0
var speed_boost_time := 0.0
var fire_cooldown := 0.0
var weapon := "bullet"
var ammo := 5
var reload_time := 0.0
var spawn_flash := 0.0
var last_move := 0.0
var fire_held := false
var trigger_pulled := false
var left_barrel := false
var bullets_fired := 0
var shotgun_reload := 0.0
var laser_fired := false
var laser_time := 0.0
var homing_launched := false
var homing_activation := 0.0
var gatling_charge := 0.0
var gatling_time_since_fire := 0.0
var gatling_new_burst := true
var atlas: Texture2D

const ATLAS_FRAMES := {
	"base": Rect2(203.0, 557.0, 68.0, 84.0),
	"tread": Rect2(1715.0, 131.0, 12.0, 80.0),
	"turret0": Rect2(405.0, 643.0, 68.0, 82.0),
	"turret1": Rect2(1951.0, 1233.0, 68.0, 82.0),
	"turret2": Rect2(739.0, 1087.0, 68.0, 82.0),
	"turret3": Rect2(809.0, 1087.0, 68.0, 82.0),
	"turret4": Rect2(527.0, 1113.0, 68.0, 82.0),
	"turret5": Rect2(405.0, 1185.0, 68.0, 82.0),
	"turret6": Rect2(597.0, 1113.0, 68.0, 82.0),
}

func setup(id: int, color: Color, spawn: Vector2, facing: float) -> void:
	player_id = id
	tank_color = color
	accent_color = color.lightened(0.55)
	position = spawn
	rotation = facing
	alive = true
	shield_time = 0.0
	spawn_shield_time = 0.0
	aimer_time = 0.0
	speed_boost_time = 0.0
	fire_cooldown = 0.0
	weapon = "bullet"
	ammo = 5
	reload_time = 0.0
	spawn_flash = 0.9
	fire_held = false
	gatling_charge = 0.0
	trigger_pulled = false
	left_barrel = false
	bullets_fired = 0
	shotgun_reload = 0.0
	laser_fired = false
	laser_time = 0.0
	homing_launched = false
	homing_activation = 0.0
	gatling_time_since_fire = 0.0
	gatling_new_burst = true
	atlas = load("res://assets/sprites/game_atlas.png")
	visible = true
	queue_redraw()

func reset_for_respawn(spawn: Vector2, facing: float) -> void:
	setup(player_id, tank_color, spawn, facing)

func kill() -> void:
	alive = false
	fire_held = false
	gatling_charge = 0.0
	trigger_pulled = false
	visible = false

func tick(delta: float) -> void:
	if fire_cooldown > 0.0:
		fire_cooldown -= delta
	if reload_time > 0.0:
		reload_time -= delta
		if reload_time <= 0.0:
			weapon = "bullet"
			ammo = 5
	if shotgun_reload > 0.0:
		shotgun_reload = maxf(0.0, shotgun_reload - delta)
	if laser_fired:
		laser_time += delta
		if laser_time > 0.8:
			laser_fired = false
			laser_time = 0.0
	if homing_launched:
		homing_activation = maxf(0.0, homing_activation - delta)
	if shield_time > 0.0:
		shield_time -= delta
	if spawn_shield_time > 0.0:
		spawn_shield_time -= delta
	if aimer_time > 0.0:
		aimer_time -= delta
	if speed_boost_time > 0.0:
		speed_boost_time -= delta
	if spawn_flash > 0.0:
		spawn_flash -= delta
	queue_redraw()

func _draw() -> void:
	if not alive:
		return
	if atlas:
		_draw_atlas_tank()
		return
	var body := Rect2(-BODY_SIZE.x * 0.5, -BODY_SIZE.y * 0.5, BODY_SIZE.x, BODY_SIZE.y)
	# 绘制阴影和履带.
	draw_tank_shadow(Vector2(0.0, 6.0), Vector2(31.0, 39.0), Color(0.0, 0.0, 0.0, 0.34))
	draw_rect(Rect2(-27.0, -31.0, 12.0, 62.0), Color("#27343c"), true)
	draw_rect(Rect2(15.0, -31.0, 12.0, 62.0), Color("#27343c"), true)
	for y in range(-26, 30, 11):
		draw_line(Vector2(-26.0, y), Vector2(-16.0, y), Color("#6d7c83"), 2.0)
		draw_line(Vector2(16.0, y), Vector2(26.0, y), Color("#6d7c83"), 2.0)
	draw_rect(body, tank_color, true)
	draw_rect(body, accent_color, false, 3.0)
	# 炮塔沿本地上方向绘制, 保持原版坦克轮廓.
	draw_circle(Vector2(0.0, -10.0), 19.0, tank_color.darkened(0.18))
	draw_circle(Vector2(0.0, -10.0), 15.0, tank_color)
	draw_rect(Rect2(-6.0, -55.0, 12.0, 45.0), accent_color, true)
	draw_rect(Rect2(-5.0, -57.0, 10.0, 10.0), Color("#edf6f5"), true)
	draw_circle(Vector2(0.0, -10.0), 4.0, Color("#1a252c"))
	if shield_time > 0.0 or spawn_shield_time > 0.0:
		var pulse := 1.0 + sin(Time.get_ticks_msec() * 0.008) * 0.04
		draw_arc(Vector2.ZERO, 49.0 * pulse, 0.0, TAU, 48, Color(0.5, 0.9, 1.0, 0.7), 4.0)
	if aimer_time > 0.0:
		draw_line(Vector2.ZERO, Vector2.UP * 60.0, Color(1.0, 0.9, 0.35, 0.7), 2.0)
	if spawn_flash > 0.0:
		draw_arc(Vector2.ZERO, 44.0 + (0.9 - spawn_flash) * 22.0, 0.0, TAU, 48, Color(1.0, 1.0, 1.0, spawn_flash * 0.65), 3.0)

func draw_tank_shadow(center: Vector2, radii: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(32):
		var angle := TAU * float(i) / 32.0
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	draw_colored_polygon(points, color)

func _draw_atlas_tank() -> void:
	var tint := Color(1.0, 1.0, 1.0, 1.0)
	var frame_name := "turret0"
	match weapon:
		"laser": frame_name = "turret1"
		"double": frame_name = "turret2"
		"shotgun": frame_name = "turret3"
		"homing": frame_name = "turret4"
		"mine": frame_name = "turret5"
		"gatling": frame_name = "turret6"
	var base_rect: Rect2 = ATLAS_FRAMES["base"]
	var tread_rect: Rect2 = ATLAS_FRAMES["tread"]
	var turret_rect: Rect2 = ATLAS_FRAMES[frame_name]
	var base_size := base_rect.size * 0.5
	var tread_size := tread_rect.size * 0.5
	var turret_size := turret_rect.size * 0.5
	draw_texture_rect_region(atlas, Rect2(-base_size * 0.5, base_size), base_rect, tint)
	draw_texture_rect_region(atlas, Rect2(Vector2(-30.0, -40.0), tread_size), tread_rect, tint)
	draw_texture_rect_region(atlas, Rect2(Vector2(18.0, -40.0), tread_size), tread_rect, tint)
	draw_texture_rect_region(atlas, Rect2(-turret_size * 0.5, turret_size), turret_rect, tint)
	if shield_time > 0.0 or spawn_shield_time > 0.0:
		var pulse := 1.0 + sin(Time.get_ticks_msec() * 0.008) * 0.04
		draw_arc(Vector2.ZERO, 49.0 * pulse, 0.0, TAU, 48, Color(0.5, 0.9, 1.0, 0.7), 4.0)
	if aimer_time > 0.0:
		draw_line(Vector2.ZERO, Vector2.UP * 60.0, Color(1.0, 0.9, 0.35, 0.7), 2.0)
	if spawn_flash > 0.0:
		draw_arc(Vector2.ZERO, 44.0 + (0.9 - spawn_flash) * 22.0, 0.0, TAU, 48, Color(1.0, 1.0, 1.0, spawn_flash * 0.65), 3.0)
