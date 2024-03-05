@icon("res://assets/sprites/monsters/minotaur/td_monsters_minotaur_d1.png")
extends Monster
class_name Minotaur

func spawn(spawn_grid: Vector2i) -> void:
	super(spawn_grid)
	print("Minotaur spawning at ", spawn_grid)

func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move(LevelGrid.a_star_to_player(position))
