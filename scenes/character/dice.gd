extends Node
class_name Dice

var sides: int = 6
var count: int = 1

@onready var rng: RandomNumberGenerator

func _init(new_sides: int = 6, new_count: int = 1) -> void:
	update_sides(new_sides)
	update_count(new_count)
	rng = RandomNumberGenerator.new()
	rng.randomize()

func get_max() -> int:
	return count * sides

func get_sides() -> int:
	return sides

func update_sides(new_sides: int) -> void:
	if new_sides < 1:
		sides = 1
	else:
		sides = new_sides

func get_count() -> int:
	return count

func update_count(new_count: int) -> void:
	if 0 < new_count:
		count = new_count

func seed_rng(new_seed: int) -> void:
	rng.seed = new_seed

func roll_single() -> int:
	return rng.randi_range(1, sides)

func roll_all() -> Array[int]:
	var results: Array[int] = []
	for _index in range(count):
		results.push_back(roll_single())
	return results

func sum(accumulator: int, number: int) -> int:
	return accumulator + number

func roll() -> int:
	return roll_all().reduce(sum, 0)

func roll_drop_lowest(drop_count: int = 1) -> int:
	if drop_count >= count:
		return 0
	var rolls = roll_all()
	rolls.sort()
	return rolls.slice(drop_count, count).reduce(sum, 0)
