@icon("res://assets/sprites/monsters/skeleton/td_monsters_skeleton_unarmed_d1.png")
extends Monster
class_name Skeleton

func _init():
	stat_block.update_stat_block([1, 0, 13, 0, 13, 10])

func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move("Left")
