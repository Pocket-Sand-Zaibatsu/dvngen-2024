extends Area2D
class_name WorldObject

@export var tile_size = 16

@onready var rng: RandomNumberGenerator
@onready var collision_shape = get_node("CollisionShape2D")
@onready var sprite = get_node("Sprite2D")

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid)

func _on_body_entered(_body: Variant):
	pass
