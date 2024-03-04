@icon("res://assets/sprites/monsters/minotaur/td_monsters_minotaur_d1.png")
extends Monster
class_name Minotaur

func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move("Down")
