extends Node
class_name EnemyManager

enum ENEMY_TYPE {
	BEETLE,
	MINOTAUR,
	SKELETON,
}

var loader: Dictionary = {
	ENEMY_TYPE.BEETLE: {
		"scene": preload("res://scenes/character/monsters/beetle/beetle.tscn")
	},
	ENEMY_TYPE.MINOTAUR: {
		"scene": preload("res://scenes/character/monsters/minotaur/minotaur.tscn")
	},
	ENEMY_TYPE.SKELETON: {
		"scene": preload("res://scenes/character/monsters/skeleton/skeleton.tscn")
	}
}

@onready var enemies: Array[Monster] = []

func reset():
	for monster in enemies:
		monster.despawn()
	enemies.clear()

func spawn_enemy(enemy_type: ENEMY_TYPE, position: Vector2i) -> void:
	var enemy = loader[enemy_type]["scene"].instantiate()
	enemy.spawn(position)
	call_deferred("add_child", enemy)
	enemies.push_back(enemy)
