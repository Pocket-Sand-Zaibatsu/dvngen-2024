extends Character
class_name Monster

const uuid_util = preload("res://addons/uuid/uuid.gd")

signal enemy_died(uuid: String, location_grid: Vector2i)

@export var uuid: String

@onready var rng: RandomNumberGenerator

func _init():
	uuid = uuid_util.v4()
	log_name = "monster"

func _ready():
	super()
	rng = RandomNumberGenerator.new()
	rng.seed = 0
	damage_sent.connect(Player._on_damage_sent)
	Player.damage_sent.connect(_on_damage_sent)
	initialize_health()

func initialize_health() -> void:
	for _index in range(level):
		max_health += hit_dice.roll()
	current_health = max_health

func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			var monster_direction = rng.randi_range(0, direction_vector.keys().size() - 1)
			move(direction_vector.keys()[monster_direction])

func die() -> void:
	enemy_died.emit(uuid, get_grid())
	despawn()

func despawn() -> void:
	LevelGrid.despawn_actor(position)
	get_parent().enemies.erase(uuid)
	self.queue_free()

func _unhandled_input(event):
	handle_movement(event)
