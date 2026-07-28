extends Node2D
# Owns the board. Square grid, 4-directional adjacency (up/down/left/right).
# Attach this script to a Node2D named "GridManager" inside Game.tscn.

signal score_changed(new_score)
signal game_over
signal game_won

export var grid_cols: int = 8
export var start_rows: int = 6
export var shots_per_new_row: int = 8

var cell_size: float
var grid: Dictionary = {}   # key: Vector2(row, col) -> Head node
var shots_fired: int = 0
var board_locked: bool = false


func _ready() -> void:
	cell_size = Globals.CELL_SIZE
	_generate_initial_grid()


func _generate_initial_grid() -> void:
	for row in range(start_rows):
		for col in range(grid_cols):
			_spawn_head(row, col, randi() % Globals.HeadType.size())


func _spawn_head(row: int, col: int, type: int) -> void:
	var head = Globals.HEAD_SCENE.instance()
	add_child(head)
	head.set_type(type)
	head.grid_row = row
	head.grid_col = col
	head.position = grid_to_pixel(row, col)
	grid[Vector2(row, col)] = head


func grid_to_pixel(row: int, col: int) -> Vector2:
	var x: float = Globals.GRID_LEFT_MARGIN + col * cell_size + cell_size * 0.5
	var y: float = Globals.GRID_TOP_MARGIN + row * cell_size + cell_size * 0.5
	return Vector2(x, y)


func get_neighbors(row: int, col: int) -> Array:
	return [
		Vector2(row - 1, col),
		Vector2(row + 1, col),
		Vector2(row, col - 1),
		Vector2(row, col + 1),
	]


# Called every frame by Cannon while a shot is in flight.
# Returns {} if the shot hasn't landed yet, else {"row": r, "col": c}.
func check_landing(world_pos: Vector2) -> Dictionary:
	if board_locked:
		return {}
	if world_pos.y <= Globals.GRID_TOP_MARGIN:
		return _nearest_free_cell(world_pos)
	for key in grid.keys():
		var head = grid[key]
		if head.position.distance_to(world_pos) < cell_size * 0.92:
			return _nearest_free_cell(world_pos)
	return {}


func _nearest_free_cell(world_pos: Vector2) -> Dictionary:
	var approx_row: int = int(round((world_pos.y - Globals.GRID_TOP_MARGIN - cell_size * 0.5) / cell_size))
	approx_row = max(0, approx_row)
	var best_key = null
	var best_dist := INF
	for r in range(max(0, approx_row - 1), approx_row + 2):
		for c in range(grid_cols):
			var key := Vector2(r, c)
			if grid.has(key):
				continue
			var d: float = grid_to_pixel(r, c).distance_to(world_pos)
			if d < best_dist:
				best_dist = d
				best_key = key
	if best_key == null:
		# Board is jammed solid at this height; fall back to row 0.
		return {"row": 0, "col": clamp(int(round(world_pos.x / cell_size)), 0, grid_cols - 1)}
	return {"row": int(best_key.x), "col": int(best_key.y)}


func place_head(row: int, col: int, type: int) -> void:
	if board_locked:
		return
	_spawn_head(row, col, type)
	shots_fired += 1
	_resolve_matches(row, col, type)
	if not board_locked and shots_fired % shots_per_new_row == 0:
		_push_new_row()
	_check_game_over()


func _resolve_matches(row: int, col: int, type: int) -> void:
	var cluster := _flood_fill(row, col, type)
	if cluster.size() >= 3:
		for key in cluster:
			var head = grid[key]
			grid.erase(key)
			head.queue_free()
		Globals.score += cluster.size() * 10
		emit_signal("score_changed", Globals.score)
		_drop_floating_heads()
	if grid.empty() and not board_locked:
		board_locked = true
		emit_signal("game_won")


func _flood_fill(row: int, col: int, type: int) -> Array:
	var visited := {}
	var stack := [Vector2(row, col)]
	var result := []
	while stack.size() > 0:
		var current = stack.pop_back()
		if visited.has(current):
			continue
		visited[current] = true
		if not grid.has(current):
			continue
		if grid[current].type != type:
			continue
		result.append(current)
		for n in get_neighbors(int(current.x), int(current.y)):
			if not visited.has(n):
				stack.append(n)
	return result


func _drop_floating_heads() -> void:
	var anchored := {}
	var stack := []
	for key in grid.keys():
		if int(key.x) == 0:
			stack.append(key)
	while stack.size() > 0:
		var current = stack.pop_back()
		if anchored.has(current):
			continue
		anchored[current] = true
		for n in get_neighbors(int(current.x), int(current.y)):
			if grid.has(n) and not anchored.has(n):
				stack.append(n)
	var dropped := 0
	for key in grid.keys().duplicate():
		if not anchored.has(key):
			var head = grid[key]
			grid.erase(key)
			_animate_drop(head)
			dropped += 1
	if dropped > 0:
		Globals.score += dropped * 15
		emit_signal("score_changed", Globals.score)


func _animate_drop(head: Node2D) -> void:
	var tween := Tween.new()
	head.add_child(tween)
	tween.interpolate_property(head, "position:y", head.position.y, head.position.y + 900,
		0.6, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.interpolate_property(head, "modulate:a", 1.0, 0.0,
		0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	tween.connect("tween_all_completed", head, "queue_free")


func _push_new_row() -> void:
	var new_grid := {}
	for key in grid.keys():
		var new_key := Vector2(key.x + 1, key.y)
		new_grid[new_key] = grid[key]
	grid = new_grid
	for key in grid.keys():
		var head = grid[key]
		head.grid_row = int(key.x)
		var tween := Tween.new()
		head.add_child(tween)
		tween.interpolate_property(head, "position", head.position,
			grid_to_pixel(int(key.x), int(key.y)), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
	for col in range(grid_cols):
		_spawn_head(0, col, randi() % Globals.HeadType.size())


func _check_game_over() -> void:
	if board_locked:
		return
	for key in grid.keys():
		if int(key.x) >= Globals.DANGER_ROW:
			board_locked = true
			emit_signal("game_over")
			return
