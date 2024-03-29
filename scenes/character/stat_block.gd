extends Node
class_name StatBlock

enum Stat {
	CHA = 0,
	CON = 1,
	DEX = 2,
	INT = 3,
	STR = 4,
	WIS = 5,
}

var stats = {
	Stat.CHA: {
		"long": "charisma",
		"short": "cha",
		"value": 0,
	},
	Stat.CON: {
		"long": "constitution",
		"short": "con",
		"value": 0,
	},
	Stat.DEX: {
		"long": "dexterity",
		"short": "dex",
		"value": 0,
	},
	Stat.INT: {
		"long": "intelligence",
		"short": "int",
		"value": 0,
	},
	Stat.STR: {
		"long": "strength",
		"short": "str",
		"value": 0,
	},
	Stat.WIS: {
		"long": "widsom",
		"short": "wis",
		"value": 0,
	}
}

func _init() -> void:
	var dice = Dice.new(6, 5)
	for stat in Stat.values():
		stats[stat].value = dice.roll_drop_lowest(2)

func get_stat(stat: Stat) -> int:
	return stats[stat]["value"]

func update_stat(stat: Stat, new_value: int) -> void:
	stats[stat]["value"] = new_value

func update_stat_block(stat_block: Array[int]) -> void:
	if 6 == stat_block.size():
		for stat in Stat.values():
			stats[stat]["value"] = stat_block[stat]

func _to_string():
	return "CHA: %d, CON: %d, DEX: %d, INT: %d, STR: %d, WIS: %d" % [
		stats[Stat.CHA]["value"],
		stats[Stat.CON]["value"],
		stats[Stat.DEX]["value"],
		stats[Stat.INT]["value"],
		stats[Stat.STR]["value"],
		stats[Stat.WIS]["value"],
	]
