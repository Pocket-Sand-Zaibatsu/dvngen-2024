@icon("res://assets/sprites/monsters/demon/td_monsters_demon_d1.png")
extends Monster
class_name Demon

func _init():
	super()
	log_name = "demon"
	hit_dice = DicePool.new([Dice.new(20)], 0)
	unarmed_damage_dice = DicePool.new([Dice.new(4)], 0)
	stat_block.update_stat_block([16, 20, 12, 14, 21, 13])
