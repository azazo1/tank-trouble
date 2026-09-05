# 由原版 Constants 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_Constants: Dictionary = {}
static var _initialized_Constants = false
static func initialize_original_static():
	if _initialized_Constants: return
	_initialized_Constants = true
	_static_Constants["SERVER"] = {"MAX_PAYLOAD": 1048576, "MAX_GAME_COUNT": 6, "GAME_CONTROLLER_UPDATE_INTERVAL": (JS.number(1000) / JS.number(30)), "STATS_REPORT_INTERVAL": (JS.number(1000) * JS.number(60)), "KEEPALIVE_INTERVAL": (JS.number(1000) * JS.number(60)), "VALIDATION_INTERVAL": (JS.number(1000) * JS.number(30)), "AI_CONTROLLER_UPDATE_INTERVAL": (JS.number(1000) / JS.number(30)), "GOLD_SPAWN_DURATION_MIN": (JS.number(1000) * JS.number(20)), "GOLD_SPAWN_DURATION_VARIANCE": (JS.number(1000) * JS.number(20)), "GOLD_SPAWN_DOUBLE_PROBABILITY": 0.06, "GOLD_SPAWN_TRIPLE_PROBABILITY": 0.01, "GOLD_SPAWN_MAX_PER_ROUND": 3, "DIAMOND_SPAWN_DURATION_MIN": (JS.number(1000) * JS.number(100)), "DIAMOND_SPAWN_DURATION_VARIANCE": (JS.number(1000) * JS.number(400)), "DIAMOND_SPAWN_MAX_PER_ROUND": 1, "ACHIEVEMENT_UPDATE_INTERVAL": (JS.number(1000) * JS.number(2)), "ACHIEVEMENT_TICK_INTERVAL": 250, "MAX_PLAYERS_PER_CONNECTION": 3, "MAX_ACCEPTED_POSITION_DIFF_SQUARED": (JS.number(3.5) * JS.number(3.5)), "MAX_ACCEPTED_ROTATION_DIFF": 1, "MAX_ACCEPTED_MAZE_DISTANCE": 1, "MAX_INACTIVITY_TIME": (JS.number(1000) * JS.number(60)), "TRACKING_WINDOW_SIZE": 5, "TRACKING_EMISSION_TOLERANCE": 0.96, "TRACKING_SPEED_TOLERANCE": 1.04, "TRACKING_VIOLATION_DURATION": (JS.number(1000) * JS.number(60)), "TRACKING_VIOLATION_THRESHOLD": 5, "CHAT_COOLDOWN_TIME": 20, "CHAT_COOLDOWN_PERIOD": (JS.number((JS.number(60) * JS.number(60))) * JS.number(3)), "TEMP_BAN_CACHE_DURATION": 60, "TANKSTATE_VIOLATION_REASONS": {"EMISSION_TOO_OFTEN": 0, "MOVED_TOO_FAST": 1, "TURNED_TOO_FAST": 2}}
	_static_Constants["CLIENT"] = {"TANKSTATE_EMISSION_INTERVAL": 0.5, "MAX_PLAYERS": 3, "RECONNECT_INTERVAL": 10000, "MAX_LATENCY_DIFFERENCE_TO_ACCEPT_FOR_POPULATED_SERVER": 35}
	_static_Constants["GAME"] = {"MAX_ACTIVE_PLAYERS": 8, "SYMMETRIC_MAX_ACTIVE_PLAYERS": 4, "DEFAULT_ACTIVE_PLAYERS": 6, "MAX_QUEUED_PLAYERS": 6}
	_static_Constants["PIXELS_PER_METER"] = 20
	_static_Constants["METERS_PER_PIXEL"] = 0.05
	_static_Constants["PATH_MIN_STEP_LENGTH"] = 0.01
	_static_Constants["BULLET"] = {"RADIUS": {"px": 5, "m": (JS.number(5) / JS.number(20))}, "SPEED": {"px": 360, "m": (JS.number(360) / JS.number(20))}, "OFFSET": {"px": 50, "m": (JS.number(50) / JS.number(20))}}
	_static_Constants["LASER"] = {"RADIUS": {"px": 0, "m": (JS.number(0) / JS.number(20))}, "SPEED": {"px": 3600, "m": (JS.number(3600) / JS.number(20))}, "OFFSET": {"px": 50, "m": (JS.number(50) / JS.number(20))}}
	_static_Constants["DOUBLE_BARREL"] = {"RADIUS": {"px": 5, "m": (JS.number(5) / JS.number(20))}, "SPEED": {"px": 360, "m": (JS.number(360) / JS.number(20))}, "OFFSET": {"px": 45, "m": (JS.number(45) / JS.number(20))}, "SPACE": {"px": 9, "m": (JS.number(9) / JS.number(20))}}
	_static_Constants["SHOTGUN"] = {"RADIUS": {"px": 2, "m": (JS.number(2) / JS.number(20))}, "MIN_SPEED": {"px": 600, "m": (JS.number(600) / JS.number(20))}, "MAX_SPEED": {"px": 700, "m": (JS.number(700) / JS.number(20))}, "OFFSET": {"px": 49, "m": (JS.number(49) / JS.number(20))}, "SPACE": {"px": 8, "m": (JS.number(8) / JS.number(20))}}
	_static_Constants["GATLING_GUN"] = {"RADIUS": {"px": 2, "m": (JS.number(2) / JS.number(20))}, "MIN_SPEED": {"px": 500, "m": (JS.number(500) / JS.number(20))}, "MAX_SPEED": {"px": 600, "m": (JS.number(600) / JS.number(20))}, "OFFSET": {"px": 60, "m": (JS.number(60) / JS.number(20))}, "SPACE": {"px": 8, "m": (JS.number(8) / JS.number(20))}}
	_static_Constants["HOMING_MISSILE"] = {"RADIUS": {"px": 4, "m": (JS.number(4) / JS.number(20))}, "SPEED": {"px": 360, "m": (JS.number(360) / JS.number(20))}, "OFFSET": {"px": 50, "m": (JS.number(50) / JS.number(20))}, "ACCELERATION": 40}
	_static_Constants["MINE"] = {"RADIUS": {"px": 16, "m": (JS.number(16) / JS.number(20))}, "LAUNCH_SPEED": {"px": 250, "m": (JS.number(250) / JS.number(20))}, "MIN_SPEED": {"px": 500, "m": (JS.number(500) / JS.number(20))}, "MAX_SPEED": {"px": 700, "m": (JS.number(700) / JS.number(20))}, "OFFSET": {"px": -(29), "m": (JS.number(-(29)) / JS.number(20))}, "ACCELERATION": 40}
	_static_Constants["COLLECTIBLE_TYPES"] = {"CRATE_LASER": 0, "CRATE_DOUBLE_BARREL": 1, "CRATE_SHOTGUN": 2, "CRATE_HOMING_MISSILE": 3, "CRATE_MINE": 4, "CRATE_GATLING_GUN": 5, "WEAPON_CRATE_COUNT": 6, "CRATE_SHIELD": 6, "CRATE_AIMER": 7, "CRATE_SPEED_BOOST": 8, "UPGRADE_CRATE_COUNT": 9, "CRATE_COUNT": 9, "GOLD": 9, "DIAMOND": 10, "FLAG": 11, "COLLECTIBLE_TO_UPGRADE_OFFSET": -(4)}
	_static_Constants["CRATE"] = {"WIDTH": {"px": 64, "m": (JS.number(64) / JS.number(20))}, "HEIGHT": {"px": 64, "m": (JS.number(64) / JS.number(20))}}
	_static_Constants["GOLD"] = {"RADIUS": {"px": 35, "m": (JS.number(35) / JS.number(20))}}
	_static_Constants["DIAMOND"] = {"WIDTH": {"px": 44, "m": (JS.number(44) / JS.number(20))}, "HEIGHT": {"px": 76, "m": (JS.number(76) / JS.number(20))}, "MIDDLE_HEIGHT": {"px": 38, "m": (JS.number(38) / JS.number(20))}}
	_static_Constants["SHIELD"] = {"RADIUS": {"px": 86, "m": (JS.number(86) / JS.number(20))}}
	_static_Constants["WEAPON_TYPES"] = {"BULLET": -(1), "LASER": 0, "DOUBLE_BARREL": 1, "SHOTGUN": 2, "HOMING_MISSILE": 3, "MINE": 4, "GATLING_GUN": 5}
	_static_Constants["PROJECTILE_BOUNCE_TIMEOUT_WINDOW"] = 35
	_static_Constants["PROJECTILE_BOUNCE_TIMEOUT_COUNT"] = 5
	_static_Constants["BULLET_AMMO_COUNT"] = 5
	_static_Constants["BULLET_MAX_LIFETIME"] = 10
	_static_Constants["LASER_LOCK_TIME"] = 0.2
	_static_Constants["LASER_MAX_LIFETIME"] = 0.8
	_static_Constants["DOUBLE_BARREL_AMMO_COUNT"] = 10
	_static_Constants["DOUBLE_BARREL_RELOAD_TIME"] = 1
	_static_Constants["DOUBLE_BARREL_MAX_LIFETIME"] = 6
	_static_Constants["SHOTGUN_AMMO_COUNT"] = 3
	_static_Constants["SHOTGUN_NUM_BUCKSHOT"] = 20
	_static_Constants["SHOTGUN_BUCKSHOT_SPREAD"] = 0.3
	_static_Constants["SHOTGUN_RELOAD_TIME"] = 1
	_static_Constants["SHOTGUN_LIFETIME_AFTER_MAZE_HIT"] = 0.7
	_static_Constants["SHOTGUN_MAX_LIFETIME"] = 2
	_static_Constants["HOMING_MISSILE_ACTIVATION_TIME"] = 2
	_static_Constants["HOMING_MISSILE_MAX_LIFETIME"] = 10
	_static_Constants["MINE_AMMO_COUNT"] = 3
	_static_Constants["MINE_ACTIVATION_DELAY"] = 0.5
	_static_Constants["MINE_DETONATION_DELAY"] = 0.4
	_static_Constants["MINE_NUM_SHRAPNEL"] = 30
	_static_Constants["MINE_SHRAPNEL_RADIUS"] = (JS.number(2) / JS.number(20))
	_static_Constants["GATLING_GUN_AMMO_COUNT"] = 20
	_static_Constants["GATLING_GUN_BULLET_SPREAD"] = 0.1
	_static_Constants["GATLING_GUN_CHARGE_TIME"] = 0.5
	_static_Constants["GATLING_GUN_FIRE_RATE"] = 0.12
	_static_Constants["GATLING_GUN_DISCHARGE_TIME"] = 1.5
	_static_Constants["GATLING_GUN_MAX_LIFETIME"] = 2
	_static_Constants["CRATE_SPAWN_DURATION_MIN"] = 3
	_static_Constants["CRATE_SPAWN_DURATION_VARIANCE"] = 5
	_static_Constants["CRATE_MINIMUM_TILES_TO_TANKS"] = 4
	_static_Constants["GOLD_MINIMUM_TILES_TO_TANKS"] = 5
	_static_Constants["DIAMOND_MINIMUM_TILES_TO_TANKS"] = 6
	_static_Constants["MAX_CRATES"] = 3
	_static_Constants["MAX_GOLDS"] = 3
	_static_Constants["MAX_DIAMONDS"] = 1
	_static_Constants["MAX_WEAPON_QUEUE"] = 3
	_static_Constants["UPGRADE_TYPES"] = {"LASER_AIMER": 0, "SPAWN_SHIELD": 1, "SHIELD": 2, "AIMER": 3, "SPEED_BOOST": 4}
	_static_Constants["LASER_AIMER_LENGTH"] = 60
	_static_Constants["SPAWN_SHIELD_LIFETIME"] = 10
	_static_Constants["SPAWN_SHIELD_WEAKEN_TIME"] = 2
	_static_Constants["AIMER_LENGTH"] = 60
	_static_Constants["AIMER_LIFETIME"] = 10
	_static_Constants["SHIELD_LIFETIME"] = 6
	_static_Constants["SHIELD_WEAKEN_TIME"] = 2
	_static_Constants["SPEED_BOOST_LIFETIME"] = 10
	_static_Constants["SPEED_BOOST_EFFECT"] = 0.3
	_static_Constants["MODIFIER_TYPES"] = {"SPEED": 0}
	_static_Constants["MODIFIER_INFO"] = [{"DEFAULT": 1}]
	_static_Constants["SCORE_TYPES"] = {"KILL": 0, "VICTORY": 1}
	_static_Constants["EMBLEM_TYPES"] = {"TERMINATOR": 0, "DOMINATOR": 1}
	_static_Constants["COUNTER_TYPES"] = {"TIMER_COUNTDOWN": 0, "OVERTIME_COUNT_UP": 1, "TIMER_COUNT_UP": 2, "PIE_COUNTDOWN": 3}
	_static_Constants["ZONE_TYPES"] = {"SPAWN": 0, "HILL": 1, "BASE": 2, "STORM": 3}
	_static_Constants["SPAWN_ZONE_MINIMUM_TILES_TO_TANKS"] = 1
	_static_Constants["SPAWN_ZONE_LIFETIME"] = 4
	_static_Constants["SPAWN_ZONE_START_GROW_TIME"] = 2.4
	_static_Constants["SPAWN_ZONE_END_GROW_TIME"] = 2.3
	_static_Constants["SPAWN_ZONE_START_RADIUS"] = 0.3
	_static_Constants["SPAWN_ZONE_END_RADIUS"] = 3.7
	_static_Constants["STORM_ZONE_EXPANSION_TIME"] = 10
	_static_Constants["STORM_ZONE_START_GROW_TIME"] = 5
	_static_Constants["MAX_DELTA_TIME"] = (JS.number(1) / JS.number(10))
	_static_Constants["BETWEEN_ROUNDS_DURATION"] = 1
	_static_Constants["CELEBRATION_DURATION"] = 7
	_static_Constants["COUNTDOWN_START_VALUE"] = 3
	_static_Constants["COUNTDOWN_DURATION"] = 0.5
	_static_Constants["ROUND_FINISHING_DURATION"] = 3
	_static_Constants["JOIN_PRIORITY_START_GAME_WEIGHT"] = 1000
	_static_Constants["JOIN_PRIORITY_DEATHMATCH_MIN_SECONDS_TO_PENALIZE"] = 10
	_static_Constants["JOIN_PRIORITY_DEATHMATCH_MAX_SECONDS_TO_PENALIZE"] = 30
	_static_Constants["JOIN_PRIORITY_DEATHMATCH_TIME_WEIGHT"] = 10
	_static_Constants["STATISTICS"] = {"SLIDING_WINDOW_SIZE": 10, "MINIMUM_VICTORIES_FOR_DOMINATOR": 3, "MINIMUM_KILLS_FOR_TERMINATOR": 3, "MINIMUM_KILLS_FOR_KILL_STREAK": 3}
	_static_Constants["ACHIEVEMENT"] = {"FOLLOW_THE_RED_PENGUIN": {"MAX_ACCEPTED_ANGLE_DIFFERENCE_FOR_CLEARING_TURN_STEP": 0.25, "MAX_ACCEPTED_ROTATION_DURING_DRIVE_STEP": 1, "MAX_ACCEPTED_ROTATION_DURING_SHOOT_STEP": 0.5, "MAX_ACCEPTED_ROTATION_DURING_WAIT_STEP": 0.5}, "RED_INFILTRATION": {"MAX_ACCEPTED_ANGLE_DIFFERENCE_FOR_CLEARING_TURN_STEP": 0.25, "MAX_ACCEPTED_ROTATION_DURING_DRIVE_STEP": 1, "MAX_ACCEPTED_ROTATION_DURING_SHOOT_STEP": 0.5, "MAX_ACCEPTED_ROTATION_DURING_WAIT_STEP": 0.5}, "WAKKA_WAKKA_WAKKA": {"STEP_SIZE": 2}, "MEMORY_LIKE_A_GOLDFISH": {"TIME_TO_SURVIVE": 3}}
	_static_Constants["TANK"] = {"WIDTH": {"px": 60, "m": (JS.number(60) / JS.number(20))}, "HEIGHT": {"px": 80, "m": (JS.number(80) / JS.number(20))}, "ROTATION_SPEED": 5, "FORWARD_SPEED": {"px": 319, "m": (JS.number(319) / JS.number(20))}, "BACK_SPEED": {"px": 256, "m": (JS.number(256) / JS.number(20))}}
	_static_Constants["BULLET_TURRET"] = {"WIDTH": {"px": 14, "m": (JS.number(14) / JS.number(20))}, "HEIGHT": {"px": 28, "m": (JS.number(28) / JS.number(20))}, "OFFSET_X": {"px": 0, "m": 0}, "OFFSET_Y": {"px": -(40), "m": (JS.number(-(40)) / JS.number(20))}}
	_static_Constants["LASER_TURRET"] = {"ANTENNA_WIDTH": {"px": 2, "m": (JS.number(2) / JS.number(20))}, "ANTENNA_HEIGHT": {"px": 28, "m": (JS.number(28) / JS.number(20))}, "ANTENNA_OFFSET_X": {"px": 0, "m": 0}, "ANTENNA_OFFSET_Y": {"px": -(40), "m": (JS.number(-(40)) / JS.number(20))}, "DISH_WIDTH": {"px": 40, "m": (JS.number(40) / JS.number(20))}, "DISH_HEIGHT": {"px": 10, "m": (JS.number(10) / JS.number(20))}, "DISH_OFFSET_X": {"px": 0, "m": 0}, "DISH_OFFSET_Y": {"px": -(37), "m": (JS.number(-(37)) / JS.number(20))}}
	_static_Constants["DOUBLE_BARREL_TURRET"] = {"WIDTH": {"px": 32, "m": (JS.number(32) / JS.number(20))}, "HEIGHT": {"px": 22, "m": (JS.number(22) / JS.number(20))}, "OFFSET_X": {"px": 0, "m": 0}, "OFFSET_Y": {"px": -(35), "m": (JS.number(-(35)) / JS.number(20))}}
	_static_Constants["SHOTGUN_TURRET"] = {"WIDTH": {"px": 28, "m": (JS.number(28) / JS.number(20))}, "HEIGHT": {"px": 27, "m": (JS.number(27) / JS.number(20))}, "OFFSET_X": {"px": 0, "m": 0}, "OFFSET_Y": {"px": -(39), "m": (JS.number(-(39)) / JS.number(20))}}
	_static_Constants["MISSILE_TURRET"] = {"WIDTH": {"px": 6, "m": (JS.number(6) / JS.number(20))}, "CENTER_HEIGHT": {"px": 28, "m": (JS.number(28) / JS.number(20))}, "SIDE_HEIGHT": {"px": 8, "m": (JS.number(8) / JS.number(20))}, "OFFSET_X": {"px": 0, "m": 0}, "OFFSET_Y": {"px": -(39), "m": (JS.number(-(39)) / JS.number(20))}}
	_static_Constants["GATLING_GUN_TURRET"] = {"WIDTH": {"px": 28, "m": (JS.number(28) / JS.number(20))}, "HEIGHT": {"px": 27, "m": (JS.number(27) / JS.number(20))}, "OFFSET_X": {"px": 0, "m": 0}, "OFFSET_Y": {"px": -(39), "m": (JS.number(-(39)) / JS.number(20))}}
	_static_Constants["MAZE"] = {"BASE_WIDTH": 2, "WIDTH_FOR_PLAYERS": [0, 2, 4, 6, 8, 9, 10, 11, 12], "MAX_RANDOM_WIDTH_MULTIPLIER": 1.5, "MAX_WIDTH": 16, "BASE_HEIGHT": 2, "HEIGHT_FOR_PLAYERS": [0, 1, 2, 3, 4, 5, 5, 6, 6], "MAX_RANDOM_HEIGHT_MULTIPLIER": 1.5, "MAX_HEIGHT": 10, "TILE_PROBABILITIES": [0.5, 0.7, 0.9, 0.9, 1], "WALL_PROBABILITIES": [0.5, 0.8, 0.9, 1, 1]}
	_static_Constants["MAZE_TILE_SIZE"] = {"px": 200, "m": (JS.number(200) / JS.number(20))}
	_static_Constants["MAZE_WALL_WIDTH"] = {"px": 16, "m": (JS.number(16) / JS.number(20))}
	_static_Constants["MAZE_MINIMUM_TILES_PER_TANK"] = 5
	_static_Constants["MAZE_MINIMUM_TILES_BETWEEN_TANKS"] = 4
	_static_Constants["MAZE_MINIMUM_REACHABLE_RATIO"] = 1
	_static_Constants["MAZE_MAX_DEAD_END_PENALTY"] = 5
	_static_Constants["MAZE_THEMES"] = {"STANDARD": 0, "HALLOWEEN": 1, "CHRISTMAS": 2, "COUNT": 3, "RANDOM": 4}
	_static_Constants["MAZE_THEME_INFO"] = [{"BORDER_CONFIG": [], "FLOOR_CONFIG": [{"required": 0, "missing": 0, "weight": 1}, {"required": 0, "missing": 0, "weight": 1}], "SPACE_CONFIG": [], "WALL_CONFIG": [{"flipX": true, "flipY": true, "weight": 1}], "WALL_DECORATION_CONFIG": [], "WALL_DECORATION_PROBABILITY": 0}, {"ACTIVE_DURATION_START": JS.construct("@Date", ["2017-10-01"]), "ACTIVE_DURATION_END": JS.construct("@Date", ["2017-11-01T12:00:00Z"]), "BORDER_CONFIG": [{"flip": true, "weight": 2}, {"flip": true, "weight": 2}, {"flip": true, "weight": 1}, {"flip": true, "weight": 1}], "FLOOR_CONFIG": [{"required": 0, "missing": 0, "weight": 2}, {"required": 0, "missing": 0, "weight": 2}, {"required": 0, "missing": 0, "weight": 1}, {"required": 0, "missing": 0, "weight": 1}, {"required": 5, "missing": 0, "weight": 1}, {"required": 3, "missing": 0, "weight": 2}], "SPACE_CONFIG": [{"required": 0, "missing": 0, "weight": 1}, {"required": 0, "missing": 0, "weight": 1}, {"required": 15, "missing": 0, "weight": 1}], "WALL_DECORATION_CONFIG": [{"required": 10, "missing": 0, "weight": 1}, {"required": 10, "missing": 0, "weight": 1}, {"required": 10, "missing": 5, "weight": 1}, {"required": 12, "missing": 0, "weight": 2}, {"required": 14, "missing": 0, "weight": 1}], "WALL_CONFIG": [{"flipX": true, "flipY": true, "weight": 1}, {"flipX": true, "flipY": true, "weight": 1}, {"flipX": true, "flipY": true, "weight": 1}], "WALL_DECORATION_PROBABILITY": 0.2}, {"ACTIVE_DURATION_START": JS.construct("@Date", ["2017-12-01"]), "ACTIVE_DURATION_END": JS.construct("@Date", ["2017-12-31T23:59:59Z"]), "BORDER_CONFIG": [{"flip": true, "weight": 3}, {"flip": true, "weight": 1}, {"flip": true, "weight": 1}, {"flip": true, "weight": 1}, {"flip": true, "weight": 1}, {"flip": true, "weight": 1}], "FLOOR_CONFIG": [{"required": 0, "missing": 0, "weight": 2}, {"required": 0, "missing": 0, "weight": 2}, {"required": 0, "missing": 0, "weight": 0.5}, {"required": 0, "missing": 0, "weight": 1}, {"required": 0, "missing": 0, "weight": 1}, {"required": 1, "missing": 0, "weight": 3}, {"required": 1, "missing": 0, "weight": 3}, {"required": 5, "missing": 0, "weight": 3}, {"required": 3, "missing": 0, "weight": 3}, {"required": 11, "missing": 0, "weight": 3}], "SPACE_CONFIG": [{"required": 0, "missing": 0, "weight": 1}, {"required": 0, "missing": 0, "weight": 1}, {"required": 1, "missing": 0, "weight": 1}, {"required": 3, "missing": 0, "weight": 1}, {"required": 15, "missing": 0, "weight": 1}, {"required": 3, "missing": 0, "weight": 1}], "WALL_DECORATION_CONFIG": [{"required": 5, "missing": 0, "weight": 1}, {"required": 5, "missing": 0, "weight": 1}, {"required": 3, "missing": 0, "weight": 1}], "WALL_CONFIG": [{"flipX": true, "flipY": true, "weight": 1}, {"flipX": true, "flipY": true, "weight": 1}, {"flipX": true, "flipY": true, "weight": 1}, {"flipX": true, "flipY": true, "weight": 1}], "WALL_DECORATION_PROBABILITY": 0.2}]
	_static_Constants["GAME_MODES"] = {"CURRENT": -(1), "CLASSIC": 0, "BOOT_CAMP": 1, "DEATHMATCH": 2, "TEAM_CLASSIC": 3, "TEAM_DEATHMATCH": 4, "CAPTURE_THE_FLAG": 5, "COUNT": 3}
	_static_Constants["GAME_MODE_INFO"] = [{"AVAILABLE_ONLINE": true, "ACTIVE_HOURS": [0, 1, 2, 4, 5, 6, 8, 9, 10, 12, 13, 14, 16, 17, 18, 20, 21, 22], "HAS_CELEBRATION": false, "MIN_PLAYERS": 2, "DEFAULT_AVAILABLE_CRATES": [0, 1, 2, 3, 4, 5, 6]}, {"AVAILABLE_ONLINE": false, "HAS_CELEBRATION": false, "MIN_PLAYERS": 2, "DEFAULT_AVAILABLE_CRATES": [0, 1, 2, 3, 4, 5, 6]}, {"AVAILABLE_ONLINE": true, "ACTIVE_HOURS": [3, 7, 11, 15, 19, 23], "HAS_CELEBRATION": true, "MIN_PLAYERS": 3, "DEFAULT_AVAILABLE_CRATES": [0, 1, 2, 3, 4, 5, 6]}]
	_static_Constants["CLASSIC_STORM_APPEAR_DURATION"] = 60
	_static_Constants["DEATHMATCH_ROUND_DURATION"] = 60
	_static_Constants["DEATHMATCH_RESPAWN_DURATION"] = 1
	_static_Constants["DEATHMATCH_STORM_APPEAR_DURATION"] = 30
	_static_Constants["TEAMS"] = {"NO_TEAM": 0, "TEAM_RED": 1, "TEAM_BLUE": 2}
	_static_Constants["COLLISION_CATEGORIES"] = {"TANK": 1, "MAZE": JS.bitwise("<<", 1, 1), "PROJECTILE": JS.bitwise("<<", 1, 2), "TRAP": JS.bitwise("<<", 1, 3), "COLLECTIBLE": JS.bitwise("<<", 1, 4), "SHIELD": JS.bitwise("<<", 1, 5), "ZONE": JS.bitwise("<<", 1, 6)}
	_static_Constants["AI"] = {"PATH_STEP_SIZE": 0.1, "MIN_PROJECTILE_DISTANCE_TO_CONSIDER": 4, "MAX_PROJECTILE_DISTANCE_TO_CONSIDER": 10, "MIN_PROJECTILE_PATH_LENGTH": 4, "MAX_PROJECTILE_PATH_LENGTH": 10, "PROJECTILE_THREAT_TIME_FALLOFF": 0.25, "PROJECTILE_THREAT_WEIGHT": 0.5, "MIN_TRAP_THREAT_DISTANCE_TO_CONSIDER": 8, "MAX_TRAP_THREAT_DISTANCE_TO_CONSIDER": 16, "TRAP_THREAT_WEIGHT": 10, "MINE_INITIAL_THREAT_WEIGHT": 10, "MINE_THREAT_MIN_TIME_FALLOFF": 0.1, "MINE_THREAT_MAX_TIME_FALLOFF": 1, "OWN_MINE_THREAT_MAX_TIME_MODIFIER": 0.8, "OWN_MINE_THREAT_MIN_TIME_MODIFIER": 0.2, "MIN_TANK_THREAT_DISTANCE_TO_CONSIDER": 8, "MAX_TANK_THREAT_DISTANCE_TO_CONSIDER": 16, "MIN_FIRING_THREAT_PATH_BOUNCES": 2, "MAX_FIRING_THREAT_PATH_BOUNCES": 5, "MIN_FIRING_THREAT_PATH_LENGTH": 2, "MAX_FIRING_THREAT_PATH_LENGTH": 10, "FIRING_PATH_THREAT_WEIGHT": 0.25, "TANK_THREAT_WEIGHT": 2, "LASER_AIMER_THREAT_WEIGHT": 0.5, "SPAWN_ZONE_THREAT_WEIGHT": 10, "STORM_ZONE_THREAT_WEIGHT": 10, "MIN_AGGRESSIVENESS_GROWTH": 0, "MAX_AGGRESSIVENESS_GROWTH": 0.0003, "AGGRESSIVENESS_SHOOT_AFTER_SHRINKAGE": 0.3, "AGGRESSIVENESS_RETALIATE_SHRINKAGE": 0.2, "AGGRESSIVENESS_LAY_TRAP_SHRINKAGE": 0.5, "MIN_GREEDINESS_GROWTH": 0, "MAX_GREEDINESS_GROWTH": 0.0003, "GREEDINESS_PICK_UP_COLLECTIBLE_SHRINKAGE": 0.5, "MIN_CRATE_DISTANCE_TO_CONSIDER": 4, "MAX_CRATE_DISTANCE_TO_CONSIDER": 10, "MIN_CRATE_DISTANCE_FALLOFF": 0.01, "MAX_CRATE_DISTANCE_FALLOFF": 0.25, "MIN_CRATE_PRIORITY_OFFSET": 0.5, "MAX_CRATE_PRIORITY_OFFSET": 1, "MIN_CURRENCY_DISTANCE_TO_CONSIDER": 6, "MAX_CURRENCY_DISTANCE_TO_CONSIDER": 20, "MIN_CURRENCY_DISTANCE_FALLOFF": 0.01, "MAX_CURRENCY_DISTANCE_FALLOFF": 0.25, "MIN_GOLD_PRIORITY_OFFSET": 0, "MAX_GOLD_PRIORITY_OFFSET": 0.5, "MIN_DIAMOND_PRIORITY_OFFSET": 0.1, "MAX_DIAMOND_PRIORITY_OFFSET": 1, "MIN_PRIORITY_DECREASE": 0.0001, "MAX_PRIORITY_DECREASE": 0.001, "MIN_GOAL_PERIOD": 100, "MAX_GOAL_PERIOD": 800, "GET_UNSTUCK_GOAL_PERIOD": 30, "GET_UNSTUCK_DISTANCE": 2.5, "MAX_HUNT_PRIORITY": 0.2, "IDLE_PRIORITY": 0.01, "MIN_IDLE_DURATION": 100, "MAX_IDLE_DURATION": 500, "MIN_IDLE_DISTANCE": 2, "KILLS_TO_REMEMBER": 10, "DRIVE_TO_TILE_DISTANCE_SQUARED": (JS.number(4) * JS.number(4)), "DRIVE_TO_POSITION_DISTANCE_SQUARED": (JS.number(1) * JS.number(1)), "TURN_TO_DIFFERENCE": 0.1, "MAX_ROTATION_IMPRECISION": 0.3, "MIN_PROJECTILE_BOUNCES": 1, "MAX_PROJECTILE_BOUNCES": 5, "MIN_SCARY_PROJECTILE_DISTANCE": 3, "MAX_SCARY_PROJECTILE_DISTANCE": 15, "MIN_DODGE_PROJECTILE_DISTANCE": 4, "MAX_DODGE_PROJECTILE_DISTANCE": 12, "MIN_ESCAPE_PATH_LENGTH": 1, "MAX_ESCAPE_PATH_LENGTH": 7, "TIME_TO_DODGE": 1, "DISTANCE_TO_DODGE": 8, "AMOUNT_TO_DODGE": 4, "DODGE_PRIORITY_OFFSET": 1.5, "MIN_TANK_TARGET_DISTANCE_TO_CONSIDER": 3, "MAX_TANK_TARGET_DISTANCE_TO_CONSIDER": 8, "MIN_SHOOT_AFTER_PRIORITY_OFFSET": 0, "MAX_SHOOT_AFTER_PRIORITY_OFFSET": 1.5, "MIN_LAY_TRAP_PRIORITY_OFFSET": 0, "MAX_LAY_TRAP_PRIORITY_OFFSET": 1, "LAY_TRAP_DRIVE_FORWARD_DISTANCE": 0.33, "OWN_TRAP_MIN_DISTANCE": 2, "MIN_KILLS_TO_BE_BLINDED_BY_REVENGE": 1, "MAX_KILLS_TO_BE_BLINDED_BY_REVENGE": 5, "MIN_REVENGE_PRIORITY": 0.2, "MAX_REVENGE_PRIORITY": 0.8, "MIN_WIN_PRIORITY": 0.1, "MAX_WIN_PRIORITY": 0.7, "MAX_FIRE_DELAY": 300, "MIN_FIRING_PATH_BOUNCES": 1, "MAX_FIRING_PATH_BOUNCES": 6, "MIN_FIRING_PATH_LENGTH": 2, "MAX_FIRING_PATH_LENGTH": 8, "MIN_NUM_FIRING_PATHS": 1, "MAX_NUM_FIRING_PATHS": 5, "MIN_FIRING_PATH_SPREAD": 1.04, "MAX_FIRING_PATH_SPREAD": 2.09, "FIRING_PATH_RANDOM_OFFSET": 0.35, "MIN_PREFERRED_CLOSEST_DISTANCE_OFFSET": 3, "MAX_PREFERRED_CLOSEST_DISTANCE_OFFSET": 8, "MIN_DISTANCE_TO_FIRE": 8, "MAX_DISTANCE_TO_FIRE": 20, "MIN_FIRST_SEGMENT_TO_FIRE": 4, "MIN_DISTANCE_TO_RETALIATE": 4, "MAX_DISTANCE_TO_RETALIATE": 10, "MAX_RETALIATE_DELAY": 100, "MIN_TURN_AROUND_ANGLE": 1.04, "MAX_TURN_AROUND_ANGLE": 2.09, "MAX_STUCK_TIME": 100, "MIN_TANK_HUNT_DISTANCE_TO_CONSIDER": 6, "MAX_TANK_HUNT_DISTANCE_TO_CONSIDER": 20, "MIN_RUN_AWAY_DISTANCE_TO_CONSIDER": 6, "MAX_RUN_AWAY_DISTANCE_TO_CONSIDER": 20, "MIN_RUN_AWAY_PRIORITY_OFFSET": 0.2, "MAX_RUN_AWAY_PRIORITY_OFFSET": 1, "MIN_LASER_AIMER_DISTANCE": 3, "MAX_LASER_AIMER_DISTANCE": 12, "POSITION_DEAD_DISTANCE": 1, "POSITION_DEAD_ANGLE": 1.13, "ROTATION_DEAD_ANGLE": 0.1, "MAX_PATH_LENGTH_TO_REVERSE": 1, "MIN_PATH_DEAD_END_WEIGHT": 0.2, "MAX_PATH_DEAD_END_WEIGHT": 1, "MIN_PATH_THREAT_WEIGHT": 0.1, "MAX_PATH_THREAT_WEIGHT": 1}
	_static_Constants["MODE_CLIENT_ONLINE"] = "client online"
	_static_Constants["MODE_CLIENT_LOCAL"] = "client local"
	_static_Constants["MODE_SERVER"] = "server"
	_static_Constants["CHAT_SEND_RECEIPT"] = {"SUCCESS": "success", "RETRY": "retry", "FAIL": "fail"}
	_static_Constants["mode"] = JS.get_property(_static_Constants, "MODE_CLIENT_LOCAL")
static func original_static_get(key):
	initialize_original_static()
	if _static_Constants.has(key): return _static_Constants[key]
	return null
static func original_static_set(key, value):
	_static_Constants[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/world/constants.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

static func original_setMode(_arg0 = null):
	var _scope0: Dictionary = {"mode": _arg0}
	JS.set_property(JS.module("Constants"), "mode", _scope0["mode"])
	return null

static func original_getMode():
	var _scope1: Dictionary = {}
	return JS.get_property(JS.module("Constants"), "mode")
	return null
