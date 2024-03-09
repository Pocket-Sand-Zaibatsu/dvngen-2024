extends Node
class_name WorldObjectManager

enum OBJECT_TYPE {
	BONES,
	BLOOD,
	DOOR_EW,
	ITEMDROP,
}

var loader: Dictionary = {
	OBJECT_TYPE.BONES: {
		"scene": preload ("res://scenes/world-object/bones/bones.tscn"),
	},
	OBJECT_TYPE.DOOR_EW: {
		"scene": preload ("res://scenes/world-object/doors/doors_ew.tscn"),
	},
	OBJECT_TYPE.ITEMDROP: {
		"scene": preload ("res://scenes/world-object/item_drop/item_drop.tscn")
	},
		OBJECT_TYPE.BLOOD: {
		"scene": preload ("res://scenes/world-object/blood_splatter/blood.tscn")
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

func spawn_item_drops(spawn_grid: Vector2i, item_names: Array[String]):
	for item_name in item_names:
		var item = loader[OBJECT_TYPE.ITEMDROP]["scene"].instantiate()
		item.set_item_name(item_name)
		item.spawn(spawn_grid)
		objects[item.uuid] = item
		call_deferred("add_child", item)

func spawn_object(object_type: OBJECT_TYPE, spawn_grid: Vector2i) -> String:
	var item = loader[object_type]["scene"].instantiate()
	item.spawn(spawn_grid)
	objects[item.uuid] = item
	call_deferred("add_child", item)
	return item.uuid
