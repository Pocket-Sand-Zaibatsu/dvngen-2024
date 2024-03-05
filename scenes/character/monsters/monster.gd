extends Character
class_name Monster

const uuid_util = preload("res://addons/uuid/uuid.gd")

@onready var rng: RandomNumberGenerator
@onready var uuid = uuid_util.v4()

func _ready():
	super()
	rng = RandomNumberGenerator.new()
	rng.seed = 0
	damage_sent.connect(Player._on_damage_sent)
	Player.damage_sent.connect(_on_damage_sent)

func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			var monster_direction = rng.randi_range(0, direction_vector.keys().size() - 1)
			move(direction_vector.keys()[monster_direction])

func despawn() -> void:
	LevelGrid.despawn_actor(position)
	get_parent().enemies.erase(uuid)
	self.queue_free()

func _unhandled_input(event):
	handle_movement(event)
