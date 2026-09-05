# 由原版 UIConstants 的 AST 转译, 请修改转译器或单独维护的适配模块.
extends "res://game/runtime/original_object.gd"
const JS = preload("res://game/runtime/js_support.gd")

static var _static_UIConstants: Dictionary = {}
static var _initialized_UIConstants = false
static func initialize_original_static():
	if _initialized_UIConstants: return
	_initialized_UIConstants = true
	_static_UIConstants["SCORE_CATEGORIES"] = {"EMBLEM": 0, "SCORE": 1, "SEPARATOR": 2, "TEAM": 3}
	_static_UIConstants["SCALED_FOR_HIGH_DENSITY"] = false
	_static_UIConstants["ASSET_SCALE"] = 1
	_static_UIConstants["GAME_ASSET_SCALE"] = 2
	_static_UIConstants["SPINE_SCALE"] = 1
	_static_UIConstants["MAX_CLICK_LENGTH"] = 200
	_static_UIConstants["MOUSE_INPUT"] = {"MAX_REVERSE_DISTANCE": 200, "POSITION_DEAD_DISTANCE": 100, "POSITION_DEAD_ANGLE": 0.78, "ROTATION_DEAD_ANGLE": 0.1}
	_static_UIConstants["SIGNUP_TYPING_SOUND_COUNT"] = 3
	_static_UIConstants["SIGNUP_TYPING_PAUSE"] = 500
	_static_UIConstants["SIGNUP_RANDOM_OPTIONS"] = 6
	_static_UIConstants["TANK_ICON_SIZES"] = {"SMALL": "small", "MEDIUM": "medium", "LARGE": "large"}
	_static_UIConstants["TANK_ICON_RESOLUTIONS"] = {"small": 140, "medium": 200, "large": 320}
	_static_UIConstants["TANK_ICON_TINT_PARTS"] = {"TURRET": "turret", "TREAD": "tread", "BASE": "base"}
	_static_UIConstants["TANK_ICON_PARTS"] = {"TURRET": "turret", "BARREL": "barrel", "LEFT_TREAD": "leftTread", "RIGHT_TREAD": "rightTread", "BASE": "base", "TURRET_SHADE": "turretShade", "BARREL_SHADE": "barrelShade", "LEFT_TREAD_SHADE": "leftTreadShade", "RIGHT_TREAD_SHADE": "rightTreadShade", "BASE_SHADE": "baseShade"}
	_static_UIConstants["TANK_ICON_ACCESSORY_PARTS"] = {"TURRET": "turret", "BARREL": "barrel", "FRONT": "front", "BACK": "back", "TREAD": "tread", "BACKGROUND": "background", "BADGE": "badge"}
	_static_UIConstants["TANK_UNAVAILABLE_COLOUR"] = {"type": "numeric", "rawValue": "0x888888", "numericValue": "0x888888", "imageValue": ""}
	_static_UIConstants["GAME_ICON_POOL_SIZE"] = 5
	_static_UIConstants["GAME_ICON_TANK_COUNT"] = 4
	_static_UIConstants["TANK_AVATAR_POOL_SIZE"] = 10
	_static_UIConstants["TANK_ICON_POOL_SIZE"] = 10
	_static_UIConstants["REFRESH_GAME_LIST_INTERVAL"] = 10000
	_static_UIConstants["INITIAL_SERVER_STATS_DELAY"] = 2000
	_static_UIConstants["REFRESH_SERVER_STATS_INTERVAL"] = 60000
	_static_UIConstants["ELEMENT_POP_IN_TIME"] = 300
	_static_UIConstants["ELEMENT_GLIDE_OUT_TIME"] = 200
	_static_UIConstants["ELEMENT_MOVE_TIME"] = 300
	_static_UIConstants["ELEMENT_SELECTION_TIME"] = 200
	_static_UIConstants["ELEMENT_DESELECTION_TIME"] = 200
	_static_UIConstants["GAME_ICON_COUNT"] = 3
	_static_UIConstants["GAME_ICON_WIDTH"] = 160
	_static_UIConstants["GAME_ICON_HEIGHT"] = 120
	_static_UIConstants["GAME_ICON_MARGIN"] = 120
	_static_UIConstants["GAME_ICON_Y"] = 100
	_static_UIConstants["LOGIN_BACKGROUND_TOP_MARGIN"] = 20
	_static_UIConstants["LOGIN_BACKGROUND_SIDE_MARGIN"] = 40
	_static_UIConstants["LOGIN_BACKGROUND_BOTTOM_MARGIN"] = 70
	_static_UIConstants["BUTTON_SIZES"] = {"SMALL": "small", "MEDIUM": "medium", "LARGE": "large"}
	_static_UIConstants["BUTTON_RESOLUTIONS"] = {"small": 24, "medium": 34, "large": 52}
	_static_UIConstants["BUTTON_HEIGHTS"] = {"small": 24, "medium": 34, "large": 52}
	_static_UIConstants["BUTTON_FONT_SIZES"] = {"small": 12.6, "medium": 16.8, "large": 28}
	_static_UIConstants["BUTTON_MARGINS"] = {"small": 5, "medium": 10, "large": 20}
	_static_UIConstants["BUTTON_SHADOW_WIDTH"] = 6
	_static_UIConstants["BUTTON_SHADOW_HEIGHT_TOP"] = 3
	_static_UIConstants["BUTTON_SHADOW_HEIGHT_BOTTOM"] = 9
	_static_UIConstants["BUTTON_ACTIVE_OFFSET"] = 2
	_static_UIConstants["BUTTON_FONT_BASELINE_FRACTION"] = (JS.number(170) / JS.number(1000))
	_static_UIConstants["OVERLAY_FADE_TIME"] = 200
	_static_UIConstants["MENU_BACKGROUND_MIN_TOP_MARGIN"] = 10
	_static_UIConstants["MENU_BACKGROUND_HEIGHT_RATIO"] = 0.81
	_static_UIConstants["MENU_BACKGROUND_Y_RATIO"] = 0.43
	_static_UIConstants["MENU_BUTTON_WIDTHS"] = {"small": 80, "medium": 120, "large": 200}
	_static_UIConstants["MENU_BUTTON_SPACINGS"] = {"small": 10, "medium": 15, "large": 25}
	_static_UIConstants["MENU_BUTTON_BACKGROUND_Y_RATIO"] = 0.93
	_static_UIConstants["MENU_LAIKA_X"] = -(148)
	_static_UIConstants["MENU_LAIKA_MIN_EVENT_DELAY"] = 15
	_static_UIConstants["MENU_LAIKA_MAX_EVENT_DELAY"] = 30
	_static_UIConstants["MENU_LAIKA_Y"] = 16
	_static_UIConstants["MENU_LAIKA_GROWL_TIME"] = 2000
	_static_UIConstants["MENU_LAIKA_HOWL_TIME"] = 2500
	_static_UIConstants["MENU_DIMITRI_X"] = 98
	_static_UIConstants["MENU_DIMITRI_Y"] = -(33)
	_static_UIConstants["MENU_DIMITRI_MIN_EVENT_DELAY"] = 15
	_static_UIConstants["MENU_DIMITRI_MAX_EVENT_DELAY"] = 30
	_static_UIConstants["MENU_DIMITRI_SCOWL_TIME"] = 3000
	_static_UIConstants["BUTTON_INFO_FONT_SIZE"] = 14
	_static_UIConstants["DISCONNECTED_ICON_Y"] = 110
	_static_UIConstants["DISCONNECTED_HEADER_Y"] = -(74)
	_static_UIConstants["DISCONNECTED_MESSAGE_Y"] = 64
	_static_UIConstants["DISCONNECTED_HEADER_FONT_SIZE"] = 24
	_static_UIConstants["DISCONNECTED_HEADER_STROKE_WIDTH"] = 4
	_static_UIConstants["DISCONNECTED_MESSAGE_FONT_SIZE"] = 16
	_static_UIConstants["DISCONNECTED_MESSAGE_STROKE_WIDTH"] = 4
	_static_UIConstants["DISCONNECTED_MESSAGE_UPDATE_TIME"] = 2800
	_static_UIConstants["DISCONNECTED_DELAY_TIME"] = 100
	_static_UIConstants["CONNECTING_MESSAGES"] = ["Establishing communications", "Making contact", "Calling for backup", "Awaiting signal", "Wiring telegram", "Telegraphing code", "Negotiating terms", "Preparing nukes", "Reloading turrets", "Reheating the Cold War", "Cleaning the pipes", "Broadcasting propaganda"]
	_static_UIConstants["USERNAME_FONT_SIZE"] = 24
	_static_UIConstants["USERNAME_STROKE_WIDTH"] = 4
	_static_UIConstants["TANK_NAME_FONT_SIZE"] = 32
	_static_UIConstants["TANK_NAME_STROKE_WIDTH"] = 8
	_static_UIConstants["TANK_NAME_MARGIN"] = 5
	_static_UIConstants["JOIN_GAME_BUTTON_INFO_Y"] = 31
	_static_UIConstants["JOIN_GAME_BUTTON_Y"] = 218
	_static_UIConstants["RANDOM_GAME_BUTTON_INFO_Y"] = 40
	_static_UIConstants["CREATE_GAME_BUTTON_INFO_Y"] = 40
	_static_UIConstants["TANK_ICON_WIDTH_SMALL"] = 140
	_static_UIConstants["TANK_ICON_HEIGHT_SMALL"] = 84
	_static_UIConstants["TANK_ICON_WIDTH_MEDIUM"] = 200
	_static_UIConstants["TANK_ICON_HEIGHT_MEDIUM"] = 120
	_static_UIConstants["TANK_ICON_WIDTH_LARGE"] = 320
	_static_UIConstants["TANK_ICON_HEIGHT_LARGE"] = 192
	_static_UIConstants["TANK_ICON_PLACEMENTS"] = [{"x": -(70), "y": 35, "flipped": false}, {"x": 70, "y": 35, "flipped": true}, {"x": -(70), "y": -(60), "flipped": false}, {"x": 70, "y": -(60), "flipped": true}]
	_static_UIConstants["TANK_NAME_PLACEMENTS"] = [{"x": -(70), "y": 75}, {"x": 70, "y": 75}, {"x": -(70), "y": -(20)}, {"x": 70, "y": -(20)}]
	_static_UIConstants["AVATAR_LAIKA_X"] = 190
	_static_UIConstants["AVATAR_LAIKA_Y"] = 40
	_static_UIConstants["AVATAR_LAIKA_SCALE"] = 0.3
	_static_UIConstants["AVATAR_LAIKA_GROWL_TIME"] = 1500
	_static_UIConstants["AVATAR_LAIKA_WHIMPER_TIME"] = 2000
	_static_UIConstants["AVATAR_LAIKA_GASP_TIME"] = 1500
	_static_UIConstants["AVATAR_LAIKA_GLOAT_CHANCE"] = 0.3
	_static_UIConstants["AVATAR_LAIKA_HOWL_TIME"] = 2000
	_static_UIConstants["AVATAR_DIMITRI_X"] = 100
	_static_UIConstants["AVATAR_DIMITRI_Y"] = 40
	_static_UIConstants["AVATAR_DIMITRI_SCALE"] = 0.4
	_static_UIConstants["AVATAR_DIMITRI_GASP_CHANCE"] = 0.4
	_static_UIConstants["AVATAR_DIMITRI_GASP_TIME"] = 1500
	_static_UIConstants["AVATAR_DIMITRI_GLOAT_CHANCE"] = 0.4
	_static_UIConstants["AVATAR_DIMITRI_SCOWL_TIME"] = 2000
	_static_UIConstants["TANK_ICON_OUTLINE_WIDTH"] = 1
	_static_UIConstants["CONTROL_SELECTED_WAIT_TIME"] = 500
	_static_UIConstants["WEAPON_ICON_WIDTH"] = 36
	_static_UIConstants["WEAPON_ICON_MAX_SCALE"] = 0.8
	_static_UIConstants["WEAPON_ICON_SCALE_STEP"] = 0.1
	_static_UIConstants["FAVOURITE_ICON_WIDTH"] = 20
	_static_UIConstants["FAVOURITE_ICON_HEIGHT"] = 20
	_static_UIConstants["LEAVE_GAME_BUTTON_WIDTH"] = 35
	_static_UIConstants["LEAVE_GAME_MESSAGE_FONT_SIZE"] = 16
	_static_UIConstants["LEAVE_GAME_MESSAGE_STROKE_WIDTH"] = 4
	_static_UIConstants["LEAVE_GAME_MESSAGE_DELAY"] = 200
	_static_UIConstants["LEAVE_GAME_MARGIN"] = 28
	_static_UIConstants["RANK_ICON_WIDTH"] = 22
	_static_UIConstants["RANK_ICON_HEIGHT"] = 24
	_static_UIConstants["GUEST_ICON_WIDTH"] = 14
	_static_UIConstants["GUEST_ICON_HEIGHT"] = 24
	_static_UIConstants["WAITING_ICON_WIDTH"] = 199
	_static_UIConstants["WAITING_ICON_HEIGHT"] = 210
	_static_UIConstants["WAITING_HEADER_Y"] = -(128)
	_static_UIConstants["WAITING_MESSAGE_Y"] = 128
	_static_UIConstants["WAITING_MAX_DOTS"] = 3
	_static_UIConstants["WAITING_UPDATE_TIME"] = 200
	_static_UIConstants["WAITING_HEADER_FONT_SIZE"] = 24
	_static_UIConstants["WAITING_HEADER_STROKE_WIDTH"] = 4
	_static_UIConstants["WAITING_MESSAGE_FONT_SIZE"] = 16
	_static_UIConstants["WAITING_MESSAGE_STROKE_WIDTH"] = 4
	_static_UIConstants["WAITING_FOR_ROUND_TITLE_TIME"] = 1000
	_static_UIConstants["WAITING_FOR_MAZE_REMOVAL_TIME"] = 1000
	_static_UIConstants["WAITING_FOR_PLAYERS_DELAY_TIME"] = 1500
	_static_UIConstants["WAITING_FOR_CELEBRATION_TIME"] = 7000
	_static_UIConstants["CELEBRATION_TROPHY_LIFETIME"] = 1
	_static_UIConstants["CELEBRATION_TANK_LIFETIME"] = 5.5
	_static_UIConstants["CELEBRATION_PRIZE_HANDOUT_TIME"] = 3.5
	_static_UIConstants["CELEBRATION_HEADER_Y"] = -(128)
	_static_UIConstants["CELEBRATION_HEADER_FONT_SIZE"] = 24
	_static_UIConstants["CELEBRATION_HEADER_STROKE_WIDTH"] = 4
	_static_UIConstants["CELEBRATION_TIE_Y"] = 64
	_static_UIConstants["TROPHY_EXPLOSION_Y"] = 55
	_static_UIConstants["TROPHY_EXPLOSION_MIN_X_SPEED"] = -(80)
	_static_UIConstants["TROPHY_EXPLOSION_MAX_X_SPEED"] = 80
	_static_UIConstants["TROPHY_EXPLOSION_MIN_Y_SPEED"] = -(110)
	_static_UIConstants["TROPHY_EXPLOSION_MAX_Y_SPEED"] = 30
	_static_UIConstants["TROPHY_EXPLOSION_DRAG_X"] = 25
	_static_UIConstants["TROPHY_EXPLOSION_DRAG_Y"] = 37
	_static_UIConstants["TROPHY_EXPLOSION_FLOOR_Y"] = 90
	_static_UIConstants["TROPHY_FRAGMENT_MIN_SPEED"] = 170
	_static_UIConstants["TROPHY_FRAGMENT_MAX_SPEED"] = 270
	_static_UIConstants["TROPHY_FRAGMENT_MAX_ROTATION_SPEED"] = 30
	_static_UIConstants["TROPHY_FRAGMENT_MIN_ANGLE"] = -(1.0367)
	_static_UIConstants["TROPHY_FRAGMENT_MAX_ANGLE"] = -(2.0734)
	_static_UIConstants["TROPHY_FRAGMENT_GRAVITY"] = 250
	_static_UIConstants["TROPHY_FRAGMENT_POOL_SIZE"] = 12
	_static_UIConstants["TROPHY_BASE_FRAGMENT_POOL_SIZE"] = 4
	_static_UIConstants["TROPHY_BASE_FRAGMENT_EXPLOSION_OFFSET"] = 30
	_static_UIConstants["CONFETTI_COLORS"] = [670683, 14762049, 1548314, 16248668, 14448414, 12261023]
	_static_UIConstants["CONFETTI_MIN_X_SPEED"] = -(300)
	_static_UIConstants["CONFETTI_MAX_X_SPEED"] = 300
	_static_UIConstants["CONFETTI_MIN_Y_SPEED"] = -(430)
	_static_UIConstants["CONFETTI_MAX_Y_SPEED"] = 50
	_static_UIConstants["CONFETTI_DRAG"] = 200
	_static_UIConstants["CONFETTI_GRAVITY"] = 250
	_static_UIConstants["CONFETTI_WOBBLE_KICK_IN_SPEED"] = 1.5
	_static_UIConstants["CONFETTI_WOBBLE_MIN_FREQUENCY"] = 2.5
	_static_UIConstants["CONFETTI_WOBBLE_MAX_FREQUENCY"] = 7.5
	_static_UIConstants["CONFETTI_WOBBLE_AMPLITUDE"] = 5
	_static_UIConstants["CONFETTI_Y_VARIATION"] = 20
	_static_UIConstants["STREAMER_MIN_SPEED"] = 250
	_static_UIConstants["STREAMER_MAX_SPEED"] = 300
	_static_UIConstants["STREAMER_MIN_ANGLE"] = -(0.785398)
	_static_UIConstants["STREAMER_MAX_ANGLE"] = -(2.35619)
	_static_UIConstants["STREAMER_LIFETIME"] = 2.5
	_static_UIConstants["STREAMER_WIDTH"] = 6
	_static_UIConstants["STREAMER_FREQUENCY"] = 0.1
	_static_UIConstants["STREAMER_AMPLITUDE_X"] = 10
	_static_UIConstants["STREAMER_AMPLITUDE_Y"] = 8.5
	_static_UIConstants["TANK_PANEL_MAX_WIDTH"] = 800
	_static_UIConstants["TANK_PANEL_MAX_HEIGHT"] = 180
	_static_UIConstants["TANK_PANEL_SIDE_MARGIN"] = 30
	_static_UIConstants["TANK_PANEL_MIN_WIDTH_PER_ICON"] = 137
	_static_UIConstants["TANK_PANEL_MAX_ICONS_BEFORE_INTERLEAVING"] = 3
	_static_UIConstants["TANK_PANEL_ICON_INTERLEAVE_SCALE"] = 0.9
	_static_UIConstants["TANK_PANEL_INTERLEAVE_HEIGHT"] = 20
	_static_UIConstants["TANK_PANEL_INTERLEAVE_OFFSET"] = 8
	_static_UIConstants["TANK_PANEL_ICON_BOTTOM_MARGIN"] = 50
	_static_UIConstants["TANK_PANEL_NAME_BOTTOM_MARGIN"] = 54
	_static_UIConstants["TANK_PANEL_SCORE_BOTTOM_MARGIN"] = 30
	_static_UIConstants["RANK_LEVEL_UP_SPARKLE_POOL_SIZE"] = 12
	_static_UIConstants["RANK_LEVEL_DOWN_SHAKE_OFFSET"] = 1.5
	_static_UIConstants["RANK_LEVEL_DOWN_TEAR_MIN_OFFSET"] = 7.5
	_static_UIConstants["RANK_LEVEL_DOWN_TEAR_RANDOM_OFFSET"] = 10
	_static_UIConstants["RANK_LEVEL_DOWN_TEAR_Y_OFFSET"] = 2.5
	_static_UIConstants["SCORE_EXPLOSION_Y"] = 9
	_static_UIConstants["SCORE_EXPLOSION_MIN_X_SPEED"] = -(60)
	_static_UIConstants["SCORE_EXPLOSION_MAX_X_SPEED"] = 60
	_static_UIConstants["SCORE_EXPLOSION_MIN_Y_SPEED"] = -(110)
	_static_UIConstants["SCORE_EXPLOSION_MAX_Y_SPEED"] = -(40)
	_static_UIConstants["SCORE_EXPLOSION_DRAG"] = 50
	_static_UIConstants["SCORE_FRAGMENT_MIN_SPEED"] = 50
	_static_UIConstants["SCORE_FRAGMENT_MAX_SPEED"] = 150
	_static_UIConstants["SCORE_FRAGMENT_MAX_ROTATION_SPEED"] = 30
	_static_UIConstants["SCORE_FRAGMENT_MIN_ANGLE"] = -(1.0367)
	_static_UIConstants["SCORE_FRAGMENT_MAX_ANGLE"] = -(2.0734)
	_static_UIConstants["SCORE_FRAGMENT_POOL_SIZE"] = 30
	_static_UIConstants["MAX_SCORE_FRAGMENTS_PER_EXPLOSION"] = 15
	_static_UIConstants["MIN_SCORE_FRAGMENTS_PER_LETTER"] = 5
	_static_UIConstants["SCORE_FONT_SIZE"] = 20
	_static_UIConstants["SCORE_STROKE_WIDTH"] = 4
	_static_UIConstants["PLAYER_PANEL_GRAVITY"] = 175
	_static_UIConstants["GAME_MODE_NAME_INFO"] = [{"NAME": "Last Tank Standing", "ICON": -(1)}, {"NAME": "Boot Camp", "ICON": -(1)}, {"NAME": "Deathmatch", "ICON": 0}]
	_static_UIConstants["GAME_MODE_SCORE_ITEM_INFO"] = [{"ITEM_CONFIG": [{"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "EMBLEM"), "type": JS.get_property(JS.get_property(JS.module("Constants"), "EMBLEM_TYPES"), "TERMINATOR"), "anchorX": 0.5}, {"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "SCORE"), "type": JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "KILL"), "anchorX": 1}, {"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "SEPARATOR"), "type": null, "anchorX": 0.5}, {"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "SCORE"), "type": JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "VICTORY"), "anchorX": 0}, {"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "EMBLEM"), "type": JS.get_property(JS.get_property(JS.module("Constants"), "EMBLEM_TYPES"), "DOMINATOR"), "anchorX": 0.5}], "CENTER_ITEM": 2}, {"ITEM_CONFIG": [{"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "SCORE"), "type": JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "KILL"), "anchorX": 1}, {"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "SEPARATOR"), "type": null, "anchorX": 0.5}, {"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "SCORE"), "type": JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "VICTORY"), "anchorX": 0}], "CENTER_ITEM": 1}, {"ITEM_CONFIG": [{"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "EMBLEM"), "type": JS.get_property(JS.get_property(JS.module("Constants"), "EMBLEM_TYPES"), "TERMINATOR"), "anchorX": 0.5}, {"category": JS.get_property(JS.get_property(_static_UIConstants, "SCORE_CATEGORIES"), "SCORE"), "type": JS.get_property(JS.get_property(JS.module("Constants"), "SCORE_TYPES"), "KILL"), "anchorX": 0.5}], "CENTER_ITEM": 1}]
	_static_UIConstants["SCORE_ITEM_INFO"] = [{"paddingX": 5, "offsetY": -(4)}, {"paddingX": 0, "offsetY": 0}, {"paddingX": 1.5, "offsetY": -(2)}]
	_static_UIConstants["THEME_MUSIC"] = [["assets/audio/PanzerPolka.m4a", "assets/audio/PanzerPolkaFiltered.m4a"], ["assets/audio/SpooktacularOClock.m4a", "assets/audio/SpooktacularOClockFiltered.m4a"], ["assets/audio/BalalaikaBlowout.m4a", "assets/audio/BalalaikaBlowoutFiltered.m4a"]]
	_static_UIConstants["ERROR_WIDTH"] = 280
	_static_UIConstants["TANK_INFO_WIDTH"] = 218
	_static_UIConstants["TANK_INFO_MAX_NUMBER_WIDTH"] = 58
	_static_UIConstants["RANK_TITLES"] = ["Dog Food", "Lab Rat", "Intern", "Scavenger", "Cadet", "Sergeant", "Captain", "Commander", "Jr. Scientist", "Scientist", "Lead Scientist", "Mad Scientist"]
	_static_UIConstants["RANK_LEVELS"] = [5, 10, 25, 50, 100, 150, 250, 500, 1000, 1500, 2000]
	_static_UIConstants["XP_LEVELS"] = [1000, 3000, 6000, 10000, 15000, 21000, 28000, 36000, 45000, 55000, 66000, 78000, 91000, 105000, 120000, 136000, 153000, 171000, 190000]
	_static_UIConstants["SETTINGS_WIDTH"] = 250
	_static_UIConstants["SETTINGS_SERVER_SELECT_HEIGHT"] = 30
	_static_UIConstants["SETTINGS_SERVER_MAX_OPTION_HEIGHT"] = 280
	_static_UIConstants["SETTINGS_QUALITY_SELECT_HEIGHT"] = 30
	_static_UIConstants["SETTINGS_QUALITY_MAX_OPTION_HEIGHT"] = 100
	_static_UIConstants["SETTINGS_QUALITY_FPS_AVG_WEIGHT"] = 0.15
	_static_UIConstants["SETTINGS_QUALITY_FPS_MIN_SAMPLES"] = 300
	_static_UIConstants["SETTINGS_QUALITY_FPS_CHANGE_TO_LOW"] = 30
	_static_UIConstants["SETTINGS_QUALITY_FPS_SAMPLE_UPDATE_INTERVAL"] = 120
	_static_UIConstants["MAXIMUM_GOOD_LATENCY"] = 150
	_static_UIConstants["MAXIMUM_AVERAGE_LATENCY"] = 300
	_static_UIConstants["MINIMUM_GOOD_FPS"] = 55
	_static_UIConstants["MINIMUM_AVERAGE_FPS"] = 45
	_static_UIConstants["SELECT_USER_WIDTH_PER_USER"] = 114
	_static_UIConstants["REQUEST_MAZE_INTERVAL"] = 1000
	_static_UIConstants["COUNT_DOWN_POOL_SIZE"] = 3
	_static_UIConstants["TANK_POOL_SIZE"] = 8
	_static_UIConstants["TANK_NAME_POOL_SIZE"] = 8
	_static_UIConstants["CRATE_POOL_SIZE"] = 3
	_static_UIConstants["GOLD_POOL_SIZE"] = 3
	_static_UIConstants["DIAMOND_SHINE_POOL_SIZE"] = 1
	_static_UIConstants["DIAMOND_POOL_SIZE"] = 1
	_static_UIConstants["SPARKLE_POOL_SIZE"] = 12
	_static_UIConstants["PROJECTILE_POOL_SIZE"] = 40
	_static_UIConstants["SHRAPNEL_POOL_SIZE"] = 240
	_static_UIConstants["MISSILE_POOL_SIZE"] = 8
	_static_UIConstants["LASER_POOL_SIZE"] = 8
	_static_UIConstants["MINE_POOL_SIZE"] = 24
	_static_UIConstants["AIMER_POOL_SIZE"] = 8
	_static_UIConstants["SPAWN_ZONE_POOL_SIZE"] = 8
	_static_UIConstants["SHIELD_POOL_SIZE"] = 8
	_static_UIConstants["TANK_FEATHER_POOL_SIZE"] = 50
	_static_UIConstants["TANK_EXPLOSION_POOL_SIZE"] = 8
	_static_UIConstants["EXPLOSION_POOL_SIZE"] = 12
	_static_UIConstants["BULLET_PUFF_POOL_SIZE"] = 100
	_static_UIConstants["MISSILE_LAUNCH_SMOKE_POOL_SIZE"] = 80
	_static_UIConstants["CHAT_SYMBOL_POOL_SIZE"] = 8
	_static_UIConstants["WEAPON_SYMBOL_POOL_SIZE"] = 8
	_static_UIConstants["ROUND_TITLE_FONT_SIZE"] = 48
	_static_UIConstants["ROUND_TITLE_STROKE_WIDTH"] = 4
	_static_UIConstants["ROUND_RANKED_FONT_SIZE"] = 24
	_static_UIConstants["ROUND_TITLE_SPACING"] = 40
	_static_UIConstants["ROUND_TITLE_OFFSET"] = -(100)
	_static_UIConstants["ROUND_TITLE_DISPLAY_TIME"] = 2000
	_static_UIConstants["COUNT_DOWN_DISPLAY_TIME"] = 500
	_static_UIConstants["TANK_NAME_DISPLAY_TIME"] = 2.5
	_static_UIConstants["CHAT_SYMBOL_DISPLAY_TIME"] = 3
	_static_UIConstants["TANK_LOCAL_SMOOTHING"] = 1
	_static_UIConstants["TANK_ONLINE_SMOOTHING"] = 3
	_static_UIConstants["TANK_LEFT_TREAD_X"] = -(13)
	_static_UIConstants["TANK_RIGHT_TREAD_X"] = 13
	_static_UIConstants["TANK_TURRET_Y"] = -(8)
	_static_UIConstants["TANK_TREAD_FORWARD_SPEED"] = 0.108
	_static_UIConstants["TANK_TREAD_INNER_FORWARD_SPEED"] = 0.024
	_static_UIConstants["TANK_TREAD_BACK_SPEED"] = 0.084
	_static_UIConstants["TANK_TREAD_INNER_BACK_SPEED"] = 0.012
	_static_UIConstants["TANK_TREAD_TURN_SPEED"] = 0.069
	_static_UIConstants["COUNT_DOWN_AUDIO_COUNT"] = 4
	_static_UIConstants["EMPTY_BARREL_AUDIO_COUNT"] = 4
	_static_UIConstants["FIRE_BULLET_AUDIO_COUNT"] = 2
	_static_UIConstants["BULLET_BOUNCE_AUDIO_COUNT"] = 12
	_static_UIConstants["SHIELD_IMPACT_AUDIO_COUNT"] = 3
	_static_UIConstants["BULLET_PUFF_AUDIO_COUNT"] = 3
	_static_UIConstants["SHRAPNEL_HIT_AUDIO_COUNT"] = 7
	_static_UIConstants["MINE_EXPLOSION_AUDIO_COUNT"] = 3
	_static_UIConstants["MISSILE_TARGETING_AUDIO_COUNT"] = 11
	_static_UIConstants["TANK_EXPLOSION_AUDIO_COUNT"] = 3
	_static_UIConstants["LAIKA_HOWL_AUDIO_COUNT"] = 2
	_static_UIConstants["LASER_RETRACTION_TIME"] = 0.05
	_static_UIConstants["LASER_WIDTH"] = 4
	_static_UIConstants["MINE_EXPLOSION_CAMERA_SHAKE"] = 5
	_static_UIConstants["MINE_SHRAPNEL_MIN_ROTATION_SPEED"] = 3.14
	_static_UIConstants["MINE_SHRAPNEL_MAX_ROTATION_SPEED"] = 9.42
	_static_UIConstants["MISSILE_LAUNCH_MIN_SPEED"] = 70
	_static_UIConstants["MISSILE_LAUNCH_MAX_SPEED"] = 90
	_static_UIConstants["MISSILE_SMOKE_COLOUR"] = 0
	_static_UIConstants["MISSILE_TARGETING_SOUND_INTERVAL_PER_TILE"] = 0.2
	_static_UIConstants["GATLING_GUN_MIN_ANIMATION_SPEED"] = 12
	_static_UIConstants["GATLING_GUN_ANIMATION_SPEED_RANGE"] = 36
	_static_UIConstants["AIMER_WIDTH"] = 4
	_static_UIConstants["AIMER_OFFSET"] = 50
	_static_UIConstants["AIMER_MIN_STEP_LENGTH"] = 0.01
	_static_UIConstants["SHIELD_SPARK_BOLT_POOL_SIZE"] = 10
	_static_UIConstants["SHIELD_SPARK_SPEED"] = 150
	_static_UIConstants["SHIELD_SPARK_RANDOM_SPEED"] = 75
	_static_UIConstants["SHIELD_SPAWN_TIME"] = 300
	_static_UIConstants["SHIELD_LAYER_1_ROTATION_SPEED"] = 0.4
	_static_UIConstants["SHIELD_LAYER_2_ROTATION_SPEED"] = -(0.25)
	_static_UIConstants["SHIELD_NUM_BOLTS"] = 5
	_static_UIConstants["SHIELD_BOLT_MIN_ROTATION_SPEED"] = 0.3
	_static_UIConstants["SHIELD_BOLT_MAX_ROTATION_SPEED"] = 0.6
	_static_UIConstants["SHIELD_BREAK_TIME"] = 200
	_static_UIConstants["INVERSE_SHIELD_WEAKENED_FLICKER_PROBABILITY"] = 0.5
	_static_UIConstants["SHIELD_WEAKENED_FLICKER_ALPHA_MIN"] = 0.2
	_static_UIConstants["SHIELD_WEAKENED_FLICKER_ALPHA_MAX"] = 0.7
	_static_UIConstants["INVERSE_SHIELD_SPARK_PROBABILITY_IN_COLLISION"] = 0.85
	_static_UIConstants["COUNTER_TIMER_POOL_SIZE"] = 2
	_static_UIConstants["TIMER_TOP_MARGIN"] = 20
	_static_UIConstants["TIMER_SPACING"] = 6
	_static_UIConstants["TIMER_FONT_SIZE"] = 24
	_static_UIConstants["TIMER_STROKE_WIDTH"] = 4
	_static_UIConstants["TIMER_COUNT_SCALE"] = 1.3
	_static_UIConstants["TIMER_EMPHASIZE_SCALE"] = 1.5
	_static_UIConstants["OVERTIME_BLINK_SPEED"] = 10
	_static_UIConstants["OVERTIME_BLINK_COLORS"] = [16711680, 16776960]
	_static_UIConstants["OVERTIME_SCALE_TIME"] = 500
	_static_UIConstants["OVERTIME_SCALE"] = 1.2
	_static_UIConstants["SPAWN_ZONE_SPAWN_TIME"] = 300
	_static_UIConstants["SPAWN_ZONE_NUM_BOLTS"] = 5
	_static_UIConstants["SPAWN_ZONE_HOLE_EXPANSION_TIME"] = 0.5
	_static_UIConstants["SPAWN_ZONE_HOLE_EXPANSION_SIZE"] = 5
	_static_UIConstants["SPAWN_ZONE_SPARK_SPEED"] = 150
	_static_UIConstants["SPAWN_ZONE_SPARK_RANDOM_SPEED"] = 25
	_static_UIConstants["SPAWN_ZONE_HOLE_1_ROTATION_SPEED"] = 0.5
	_static_UIConstants["SPAWN_ZONE_HOLE_2_ROTATION_SPEED"] = -(0.25)
	_static_UIConstants["SPAWN_ZONE_SWIRL_1_ROTATION_SPEED"] = 1
	_static_UIConstants["SPAWN_ZONE_SWIRL_2_ROTATION_SPEED"] = -(1.2)
	_static_UIConstants["INVERSE_SPAWN_ZONE_STABLE_BOLT_PROBABILITY"] = 0.99
	_static_UIConstants["INVERSE_SPAWN_ZONE_UNSTABLE_BOLT_PROBABILITY"] = 0.97
	_static_UIConstants["SPAWN_ZONE_UNSTABLE_SHAKE"] = 2
	_static_UIConstants["SPAWN_ZONE_UNSTABLE_BOLT_OFFSET"] = 10
	_static_UIConstants["SPAWN_ZONE_UNSTABLE_PARTICLE_OFFSET"] = 50
	_static_UIConstants["SPAWN_ZONE_UNSTABLE_PARTICLE_SPEED"] = -(1.5)
	_static_UIConstants["SPAWN_ZONE_COLLAPSE_MIN_PARTICLE_SPEED"] = 0.7
	_static_UIConstants["SPAWN_ZONE_COLLAPSE_MAX_PARTICLE_SPEED"] = 1.2
	_static_UIConstants["SPAWN_ZONE_BREAK_DELAY"] = 300
	_static_UIConstants["SPAWN_ZONE_BREAK_TIME"] = 200
	_static_UIConstants["STORM_ZONE_TILE_SPRITE_RESOLUTION"] = 256
	_static_UIConstants["STORM_ZONE_TILE_SPRITE_RANDOM_OFFSET"] = 100
	_static_UIConstants["STORM_ZONE_TILE_SPRITE_SCROLL_SPEED"] = 1
	_static_UIConstants["STORM_ZONE_NUM_LIGHTNINGS"] = 20
	_static_UIConstants["STORM_ZONE_MIN_STORM_PARTICLE_LIFETIME"] = 2
	_static_UIConstants["STORM_ZONE_MAX_STORM_PARTICLE_LIFETIME"] = 3
	_static_UIConstants["STORM_ZONE_FIRST_STORM_PARTICLE_RADIUS_MULTIPLIER"] = 0.1
	_static_UIConstants["STORM_ZONE_STORM_PARTICLE_RADIUS_MULTIPLIER"] = 1
	_static_UIConstants["STORM_ZONE_MIN_STORM_PARTICLE_RADIUS"] = 30
	_static_UIConstants["STORM_ZONE_MAX_STORM_PARTICLE_RADIUS"] = 50
	_static_UIConstants["STORM_ZONE_EXPANSION_STORM_PARTICLE_RADIUS_MULTIPLIER"] = 1.5
	_static_UIConstants["STORM_ZONE_EXPANSION_STORM_PARTICLE_LIFETIME_MULTIPLIER"] = 0.5
	_static_UIConstants["STORM_ZONE_STORM_PARTICLE_RANDOM_SPEED"] = 150
	_static_UIConstants["STORM_ZONE_STORM_PARTICLE_MIN_SPEED_CLAMP_MULTIPLIER"] = 0.1
	_static_UIConstants["STORM_ZONE_STRIKE_TANK_RANDOM_ANGLE"] = 1.25
	_static_UIConstants["STORM_ZONE_STRIKE_TANK_MAX_RANDOM_OFFSET"] = 2.5
	_static_UIConstants["TANK_FEATHER_COUNT"] = 30
	_static_UIConstants["CRATE_SPAWN_TIME"] = 500
	_static_UIConstants["GOLD_SPAWN_TIME"] = 500
	_static_UIConstants["GOLD_MIN_ROTATION_SPEED"] = 18
	_static_UIConstants["GOLD_MAX_ROTATION_SPEED"] = 22
	_static_UIConstants["GOLD_SPARKLE_MIN_INTERVAL_TIME"] = 500
	_static_UIConstants["GOLD_SPARKLE_MAX_INTERVAL_TIME"] = 1500
	_static_UIConstants["DIAMOND_SPAWN_TIME"] = 500
	_static_UIConstants["DIAMOND_GLOW_SCALE_CYCLE_SPEED"] = 2
	_static_UIConstants["DIAMOND_FIRST_RAY_OPACITY_CYCLE_SPEED"] = 2
	_static_UIConstants["DIAMOND_FIRST_RAY_ROTATION_SPEED"] = 0.5
	_static_UIConstants["DIAMOND_SECOND_RAY_OPACITY_CYCLE_SPEED"] = 3
	_static_UIConstants["DIAMOND_SECOND_RAY_OPACITY_CYCLE_PHASE"] = 1
	_static_UIConstants["DIAMOND_SECOND_RAY_ROTATION_SPEED"] = 0.5
	_static_UIConstants["DIAMOND_SPARKLE_MIN_INTERVAL_TIME"] = 500
	_static_UIConstants["DIAMOND_SPARKLE_MAX_INTERVAL_TIME"] = 1500
	_static_UIConstants["SPARKLE_ANIMATION_TIME"] = 500
	_static_UIConstants["EXPLOSION_FRAGMENT_COUNT"] = 15
	_static_UIConstants["EXPLOSION_FRAGMENT_COLLISION_TIME"] = 0.1
	_static_UIConstants["EXPLOSION_FRAGMENT_MIN_LIFETIME"] = 2
	_static_UIConstants["EXPLOSION_FRAGMENT_MAX_LIFETIME"] = 3
	_static_UIConstants["EXPLOSION_FRAGMENT_MIN_SPEED"] = 50
	_static_UIConstants["EXPLOSION_FRAGMENT_MAX_SPEED"] = 300
	_static_UIConstants["EXPLOSION_FRAGMENT_MAX_ROTATION_SPEED"] = 30
	_static_UIConstants["RUBBLE_FRAGMENT_POOL_SIZE"] = 25
	_static_UIConstants["INVERSE_RUBBLE_SPAWN_PROBABILITY_IN_THE_OPEN"] = 0.99
	_static_UIConstants["INVERSE_RUBBLE_SPAWN_PROBABILITY_IN_COLLISION"] = 0.83
	_static_UIConstants["RUBBLE_FRAGMENT_MIN_LIFETIME"] = 0.5
	_static_UIConstants["RUBBLE_FRAGMENT_MAX_LIFETIME"] = 0.8
	_static_UIConstants["RUBBLE_FRAGMENT_SPEED_SCALE"] = 25
	_static_UIConstants["RUBBLE_FRAGMENT_RANDOM_SPEED"] = 120
	_static_UIConstants["RUBBLE_FRAGMENT_MAX_ROTATION_SPEED"] = 40
	_static_UIConstants["RUBBLE_SMOKE_SPEED_SCALE"] = 15
	_static_UIConstants["RUBBLE_SMOKE_RANDOM_SPEED"] = 65
	_static_UIConstants["RUBBLE_TREAD_OFFSET"] = 26
	_static_UIConstants["MAZE_SIDE_MARGIN"] = 20
	_static_UIConstants["MAZE_TOP_MARGIN"] = 10
	_static_UIConstants["MAZE_BOTTOM_MARGIN"] = 140
	_static_UIConstants["TANK_EXPLOSION_CAMERA_SHAKE"] = 15
	_static_UIConstants["MAX_CAMERA_SHAKE"] = 25
	_static_UIConstants["CAMERA_SHAKE_FADE"] = 0.5
	_static_UIConstants["LAIKA"] = {"TRACKS": {"TORSO": 0, "HEAD": 1, "EYES": 2, "MOUTH": 3, "HOWL": 4, "EARS": 5, "TOES": 6, "CHAIN": 7}, "DEFAULT_MIX_TIME": 0.4, "HOWL_MIX_TIME": 0.2, "MIN_TOE_ROLL_DELAY": 3, "MAX_TOE_ROLL_DELAY": 15, "MIN_BLINK_DELAY": 5, "MAX_BLINK_DELAY": 8, "BLINK_TIME": 0.2, "LASER_BLINK_TIME": 0.1, "LASER_BLINK_PROBABILITY": 0.1, "LASER_NUM_BLINKS": 3, "LASER_TIME": 3, "NUM_HOWLS": 3, "MIN_HOWL_TIME": 0.3, "MAX_HOWL_TIME": 0.5, "CHAIN_RATTLE_DELAY": 200}
	_static_UIConstants["DIMITRI"] = {"TRACKS": {"TORSO": 0, "HEAD": 1, "EYES": 2, "MOUTH": 3, "SCHNURRBART": 4, "HANDS": 5, "HIP": 6, "FOOT": 7}, "DEFAULT_MIX_TIME": 0.4, "FOOT_TAP_MIX_TIME": 0.1, "MIN_LEGS_DELAY": 7, "MAX_LEGS_DELAY": 13, "MIN_WIGGLE_DELAY": 5, "MAX_WIGGLE_DELAY": 11, "SCHNURRBART_NUM_WIGGLES": 2, "HIP_BOUNCE_PROBABILITY": 0.33, "HIP_NUM_BOUNCES": 3, "FOOT_SCRATCH_PROBABILITY": 0.33, "FOOT_NUM_SCRATCHES": 5, "FOOT_NUM_TAPS": 3}
	_static_UIConstants["CONNECTION_ERROR_MESSAGE_OFFSET"] = 30
	_static_UIConstants["CONNECTION_ERROR_MESSAGE_FONT_SIZE"] = 16
	_static_UIConstants["CONNECTION_ERROR_MESSAGE_STROKE_WIDTH"] = 4
	_static_UIConstants["GARAGE_TANK_ICON_MARGIN"] = 115
	_static_UIConstants["SPRAY_CAN_POOL_SIZE"] = 30
	_static_UIConstants["PER_SPRAY_CAN_SPAWN_DELAY"] = 90
	_static_UIConstants["SPRAY_CAN_WIDTH"] = 40
	_static_UIConstants["SPRAY_CAN_DRAG_MARGIN"] = 5
	_static_UIConstants["GARAGE_SPRAY_ZONE_TURRET_Y"] = 0.05
	_static_UIConstants["GARAGE_SPRAY_ZONE_TREAD_X"] = 0.015
	_static_UIConstants["GARAGE_SPRAY_ZONE_OUTSIDE_MIN_Y"] = -(0.22)
	_static_UIConstants["GARAGE_SPRAY_ZONE_OUTSIDE_MAX_Y"] = 0.45
	_static_UIConstants["GARAGE_SPRAY_ZONE_OUTSIDE_X"] = 0.3
	_static_UIConstants["GARAGE_SPRAY_START_X"] = 0.32
	_static_UIConstants["GARAGE_SPRAY_TURRET_END_X"] = -(0.21)
	_static_UIConstants["GARAGE_SPRAY_TREAD_END_X"] = -(0.35)
	_static_UIConstants["GARAGE_SPRAY_BASE_END_X"] = -(0.31)
	_static_UIConstants["GARAGE_SPRAY_TURRET_Y"] = 0.1
	_static_UIConstants["GARAGE_SPRAY_TREAD_Y"] = 0.4
	_static_UIConstants["GARAGE_SPRAY_BASE_Y"] = 0.38
	_static_UIConstants["GARAGE_SPRAY_SHAKE_PROBABILITY"] = 0.15
	_static_UIConstants["GARAGE_SPRAY_SHAKE_TIME"] = 80
	_static_UIConstants["GARAGE_SPRAY_NUM_SHAKES"] = 6
	_static_UIConstants["GARAGE_SPRAY_SHAKE_OFFSET"] = 25
	_static_UIConstants["GARAGE_SPRAY_SHAKE_MAX_ROTATION"] = 0.2
	_static_UIConstants["GARAGE_SPRAY_TIME"] = 800
	_static_UIConstants["GARAGE_SPRAY_PARTICLE_TIME"] = 1500
	_static_UIConstants["GARAGE_SPRAY_OFFSET_X"] = 0
	_static_UIConstants["GARAGE_SPRAY_OFFSET_Y"] = -(0.43)
	_static_UIConstants["SPRAY_MIN_X_SPEED"] = -(120)
	_static_UIConstants["SPRAY_MAX_X_SPEED"] = 60
	_static_UIConstants["SPRAY_MIN_Y_SPEED"] = -(70)
	_static_UIConstants["SPRAY_MAX_Y_SPEED"] = 70
	_static_UIConstants["SPRAY_DRAG"] = 25
	_static_UIConstants["SPRAY_RADIUS"] = 16
	_static_UIConstants["SPRAY_INNER_RADIUS"] = 2
	_static_UIConstants["ACCESSORIES_PER_ROW"] = 8
	_static_UIConstants["PER_ACCESSORY_SPAWN_DELAY"] = 90
	_static_UIConstants["ACCESSORY_FLY_OUT_TIME"] = 600
	_static_UIConstants["ACCESSORY_WIDTH"] = 65
	_static_UIConstants["ACCESSORY_HEIGHT"] = 65
	_static_UIConstants["GARAGE_MAX_DRAG_SPEED"] = 850
	_static_UIConstants["GARAGE_SNAP_DISTANCE_TO_SPEED_SCALE"] = 8
	_static_UIConstants["GARAGE_TANK_ICON_SCROLL_SPEED"] = 600
	_static_UIConstants["GARAGE_BOX_SCROLL_SPEED"] = 400
	_static_UIConstants["GARAGE_ACCESSORY_SCROLL_SPEED"] = 400
	_static_UIConstants["GARAGE_BUTTON_SCROLL_OFFSET"] = 50
	_static_UIConstants["GARAGE_SCROLL_DRAG"] = 0.9
	_static_UIConstants["WELDER_SAMPLE_CELL_SIZE"] = 5
	_static_UIConstants["WELDER_SAMPLE_JITTER_SIZE"] = 5
	_static_UIConstants["GARAGE_WELD_SMOKE_TIME"] = 700
	_static_UIConstants["GARAGE_WELD_PARTICLE_TIME"] = 1500
	_static_UIConstants["WELDER_SMOKE_MIN_X_SPEED"] = -(30)
	_static_UIConstants["WELDER_SMOKE_MAX_X_SPEED"] = 30
	_static_UIConstants["WELDER_SMOKE_MIN_Y_SPEED"] = -(20)
	_static_UIConstants["WELDER_SMOKE_MAX_Y_SPEED"] = 30
	_static_UIConstants["WELDER_SMOKE_INNER_RADIUS"] = 8
	_static_UIConstants["WELDER_SMOKE_RADIUS"] = 16
	_static_UIConstants["GARAGE_WELD_SPARK_TIME"] = 1300
	_static_UIConstants["WELDER_SPARK_MIN_X_SPEED"] = -(150)
	_static_UIConstants["WELDER_SPARK_MAX_X_SPEED"] = 150
	_static_UIConstants["WELDER_SPARK_MIN_Y_SPEED"] = -(130)
	_static_UIConstants["WELDER_SPARK_MAX_Y_SPEED"] = 50
	_static_UIConstants["WELDER_SPARK_LENGTH"] = 8
	_static_UIConstants["WELDER_SPARK_WIDTH"] = 2
	_static_UIConstants["GARAGE_BOX_WIDTH"] = 140
	_static_UIConstants["GARAGE_BOX_HEIGHT"] = 140
	_static_UIConstants["BOXES_PER_ROW"] = 4
	_static_UIConstants["BASE_BOX_SPAWN_DELAY"] = 250
	_static_UIConstants["PER_BOX_SPAWN_DELAY"] = 90
	_static_UIConstants["SCRAPYARD_PLATE_WIDTH"] = 11
	_static_UIConstants["SCRAPYARD_PLATE_HEIGHT"] = 22
	_static_UIConstants["SCRAPYARD_PLATE_SPACING"] = 1
	_static_UIConstants["SCRAPYARD_FLIP_DELAY"] = 100
	_static_UIConstants["SCRAPYARD_FLIP_TIME"] = 630
	_static_UIConstants["SCRAPYARD_FIRST_UPDATE"] = 60000
	_static_UIConstants["SCRAPYARD_FOLLOWING_UPDATES"] = 300000
	_static_UIConstants["FORUM_THREAD_REFRESH_INTERVAL"] = 30
	_static_UIConstants["FORUM_REPLY_REFRESH_INTERVAL"] = 10
	_static_UIConstants["FORUM_MAX_PAGES_AROUND_CURRENT"] = 3
	_static_UIConstants["FORUM_BACK_BUTTON_WIDTH"] = 77
	_static_UIConstants["FORUM_OLDEST_PAGE_BUTTON_WIDTH"] = 51
	_static_UIConstants["FORUM_NEWEST_PAGE_BUTTON_WIDTH"] = 51
	_static_UIConstants["FORUM_PAGE_ELLIPSIS_WIDTH"] = 36
	_static_UIConstants["FORUM_PAGE_BUTTON_WIDTHS"] = [37, 41, 37, 39, 32, 40]
	_static_UIConstants["FORUM_PAGE_BUTTON_HEIGHT"] = 45
	_static_UIConstants["FORUM_PAGE_BUTTON_ANIMATION_BOTTOM"] = 15
	_static_UIConstants["FORUM_PAGE_ELLIPSIS_ANIMATION_BOTTOM"] = 9
	_static_UIConstants["ADMIN_LEVEL_ACCEPT_GUIDELINES"] = 0
	_static_UIConstants["ADMIN_LEVEL_DASHBOARD"] = 1
	_static_UIConstants["ADMIN_LEVEL_MODERATE_PLAYER_NAME"] = 1
	_static_UIConstants["ADMIN_LEVEL_PLAYER_LOOKUP"] = 1
	_static_UIConstants["ADMIN_LEVEL_APPROVE_THREAD_OR_REPLY"] = 1
	_static_UIConstants["ADMIN_LEVEL_DELETE_THREAD_OR_REPLY"] = 1
	_static_UIConstants["ADMIN_LEVEL_CHAT_LOG"] = 1
	_static_UIConstants["ADMIN_LEVEL_READ_MESSAGES"] = 1
	_static_UIConstants["ADMIN_LEVEL_VIEW_STATISTICS"] = 1
	_static_UIConstants["ADMIN_LEVEL_VIEW_LOG"] = 1
	_static_UIConstants["ADMIN_LEVEL_RESOLVE_CHAT_MESSAGE_REPORT"] = 2
	_static_UIConstants["ADMIN_LEVEL_LOCK_THREAD"] = 2
	_static_UIConstants["ADMIN_LEVEL_PIN_THREAD"] = 3
	_static_UIConstants["ADMIN_LEVEL_BAN_THREAD_OR_REPLY"] = 3
	_static_UIConstants["ADMIN_LEVEL_BAN_USER"] = 3
	_static_UIConstants["ADMIN_LEVEL_VIEW_SENSITIVE_PLAYER_DETAILS"] = 6
	_static_UIConstants["ADMIN_LEVEL_SET_PLAYER_ADMIN_LEVEL"] = 6
	_static_UIConstants["ADMIN_LEVEL_PURCHASE_GOLD_SHOP_ITEM"] = 6
	_static_UIConstants["ADMIN_LEVEL_PURCHASE_VIRTUAL_SHOP_ITEM"] = 6
	_static_UIConstants["ADMIN_LEVEL_NEWS"] = 9
	_static_UIConstants["ADMIN_LEVEL_SERVER_LOG"] = 9
	_static_UIConstants["ADMIN_LEVEL_PURCHASE_SHOP_ITEM"] = 9
	_static_UIConstants["ADMIN_LEVEL_EDIT_SHOP_ITEM"] = 9
	_static_UIConstants["ADMIN_ROLE_WRITE_MESSAGES"] = "writeMessages"
	_static_UIConstants["ADMIN_LOG"] = {"ACTION_APPROVE_USERNAME": 0, "ACTION_REJECT_USERNAME": 1, "ACTION_UNDO_USERNAME_MODERATION": 2, "ACTION_BAN_PLAYER": 3, "ACTION_REMOVE_PLAYER_BAN": 4, "ACTION_RECOMMEND_PLAYER_PROMOTION": 5, "ACTION_PROMOTE_PLAYER_FROM_RECOMMENDATIONS": 6, "ACTION_PROMOTE_PLAYER": 7, "ACTION_DEMOTE_PLAYER": 8, "ACTION_APPROVE_CHAT_MESSAGE": 9, "ACTION_BAN_CHAT_MESSAGE": 10, "ACTION_CREATE_NEWS_POST": 11, "ACTION_EDIT_NEWS_POST": 12, "ACTION_DELETE_NEWS_POST": 13, "ACTION_ACCEPT_ADMIN_GUIDELINES": 14, "ACTION_REJECT_ADMIN_GUIDELINES": 15, "ACTION_RETIRE_ADMIN": 16, "ACTION_EDIT_MESSAGE_CONTENT": 17, "ACTION_REVERT_ACCOUNT_CHANGE": 18, "ACTION_RESET_ACCOUNT_PASSWORD": 19, "ACTION_RESEND_VERIFICATION_EMAIL": 20, "ACTION_PURCHASE_VIRTUAL_SHOP_ITEM": 21, "ACTION_REFUND_VIRTUAL_SHOP_ITEM": 22, "ACTION_APPROVE_FORUM_THREAD": 23, "ACTION_UNAPPROVE_FORUM_THREAD": 24, "ACTION_LOCK_FORUM_THREAD": 25, "ACTION_UNLOCK_FORUM_THREAD": 26, "ACTION_PIN_FORUM_THREAD": 27, "ACTION_UNPIN_FORUM_THREAD": 28, "ACTION_DELETE_FORUM_THREAD": 29, "ACTION_UNDELETE_FORUM_THREAD": 30, "ACTION_BAN_FORUM_THREAD": 31, "ACTION_UNBAN_FORUM_THREAD": 32, "ACTION_APPROVE_FORUM_REPLY": 33, "ACTION_UNAPPROVE_FORUM_REPLY": 34, "ACTION_DELETE_FORUM_REPLY": 35, "ACTION_UNDELETE_FORUM_REPLY": 36, "ACTION_BAN_FORUM_REPLY": 37, "ACTION_UNBAN_FORUM_REPLY": 38, "ACTION_DELETE_ACCOUNT": 39, "ACTION_PURCHASE_GOLD_SHOP_ITEM": 40, "ACTION_REFUND_GOLD_SHOP_ITEM": 41, "ACTION_PURCHASE_SHOP_ITEM": 42, "ACTION_REFUND_SHOP_ITEM": 43, "ACTION_EDIT_EMAIL": 44, "ACTION_DELETE_EMAIL": 45, "ACTION_EDIT_SHOP_ITEM": 46, "ACTION_REMOVE_ACCOUNT_DELETION": 47, "ACTION_KICK_CHEATING_PLAYER": 48}
	_static_UIConstants["CHAT_BOX_MAX_NUM_MESSAGES"] = 30
	_static_UIConstants["AD_RELIEF_TIME"] = 600000
	_static_UIConstants["NAG_RELIEF_TIME"] = 1800000
static func original_static_get(key):
	initialize_original_static()
	if _static_UIConstants.has(key): return _static_UIConstants[key]
	return null
static func original_static_set(key, value):
	_static_UIConstants[key] = value
	return value
func original_own_fields():
	return []
static func create(_arg0 = null, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null, _arg5 = null, _arg6 = null, _arg7 = null, _arg8 = null, _arg9 = null, _arg10 = null, _arg11 = null, _arg12 = null, _arg13 = null, _arg14 = null, _arg15 = null):
	var instance = load("res://game/ported/presentation/uiconstants.gd").new()
	JS.invoke_method(instance, "_construct_create", [_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14, _arg15])
	return instance

static func original_scaleForHighDensity(_arg0 = null):
	var _scope0: Dictionary = {"devicePixelRatio": _arg0, "resolutionScale": null}
	if JS.truthy((not JS.truthy(JS.get_property(JS.module("UIConstants"), "SCALED_FOR_HIGH_DENSITY")))):
		JS.set_property(JS.module("UIConstants"), "SCALED_FOR_HIGH_DENSITY", true)
		_scope0["resolutionScale"] = JS.invoke_method(JS.module("UIUtils"), "getLoadedAssetResolutionScale", [_scope0["devicePixelRatio"]])
		JS.set_property(JS.module("UIConstants"), "ASSET_SCALE", (JS.number(_scope0["devicePixelRatio"]) / JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "GAME_ASSET_SCALE", (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ASSET_SCALE")) / JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "SPINE_SCALE", JS.invoke_method("@Math", "sqrt", [_scope0["devicePixelRatio"]]))
		JS.set_property(JS.module("UIConstants"), "GAME_ICON_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ICON_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GAME_ICON_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ICON_HEIGHT")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GAME_ICON_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ICON_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GAME_ICON_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "GAME_ICON_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "LOGIN_BACKGROUND_TOP_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "LOGIN_BACKGROUND_TOP_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "LOGIN_BACKGROUND_SIDE_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "LOGIN_BACKGROUND_SIDE_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "LOGIN_BACKGROUND_BOTTOM_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "LOGIN_BACKGROUND_BOTTOM_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_HEIGHTS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "BUTTON_MARGINS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_MARGINS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "BUTTON_MARGINS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_MARGINS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "BUTTON_MARGINS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_MARGINS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "BUTTON_SHADOW_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "BUTTON_SHADOW_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "BUTTON_SHADOW_HEIGHT_TOP", (JS.number(JS.get_property(JS.module("UIConstants"), "BUTTON_SHADOW_HEIGHT_TOP")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "BUTTON_SHADOW_HEIGHT_BOTTOM", (JS.number(JS.get_property(JS.module("UIConstants"), "BUTTON_SHADOW_HEIGHT_BOTTOM")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "BUTTON_ACTIVE_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "BUTTON_ACTIVE_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "MENU_BACKGROUND_MIN_TOP_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "MENU_BACKGROUND_MIN_TOP_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_WIDTHS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "MENU_BUTTON_SPACINGS"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "MENU_LAIKA_X", (JS.number(JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_X")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "MENU_LAIKA_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "MENU_LAIKA_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "MENU_DIMITRI_X", (JS.number(JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_X")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "MENU_DIMITRI_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "MENU_DIMITRI_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "BUTTON_FONT_SIZES"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_FONT_SIZES"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "SMALL"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "BUTTON_FONT_SIZES"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_FONT_SIZES"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "MEDIUM"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.get_property(JS.module("UIConstants"), "BUTTON_FONT_SIZES"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"), (JS.number(JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_FONT_SIZES"), JS.get_property(JS.get_property(JS.module("UIConstants"), "BUTTON_SIZES"), "LARGE"))) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "BUTTON_INFO_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "BUTTON_INFO_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "DISCONNECTED_ICON_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "DISCONNECTED_ICON_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "DISCONNECTED_HEADER_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "DISCONNECTED_HEADER_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "DISCONNECTED_HEADER_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "DISCONNECTED_HEADER_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "DISCONNECTED_HEADER_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "DISCONNECTED_HEADER_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "DISCONNECTED_MESSAGE_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "DISCONNECTED_MESSAGE_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "DISCONNECTED_MESSAGE_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "DISCONNECTED_MESSAGE_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "DISCONNECTED_MESSAGE_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "DISCONNECTED_MESSAGE_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "USERNAME_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "USERNAME_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "USERNAME_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "USERNAME_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_NAME_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_NAME_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "JOIN_GAME_BUTTON_INFO_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "JOIN_GAME_BUTTON_INFO_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "JOIN_GAME_BUTTON_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "JOIN_GAME_BUTTON_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "RANDOM_GAME_BUTTON_INFO_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "RANDOM_GAME_BUTTON_INFO_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CREATE_GAME_BUTTON_INFO_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "CREATE_GAME_BUTTON_INFO_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "AVATAR_LAIKA_X", (JS.number(JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_X")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "AVATAR_LAIKA_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "AVATAR_LAIKA_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "AVATAR_DIMITRI_X", (JS.number(JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_X")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "AVATAR_DIMITRI_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "AVATAR_DIMITRI_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_ICON_OUTLINE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_ICON_OUTLINE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "LEAVE_GAME_BUTTON_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "LEAVE_GAME_BUTTON_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "LEAVE_GAME_MESSAGE_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "LEAVE_GAME_MESSAGE_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "LEAVE_GAME_MESSAGE_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "LEAVE_GAME_MESSAGE_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "LEAVE_GAME_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "LEAVE_GAME_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WAITING_ICON_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "WAITING_ICON_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WAITING_ICON_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "WAITING_ICON_HEIGHT")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WAITING_HEADER_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "WAITING_HEADER_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WAITING_HEADER_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "WAITING_HEADER_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WAITING_HEADER_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "WAITING_HEADER_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WAITING_MESSAGE_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "WAITING_MESSAGE_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WAITING_MESSAGE_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "WAITING_MESSAGE_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WAITING_MESSAGE_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "WAITING_MESSAGE_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CELEBRATION_HEADER_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "CELEBRATION_HEADER_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CELEBRATION_HEADER_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "CELEBRATION_HEADER_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CELEBRATION_HEADER_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "CELEBRATION_HEADER_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CELEBRATION_TIE_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "CELEBRATION_TIE_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_MIN_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_MIN_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_MAX_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_MAX_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_MIN_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_MIN_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_MAX_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_MAX_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_DRAG_X", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_DRAG_X")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_DRAG_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_DRAG_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_FLOOR_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_EXPLOSION_FLOOR_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_FRAGMENT_MIN_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_FRAGMENT_MIN_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_FRAGMENT_MAX_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_FRAGMENT_MAX_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_FRAGMENT_GRAVITY", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_FRAGMENT_GRAVITY")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TROPHY_BASE_FRAGMENT_EXPLOSION_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "TROPHY_BASE_FRAGMENT_EXPLOSION_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONFETTI_MIN_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "CONFETTI_MIN_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONFETTI_MAX_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "CONFETTI_MAX_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONFETTI_MIN_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "CONFETTI_MIN_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONFETTI_MAX_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "CONFETTI_MAX_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONFETTI_DRAG", (JS.number(JS.get_property(JS.module("UIConstants"), "CONFETTI_DRAG")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONFETTI_GRAVITY", (JS.number(JS.get_property(JS.module("UIConstants"), "CONFETTI_GRAVITY")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONFETTI_WOBBLE_AMPLITUDE", (JS.number(JS.get_property(JS.module("UIConstants"), "CONFETTI_WOBBLE_AMPLITUDE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONFETTI_WOBBLE_KICK_IN_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "CONFETTI_WOBBLE_KICK_IN_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONFETTI_Y_VARIATION", (JS.number(JS.get_property(JS.module("UIConstants"), "CONFETTI_Y_VARIATION")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "STREAMER_MIN_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "STREAMER_MIN_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "STREAMER_MAX_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "STREAMER_MAX_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "STREAMER_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "STREAMER_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "STREAMER_AMPLITUDE_X", (JS.number(JS.get_property(JS.module("UIConstants"), "STREAMER_AMPLITUDE_X")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "STREAMER_AMPLITUDE_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "STREAMER_AMPLITUDE_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_PANEL_MAX_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MAX_HEIGHT")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_PANEL_SIDE_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_SIDE_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_PANEL_MIN_WIDTH_PER_ICON", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_MIN_WIDTH_PER_ICON")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_HEIGHT")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_INTERLEAVE_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_ICON_BOTTOM_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_PANEL_NAME_BOTTOM_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_NAME_BOTTOM_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_PANEL_SCORE_BOTTOM_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_PANEL_SCORE_BOTTOM_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "RANK_LEVEL_DOWN_SHAKE_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "RANK_LEVEL_DOWN_SHAKE_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "RANK_LEVEL_DOWN_TEAR_MIN_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "RANK_LEVEL_DOWN_TEAR_MIN_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "RANK_LEVEL_DOWN_TEAR_RANDOM_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "RANK_LEVEL_DOWN_TEAR_RANDOM_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "RANK_LEVEL_DOWN_TEAR_Y_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "RANK_LEVEL_DOWN_TEAR_Y_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_EXPLOSION_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_Y")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MIN_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MIN_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MAX_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MAX_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MIN_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MIN_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MAX_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_MAX_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_EXPLOSION_DRAG", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_EXPLOSION_DRAG")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MIN_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MIN_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MAX_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_FRAGMENT_MAX_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCORE_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "SCORE_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "PLAYER_PANEL_GRAVITY", (JS.number(JS.get_property(JS.module("UIConstants"), "PLAYER_PANEL_GRAVITY")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "ROUND_TITLE_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "ROUND_TITLE_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "ROUND_RANKED_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "ROUND_RANKED_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "ROUND_TITLE_SPACING", (JS.number(JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_SPACING")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "ROUND_TITLE_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "ROUND_TITLE_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TIMER_TOP_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "TIMER_TOP_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TIMER_SPACING", (JS.number(JS.get_property(JS.module("UIConstants"), "TIMER_SPACING")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TIMER_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "TIMER_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TIMER_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "TIMER_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "STORM_ZONE_TILE_SPRITE_RESOLUTION", (JS.number(JS.get_property(JS.module("UIConstants"), "STORM_ZONE_TILE_SPRITE_RESOLUTION")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "STORM_ZONE_TILE_SPRITE_RANDOM_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "STORM_ZONE_TILE_SPRITE_RANDOM_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "STORM_ZONE_TILE_SPRITE_SCROLL_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "STORM_ZONE_TILE_SPRITE_SCROLL_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "MAZE_SIDE_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "MAZE_SIDE_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "MAZE_TOP_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "MAZE_TOP_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "MAZE_BOTTOM_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "MAZE_BOTTOM_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_EXPLOSION_CAMERA_SHAKE", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_EXPLOSION_CAMERA_SHAKE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "MAX_CAMERA_SHAKE", (JS.number(JS.get_property(JS.module("UIConstants"), "MAX_CAMERA_SHAKE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CAMERA_SHAKE_FADE", (JS.number(JS.get_property(JS.module("UIConstants"), "CAMERA_SHAKE_FADE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONNECTION_ERROR_MESSAGE_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "CONNECTION_ERROR_MESSAGE_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONNECTION_ERROR_MESSAGE_FONT_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "CONNECTION_ERROR_MESSAGE_FONT_SIZE")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "CONNECTION_ERROR_MESSAGE_STROKE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "CONNECTION_ERROR_MESSAGE_STROKE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GARAGE_TANK_ICON_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "GARAGE_TANK_ICON_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SPRAY_CAN_DRAG_MARGIN", (JS.number(JS.get_property(JS.module("UIConstants"), "SPRAY_CAN_DRAG_MARGIN")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GARAGE_SPRAY_SHAKE_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "GARAGE_SPRAY_SHAKE_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SPRAY_MIN_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SPRAY_MIN_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SPRAY_MAX_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SPRAY_MAX_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SPRAY_MIN_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SPRAY_MIN_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SPRAY_MAX_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "SPRAY_MAX_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SPRAY_DRAG", (JS.number(JS.get_property(JS.module("UIConstants"), "SPRAY_DRAG")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SPRAY_RADIUS", (JS.number(JS.get_property(JS.module("UIConstants"), "SPRAY_RADIUS")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SPRAY_INNER_RADIUS", (JS.number(JS.get_property(JS.module("UIConstants"), "SPRAY_INNER_RADIUS")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GARAGE_MAX_DRAG_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "GARAGE_MAX_DRAG_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GARAGE_TANK_ICON_SCROLL_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "GARAGE_TANK_ICON_SCROLL_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GARAGE_BOX_SCROLL_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "GARAGE_BOX_SCROLL_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GARAGE_ACCESSORY_SCROLL_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "GARAGE_ACCESSORY_SCROLL_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "GARAGE_BUTTON_SCROLL_OFFSET", (JS.number(JS.get_property(JS.module("UIConstants"), "GARAGE_BUTTON_SCROLL_OFFSET")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SMOKE_MIN_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SMOKE_MIN_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SMOKE_MAX_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SMOKE_MAX_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SMOKE_MIN_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SMOKE_MIN_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SMOKE_MAX_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SMOKE_MAX_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SMOKE_INNER_RADIUS", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SMOKE_INNER_RADIUS")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SMOKE_RADIUS", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SMOKE_RADIUS")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SPARK_MIN_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SPARK_MIN_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SPARK_MAX_X_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SPARK_MAX_X_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SPARK_MIN_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SPARK_MIN_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SPARK_MAX_Y_SPEED", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SPARK_MAX_Y_SPEED")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SPARK_LENGTH", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SPARK_LENGTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SPARK_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SPARK_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCRAPYARD_PLATE_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "SCRAPYARD_PLATE_WIDTH")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCRAPYARD_PLATE_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "SCRAPYARD_PLATE_HEIGHT")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "SCRAPYARD_PLATE_SPACING", (JS.number(JS.get_property(JS.module("UIConstants"), "SCRAPYARD_PLATE_SPACING")) * JS.number(_scope0["devicePixelRatio"])))
		JS.set_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_SMALL", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_SMALL")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "TANK_ICON_HEIGHT_SMALL", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_ICON_HEIGHT_SMALL")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_MEDIUM", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_MEDIUM")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "TANK_ICON_HEIGHT_MEDIUM", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_ICON_HEIGHT_MEDIUM")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_LARGE", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_ICON_WIDTH_LARGE")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "TANK_ICON_HEIGHT_LARGE", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_ICON_HEIGHT_LARGE")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 0), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 0), "x")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 0), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 0), "y")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 1), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 1), "x")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 1), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 1), "y")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 2), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 2), "x")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 2), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 2), "y")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 3), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 3), "x")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 3), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_ICON_PLACEMENTS"), 3), "y")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 0), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 0), "x")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 0), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 0), "y")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 1), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 1), "x")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 1), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 1), "y")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 2), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 2), "x")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 2), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 2), "y")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 3), "x", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 3), "x")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 3), "y", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "TANK_NAME_PLACEMENTS"), 3), "y")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "WEAPON_ICON_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "WEAPON_ICON_WIDTH")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "FAVOURITE_ICON_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "FAVOURITE_ICON_WIDTH")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "FAVOURITE_ICON_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "FAVOURITE_ICON_HEIGHT")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 0), "paddingX", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 0), "paddingX")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 0), "offsetY", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 0), "offsetY")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 1), "paddingX", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 1), "paddingX")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 1), "offsetY", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 1), "offsetY")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 2), "paddingX", (JS.number(JS.get_property(JS.get_property(JS.get_property(JS.module("UIConstants"), "SCORE_ITEM_INFO"), 2), "paddingX")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "RANK_ICON_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "RANK_ICON_WIDTH")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "RANK_ICON_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "RANK_ICON_HEIGHT")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "GUEST_ICON_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "GUEST_ICON_WIDTH")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "GUEST_ICON_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "GUEST_ICON_HEIGHT")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "TANK_LEFT_TREAD_X", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_LEFT_TREAD_X")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "TANK_RIGHT_TREAD_X", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_RIGHT_TREAD_X")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "TANK_TURRET_Y", (JS.number(JS.get_property(JS.module("UIConstants"), "TANK_TURRET_Y")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "SPRAY_CAN_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "SPRAY_CAN_WIDTH")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "ACCESSORY_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "ACCESSORY_WIDTH")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "ACCESSORY_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "ACCESSORY_HEIGHT")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SAMPLE_CELL_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SAMPLE_CELL_SIZE")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "WELDER_SAMPLE_JITTER_SIZE", (JS.number(JS.get_property(JS.module("UIConstants"), "WELDER_SAMPLE_JITTER_SIZE")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "GARAGE_BOX_WIDTH", (JS.number(JS.get_property(JS.module("UIConstants"), "GARAGE_BOX_WIDTH")) * JS.number(_scope0["resolutionScale"])))
		JS.set_property(JS.module("UIConstants"), "GARAGE_BOX_HEIGHT", (JS.number(JS.get_property(JS.module("UIConstants"), "GARAGE_BOX_HEIGHT")) * JS.number(_scope0["resolutionScale"])))
	return null
