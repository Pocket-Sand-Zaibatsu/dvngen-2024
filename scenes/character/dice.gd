extends Node
class_name Dice

@export var sides: int

@onready var rng: RandomNumberGenerator

func _init(new_sides: int) -> void:
	if new_sides < 1:
		sides = 1
	else:
		sides = new_sides
	rng = RandomNumberGenerator.new()
	rng.randomize()

func seed_rng(new_seed: int) -> void:
	rng.seed = new_seed

func roll() -> int:
	return rng.randi_range(1, sides)

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
