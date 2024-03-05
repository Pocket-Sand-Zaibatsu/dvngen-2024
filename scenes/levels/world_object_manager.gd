extends Node
class_name WorldObjectManager

enum OBJECT_TYPE {
	BONES,
}

var loader: Dictionary = {
	OBJECT_TYPE.BONES: {
		"scene": preload("res://scenes/world-object/bones/bones.tscn")
	}
}

@onready var objects: Dictionary = {}
@onready var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

func reset():
	for item in objects:
		objects[item].despawn()
	objects.clear()

func spawn_object(object_type: OBJECT_TYPE, spawn_grid: Vector2i) -> void:
	var item = loader[object_type]["scene"].instantiate()
	item.spawn(spawn_grid)
	objects[item.uuid] = item
	call_deferred("add_child", item)
