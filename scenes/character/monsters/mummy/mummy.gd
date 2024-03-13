@icon("res://assets/sprites/monsters/mummy/td_monsters_mummy_d1.png")
extends Monster
class_name Mummy

func _init():
	super()
	log_name = "Mummy"
	hit_dice = DicePool.new([Dice.new(3)], 3)
	unarmed_damage_dice = DicePool.new([Dice.new(3)], 0)
	stat_block.update_stat_block([4, 10, 15, 2, 1, 14])
