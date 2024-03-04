extends CharacterBody2D
class_name Character

@export var animation_speed := 10
@export var tile_size = 16
var moving = false
var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

@onready var ray = get_node("RayCast2D")
@onready var _animated_sprite = get_node("AnimatedSprite2D")
@onready var audio_player = get_node("AudioStreamPlayer2D")

func _ready():
	_animated_sprite.play("Down")

func spawn(spawn_position: Vector2i) -> void:
	position = spawn_position * tile_size
	position += Vector2.ONE * tile_size / 2

func _process(_delta):
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play("Right")
	if Input.is_action_pressed("ui_left"):
		_animated_sprite.play("Left")
	if Input.is_action_pressed("ui_up"):
		_animated_sprite.play("Up")
	if Input.is_action_pressed("ui_down"):
		_animated_sprite.play("Down")
		
		
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
