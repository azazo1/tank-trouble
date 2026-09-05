class_name Maze
extends Node2D

const TILE_SIZE := 200.0
const WALL_WIDTH := 16.0
const ARENA_RECT := Rect2(0.0, 88.0, 1200.0, 632.0)
const FLOOR_COLOR := Color("#15232a")
const FLOOR_LINE := Color(0.28, 0.38, 0.4, 0.22)
const WALL_COLOR := Color("#71808a")
const WALL_EDGE := Color("#b5c3c7")

var walls: Array[Rect2] = []
var width := 6
var height := 3
var tiles: Array = []
var rng := RandomNumberGenerator.new()
var atlas: Texture2D
var floor_frames := [Rect2(1723.0, 469.0, 200.0, 200.0), Rect2(1041.0, 243.0, 200.0, 200.0), Rect2(537.0, 305.0, 200.0, 200.0)]
var wall_frame := Rect2(1513.0, 53.0, 216.0, 16.0)

func _ready() -> void:
	rng.randomize()
	atlas = load("res://assets/sprites/game_atlas.png")
	build_for_players(2)

func build_for_players(player_count: int) -> void:
	var width_for_players := [0, 2, 4, 6, 8, 9, 10, 11, 12]
	var height_for_players := [0, 1, 2, 3, 4, 5, 5, 6, 6]
	var index := clampi(player_count, 0, width_for_players.size() - 1)
	width = mini(16, 2 + width_for_players[index])
	height = mini(10, 2 + height_for_players[index])
	if player_count <= 2:
		height = 3
	_generate_tiles()
	_rebuild_walls()
	queue_redraw()

func build_layout() -> void:
	build_for_players(2)

func _generate_tiles() -> void:
	tiles.clear()
	for x in range(width):
		tiles.append([])
		for y in range(height):
			tiles[x].append({"top": true, "left": true, "visited": false})
	var stack: Array[Vector2i] = [Vector2i(0, 0)]
	tiles[0][0]["visited"] = true
	while not stack.is_empty():
		var current: Vector2i = stack[-1]
		var neighbours: Array[Vector2i] = []
		for candidate in [Vector2i(current.x - 1, current.y), Vector2i(current.x + 1, current.y), Vector2i(current.x, current.y - 1), Vector2i(current.x, current.y + 1)]:
			if candidate.x >= 0 and candidate.x < width and candidate.y >= 0 and candidate.y < height and not bool(tiles[candidate.x][candidate.y]["visited"]):
				neighbours.append(candidate)
		if neighbours.is_empty():
			stack.pop_back()
			continue
		var next: Vector2i = neighbours[rng.randi_range(0, neighbours.size() - 1)]
		if next.x == current.x - 1:
			tiles[current.x][current.y]["left"] = false
		elif next.x == current.x + 1:
			tiles[next.x][next.y]["left"] = false
		elif next.y == current.y - 1:
			tiles[current.x][current.y]["top"] = false
		else:
			tiles[next.x][next.y]["top"] = false
		tiles[next.x][next.y]["visited"] = true
		stack.append(next)
	for x in range(width):
		for y in range(height):
			tiles[x][y].erase("visited")
	for x in range(width):
		for y in range(height):
			if x > 0 and bool(tiles[x][y]["left"]) and rng.randf() < 0.12:
				tiles[x][y]["left"] = false
			if y > 0 and bool(tiles[x][y]["top"]) and rng.randf() < 0.12:
				tiles[x][y]["top"] = false

func _rebuild_walls() -> void:
	walls.clear()
	for x in range(width):
		for y in range(height):
			var origin := Vector2(float(x) * TILE_SIZE, 88.0 + float(y) * TILE_SIZE)
			if y == 0 or bool(tiles[x][y]["top"]):
				walls.append(Rect2(origin.x, origin.y - WALL_WIDTH * 0.5, TILE_SIZE, WALL_WIDTH))
			if x == 0 or bool(tiles[x][y]["left"]):
				walls.append(Rect2(origin.x - WALL_WIDTH * 0.5, origin.y, WALL_WIDTH, TILE_SIZE))
			if y == height - 1:
				walls.append(Rect2(origin.x, origin.y + TILE_SIZE - WALL_WIDTH * 0.5, TILE_SIZE, WALL_WIDTH))
			if x == width - 1:
				walls.append(Rect2(origin.x + TILE_SIZE - WALL_WIDTH * 0.5, origin.y, WALL_WIDTH, TILE_SIZE))

