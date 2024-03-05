extends Node2D
class_name LevelGenerator

var skeleton_scene = preload("res://scenes/character/monsters/skeleton/skeleton.tscn")
var minotaur_scene = preload("res://scenes/character/monsters/minotaur/minotaur.tscn")

@export var map_size := Vector2i(100, 100)
@export var room_size_range := Vector2i(8, 15)
@export var max_rooms := 20
@export var map_seed := 0

@onready var level: TileMap = get_node("Level")
@onready var stairs
@onready var map: Dictionary = {}
@onready var grid: LevelGrid

func _on_generate_level():
	map_seed += 1
	_create_level()

func _get_floor_tile(rng: RandomNumberGenerator) -> Vector2i:
	return Vector2i(rng.randi_range(0, 5), rng.randi_range(0, 1))

func _get_wall_tile(rng: RandomNumberGenerator, is_ew: bool = true) -> Vector2i:
	var row := 2
	if not is_ew:
		row = 3
	return Vector2i(rng.randi_range(0, 5), row)

func _ready() -> void:
	$Level1Music.play()
	var stairs_scene = preload("res://scenes/world-object/stairs/stairs.tscn")
	stairs = stairs_scene.instantiate()
	add_child(stairs)
	stairs.generate_level.connect(_on_generate_level)
	_create_level()

func _create_level() -> void:
	Player.hide()
	level.hide()
	_initialize_map()
	_build_rooms()
	level.show()
	Player.show()

func _initialize_map() -> void:
	LevelGrid.construct(map_size)
	level.clear()
	map.clear()
	for x in range(map_size.x):
		for y in range(map_size.y):
			map[Vector2i(x,y)] = "empty"

func _get_random_room(rng: RandomNumberGenerator) -> Rect2i:
	var width := rng.randi_range(room_size_range.x, room_size_range.y)
	var height := rng.randi_range(room_size_range.x, room_size_range.y)
	var x := rng.randi_range(0, map_size.x - width - 1)
	var y := rng.randi_range(0, map_size.y - height - 1)
	return Rect2i(x, y, width, height)

func _intersects(rooms: Array, room: Rect2i) -> bool:
	var intersects := false
	for other_room in rooms:
		if room.intersects(other_room):
			intersects = true
			break
	return intersects

func _add_floor(initial: Vector2i, final: Vector2i) -> void:
	LevelGrid.paint_cells_rectangle(initial, final, LevelGrid.CELL_TYPE.EMPTY)
	for x in range(initial.x, final.x):
		for y in range(initial.y, final.y):
			map[Vector2i(x, y)] = "floor"

func _add_connection(rng: RandomNumberGenerator, first: Rect2i, second: Rect2i) -> void:
	var first_center := (first.position + first.end) / 2
	var second_center := (second.position + second.end) / 2
	if 0 == rng.randi_range(0, 1):
		_add_floor(Vector2i(min(first_center.x, second_center.x), first_center.y), Vector2i(max(first_center.x, second_center.x) + 1, first_center.y + 1))
		_add_floor(Vector2i(second_center.x, min(first_center.y, second_center.y)), Vector2i(second_center.x + 1, max(first_center.y, second_center.y) + 1))
	else:
		_add_floor(Vector2i(first_center.x, min(first_center.y, second_center.y)), Vector2i(first_center.x + 1, max(first_center.y, second_center.y) + 1))
		_add_floor(Vector2i(min(first_center.x, second_center.x), second_center.y), Vector2i(max(first_center.x, second_center.x) + 1, second_center.y + 1))

func _build_rooms() -> void:
	var rng := RandomNumberGenerator.new()
	# REMOVE FOR FINAL GAME
	rng.seed = map_seed
	var rooms := []
	for possible in range(max_rooms):
		var room := _get_random_room(rng)
		if _intersects(rooms, room):
			continue
		rooms.push_back(room)
		_add_floor(room.position, room.end)
		if 1 < rooms.size():
			var previous: Rect2i = rooms[-2]
			_add_connection(rng, room, previous)
	_add_walls()
	_paint_map(rng)
	Player.spawn((rooms[0].position + rooms[0].end) / 2)
	stairs.spawn((rooms[-1].position + rooms[-1].end) / 2)
	var skeleton1 = skeleton_scene.instantiate()
	skeleton1.spawn(Vector2i(Player.get_grid().x + 2, Player.get_grid().y))
	add_child(skeleton1)
	var skeleton2 = skeleton_scene.instantiate()
	skeleton2.spawn(Vector2i(Player.get_grid().x + 1, Player.get_grid().y))
	add_child(skeleton2)
	var minotaur1 = minotaur_scene.instantiate()
	minotaur1.spawn(Vector2i(Player.get_grid().x + 1, Player.get_grid().y - 2))
	add_child(minotaur1)
	var minotaur2 = minotaur_scene.instantiate()
	minotaur2.spawn(Vector2i(Player.get_grid().x + 1, Player.get_grid().y - 1))
	add_child(minotaur2)

func _check_neighbor(coords: Vector2i) -> String:
	if 0 <= coords.x && map_size.x > coords.x && 0 <= coords.y && map_size.y > coords.y:
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
			neighbors += _check_neighbor(Vector2i(x,     y - 1))
			neighbors += _check_neighbor(Vector2i(x,     y + 1))
			if neighbors in ["01", "10", "12", "21"]:
				map[coords] = "ew"
				continue
			neighbors += _check_neighbor(Vector2i(x - 1, y - 1))
			neighbors += _check_neighbor(Vector2i(x + 1, y - 1))
			neighbors += _check_neighbor(Vector2i(x - 1, y    ))
			neighbors += _check_neighbor(Vector2i(x + 1, y    ))
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


func _paint_map(rng: RandomNumberGenerator) -> void:
	for tile in map:
		var layer := 0
		if map[tile] in ["ew", "ns"]:
			layer = 1
		match map[tile]:
			"floor": level.set_cell(layer, tile, 25, _get_floor_tile(rng))
			"empty": level.set_cell(layer, tile, 26, Vector2i.ZERO)
			"ew": level.set_cell(layer, tile, 25, _get_wall_tile(rng))
			"ns": level.set_cell(layer, tile, 25, _get_wall_tile(rng, false))
