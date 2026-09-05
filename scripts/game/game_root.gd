class_name GameRoot
extends Node2D

enum Screen { MENU, PLAY, RESULTS }
enum Mode { CLASSIC, DEATHMATCH }
enum RoundPhase { COUNTDOWN, ACTIVE, ROUND_END }

const MAX_SCORE := 3
const ROUND_LIMIT := 60.0
const BULLET_COLOR := Color("#ffd166")
const PLAYER_COLORS := [Color("#29b6f6"), Color("#ff6b6b")]
const PICKUP_TYPES := ["double", "shotgun", "laser", "homing", "gatling", "shield", "aimer", "speed", "mine"]
const BULLET_SPEED := 360.0
const LASER_SPEED := 3600.0
const LASER_LOCK_TIME := 0.2
const LASER_BEAM_TIME := 0.8
const DOUBLE_BARREL_SPACING := 9.0
const SHOTGUN_PELLETS := 20
const SHOTGUN_SPREAD := 0.3
const HOMING_SPEED := 360.0
const HOMING_LIFETIME := 10.0
const MINE_LAUNCH_SPEED := 250.0
const MINE_ARM_TIME := 0.5
const MINE_RADIUS := 16.0
const MINE_EXPLOSION_RADIUS := 84.0
const MINE_SHRAPNEL_COUNT := 30
const GATLING_CHARGE_TIME := 0.5
const GATLING_FIRE_RATE := 0.12
const RESPAWN_DELAY := 1.0

var screen := Screen.MENU
var mode := Mode.CLASSIC
var phase := RoundPhase.COUNTDOWN
var round_number := 1
var countdown := 3.0
var round_time := 0.0
var round_limit := ROUND_LIMIT
var round_end_delay := 0.0
var winner := -1
var match_winner := -1
var scores := [0, 0]

var maze: Maze
var effects: WorldEffects
var hud: GameHud
var audio: GameAudio
var tanks: Array[Tank] = []
var projectiles: Array[Projectile] = []
var pickups: Array[Dictionary] = []
var mines: Array[Dictionary] = []
var laser_beams: Array[Dictionary] = []
var explosions: Array[Dictionary] = []
var respawn_timers := [0.0, 0.0]
var pickup_timer := 4.0
var storm_active := false
var storm_elapsed := 0.0
var storm_next_shrink := 0.0
var storm_bounds := Rect2(0.0, 88.0, 1200.0, 600.0)
var last_countdown_value := 4
var menu_texture: Texture2D
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	menu_texture = load("res://assets/sprites/menu_background.png")
	maze = Maze.new()
	maze.name = "Maze"
	add_child(maze)
	effects = WorldEffects.new()
	effects.name = "WorldEffects"
	effects.bind(self)
	add_child(effects)
	audio = GameAudio.new()
	audio.name = "GameAudio"
	add_child(audio)
	hud = GameHud.new()
	hud.name = "GameHud"
	hud.bind(self, menu_texture)
	add_child(hud)
	maze.hide()
	GameLog.info("Tank Trouble local edition ready")
	queue_redraw()

func _process(delta: float) -> void:
	match screen:
		Screen.PLAY:
			_process_match(delta)
		Screen.RESULTS:
			_process_results(delta)
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key: Key = event.keycode
		if key == KEY_ESCAPE:
			if screen == Screen.MENU:
				get_tree().quit()
			else:
				return_to_menu()
			get_viewport().set_input_as_handled()
			return
		if screen == Screen.MENU:
			if key == KEY_TAB:
				mode = Mode.DEATHMATCH if mode == Mode.CLASSIC else Mode.CLASSIC
			elif key == KEY_1:
				mode = Mode.CLASSIC
			elif key == KEY_2:
				mode = Mode.DEATHMATCH
			elif key == KEY_ENTER or key == KEY_KP_ENTER:
				start_match(mode)
		elif screen == Screen.RESULTS:
			if key == KEY_ENTER or key == KEY_KP_ENTER:
				start_match(mode)
		elif screen == Screen.PLAY and key == KEY_R:
			start_match(mode)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if screen == Screen.MENU:
			if Rect2(72.0, 528.0, 556.0, 72.0).has_point(event.position):
				start_match(mode)
			elif Rect2(72.0, 246.0, 270.0, 104.0).has_point(event.position):
				mode = Mode.CLASSIC
			elif Rect2(358.0, 246.0, 270.0, 104.0).has_point(event.position):
				mode = Mode.DEATHMATCH

