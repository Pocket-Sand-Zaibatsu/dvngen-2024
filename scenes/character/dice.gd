extends Node
class_name Dice

@export var sides: int

@onready var rng: RandomNumberGenerator

func _init(sides: int) -> void:
	if sides < 1:
		sides = 1
	self.sides = sides
	rng = RandomNumberGenerator.new()
	rng.randomize()

func seed_rng(new_seed: int) -> void:
	rng.seed = new_seed

func roll() -> int:
	return rng.randi_range(1, sides)

func roll_count(count: int) -> Array[int]:
	var results = []
	for _index in range(count):
		results.push_back(roll())
	return results

func sum(accumulator: int, number: int) -> int:
	return accumulator + number

func roll_count_sum(count: int) -> int:
	return roll_count(count).reduce(sum, 0)

func roll_count_sum_drop_lowest_x(count: int, drop_count: int = 1) -> int:
	if drop_count >= count:
		return 0
	var rolls = roll_count(count)
	return rolls.slice(0, count - drop_count - 1).reduce(sum, 0)
