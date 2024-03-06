@icon("res://assets/sprites/monsters/cat/td_monsters_cat_d1.png")
extends Monster
class_name Cat

func _init():
	super()
	log_name = "cat"
	hit_dice = DicePool.new([Dice.new(4)], 2)
	unarmed_damage_dice = DicePool.new([Dice.new(1)], 0)
	stat_block.update_stat_block([7, 10, 15, 2, 3, 12])