func start_match(selected_mode: int) -> void:
	mode = selected_mode
	screen = Screen.PLAY
	match_winner = -1
	scores = [0, 0]
	round_number = 1
	respawn_timers = [0.0, 0.0]
	storm_active = false
	storm_elapsed = 0.0
	storm_next_shrink = 0.0
	storm_bounds = Rect2(0.0, 88.0, maze.width * Maze.TILE_SIZE, maze.height * Maze.TILE_SIZE)
	_create_tanks()
	_begin_round()
	maze.show()
	GameLog.info("Match started: %s" % ("classic" if mode == Mode.CLASSIC else "deathmatch"))

func return_to_menu() -> void:
	screen = Screen.MENU
	phase = RoundPhase.COUNTDOWN
	maze.hide()
	for tank in tanks:
		if is_instance_valid(tank):
			tank.queue_free()
	tanks.clear()
	for projectile in projectiles:
		if is_instance_valid(projectile):
			projectile.queue_free()
	projectiles.clear()
	pickups.clear()
	mines.clear()
	laser_beams.clear()
	explosions.clear()

func _create_tanks() -> void:
	for tank in tanks:
		if is_instance_valid(tank):
			tank.queue_free()
	tanks.clear()
	for i in range(2):
		var tank := Tank.new()
		tank.name = "TankP%d" % (i + 1)
		tank.z_index = 20
		tank.player_id = i
		tank.tank_color = PLAYER_COLORS[i]
		add_child(tank)
		tanks.append(tank)

func _begin_round() -> void:
	phase = RoundPhase.COUNTDOWN
	countdown = 3.0
	round_time = 0.0
	round_end_delay = 0.0
	winner = -1
	pickup_timer = 4.0
	last_countdown_value = 4
	respawn_timers = [0.0, 0.0]
	for projectile in projectiles:
		if is_instance_valid(projectile):
			projectile.queue_free()
	projectiles.clear()
	pickups.clear()
	mines.clear()
	laser_beams.clear()
	explosions.clear()
	maze.build_for_players(tanks.size())
	storm_active = false
	storm_elapsed = 0.0
	storm_next_shrink = 0.0
	storm_bounds = Rect2(0.0, 88.0, maze.width * Maze.TILE_SIZE, maze.height * Maze.TILE_SIZE)
	var spawn_positions := [maze.get_spawn_position(0), maze.get_spawn_position(1)]
	var spawn_rotations := [0.0, PI]
	for i in range(tanks.size()):
		tanks[i].reset_for_respawn(spawn_positions[i], spawn_rotations[i])
		if mode == Mode.DEATHMATCH:
			tanks[i].spawn_shield_time = 10.0
	GameLog.info("Round %d ready" % round_number)

func _process_match(delta: float) -> void:
	for tank in tanks:
		tank.tick(delta)
	for i in range(laser_beams.size() - 1, -1, -1):
		laser_beams[i]["time"] = float(laser_beams[i]["time"]) - delta
		if float(laser_beams[i]["time"]) <= 0.0:
			laser_beams.remove_at(i)
	for i in range(explosions.size() - 1, -1, -1):
		explosions[i]["time"] = float(explosions[i]["time"]) - delta
		if float(explosions[i]["time"]) <= 0.0:
			explosions.remove_at(i)

	if phase == RoundPhase.COUNTDOWN:
		countdown -= delta
		var countdown_value := int(ceil(countdown))
		if countdown_value < last_countdown_value and countdown_value >= 1:
			audio.play("countdown")
			last_countdown_value = countdown_value
		if countdown <= 0.0:
			phase = RoundPhase.ACTIVE
			GameLog.info("Round %d active" % round_number)
		return
	if phase == RoundPhase.ROUND_END:
		round_end_delay -= delta
		if round_end_delay <= 0.0:
			_finish_round()
		return

	round_time += delta
	_update_storm(delta)
	for i in range(2):
		if tanks[i].alive:
			_update_tank(tanks[i], i, delta)
		elif mode == Mode.DEATHMATCH and respawn_timers[i] > 0.0:
			respawn_timers[i] -= delta
			if respawn_timers[i] <= 0.0 and round_time < round_limit:
				_respawn_tank(i)
	_update_projectiles(delta)
	_update_mines(delta)
	_check_pickups()

	if mode == Mode.DEATHMATCH:
		if round_time >= round_limit:
			_end_match(_highest_score_player())
	else:
		var alive_count := 0
		for tank in tanks:
			if tank.alive:
				alive_count += 1
		if alive_count <= 1 and round_time > 0.25:
			phase = RoundPhase.ROUND_END
			round_end_delay = 1.3
			winner = _last_alive_player()

	pickup_timer -= delta
	if pickup_timer <= 0.0 and pickups.size() < 3:
		_spawn_pickup()
		pickup_timer = rng.randf_range(5.0, 9.0)

