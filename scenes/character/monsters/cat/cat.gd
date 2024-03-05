@icon("res://assets/sprites/monsters/cat/td_monsters_cat_d1.png")
extends Monster
class_name Cat


var hp = 5
var def = 5
var hit = 0
var xp = 2


var dmg_roll = RandomNumberGenerator.new()
var atk_roll = RandomNumberGenerator.new()


func _ready():
	var attack = atk_roll.randf_range(1,20) + hit
	var damage = dmg_roll.randf_range(1,4)
	if attack >= Player.ac:
		Player.current_health = Player.current_health - damage
	

	
func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move(LevelGrid.a_star_to_player(position))

	
	
