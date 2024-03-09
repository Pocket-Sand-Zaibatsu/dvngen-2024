extends Node2D
class_name LevelGenerator

signal bottom_reached

@export var map_size := Vector2i(102, 102)
@export var room_size_range := Vector2i(5, 15)
@export var max_rooms := 30
# @export var map_size := Vector2i(32, 32)
# @export var room_size_range := Vector2i(5, 10)
# @export var max_rooms := 4
@export var map_seed := 0

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var level: TileMap = get_node("Level")
@onready var stairs
@onready var map: Dictionary = {}
@onready var enemy_manager: EnemyManager = EnemyManager.new()
@onready var world_object_manager: WorldObjectManager = WorldObjectManager.new()
@onready var projectile_manager: ProjectileManager = ProjectileManager.new()
@onready var rooms: Array[Room] = []
@onready var biome: DungeonBiome = DungeonBiome.STONE

enum DungeonBiome {
	STONE = 25,
	CAVE = 27,
	CRYPT = 52,
	SEWER = 79,
}

var dungeon_level: int = 0
signal dungeon_level_changed(current_level: int)

func _on_generate_level():
	map_seed += 1
	_create_level()

func _get_floor_tile() -> Vector2i:
	return Vector2i(rng.randi_range(0, 5), rng.randi_range(0, 1))

func _get_wall_tile(is_ew: bool = true) -> Vector2i:
	var row := 2
	if not is_ew:
		row = 3
	return Vector2i(rng.randi_range(0, 5), row)

func _ready() -> void:
	add_child(enemy_manager)
	add_child(world_object_manager)
	add_child(projectile_manager)
	var stairs_scene = preload("res://scenes/world-object/stairs/stairs.tscn")
	stairs = stairs_scene.instantiate()
	add_child(stairs)
	stairs.generate_level.connect(_on_generate_level)
	# REMOVE FOR FINAL GAME
	# rng.seed = map_seed
	$LevelMusic.play()
	$LevelAmbience.play()


func pick_biome() -> DungeonBiome:
	return DungeonBiome.values()[rng.randi() % DungeonBiome.values().size()]

func _create_level() -> void:
	dungeon_level += 1
	if 100 < dungeon_level:
		Player.you_won = true
		bottom_reached.emit()
		return
	dungeon_level_changed.emit(dungeon_level)
	biome = pick_biome()
	enemy_manager.reset()
	world_object_manager.reset()
	projectile_manager.reset()
	Player.hide()
	level.hide()
	_initialize_map()
	_build_rooms()
	level.show()
	Player.show()
	GameLogTransport.game_log_messaged.emit("Entering dungeon level %d" % dungeon_level)

func _initialize_map() -> void:
	LevelGrid.construct(map_size)
	level.clear()
	map.clear()
	for x in range(map_size.x):
		for y in range(map_size.y):
			map[Vector2i(x, y)] = "empty"

func _get_random_room() -> Rect2i:
	var width := rng.randi_range(room_size_range.x, room_size_range.y)
	var height := rng.randi_range(room_size_range.x, room_size_range.y)
	var x := rng.randi_range(1, map_size.x - width - 2)
	var y := rng.randi_range(1, map_size.y - height - 2)
	return Rect2i(x, y, width, height)

func _intersects(room: Rect2i) -> bool:
	for other_room in rooms:
		if room.intersects(other_room.boundary):
			return true
	return false

func _add_floor(initial: Vector2i, final: Vector2i) -> void:
	LevelGrid.paint_cells_rectangle(initial, final, LevelGrid.CELL_TYPE.EMPTY)
	for x in range(initial.x, final.x):
		for y in range(initial.y, final.y):
			map[Vector2i(x, y)] = "floor"

