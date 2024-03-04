extends Character
class_name Monster

@onready var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = 0

func movement(event) -> void:
	pass

func _unhandled_input(event):
	movement(event)
