extends Character
class_name Monster

@onready var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = 0

func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			var monster_direction = rng.randi_range(0, direction_vector.keys().size() - 1)
			move(monster_direction)

func _unhandled_input(event):
	handle_movement(event)