func random_pickup_position() -> Vector2:
	for _attempt in range(80):
		var candidate := Vector2(rng.randf_range(40.0, width * TILE_SIZE - 40.0), rng.randf_range(128.0, 88.0 + height * TILE_SIZE - 40.0))
		if not is_circle_blocked(candidate, 34.0):
			return candidate
	return get_spawn_position(0)

func get_spawn_position(index: int) -> Vector2:
	if index % 2 == 0:
		return Vector2(TILE_SIZE * 0.5, 88.0 + TILE_SIZE * 0.5)
	return Vector2(width * TILE_SIZE - TILE_SIZE * 0.5, 88.0 + (height - 1) * TILE_SIZE + TILE_SIZE * 0.5)

func is_circle_blocked(center: Vector2, radius: float) -> bool:
	for wall in walls:
		if wall.grow(radius).has_point(center):
			return true
	return false

func ray_hit(start: Vector2, end: Vector2) -> Dictionary:
	var segment := end - start
	var closest_fraction := 1.0
	var hit_normal := Vector2.ZERO
	for wall in walls:
		var expanded := wall.grow(0.5)
		var edges := [
			[Vector2(expanded.position.x, expanded.position.y), Vector2(expanded.end.x, expanded.position.y), Vector2.UP],
			[Vector2(expanded.end.x, expanded.position.y), Vector2(expanded.end.x, expanded.end.y), Vector2.RIGHT],
			[Vector2(expanded.end.x, expanded.end.y), Vector2(expanded.position.x, expanded.end.y), Vector2.DOWN],
			[Vector2(expanded.position.x, expanded.end.y), Vector2(expanded.position.x, expanded.position.y), Vector2.LEFT]
		]
		for edge in edges:
			var point = Geometry2D.segment_intersects_segment(start, end, edge[0], edge[1])
			if point != null:
				var fraction := start.distance_to(point) / maxf(0.001, segment.length())
				if fraction < closest_fraction:
					closest_fraction = fraction
					hit_normal = edge[2]
	if closest_fraction < 1.0:
		return {"hit": true, "point": start.lerp(end, closest_fraction), "normal": hit_normal}
	return {"hit": false, "point": end, "normal": Vector2.ZERO}

func _draw() -> void:
	draw_rect(Rect2(0.0, 0.0, 1280.0, 720.0), Color("#0b1015"))
	draw_rect(ARENA_RECT, FLOOR_COLOR)
	for x in range(width):
		for y in range(height):
			var rect := Rect2(float(x) * TILE_SIZE, 88.0 + float(y) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
			if atlas:
				draw_texture_rect_region(atlas, rect, floor_frames[(x + y) % floor_frames.size()], Color.WHITE)
	for x in range(0, 1200, 40):
		draw_line(Vector2(x, 88.0), Vector2(x, minf(720.0, 88.0 + height * TILE_SIZE)), FLOOR_LINE, 1.0)
	for y in range(88, 721, 40):
		draw_line(Vector2(0.0, y), Vector2(1200.0, y), FLOOR_LINE, 1.0)
	for wall in walls:
		if atlas and wall.size.x > wall.size.y:
			draw_texture_rect_region(atlas, wall, wall_frame, Color.WHITE)
		else:
			draw_rect(wall, WALL_COLOR)
		draw_line(wall.position, wall.position + Vector2(wall.size.x, 0.0), WALL_EDGE, 2.0)
		draw_line(wall.position, wall.position + Vector2(0.0, wall.size.y), Color(0.2, 0.26, 0.28, 0.8), 2.0)
