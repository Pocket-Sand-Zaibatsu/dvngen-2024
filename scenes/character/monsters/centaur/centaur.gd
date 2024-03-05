@icon("res://assets/sprites/monsters/centaur/td_monsters_centaur_d1.png")
extends Monster
class_name Centaur


var hp = 30
var def = 12
var hit = 6
var xp = 100


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

	
	