func _process_results(_delta: float) -> void:
	for i in range(laser_beams.size() - 1, -1, -1):
		laser_beams[i]["time"] = float(laser_beams[i]["time"]) - _delta
		if float(laser_beams[i]["time"]) <= 0.0:
			laser_beams.remove_at(i)

func _update_storm(delta: float) -> void:
	if round_time < 60.0:
		return
	if not storm_active:
		storm_active = true
		storm_elapsed = 0.0
		storm_next_shrink = 5.0
		GameLog.info("Storm zone activated")
	storm_elapsed += delta
	storm_next_shrink -= delta
	if storm_next_shrink <= 0.0:
		storm_next_shrink = 10.0
		var shrink_side := int(floor(storm_elapsed / 10.0)) % 4
		if shrink_side == 0:
			storm_bounds.position.x += Maze.TILE_SIZE
			storm_bounds.size.x -= Maze.TILE_SIZE
		elif shrink_side == 1:
			storm_bounds.size.y -= Maze.TILE_SIZE
		elif shrink_side == 2:
			storm_bounds.size.x -= Maze.TILE_SIZE
			storm_bounds.position.x += 0.0
		else:
			storm_bounds.position.y += Maze.TILE_SIZE
			storm_bounds.size.y -= Maze.TILE_SIZE
	for tank in tanks:
		if tank.alive and not storm_bounds.grow(-8.0).has_point(tank.position):
			_handle_tank_hit(tank, -1, tank.position)

func _update_tank(tank: Tank, index: int, delta: float) -> void:
	var turn := 0.0
	var throttle := 0.0
	var fire_held := false
	if index == 0:
		if Input.is_key_pressed(KEY_A):
			turn -= 1.0
		if Input.is_key_pressed(KEY_D):
			turn += 1.0
		if Input.is_key_pressed(KEY_W):
			throttle += 1.0
		if Input.is_key_pressed(KEY_S):
			throttle -= 1.0
	else:
		if Input.is_key_pressed(KEY_LEFT):
			turn -= 1.0
		if Input.is_key_pressed(KEY_RIGHT):
			turn += 1.0
		if Input.is_key_pressed(KEY_UP):
			throttle += 1.0
		if Input.is_key_pressed(KEY_DOWN):
			throttle -= 1.0
		fire_held = Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER)
	if index == 0:
		fire_held = Input.is_key_pressed(KEY_SPACE)
	var trigger_pressed := fire_held and not tank.fire_held
	var trigger_released := not fire_held and tank.fire_held
	tank.fire_held = fire_held
	if trigger_released:
		tank.trigger_pulled = false
		if tank.weapon == "gatling":
			tank.gatling_new_burst = true
		if tank.weapon not in ["bullet", "gatling"] and tank.ammo <= 0:
			tank.weapon = "bullet"
			tank.ammo = 5
	if tank.weapon == "gatling":
		_update_gatling(tank, fire_held, delta)
	elif trigger_pressed:
		_fire_tank(tank)
	if tank.weapon == "laser" and tank.laser_fired and tank.laser_time <= LASER_LOCK_TIME:
		throttle = 0.0
		turn = 0.0
	tank.rotation += turn * Tank.TURN_SPEED * delta
	var speed := Tank.FORWARD_SPEED if throttle >= 0.0 else Tank.BACK_SPEED
	if tank.speed_boost_time > 0.0:
		speed *= 1.3
	var movement := Vector2.UP.rotated(tank.rotation) * throttle * speed * delta
	var next_position := tank.position + movement
	if not maze.is_circle_blocked(next_position, Tank.COLLISION_RADIUS):
		tank.position = next_position
	else:
		var slide_x := Vector2(next_position.x, tank.position.y)
		var slide_y := Vector2(tank.position.x, next_position.y)
		if not maze.is_circle_blocked(slide_x, Tank.COLLISION_RADIUS):
			tank.position = slide_x
		elif not maze.is_circle_blocked(slide_y, Tank.COLLISION_RADIUS):
			tank.position = slide_y
	tank.last_move = throttle
	tank.queue_redraw()

