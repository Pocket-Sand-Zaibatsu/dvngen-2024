extends CharacterBody2D
class_name Character

@export var animation_speed := 10
@export var tile_size = 16
@export var volume_db = 5

@export var max_health = 100
@export var current_health = 100

signal health_changed

@onready var ray = get_node("RayCast2D")
@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var audio_player = get_node("AudioStreamPlayer2D")

var direction_vector = {
	"Right": Vector2.RIGHT,
	"Left": Vector2.LEFT,
	"Up": Vector2.UP,
	"Down": Vector2.DOWN
}
var input_to_direction = {
	"ui_right": "Right",
	"ui_left": "Left",
	"ui_up": "Up",
	"ui_down": "Down"
}

func _ready() -> void:
	audio_player.set_volume_db(volume_db)
	animated_sprite.play("Down")

func get_manhattan_distance(grid1: Vector2i, grid2: Vector2i) -> int:
	return abs(grid1.x - grid2.x) + abs(grid1.y - grid2.y)

func grid_to_position(convert: Vector2i) -> Vector2:
	return Vector2(convert * tile_size) + (Vector2.ONE * tile_size) / 2

func position_to_grid(convert: Vector2) -> Vector2i:
	return Vector2i(convert - (Vector2.ONE * tile_size) / 2) / tile_size

func get_grid() -> Vector2i:
	return position_to_grid(position)

func spawn(spawn_grid: Vector2i) -> void:
	position = grid_to_position(spawn_grid)

func move(direction: String):
	ray.target_position = direction_vector[direction] * tile_size
	ray.force_raycast_update()
	animated_sprite.play(direction)
	if !ray.is_colliding():
		position += direction_vector[direction] * tile_size
