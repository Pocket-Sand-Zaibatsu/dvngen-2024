extends Node
class_name WorldObjectManager

enum OBJECT_TYPE {
	BONES,
	DOOR_EW,
}

var loader: Dictionary = {
	OBJECT_TYPE.BONES: {
		"scene": preload("res://scenes/world-object/bones/bones.tscn"),
	},
	OBJECT_TYPE.DOOR_EW: {
		"scene": preload("res://scenes/world-object/doors/doors_ew.tscn"),
	},
}

@onready var objects: Dictionary = {}
@onready var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

func reset():
	for item in objects.keys():
		objects[item].despawn()
	objects.clear()

func spawn_object(object_type: OBJECT_TYPE, spawn_grid: Vector2i) -> String:
	var item = loader[object_type]["scene"].instantiate()
	item.spawn(spawn_grid)
	objects[item.uuid] = item
	call_deferred("add_child", item)
	return item.uuid
