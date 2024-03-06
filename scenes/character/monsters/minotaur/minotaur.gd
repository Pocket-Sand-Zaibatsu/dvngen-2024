@icon("res://assets/sprites/monsters/minotaur/td_monsters_minotaur_d1.png")
extends Monster
class_name Minotaur

func _init():
	super()
	log_name = "minotaur"
	hit_dice = DicePool.new([Dice.new(12)], 4)
	unarmed_damage_dice = DicePool.new([Dice.new(4)], 0)
	stat_block.update_stat_block([8, 15, 10, 7, 19, 10])
