class_name MazeGenerator
extends RefCounted

const NORTH := 1
const EAST := 2
const SOUTH := 4
const WEST := 8

static func generate(cols: int, rows: int, cell_size: float, origin: Vector2, seed_value: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var cells: Array = []
	for y in rows:
		var line: Array = []
		for x in cols:
			line.append(NORTH | EAST | SOUTH | WEST)
		cells.append(line)

	var visited := {}
	var stack: Array[Vector2i] = [Vector2i(1, 1)]
	visited[Vector2i(1, 1)] = true
	while not stack.is_empty():
		var current: Vector2i = stack.back()
		var options: Array[Vector2i] = []
		for direction in [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]:
			var next := current + direction
			if next.x > 0 and next.x < cols - 1 and next.y > 0 and next.y < rows - 1 and not visited.has(next):
				options.append(next)
		if options.is_empty():
			stack.pop_back()
			continue
		var next: Vector2i = options[rng.randi_range(0, options.size() - 1)]
		_remove_wall(cells, current, next)
		visited[next] = true
		stack.append(next)

	for y in range(1, rows - 1):
		for x in range(1, cols - 1):
			if rng.randf() < 0.13:
				var cell := Vector2i(x, y)
				var candidate := [Vector2i(1, 0), Vector2i(0, 1)]
				var direction: Vector2i = candidate[rng.randi_range(0, 1)]
				var other := cell + direction
				if other.x < cols - 1 and other.y < rows - 1:
					_remove_wall(cells, cell, other)

	var wall_rects: Array[Rect2] = []
		# The external frame keeps ricochets inside the arena.
	wall_rects.append(Rect2(origin.x - 7.0, origin.y - 7.0, cols * cell_size + 14.0, 10.0))
	w​all_rects.append(Rect2(origin.x - 7.0, origin.y + rows * cell_size - 3.0, cols * cell_size + 14.0, 10.0))
	wall_rects.append(Rect2(origin.x - 7.0, origin.y - 7.0, 10.0, rows * cell_size + 14.0))
	wall_rects.append(Rect2(origin.x + cols * cell_size - 3.0, origin.y - 7.0, 10.0, rows * cell_size + 14.0))
	for y in rows:
		for x in cols:
			var bits: int = cells[y][x]
			var top_left := origin + Vector2(x * cell_size, y * cell_size)
			if bits & NORTH:
				wall_rects.append(Rect2(top_left.x - 4.0, top_left.y - 4.0, cell_size + 8.0, 8.0))
			if bits & WEST:
				wall_rects.append(Rect2(top_left.x - 4.0, top_left.y - 4.0, 8.0, cell_size + 8.0))
			if x == cols - 1 and bits & EAST:
				wall_rects.append(Rect2(top_left.x + cell_size - 4.0, top_left.y - 4.0, 8.0, cell_size + 8.0))
			if y == rows - 1 and bits & SOUTH:
				wall_rects.append(Rect2(top_left.x - 4.0, top_left.y + cell_size - 4.0, cell_size + 8.0, 8.0))

	var spawn_cells := [Vector2i(1, 1), Vector2i(cols - 2, rows - 2), Vector2i(cols - 2, 1), Vector2i(1, rows - 2)]
	var spawns: Array[Vector2] = []
	for cell in spawn_cells:
		spawns.append(origin + (Vector2(cell) + Vector2(0.5, 0.5)) * cell_size)

	var pickup_cells: Array[Vector2] = []
	for attempt in 80:
		var cell := Vector2i(rng.randi_range(1, cols - 2), rng.randi_range(1, rows - 2))
		var point := origin + (Vector2(cell) + Vector2(0.5, 0.5)) * cell_size
		var too_close := false
		for spawn in spawns:
			if point.distance_to(spawn) < cell_size * 2.4:
				too_close = true
		if not too_close and not pickup_cells.has(point):
			pickup_cells.append(point)
		if pickup_cells.size() >= 8:
			break

	return {
		"cols": cols,
		"rows": rows,
		"cell_size": cell_size,
		"origin": origin,
		"cells": cells,
		"walls": wall_rects,
		"spawns": spawns,
		"pickup_points": pickup_cells,
		"bounds": Rect2(origin, Vector2(cols * cell_size, rows * cell_size)),
		"seed": seed_value
	}

static func _remove_wall(cells: Array, first: Vector2i, second: Vector2i) -> void:
	var delta := second - first
	if delta == Vector2i(0, -1):
		cells[first.y][first.x] &= ~NORTH
		cells[second.y][second.x] &= ~SOUTH
	elif delta == Vector2i(1, 0):
		cells[first.y][first.x] &= ~EAST
		cells[second.y][second.x] &= ~WEST
	elif delta == Vector2i(0, 1):
		cells[first.y][first.x] &= ~SOUTH
		cells[second.y][second.x] &= ~NORTH
	elif delta == Vector2i(-1, 0):
		cells[first.y][first.x] &= ~WEST
		cells[second.y][second.x] &= ~EAST

