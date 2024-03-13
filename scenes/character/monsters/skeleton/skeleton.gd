@icon("res://assets/sprites/monsters/skeleton/td_monsters_skeleton_unarmed_d1.png")
extends Monster
class_name Skeleton

func _init():
	super()
	log_name = "Skeleton"
	hit_dice = DicePool.new([Dice.new(10)])
	unarmed_damage_dice = DicePool.new([Dice.new(2)], 0)
	stat_block.update_stat_block([1, 0, 13, 0, 13, 10])
