@icon("res://assets/sprites/monsters/berserker/td_monsters_berserker_d1.png")
extends Monster
class_name Berserker

func _init():
	super()
	log_name = "Berserker"
	hit_dice = DicePool.new([Dice.new(8)], 4)
	unarmed_damage_dice = DicePool.new([Dice.new(3)], 0)
	stat_block.update_stat_block([9, 17, 12, 9, 16, 11])
