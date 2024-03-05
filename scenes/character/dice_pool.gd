extends Node
class_name DicePool

var dice: Array[Dice] = []
var bonus: int = 0

func _init(new_dice: Array[Dice], new_bonus: int) -> void:
	dice = new_dice
	bonus = new_bonus

func get_max() -> int:
	var result = bonus
	for die in dice:
		result += die.get_max()
	return result

func roll() -> int:
	var result: int = bonus
	for die in dice:
		result += die.roll()
	return result
