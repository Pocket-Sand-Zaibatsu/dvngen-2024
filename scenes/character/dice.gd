extends Node
class_name Dice

var sides: int = 6
var roll_bonus: int = 0

@onready var rng: RandomNumberGenerator

func _init(new_sides: int = 6, new_roll_bonus: int = 0) -> void:
	update_sides(new_sides)
	update_roll_bonus(new_roll_bonus)
	rng = RandomNumberGenerator.new()
	rng.randomize()

func get_sides() -> int:
	return sides

func update_sides(new_sides: int) -> void:
	if new_sides < 1:
		sides = 1
	else:
		sides = new_sides

func get_roll_bonus() -> int:
	return roll_bonus

func update_roll_bonus(new_roll_bonus: int) -> void:
	roll_bonus = new_roll_bonus

func seed_rng(new_seed: int) -> void:
	rng.seed = new_seed

func roll() -> int:
	return rng.randi_range(1, sides) + roll_bonus

func roll_count(count: int) -> Array[int]:
	var results: Array[int] = []
	for _index in range(count):
		results.push_back(roll())
	return results

func sum(accumulator: int, number: int) -> int:
	return accumulator + number

func roll_count_sum(count: int) -> int:
	return roll_count(count).reduce(sum, 0)

func roll_count_sum_drop_lowest(count: int, drop_count: int = 1) -> int:
	if drop_count >= count:
		return 0
	var rolls = roll_count(count)
	rolls.sort()
	return rolls.slice(drop_count, count).reduce(sum, 0)
