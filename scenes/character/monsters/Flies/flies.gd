@icon("res://assets/sprites/monsters/flies/td_monsters_flies_d1.png")
extends Monster
class_name Flies

func _init():
	super()
	log_name = "Flies"
	hit_dice = DicePool.new([Dice.new(1)], 1)
	unarmed_damage_dice = DicePool.new([Dice.new(1)], 1)
	stat_block.update_stat_block([4, 10, 15, 2, 1, 14])
