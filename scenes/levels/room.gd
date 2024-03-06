extends Node
class_name Room

const uuid_util = preload("res://addons/uuid/uuid.gd")

signal room_activated

var boundary: Rect2i
var uuid: String
var doors: Array[Vector2i] = []
var longest_continuous_door_length: int = 0

func _init(new_boundary: Rect2i) -> void:
	boundary = new_boundary
	uuid = uuid_util.v4()

func _ready() -> void:
	room_activated.connect(_on_room_activated)

func get_center() -> Vector2i:
	return (boundary.position + boundary.end) / 2

func check_floor(target_grid: Vector2i) -> bool:
	return "floor" == get_parent().map.get(target_grid, "")

func is_open() -> bool:
	return 2 < longest_continuous_door_length

func update_doors() -> void:
	var new_doors: Array[Vector2i] = []
	var new_longest_continuous_door_length: int = 0
	var current_continuous_door_length: int = 0
	for x in [boundary.position.x - 1, boundary.end.x]:
		for y in range(boundary.position.y, boundary.end.y):
			if check_floor(Vector2i(x, y)):
				current_continuous_door_length += 1
				new_doors.push_back(Vector2i(x, y))
			else:
				if current_continuous_door_length > new_longest_continuous_door_length:
					new_longest_continuous_door_length = current_continuous_door_length
				current_continuous_door_length = 0
	if current_continuous_door_length > new_longest_continuous_door_length:
		new_longest_continuous_door_length = current_continuous_door_length
	current_continuous_door_length = 0
	for y in [boundary.position.y - 1, boundary.end.y]:
		for x in range(boundary.position.x, boundary.end.x):
			if check_floor(Vector2i(x, y)):
				current_continuous_door_length += 1
				new_doors.push_back(Vector2i(x, y))
			else:
				if current_continuous_door_length > new_longest_continuous_door_length:
					new_longest_continuous_door_length = current_continuous_door_length
				current_continuous_door_length = 0
	if current_continuous_door_length > new_longest_continuous_door_length:
		new_longest_continuous_door_length = current_continuous_door_length
	doors = new_doors
	longest_continuous_door_length = new_longest_continuous_door_length

func spawn_doors() -> void:
	if is_open():
		return
	var manager = get_parent().world_object_manager
	for door in doors:
		var door_uuid = manager.spawn_object(WorldObjectManager.OBJECT_TYPE.DOOR_EW, door)
		manager.objects[door_uuid].player_entered.connect(_on_player_entered)

func _on_player_entered() -> void:
	room_activated.emit()

func _on_room_activated() -> void:
	room_activated.disconnect(_on_room_activated)
	get_parent().enemy_manager.spawn_enemy(EnemyManager.ENEMY_TYPE.MINOTAUR, get_center())
