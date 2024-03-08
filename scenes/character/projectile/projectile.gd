extends Area2D
class_name Projectile

var uuid: String
var projectile_type: String = "slash"
var current_travel: int = 1
var max_range: int = 1

@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var projectile_types: PackedStringArray = sprite.get_sprite_frames().get_animation_names()
@onready var velocity: Vector2i

func _ready():
	set_projectile_range()
	sprite.play(projectile_type)

func set_projectile_range() -> void:
	match projectile_type:
		"arrow":
			max_range = 20
		"slash":
			max_range = 1
		_:
			max_range = 10

func set_projectile_type(desired_projectile: String):
	if desired_projectile in projectile_types:
		projectile_type = desired_projectile

func set_velocity(new_velocity: Vector2i) -> void:
	velocity = new_velocity
	rotation = Vector2(velocity).angle() + PI / 2

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid + velocity)

func despawn() -> void:
	get_parent().projectiles.erase(uuid)
	self.queue_free()

func _on_body_entered(body: Variant):
	body.change_health(-10000)
	despawn()

func _on_input_received(_action: String) -> void:
	current_travel += 1
	if current_travel > max_range:
		despawn()
		return
	var next_grid = LevelGrid.position_to_grid(position) + velocity
	if LevelGrid.CELL_TYPE.OBSTACLE == LevelGrid.get_cell(next_grid):
		despawn()
	else:
		position = LevelGrid.grid_to_position(next_grid)
	
