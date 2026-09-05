class_name WorldEffects
extends Node2D

var source: Node
var atlas: Texture2D

const FRAMES := {
	"bullet": Rect2(251.0, 413.0, 20.0, 20.0),
	"double": Rect2(251.0, 435.0, 20.0, 20.0),
	"mine": Rect2(475.0, 999.0, 56.0, 56.0),
	"explosion0": Rect2(1945.0, 75.0, 100.0, 100.0),
	"explosion1": Rect2(1945.0, 177.0, 100.0, 100.0),
	"explosion2": Rect2(1945.0, 279.0, 100.0, 100.0),
	"shield": Rect2(1.0, 1167.0, 180.0, 180.0),
	"crate0": Rect2(807.0, 1171.0, 64.0, 64.0),
	"crate1": Rect2(949.0, 1115.0, 64.0, 64.0),
	"crate2": Rect2(1015.0, 1115.0, 64.0, 64.0),
	"crate3": Rect2(1205.0, 1087.0, 64.0, 64.0),
	"crate4": Rect2(1271.0, 1087.0, 64.0, 64.0),
	"crate5": Rect2(1337.0, 1087.0, 64.0, 64.0),
	"crate6": Rect2(475.0, 1197.0, 64.0, 64.0),
	"crate7": Rect2(541.0, 1197.0, 64.0, 64.0),
}

func bind(game_root: Node) -> void:
	source = game_root
	atlas = load("res://assets/sprites/game_atlas.png")
	z_index = 10

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if source == null or source.screen != GameRoot.Screen.PLAY:
		return
	for pickup in source.pickups:
		_draw_pickup(pickup)
	for mine in source.mines:
		var mine_pos: Vector2 = mine["position"]
		var armed := bool(mine["activated"])
		var pulse := 1.0 + sin(Time.get_ticks_msec() * 0.006) * 0.08
		if atlas:
			var mine_rect: Rect2 = FRAMES["mine"]
			var mine_size := mine_rect.size * 0.5 * pulse
			draw_texture_rect_region(atlas, Rect2(mine_pos - mine_size * 0.5, mine_size), mine_rect, Color(1.0, 1.0, 1.0, 1.0 if armed else 0.65))
		else:
			draw_circle(mine_pos, 18.0 * pulse, Color("#252c34"))
			draw_circle(mine_pos, 12.0, Color("#10161b"))
			draw_arc(mine_pos, 16.0, 0.0, TAU, 28, Color("#ef476f") if armed else Color("#707b84"), 2.0)
	for beam in source.laser_beams:
		var beam_color: Color = beam["color"] as Color
		var beam_alpha: float = clampf(float(beam["time"]) / GameRoot.LASER_BEAM_TIME, 0.0, 1.0)
		var points: Array = beam["points"]
		for segment_index in range(points.size() - 1):
			var beam_start: Vector2 = points[segment_index]
			var beam_end: Vector2 = points[segment_index + 1]
			draw_line(beam_start, beam_end, Color(beam_color, beam_alpha * 0.35), 12.0)
			draw_line(beam_start, beam_end, Color(beam_color, beam_alpha), 3.0)
	for burst in source.explosions:
		var burst_pos: Vector2 = burst["position"]
		var burst_time := float(burst["time"])
		var burst_max := float(burst["max"])
		var burst_color: Color = burst["color"]
		var progress := 1.0 - burst_time / 0.55
		if atlas:
			var frame_key := "explosion%d" % mini(2, int(progress * 3.0))
			var explosion_rect: Rect2 = FRAMES[frame_key]
			var explosion_size := explosion_rect.size * (burst_max / 100.0)
			draw_texture_rect_region(atlas, Rect2(burst_pos - explosion_size * 0.5, explosion_size), explosion_rect, Color(burst_color, 1.0 - progress))
		else:
			draw_circle(burst_pos, burst_max * progress, Color(burst_color, (1.0 - progress) * 0.22))
		draw_arc(burst_pos, burst_max * progress, 0.0, TAU, 36, Color(burst_color, 1.0 - progress), 4.0)
		for ray in range(8):
			var angle := TAU * float(ray) / 8.0 + progress * 0.7
			var inner := burst_pos + Vector2(cos(angle), sin(angle)) * burst_max * progress * 0.42
			var outer := burst_pos + Vector2(cos(angle), sin(angle)) * burst_max * progress
			draw_line(inner, outer, Color(burst_color, 1.0 - progress), 3.0)

func _draw_pickup(pickup: Dictionary) -> void:
	var pickup_pos: Vector2 = pickup["position"]
	var pickup_type := String(pickup["type"])
	var pulse := 1.0 + sin(float(pickup["phase"])) * 0.06
	var color := _pickup_color(pickup_type)
	if atlas:
		var frame_index := ["laser", "double", "shotgun", "homing", "mine", "gatling", "shield", "speed"].find(pickup_type)
		if frame_index >= 0:
			var crate_rect: Rect2 = FRAMES["crate%d" % frame_index]
			var crate_size := crate_rect.size * 0.5 * pulse
			draw_texture_rect_region(atlas, Rect2(pickup_pos - crate_size * 0.5, crate_size), crate_rect, Color.WHITE)
			return
	draw_circle(pickup_pos, 29.0 * pulse, Color(color, 0.11))
	draw_rect(Rect2(pickup_pos - Vector2(22.0, 22.0), Vector2(44.0, 44.0)), Color("#26343a"), true)
	draw_rect(Rect2(pickup_pos - Vector2(22.0, 22.0), Vector2(44.0, 44.0)), color, false, 3.0)
	draw_line(pickup_pos + Vector2(-16.0, -10.0), pickup_pos + Vector2(16.0, -10.0), Color(color, 0.65), 2.0)
	draw_string(ThemeDB.fallback_font, pickup_pos + Vector2(-16.0, 8.0), _pickup_label(pickup_type), HORIZONTAL_ALIGNMENT_CENTER, 32.0, 13, Color("#f4f7f2"))

func _pickup_color(pickup_type: String) -> Color:
	match pickup_type:
		"double": return Color("#ffd166")
		"shotgun": return Color("#f78c6b")
		"laser": return Color("#45e0e9")
		"homing": return Color("#c19cff")
		"gatling": return Color("#ffe08a")
		"shield": return Color("#8be28b")
		"speed": return Color("#c19cff")
		"mine": return Color("#ef476f")
	return Color("#d9e2e4")

func _pickup_label(pickup_type: String) -> String:
	match pickup_type:
		"double": return "2X"
		"shotgun": return "SG"
		"laser": return "L"
		"homing": return "HM"
		"gatling": return "G"
		"shield": return "S"
		"speed": return "V"
		"mine": return "M"
	return "?"