func _add_connection(first: Room, second: Room) -> void:
	var first_center := first.get_center()
	var second_center := second.get_center()
	if 0 == rng.randi_range(0, 1):
		_add_floor(Vector2i(min(first_center.x, second_center.x), first_center.y), Vector2i(max(first_center.x, second_center.x) + 1, first_center.y + 1))
		_add_floor(Vector2i(second_center.x, min(first_center.y, second_center.y)), Vector2i(second_center.x + 1, max(first_center.y, second_center.y) + 1))
	else:
		_add_floor(Vector2i(first_center.x, min(first_center.y, second_center.y)), Vector2i(first_center.x + 1, max(first_center.y, second_center.y) + 1))
		_add_floor(Vector2i(min(first_center.x, second_center.x), second_center.y), Vector2i(max(first_center.x, second_center.x) + 1, second_center.y + 1))

func _build_rooms() -> void:
	for room in rooms:
		room.queue_free()
	rooms.clear()
	for possible in range(max_rooms):
		var room_boundary := _get_random_room()
		if _intersects(room_boundary):
			continue
		_add_floor(room_boundary.position, room_boundary.end)
		var room = Room.new(room_boundary)
		rooms.push_back(room)
		add_child(room)
		if 1 < rooms.size():
			_add_connection(rooms[-1], rooms[-2])
	_add_walls()
	for room in rooms.slice(1, rooms.size()):
		room.update_doors()
		room.spawn_doors()
	_paint_map()
	Player.spawn(rooms[0].get_center())
	var stair_position = rooms[-1].get_center()
	stairs.spawn_with_biome(biome, Vector2i(stair_position.x + 1, stair_position.y))

func _check_neighbor(coords: Vector2i) -> String:
	if 0 <= coords.x&&map_size.x > coords.x&&0 <= coords.y&&map_size.y > coords.y:
		if "floor" == map[coords]:
			return "1"
		elif "empty" == map[coords]:
			return "2"
	return "0"

func _add_walls() -> void:
	for x in range(map_size.x):
		for y in range(map_size.y):
			var coords = Vector2i(x, y)
			if "floor" == map[coords]:
				continue
			var neighbors := ""
			neighbors += _check_neighbor(Vector2i(x, y - 1))
			neighbors += _check_neighbor(Vector2i(x, y + 1))
			if neighbors in ["01", "10", "12", "21"]:
				map[coords] = "ew"
				continue
			neighbors += _check_neighbor(Vector2i(x - 1, y - 1))
			neighbors += _check_neighbor(Vector2i(x + 1, y - 1))
			neighbors += _check_neighbor(Vector2i(x - 1, y))
			neighbors += _check_neighbor(Vector2i(x + 1, y))
			neighbors += _check_neighbor(Vector2i(x - 1, y + 1))
			neighbors += _check_neighbor(Vector2i(x + 1, y + 1))
			if neighbors.contains("1"):
				map[coords] = "ns"
	for x in range(map_size.x):
		for y in range(map_size.y):
			var coords = Vector2i(x, y)
			if "floor" == map[coords]:
				continue
			if y < map_size.y - 1 && "ns" == map[coords] && "empty" == map[Vector2i(x, y + 1)]:
				map[coords] = "ew"
			if y < map_size.y - 1 && "ew" == map[coords] && "ns" == map[Vector2i(x, y + 1)]:
				map[coords] = "ns"

func _paint_map() -> void:
	for tile in map:
		var layer := 0
		if map[tile] in ["ew", "ns"]:
			layer = 1
		match map[tile]:
			"floor": level.set_cell(layer, tile, biome, _get_floor_tile())
			"empty": level.set_cell(layer, tile, 26, Vector2i.ZERO)
			"ew": level.set_cell(layer, tile, biome, _get_wall_tile())
			"ns": level.set_cell(layer, tile, biome, _get_wall_tile(false))

func _on_enemy_died(_uuid: String, location_grid: Vector2i) -> void:
	world_object_manager.spawn_object(WorldObjectManager.OBJECT_TYPE.BLOOD, location_grid)
