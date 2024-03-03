extends Node2D

@export var map_size := Vector2i(100, 100)
@export var room_size_range := Vector2i(8, 15)
@export var max_rooms := 20

@onready var level: TileMap = $Level
@onready var camera: Camera2D = $Camera2D
@onready var map: Dictionary = {}

var BLACK_TILE := Vector2i(0, 6)
var WALL_EW := Vector2i(0, 0)
var WALL_NS := Vector2i(6, 0)
var FLOOR := Vector2i(0, 4)

func _ready() -> void:
	_initialize_map()
	_build_rooms()
	_add_walls()
	_paint_map()
	camera.position = level.map_to_local(map_size / 2)
	#var z := 64 / maxf(map_size.x, map_size.y)
	#camera.zoom = Vector2(z, z)

func _initialize_map() -> void:
	for x in range(map_size.x):
		for y in range(map_size.y):
			map[Vector2i(x,y)] = BLACK_TILE

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
	for x in range(initial.x, final.x):
		for y in range(initial.y, final.y):
			map[Vector2i(x, y)] = FLOOR

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
	rng.seed = 0
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

func _check_neighbor(coords: Vector2i) -> String:
	if 0 <= coords.x && map_size.x > coords.x && 0 <= coords.y && map_size.y > coords.y:
		if FLOOR == map[coords]:
			return "1"
		elif BLACK_TILE == map[coords]:
			return "2"
	return "0" 

func _add_walls() -> void:
	for x in range(map_size.x):
		for y in range(map_size.y):
			var coords = Vector2i(x, y)
			if FLOOR == map[coords]:
				continue
			var neighbors := ""
			neighbors += _check_neighbor(Vector2i(x,     y - 1))
			neighbors += _check_neighbor(Vector2i(x,     y + 1))
			if neighbors in ["01", "10", "12", "21"]:
				map[coords] = WALL_EW
				continue
			neighbors += _check_neighbor(Vector2i(x - 1, y - 1))
			neighbors += _check_neighbor(Vector2i(x + 1, y - 1))
			neighbors += _check_neighbor(Vector2i(x - 1, y    ))
			neighbors += _check_neighbor(Vector2i(x + 1, y    ))
			neighbors += _check_neighbor(Vector2i(x - 1, y + 1))
			neighbors += _check_neighbor(Vector2i(x + 1, y + 1))
			if neighbors.contains("1"):
				map[coords] = WALL_NS

func _paint_map() -> void:
	for tile in map:
		level.set_cell(0, tile, 0, map[tile], 0)
