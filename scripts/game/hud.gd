class_name GameHud
extends Node2D

var source: Node
var menu_texture: Texture2D

func bind(game_root: Node, texture: Texture2D) -> void:
	source = game_root
	menu_texture = texture
	z_index = 100

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if source == null:
		return
	match source.screen:
		GameRoot.Screen.MENU:
			_draw_menu()
		GameRoot.Screen.PLAY:
			_draw_hud()
		GameRoot.Screen.RESULTS:
			_draw_hud()
			_draw_results()

func _draw_menu() -> void:
	draw_rect(Rect2(0.0, 0.0, 1280.0, 720.0), Color("#0b1015"))
	if menu_texture:
		draw_texture_rect(menu_texture, Rect2(340.0, 30.0, 1060.0, 660.0), false, Color(1.0, 1.0, 1.0, 0.22))
	draw_rect(Rect2(38.0, 34.0, 680.0, 652.0), Color(0.04, 0.07, 0.09, 0.96))
	draw_line(Vector2(72.0, 184.0), Vector2(640.0, 184.0), Color("#33464e"), 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(72.0, 120.0), "TANK TROUBLE", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 54, Color("#f2f5ed"))
	draw_string(ThemeDB.fallback_font, Vector2(75.0, 155.0), "LOCAL ARCADE EDITION", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, Color("#9bb0b4"))
	draw_string(ThemeDB.fallback_font, Vector2(72.0, 224.0), "SELECT MODE", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 15, Color("#6ec6c9"))
	_draw_mode_card(Rect2(72.0, 246.0, 270.0, 104.0), "CLASSIC", "First tank standing wins", source.mode == GameRoot.Mode.CLASSIC, Color("#29b6f6"))
	_draw_mode_card(Rect2(358.0, 246.0, 270.0, 104.0), "DEATHMATCH", "60 seconds, respawns on", source.mode == GameRoot.Mode.DEATHMATCH, Color("#ff6b6b"))
	draw_string(ThemeDB.fallback_font, Vector2(72.0, 396.0), "LOCAL CONTROLS", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 15, Color("#6ec6c9"))
	_draw_control_row(Vector2(72.0, 424.0), "P1", "WASD", "MOVE / TURN", Color("#29b6f6"))
	_draw_control_row(Vector2(72.0, 462.0), "P1", "SPACE", "FIRE", Color("#29b6f6"))
	_draw_control_row(Vector2(358.0, 424.0), "P2", "ARROWS", "MOVE / TURN", Color("#ff6b6b"))
	_draw_control_row(Vector2(358.0, 462.0), "P2", "ENTER", "FIRE", Color("#ff6b6b"))
	draw_rect(Rect2(72.0, 528.0, 556.0, 72.0), Color("#24363d"), true)
	draw_rect(Rect2(72.0, 528.0, 556.0, 72.0), Color("#6ec6c9"), false, 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(72.0, 574.0), "PRESS ENTER TO START", HORIZONTAL_ALIGNMENT_CENTER, 556.0, 22, Color("#f4f7f2"))
	draw_string(ThemeDB.fallback_font, Vector2(72.0, 646.0), "TAB SWITCHES MODE   |   ESC RETURNS TO MENU", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 14, Color("#667b81"))
	draw_string(ThemeDB.fallback_font, Vector2(905.0, 650.0), "ASSET STUDY FROM HAR ARCHIVE", HORIZONTAL_ALIGNMENT_CENTER, 320.0, 13, Color(0.75, 0.8, 0.75, 0.55))

func _draw_mode_card(rect: Rect2, title: String, subtitle: String, selected: bool, color: Color) -> void:
	draw_rect(rect, Color(color, 0.18 if selected else 0.06), true)
	draw_rect(rect, color if selected else Color("#34434a"), false, 2.0)
	draw_circle(rect.position + Vector2(24.0, 26.0), 7.0, color if selected else Color("#586a70"))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(44.0, 32.0), title, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, Color("#f4f7f2"))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(44.0, 61.0), subtitle, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13, Color("#a8b9ba"))

func _draw_control_row(origin: Vector2, player: String, keys: String, action: String, color: Color) -> void:
	draw_string(ThemeDB.fallback_font, origin, player, HORIZONTAL_ALIGNMENT_LEFT, 28.0, 13, color)
	draw_string(ThemeDB.fallback_font, origin + Vector2(40.0, 0.0), keys, HORIZONTAL_ALIGNMENT_LEFT, 110.0, 16, Color("#f4f7f2"))
	draw_string(ThemeDB.fallback_font, origin + Vector2(150.0, 0.0), action, HORIZONTAL_ALIGNMENT_LEFT, 120.0, 12, Color("#8da1a5"))

