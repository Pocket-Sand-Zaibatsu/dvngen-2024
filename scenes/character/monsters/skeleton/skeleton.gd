@icon("res://assets/sprites/monsters/skeleton/td_monsters_skeleton_unarmed_d1.png")
extends Monster
class_name Skeleton

func _init():
	super()
	log_name = "skeleton"
	hit_dice = DicePool.new([Dice.new(10)])
	stat_block.update_stat_block([1, 0, 13, 0, 13, 10])
