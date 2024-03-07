extends Node
class_name CharacterLevel

const EXPERIENCE_TABLE = [
	-1,
	0,
	1000,
	3000,
	6000,
	10000,
	15000,
	21000,
	28000,
	36000,
	45000,
	55000,
	66000,
	78000,
	91000,
	105000,
	120000,
	136000,
	153000,
	171000,
	190000,
	# max int
	# https://docs.godotengine.org/en/stable/classes/class_int.html
	9223372036854775807,
]

signal level_increased

@export var level: int = 0
var current_experience: int = 0

func set_level(new_level: int) -> void:
	if 1 > new_level:
		new_level = 1
	if 20 < new_level:
		new_level = 20
	add_experience(EXPERIENCE_TABLE[new_level])

func add_experience(added_experience: int) -> void:
	current_experience += added_experience
	while current_experience >= EXPERIENCE_TABLE[level + 1]:
		level += 1
		level_increased.emit()

func _to_string() -> String:
	return "%d XP, %d level" % [current_experience, level]