func _draw_hud() -> void:
	draw_rect(Rect2(0.0, 0.0, 1280.0, 88.0), Color("#0b1015"), true)
	draw_line(Vector2(0.0, 87.0), Vector2(1280.0, 87.0), Color("#33464e"), 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(36.0, 38.0), "TANK TROUBLE", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 21, Color("#f4f7f2"))
	draw_string(ThemeDB.fallback_font, Vector2(38.0, 62.0), "ROUND %02d" % source.round_number, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13, Color("#7e959b"))
	_draw_score_badge(Vector2(244.0, 15.0), "P1", source.scores[0], Color("#29b6f6"))
	_draw_score_badge(Vector2(1016.0, 15.0), "P2", source.scores[1], Color("#ff6b6b"))
	if source.tanks.size() >= 2:
		_draw_loadout(source.tanks[0], Vector2(244.0, 79.0), Color("#29b6f6"))
		_draw_loadout(source.tanks[1], Vector2(1016.0, 79.0), Color("#ff6b6b"))
	var mode_text := "CLASSIC" if source.mode == GameRoot.Mode.CLASSIC else "DEATHMATCH"
	draw_string(ThemeDB.fallback_font, Vector2(480.0, 31.0), mode_text, HORIZONTAL_ALIGNMENT_CENTER, 320.0, 16, Color("#9eb4b7"))
	var timer_text := ""
	if source.phase == GameRoot.RoundPhase.COUNTDOWN:
		timer_text = str(max(1, int(ceil(source.countdown))))
	elif source.mode == GameRoot.Mode.DEATHMATCH:
		timer_text = "%02d" % int(ceil(max(0.0, source.round_limit - source.round_time)))
	else:
		timer_text = "DUEL"
	draw_string(ThemeDB.fallback_font, Vector2(480.0, 64.0), timer_text, HORIZONTAL_ALIGNMENT_CENTER, 320.0, 24, Color("#f0c36a"))
	draw_string(ThemeDB.fallback_font, Vector2(44.0, 698.0), "P1  WASD  MOVE   SPACE  FIRE", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13, Color("#6c9fab"))
	draw_string(ThemeDB.fallback_font, Vector2(862.0, 698.0), "P2  ARROWS  MOVE   ENTER  FIRE", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13, Color("#c48e94"))
	if source.phase == GameRoot.RoundPhase.COUNTDOWN:
		draw_rect(Rect2(0.0, 88.0, 1280.0, 574.0), Color(0.02, 0.04, 0.05, 0.18), true)
		draw_string(ThemeDB.fallback_font, Vector2(0.0, 405.0), str(max(1, int(ceil(source.countdown)))), HORIZONTAL_ALIGNMENT_CENTER, 1280.0, 96, Color(1.0, 1.0, 1.0, 0.86))
	if source.phase == GameRoot.RoundPhase.ROUND_END:
		var message := "DRAW" if source.winner < 0 else "P%d WINS" % (source.winner + 1)
		draw_string(ThemeDB.fallback_font, Vector2(0.0, 400.0), message, HORIZONTAL_ALIGNMENT_CENTER, 1280.0, 54, Color("#f0c36a"))

func _draw_score_badge(origin: Vector2, player: String, score: int, color: Color) -> void:
	draw_rect(Rect2(origin, Vector2(220.0, 57.0)), Color(color, 0.13), true)
	draw_rect(Rect2(origin, Vector2(220.0, 57.0)), Color(color, 0.7), false, 2.0)
	draw_string(ThemeDB.fallback_font, origin + Vector2(18.0, 36.0), player, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, color)
	draw_string(ThemeDB.fallback_font, origin + Vector2(172.0, 40.0), str(score), HORIZONTAL_ALIGNMENT_CENTER, 30.0, 27, Color("#f4f7f2"))

func _draw_loadout(tank: Tank, origin: Vector2, color: Color) -> void:
	var weapon_text := "RELOAD" if tank.reload_time > 0.0 else tank.weapon.to_upper()
	draw_string(ThemeDB.fallback_font, origin, weapon_text, HORIZONTAL_ALIGNMENT_LEFT, 112.0, 12, color)
	draw_string(ThemeDB.fallback_font, origin + Vector2(128.0, 0.0), "AMMO %02d" % tank.ammo, HORIZONTAL_ALIGNMENT_LEFT, 92.0, 12, Color("#84999d"))

func _draw_results() -> void:
	draw_rect(Rect2(230.0, 170.0, 820.0, 370.0), Color(0.03, 0.05, 0.06, 0.97), true)
	draw_rect(Rect2(230.0, 170.0, 820.0, 370.0), Color("#6ec6c9"), false, 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(230.0, 255.0), "MATCH COMPLETE", HORIZONTAL_ALIGNMENT_CENTER, 820.0, 32, Color("#9eb4b7"))
	var winner_text := "DRAW" if source.match_winner < 0 else "PLAYER %d WINS" % (source.match_winner + 1)
	draw_string(ThemeDB.fallback_font, Vector2(230.0, 340.0), winner_text, HORIZONTAL_ALIGNMENT_CENTER, 820.0, 54, Color("#f0c36a"))
	draw_string(ThemeDB.fallback_font, Vector2(230.0, 402.0), "P1  %d          P2  %d" % [source.scores[0], source.scores[1]], HORIZONTAL_ALIGNMENT_CENTER, 820.0, 24, Color("#f4f7f2"))
	draw_string(ThemeDB.fallback_font, Vector2(230.0, 490.0), "ENTER  PLAY AGAIN        ESC  MENU", HORIZONTAL_ALIGNMENT_CENTER, 820.0, 17, Color("#8da1a5"))
