extends Node
#class_name LevelGrid

enum CELL_TYPE {
	EMPTY = -1,
	ACTOR,
	OBSTACLE,
	OBJECT
}

var vector_to_direction = {
	Vector2i.RIGHT: "Right",
	Vector2i.LEFT: "Left",
	Vector2i.UP: "Up",
	Vector2i.DOWN: "Down"
}

var direction_to_vector = {
	"Right": Vector2i.RIGHT,
	"Left": Vector2i.LEFT,
	"Up": Vector2i.UP,
	"Down": Vector2i.DOWN
}

var tile_size = 16

@onready var grid: Dictionary = {}
@onready var grid_size: Vector2i = Vector2i.ZERO

func get_manhattan_distance(grid1: Vector2i, grid2: Vector2i) -> int:
	return abs(grid1.x - grid2.x) + abs(grid1.y - grid2.y)

func grid_to_position(grid_to_convert: Vector2i) -> Vector2:
	return Vector2(grid_to_convert * tile_size) + (Vector2.ONE * tile_size) / 2

func position_to_grid(position_to_convert: Vector2) -> Vector2i:
	return Vector2i(position_to_convert - (Vector2.ONE * tile_size) / 2) / tile_size

func reset() -> void:
	grid.clear()
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			grid[Vector2i(x, y)] = CELL_TYPE.OBSTACLE

func construct(new_size: Vector2i) -> void:
	grid_size = new_size
	reset()

func get_cell(position: Vector2i) -> CELL_TYPE:
	return grid.get(position, CELL_TYPE.OBSTACLE)

func paint_cells_rectangle(initial: Vector2i, final: Vector2i, cell_type: CELL_TYPE) -> void:
	for x in range(initial.x, final.x):
		for y in range(initial.y, final.y):
			grid[Vector2i(x, y)] = cell_type

func update_grid_position(start: Vector2i, target: Vector2i) -> Vector2:
	grid[target] = grid[start]
	grid[start] = CELL_TYPE.EMPTY
	return LevelGrid.grid_to_position(target)

func request_move(start_position: Vector2, direction: String) -> Vector2:
	var start_grid = LevelGrid.position_to_grid(start_position)
	var target_grid = start_grid + direction_to_vector.get(direction, Vector2i.ZERO)
	match get_cell(target_grid):
		CELL_TYPE.EMPTY:
			return update_grid_position(start_grid, target_grid)
	return LevelGrid.grid_to_position(start_grid)

func spawn_actor(spawn_grid: Vector2i) -> void:
	grid[spawn_grid] = CELL_TYPE.ACTOR

func despawn_actor(despawn_position: Vector2) -> void:
	grid[LevelGrid.position_to_grid(despawn_position)] = CELL_TYPE.EMPTY

func get_player_grid() -> Vector2i:
	return LevelGrid.position_to_grid(Player.position)

func a_star_to_player(start_position: Vector2) -> String:
	var start_grid = LevelGrid.position_to_grid(start_position)
	var next_grid = a_star(start_grid, get_player_grid())
	return vector_to_direction.get(next_grid - start_grid, "")

func a_star(start_grid: Vector2i, goal_grid: Vector2i) -> Vector2i:
	var open = BinaryManhattanHeap.new()
	open.set_target(goal_grid)
	open.insert(start_grid)
	var came_from = {}
	var g_score = {}
	g_score[start_grid] = 0
	var f_score = {}
	f_score[start_grid] = get_manhattan_distance(start_grid, goal_grid)
	while 0 < open.size():
		var current = open.extract()
		if goal_grid == current:
			var previous = current
			while current in came_from:
				previous = current
				current = came_from[current]
			return previous
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				if abs(x) == abs(y):
					continue
				var neighbor = Vector2i(current.x + x, current.y + y)
				if CELL_TYPE.OBSTACLE == get_cell(neighbor):
					continue
				var tentative_g_score = g_score[current] + 1
				if tentative_g_score < g_score.get(neighbor, 1000000):
					came_from[neighbor] = current
					g_score[neighbor] = tentative_g_score
					f_score[neighbor] = get_manhattan_distance(neighbor, goal_grid)
					open.insert(neighbor)
	return goal_grid
