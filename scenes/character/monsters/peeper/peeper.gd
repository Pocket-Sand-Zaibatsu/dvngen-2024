@icon("res://assets/sprites/monsters/beholder/td_monsters_beholder_d1.png")
extends Monster
class_name Peeper

func _init():
	super()
	log_name = "Peeper"
	hit_dice = DicePool.new([Dice.new(20)], 0)
	unarmed_damage_dice = DicePool.new([Dice.new(3)], 0)
	stat_block.update_stat_block([16, 20, 12, 14, 21, 13])
