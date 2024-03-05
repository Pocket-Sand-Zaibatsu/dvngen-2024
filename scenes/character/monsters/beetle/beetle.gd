@icon("res://assets/sprites/monsters/beetle/td_monsters_beetle_d1.png")
extends Monster
class_name Beetle

func _init():
	super()
	stat_block.update_stat_block([1, 12, 13, 0, 17, 10])
