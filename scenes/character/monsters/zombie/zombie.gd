@icon("res://assets/sprites/monsters/zombie/td_monsters_zombie_d1.png")
extends Monster
class_name Zombie

func _init():
	super()
	log_name = "Zombie"
	hit_dice = DicePool.new([Dice.new(3)], 3)
	unarmed_damage_dice = DicePool.new([Dice.new(3)], 0)
	stat_block.update_stat_block([4, 10, 15, 2, 1, 14])