func _fire_tank(tank: Tank) -> void:
	if tank.reload_time > 0.0:
		return
	var direction := Vector2.UP.rotated(tank.rotation)
	match tank.weapon:
		"bullet":
			if tank.ammo <= 0:
				return
			audio.play("fire_bullet", -3.0)
			var start := tank.position + direction * 50.0
			_spawn_projectile(start, direction, tank.player_id, BULLET_COLOR, BULLET_SPEED, 5, 5.0, 10.0, "bullet")
			tank.ammo -= 1
			tank.bullets_fired += 1
			tank.trigger_pulled = true
		"double":
			if tank.trigger_pulled or tank.ammo <= 0:
				return
			tank.trigger_pulled = true
			tank.left_barrel = not tank.left_barrel
			audio.play("fire_bullet", -3.0)
			var start := tank.position + direction * 45.0
			var side := direction.rotated(PI * 0.5) * DOUBLE_BARREL_SPACING
			var muzzle := start - side if tank.left_barrel else start + side
			_spawn_projectile(muzzle, direction, tank.player_id, Color("#ffd166"), BULLET_SPEED, 5, 5.0, 6.0, "double")
			tank.ammo -= 1
		"shotgun":
			if tank.trigger_pulled or tank.shotgun_reload > 0.0 or tank.ammo <= 0:
				return
			tank.trigger_pulled = true
			tank.shotgun_reload = 1.0
			audio.play("fire_shotgun")
			var start := tank.position + direction * 49.0
			for _pellet in range(SHOTGUN_PELLETS):
				var seed := rng.randf_range(-0.5, 0.5)
				var spread := seed * 8.0
				var shot_direction := direction.rotated(seed * SHOTGUN_SPREAD)
				_spawn_projectile(start + shot_direction.rotated(PI * 0.5) * spread, shot_direction, tank.player_id, Color("#f78c6b"), rng.randf_range(600.0, 700.0), 5, 2.0, 2.0, "shotgun")
			tank.ammo -= 1
		"laser":
			if tank.laser_fired or tank.ammo <= 0:
				return
			tank.laser_fired = true
			tank.laser_time = 0.0
			audio.play("fire_laser", -2.0)
			var start := tank.position + direction * 50.0
			_fire_laser(tank, start, direction)
			tank.ammo -= 1
		"homing":
			if tank.homing_launched or tank.ammo <= 0:
				return
			tank.homing_launched = true
			tank.homing_activation = 2.0
			var start := tank.position + direction * 50.0
			var target := _other_tank(tank.player_id)
			if target == null:
				return
			audio.play("fire_bullet", -2.0)
			_spawn_homing_projectile(start, direction, tank.player_id, target)
			tank.ammo -= 1
		"gatling":
			return
		"mine":
			if tank.trigger_pulled or tank.ammo <= 0:
				return
			tank.trigger_pulled = true
			audio.play("fire_mine", -2.0)
			mines.append({"position": tank.position - direction * 29.0, "velocity": -direction * MINE_LAUNCH_SPEED, "owner": tank.player_id, "time_alive": 0.0, "activated": false, "tripping_ids": [], "tripped": false, "detonated": false, "detonation_time": 0.0})
			tank.ammo -= 1

func _spawn_projectile(start: Vector2, direction: Vector2, owner_id: int, color: Color, speed: float, max_bounces: int, projectile_radius: float, lifetime: float = 10.0, projectile_kind: String = "bullet") -> void:
	var projectile := Projectile.new()
	projectile.z_index = 15
	projectile.radius = projectile_radius
	projectile.max_bounces = max_bounces
	add_child(projectile)
	projectile.setup(start, direction, owner_id, color, speed, lifetime)
	projectile.projectile_type = projectile_kind
	projectiles.append(projectile)

