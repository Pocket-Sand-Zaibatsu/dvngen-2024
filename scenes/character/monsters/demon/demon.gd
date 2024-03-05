@icon("res://assets/sprites/monsters/demon/td_monsters_demon_d1.png")
extends Monster
class_name Demon


var hp = 45
var def = 13
var hit = 6
var xp = 115


var dmg_roll = RandomNumberGenerator.new()
var atk_roll = RandomNumberGenerator.new()


func _ready():
	var attack = atk_roll.randf_range(1,20) + hit
	var damage = dmg_roll.randf_range(1,4) + 1
	if attack >= Player.ac:
		Player.current_health = Player.current_health - damage
	

	
func handle_movement(event) -> void:
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move(LevelGrid.a_star_to_player(position))

	
	
