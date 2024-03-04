extends CharacterBody2D
class_name Character

@export var animation_speed := 10
@export var tile_size = 16
var moving = false
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

@onready var ray = get_node("RayCast2D")
@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var audio_player = get_node("AudioStreamPlayer2D")

func _ready() -> void:
	animated_sprite.play("Down")

func spawn(spawn_position: Vector2i) -> void:
	position = spawn_position * tile_size
	position += Vector2.ONE * tile_size / 2

func move(direction: String):
	ray.target_position = direction_vector[direction] * tile_size
	ray.force_raycast_update()
	animated_sprite.play(direction)
	if !ray.is_colliding():
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + direction_vector[direction] * tile_size, 1.0 / animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
