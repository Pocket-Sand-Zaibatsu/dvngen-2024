extends Node
#class_name LevelGrid

enum CELL_TYPE {
	EMPTY = -1,
	PLAYER,
	ENEMY,
	OBSTACLE,
	OBJECT
}

var vector_to_input_direction = {
	Vector2i.RIGHT: "ui_right",
	Vector2i.LEFT: "ui_left",
	Vector2i.UP: "ui_up",
	Vector2i.DOWN: "ui_down"
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

func spawn(cell_type: CELL_TYPE, spawn_grid: Vector2i) -> void:
	grid[spawn_grid] = cell_type

func spawn_enemy(spawn_grid: Vector2i) -> void:
	spawn(CELL_TYPE.ENEMY, spawn_grid)

func despawn_actor(despawn_position: Vector2) -> void:
	grid[LevelGrid.position_to_grid(despawn_position)] = CELL_TYPE.EMPTY

func get_player_grid() -> Vector2i:
	return LevelGrid.position_to_grid(Player.position)

func a_star_to_player(start_position: Vector2) -> String:
	var start_grid = LevelGrid.position_to_grid(start_position)
	var next_grid = a_star(start_grid, get_player_grid())
	return vector_to_input_direction.get(next_grid - start_grid, "")

# https://www.redblobgames.com/pathfinding/a-star/introduction.html
func a_star(start_grid: Vector2i, goal_grid: Vector2i) -> Vector2i:
	var frontier = BinaryHeap.new()
	frontier.insert(start_grid, 0)
	var came_from = {}
	came_from[start_grid] = null
	var cost_so_far = {}
	cost_so_far[start_grid] = 0
	while 0 < frontier.size():
		var current = frontier.extract()
		if goal_grid == current:
			var previous = current
			while current in came_from.keys() && came_from[current]:
				previous = current
				current = came_from[current]
			return previous
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				if abs(x) == abs(y):
					continue
				var next_grid = Vector2i(current.x + x, current.y + y)
				if CELL_TYPE.OBSTACLE == get_cell(next_grid):
					continue
				var new_cost = cost_so_far[current]
				if CELL_TYPE.ENEMY == get_cell(next_grid):
					new_cost += 2
				if next_grid not in cost_so_far.keys() or new_cost < cost_so_far[next_grid]:
					cost_so_far[next_grid] = new_cost
					frontier.insert(next_grid, new_cost + get_manhattan_distance(goal_grid, next_grid))
					came_from[next_grid] = current
	return goal_grid
