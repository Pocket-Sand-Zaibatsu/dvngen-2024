@icon("res://assets/sprites/monsters/minotaur/td_monsters_minotaur_d1.png")
extends Monster
class_name Minotaur

func _init():
	super()
	stat_block.update_stat_block([8, 15, 10, 7, 19, 10])

func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move(LevelGrid.a_star_to_player(position))