func _spawn_homing_projectile(start: Vector2, direction: Vector2, owner_id: int, target: Tank) -> void:
	var projectile := Projectile.new()
	projectile.z_index = 15
	projectile.radius = 4.0
	projectile.max_bounces = 4
	projectile.lifetime = HOMING_LIFETIME
	projectile.homing_acceleration = 40.0
	projectile.homing_activation = 2.0
	add_child(projectile)
	projectile.setup_homing(start, direction, owner_id, Color("#c19cff"), HOMING_SPEED, target)
	projectiles.append(projectile)

func _update_gatling(tank: Tank, held: bool, delta: float) -> void:
	if held:
		tank.trigger_pulled = true
		tank.gatling_charge = minf(1.0, tank.gatling_charge + delta / GATLING_CHARGE_TIME)
		if tank.gatling_charge >= 1.0:
			tank.gatling_time_since_fire += delta
			while tank.gatling_time_since_fire >= GATLING_FIRE_RATE:
				tank.gatling_time_since_fire -= GATLING_FIRE_RATE
				if tank.ammo <= 0:
					break
				var direction := Vector2.UP.rotated(tank.rotation)
				var seed := rng.randf_range(-0.5, 0.5)
				var shot_direction := direction.rotated(seed * 0.1)
				var spread := seed * 8.0
				var start := tank.position + shot_direction * 60.0 + shot_direction.rotated(PI * 0.5) * spread
				_spawn_projectile(start, shot_direction, tank.player_id, Color("#ffe08a"), rng.randf_range(500.0, 600.0), 5, 2.0, 2.0, "gatling")
				tank.ammo -= 1
				if tank.gatling_new_burst:
					audio.play("fire_bullet", -6.0)
					tank.gatling_new_burst = false
	else:
		tank.gatling_charge = maxf(0.0, tank.gatling_charge - delta / 1.5)
		tank.gatling_time_since_fire = 0.0
		if tank.gatling_charge <= 0.0 and tank.ammo <= 0:
			tank.weapon = "bullet"
			tank.ammo = 5

func _fire_laser(tank: Tank, start: Vector2, direction: Vector2) -> void:
	var points: Array[Vector2] = [start]
	var current := start
	var current_direction := direction.normalized()
	var remaining := LASER_SPEED * 0.8
	for _bounce in range(7):
		var wanted_end := current + current_direction * remaining
		var wall_hit := maze.ray_hit(current, wanted_end)
		var segment_end: Vector2 = wall_hit["point"]
		var closest_target: Tank = null
		var closest_distance := segment_end.distance_to(current)
		for target in tanks:
			if not target.alive or target.player_id == tank.player_id:
				continue
			var projection := current_direction.dot(target.position - current)
			if projection < 0.0 or projection > closest_distance:
				continue
			var nearest := current + current_direction * projection
			if target.position.distance_to(nearest) <= 28.0:
				closest_target = target
				closest_distance = projection
		if closest_target != null:
			segment_end = current + current_direction * closest_distance
			points.append(segment_end)
			_handle_tank_hit(closest_target, tank.player_id, segment_end)
			break
		points.append(segment_end)
		var traveled := current.distance_to(segment_end)
		remaining -= traveled
		if not bool(wall_hit["hit"]) or remaining <= 0.0:
			break
		var normal: Vector2 = wall_hit["normal"]
		current_direction = current_direction.bounce(normal).normalized()
		current = segment_end + current_direction * 0.5
	laser_beams.append({"points": points, "time": LASER_BEAM_TIME, "color": Color("#45e0e9")})

