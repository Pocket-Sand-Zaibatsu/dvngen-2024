@icon("res://assets/sprites/monsters/bat/td_monsters_bat_d1.png")
extends Monster
class_name Bat

func _init():
	super()
	log_name = "Bat"
	hit_dice = DicePool.new([Dice.new(2)], 2)
	unarmed_damage_dice = DicePool.new([Dice.new(2)], 0)
	stat_block.update_stat_block([4, 10, 15, 2, 1, 14])
