extends CharacterBody2D
class_name Character

@export var animation_speed := 10
@export var tile_size = 16
@export var volume_db = 5

@export var max_health = 100
@export var current_health = 100

signal actor_spawned(grid: Vector2i)
signal health_changed

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

func get_grid() -> Vector2i:
	return LevelGrid.position_to_grid(position)

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid)
	LevelGrid.spawn_actor(spawn_grid)

func move(direction: String):
	position = LevelGrid.request_move(position, direction)