func _update_projectiles(delta: float) -> void:
	for projectile in projectiles.duplicate():
		if not is_instance_valid(projectile):
			projectiles.erase(projectile)
			continue
		var bounce_count_before: int = projectile.bounce_count
		var projectile_alive: bool = projectile.advance(delta, maze)
		if projectile.projectile_type == "shotgun" and projectile.maze_hit:
			projectile.lifetime = minf(projectile.lifetime, 0.7)
		if projectile.bounce_count > bounce_count_before:
			audio.play("bounce", -7.0)
		if not projectile_alive:
			if projectile.projectile_type == "bullet":
				for tank in tanks:
					if tank.player_id == projectile.owner_id:
						tank.ammo = mini(5, tank.ammo + 1)
						tank.bullets_fired = maxi(0, tank.bullets_fired - 1)
						break
			projectiles.erase(projectile)
			projectile.queue_free()
			continue
		for tank in tanks:
			if tank.alive and (tank.player_id != projectile.owner_id or projectile.projectile_type == "shrapnel") and tank.position.distance_to(projectile.position) < 28.0:
				_handle_tank_hit(tank, projectile.owner_id, projectile.position)
				projectiles.erase(projectile)
				projectile.queue_free()
				break

func _update_mines(delta: float) -> void:
	for i in range(mines.size() - 1, -1, -1):
		var mine: Dictionary = mines[i]
		mine["time_alive"] = float(mine["time_alive"]) + delta
		mine["activated"] = float(mine["time_alive"]) >= 0.5
		if not bool(mine["activated"]):
			var mine_position: Vector2 = mine["position"]
			var mine_velocity: Vector2 = mine["velocity"]
			var velocity_length := mine_velocity.length()
			if velocity_length > 0.0:
				mine_velocity = mine_velocity.normalized() * maxf(0.0, velocity_length - 40.0 * delta)
				mine["velocity"] = mine_velocity
			var next_position := mine_position + mine_velocity * delta
			if not maze.is_circle_blocked(next_position, MINE_RADIUS):
				mine["position"] = next_position
			else:
				mine["velocity"] = Vector2.ZERO
		if not bool(mine["activated"]):
			mines[i] = mine
			continue
		var tripping_ids: Array = mine["tripping_ids"]
		var current_ids: Array = []
		for tank in tanks:
			if tank.alive and tank.position.distance_to(mine["position"]) < 48.0:
				current_ids.append(tank.player_id)
		mine["tripping_ids"] = current_ids
		if current_ids.size() > 0:
			mine["tripped"] = true
		elif bool(mine["tripped"]) and not bool(mine["detonated"]):
			mine["detonated"] = true
			mine["detonation_time"] = 0.4
		if bool(mine["detonated"]):
			mine["detonation_time"] = float(mine["detonation_time"]) - delta
		if bool(mine["detonated"]) and float(mine["detonation_time"]) <= 0.0:
			var center: Vector2 = mine["position"]
			_spawn_mine_shrapnel(center, int(mine["owner"]))
			_handle_explosion(center, MINE_EXPLOSION_RADIUS, int(mine["owner"]))
			mines.remove_at(i)
			continue
		mines[i] = mine

func _spawn_mine_shrapnel(center: Vector2, owner_id: int) -> void:
	for _shrapnel in range(MINE_SHRAPNEL_COUNT):
		var angle := rng.randf_range(0.0, TAU)
		var projectile := Projectile.new()
		projectile.z_index = 14
		projectile.radius = 2.0
		add_child(projectile)
		projectile.setup_shrapnel(center, Vector2.RIGHT.rotated(angle), owner_id, Color("#ef476f"), rng.randf_range(500.0, 700.0))
		projectiles.append(projectile)

func _handle_explosion(center: Vector2, radius: float, owner_id: int) -> void:
	explosions.append({"position": center, "time": 0.55, "max": radius, "color": Color("#ef476f")})
	for tank in tanks:
		if tank.alive and tank.position.distance_to(center) <= radius:
			_handle_tank_hit(tank, owner_id, center)

func _handle_tank_hit(victim: Tank, attacker_id: int, impact: Vector2) -> void:
	if victim.shield_time > 0.0 or victim.spawn_shield_time > 0.0:
		audio.play("shield", -4.0)
		explosions.append({"position": impact, "time": 0.18, "max": 30.0, "color": Color("#8be28b")})
		return
	victim.kill()
	audio.play("explosion", -2.0)
	respawn_timers[victim.player_id] = RESPAWN_DELAY
	explosions.append({"position": victim.position, "time": 0.55, "max": 74.0, "color": victim.tank_color})
	if mode == Mode.DEATHMATCH and attacker_id >= 0 and attacker_id != victim.player_id:
		scores[attacker_id] += 1
	GameLog.info("Player %d destroyed player %d" % [attacker_id + 1, victim.player_id + 1])
	if mode == Mode.CLASSIC:
		winner = attacker_id if attacker_id != victim.player_id else _last_alive_player()

