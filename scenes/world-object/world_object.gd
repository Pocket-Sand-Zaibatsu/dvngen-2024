extends Area2D
class_name WorldObject

const uuid_util = preload("res://addons/uuid/uuid.gd")

@export var tile_size = 16
@export var uuid: String

@onready var rng: RandomNumberGenerator
@onready var collision_shape = get_node("CollisionShape2D")
@onready var sprite = get_node("Sprite2D")
@onready var available_textures: Array[String] = []

func _init() -> void:
	uuid = uuid_util.v4()

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()

func choose_and_set_random_texture() -> void:
	var texture_index = rng.randi_range(0, available_textures.size() - 1)
	sprite.texture = load(available_textures[texture_index])

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid)

func despawn() -> void:
	get_parent().objects.erase(uuid)
	self.queue_free()

func is_body_player(body: Variant) -> bool:
	return "Player" == body.name

func _on_body_entered(_body: Variant):
	pass

func _on_body_exited(_body: Variant):
	pass
