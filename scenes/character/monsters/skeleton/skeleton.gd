@icon("res://assets/sprites/monsters/skeleton/td_monsters_skeleton_unarmed_d1.png")
extends Monster
class_name Skeleton

func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move("Left")
