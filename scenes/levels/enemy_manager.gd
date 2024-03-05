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

@onready var enemies: Dictionary = {}
@onready var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

func reset():
	for monster in enemies:
		enemies[monster].despawn()
	enemies.clear()

func spawn_random_enemy(spawn_grid: Vector2i) -> void:
	spawn_enemy(
		ENEMY_TYPE.values()[rng.randi() % ENEMY_TYPE.values().size()],
		spawn_grid
	)

func spawn_enemy(enemy_type: ENEMY_TYPE, spawn_grid: Vector2i) -> void:
	var enemy = loader[enemy_type]["scene"].instantiate()
	enemy.spawn(spawn_grid)
	Player.damage_sent.connect(enemy._on_damage_sent)
	enemies[enemy.uuid] = enemy
	call_deferred("add_child", enemy)