func _check_pickups() -> void:
	for i in range(pickups.size() - 1, -1, -1):
		var pickup: Dictionary = pickups[i]
		pickup["phase"] = float(pickup["phase"]) + 0.09
		pickups[i] = pickup
		for tank in tanks:
			if tank.alive and tank.position.distance_to(pickup["position"]) < 45.0:
				_apply_pickup(tank, String(pickup["type"]))
				pickups.remove_at(i)
				break

func _spawn_pickup() -> void:
	var pickup_type: String = PICKUP_TYPES[rng.randi_range(0, PICKUP_TYPES.size() - 1)]
	pickups.append({"position": maze.random_pickup_position(), "type": pickup_type, "phase": rng.randf_range(0.0, TAU)})

func _apply_pickup(tank: Tank, pickup_type: String) -> void:
	tank.trigger_pulled = false
	tank.left_barrel = false
	tank.shotgun_reload = 0.0
	tank.laser_fired = false
	tank.laser_time = 0.0
	tank.homing_launched = false
	tank.gatling_charge = 0.0
	tank.gatling_time_since_fire = 0.0
	tank.gatling_new_burst = true
	match pickup_type:
		"shield":
			tank.shield_time = 6.0
		"aimer":
			tank.aimer_time = 10.0
		"speed":
			tank.speed_boost_time = 10.0
		"double":
			tank.weapon = "double"
			tank.ammo = 10
			tank.reload_time = 0.0
		"shotgun":
			tank.weapon = "shotgun"
			tank.ammo = 3
			tank.reload_time = 0.0
		"laser":
			tank.weapon = "laser"
			tank.ammo = 1
			tank.reload_time = 0.0
		"homing":
			tank.weapon = "homing"
			tank.ammo = 1
			tank.reload_time = 0.0
		"gatling":
			tank.weapon = "gatling"
			tank.ammo = 20
			tank.reload_time = 0.0
		"mine":
			tank.weapon = "mine"
			tank.ammo = 3
			tank.reload_time = 0.0
	GameLog.info("Player %d picked up %s" % [tank.player_id + 1, pickup_type])

func _respawn_tank(index: int) -> void:
	var candidates := [maze.get_spawn_position(0), maze.get_spawn_position(1), maze.random_pickup_position(), maze.random_pickup_position()]
	var spawn: Vector2 = candidates[rng.randi_range(0, candidates.size() - 1)]
	if maze.is_circle_blocked(spawn, Tank.COLLISION_RADIUS):
		spawn = Vector2(640.0, 382.0)
	tanks[index].reset_for_respawn(spawn, rng.randf_range(-PI, PI))
	tanks[index].spawn_shield_time = 10.0
	GameLog.info("Player %d respawned" % (index + 1))

func _last_alive_player() -> int:
	for tank in tanks:
		if tank.alive:
			return tank.player_id
	return -1

func _highest_score_player() -> int:
	if scores[0] == scores[1]:
		return -1
	return 0 if scores[0] > scores[1] else 1

func _other_tank(player_id: int) -> Tank:
	for tank in tanks:
		if tank.player_id != player_id and tank.alive:
			return tank
	return null

func _finish_round() -> void:
	if mode == Mode.CLASSIC:
		if winner < 0:
			winner = _last_alive_player()
		if winner >= 0:
			scores[winner] += 1
		if scores[0] >= MAX_SCORE or scores[1] >= MAX_SCORE:
			_end_match(_highest_score_player())
			return
		round_number += 1
		_begin_round()

func _end_match(final_winner: int) -> void:
	if screen == Screen.RESULTS:
		return
	match_winner = final_winner
	screen = Screen.RESULTS
	phase = RoundPhase.ROUND_END
	for projectile in projectiles:
		if is_instance_valid(projectile):
			projectile.queue_free()
	projectiles.clear()
	GameLog.info("Match complete")
	audio.play("winner", -4.0)

func _draw() -> void:
	if screen == Screen.MENU:
		draw_rect(Rect2(0.0, 0.0, 1280.0, 720.0), Color("#0b1015"))
