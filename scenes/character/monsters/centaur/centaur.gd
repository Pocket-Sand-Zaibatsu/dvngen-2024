@icon("res://assets/sprites/monsters/centaur/td_monsters_centaur_d1.png")
extends Monster
class_name Centaur

func _init():
	super()
	log_name = "centaur"
	hit_dice = DicePool.new([Dice.new(8)], 6)
	unarmed_damage_dice = DicePool.new([Dice.new(3)], 0)
	stat_block.update_stat_block([11, 15, 14, 8, 18, 13])
