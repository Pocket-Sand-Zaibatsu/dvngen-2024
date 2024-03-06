extends Node
class_name Room

const uuid_util = preload("res://addons/uuid/uuid.gd")

var boundary: Rect2i
var uuid: String
var doors: Array[Vector2i] = []
var longest_continuous_door_length: int = 0

func _init(new_boundary: Rect2i) -> void:
	boundary = new_boundary
	uuid = uuid_util.v4()

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
	for y in [boundary.position.y - 1, boundary.end.y]:
		for x in range(boundary.position.x, boundary.end.x):
			if check_floor(Vector2i(x, y)):
				current_continuous_door_length += 1
				new_doors.push_back(Vector2i(x, y))
			else:
				if current_continuous_door_length > new_longest_continuous_door_length:
					new_longest_continuous_door_length = current_continuous_door_length
				current_continuous_door_length = 0
	doors = new_doors
	longest_continuous_door_length = new_longest_continuous_door_length

func spawn_doors() -> void:
	if is_open():
		return
	for door in doors:
		get_parent().world_object_manager.spawn_object(WorldObjectManager.OBJECT_TYPE.DOOR_EW, door)
