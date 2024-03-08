extends Area2D
class_name Projectile

signal log_messaged(contents: String)

var uuid: String
var desired_type: String = "slash"
var projectile_type: String = "slash"
var current_travel: int = 1
var max_range: int = 1
var actor: String
var attack_roll: int
var damage: int

@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var projectile_types: PackedStringArray = sprite.get_sprite_frames().get_animation_names()
@onready var velocity: Vector2i

func _ready():
	if desired_type in projectile_types:
		projectile_type = desired_type
	set_projectile_range()
	sprite.play(projectile_type)
	log_messaged.connect(GameLogTransport._on_log_messaged)

func set_projectile_range() -> void:
	match projectile_type:
		"slash", "bash":
			max_range = 1
		"lightning":
			max_range = 3
		"arrow":
			max_range = 20
		_:
			max_range = 10

func set_projectile_type(new_type: String):
	desired_type = new_type

func set_velocity(new_velocity: Vector2i) -> void:
	velocity = new_velocity
	rotation = Vector2(velocity).angle() + PI / 2

func set_attack(new_actor: String, new_attack_roll: int, new_damage: int) -> void:
	actor = new_actor
	attack_roll = new_attack_roll
	damage = new_damage

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid + velocity)

func despawn() -> void:
	get_parent().projectiles.erase(uuid)
	self.queue_free()

func _on_body_entered(body: Variant):
	if body.has_method("_on_damage_sent"):
		body._on_damage_sent(actor, attack_roll, damage)
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

func _on_area_entered(area):
	if area.has_method("blocks_projectiles") && area.blocks_projectiles():
		despawn()
