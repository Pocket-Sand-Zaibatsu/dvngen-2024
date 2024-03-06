extends Node
class_name EnemyManager

const uuid_util = preload("res://addons/uuid/uuid.gd")

enum ENEMY_TYPE {
	BAT,
	BEETLE,
	BERSERKER,
	CAT,
	CENTAUR,
	DEMON,
	MINOTAUR,
	SKELETON,
}

var loader: Dictionary = {
	ENEMY_TYPE.BAT: {
		"scene": preload("res://scenes/character/monsters/bat/bat.tscn")
	},
	ENEMY_TYPE.BEETLE: {
		"scene": preload("res://scenes/character/monsters/beetle/beetle.tscn")
	},
	ENEMY_TYPE.BERSERKER: {
		"scene": preload("res://scenes/character/monsters/berserker/berserker.tscn")
	},
	ENEMY_TYPE.CAT: {
		"scene": preload("res://scenes/character/monsters/cat/cat.tscn")
	},
	ENEMY_TYPE.CENTAUR: {
		"scene": preload("res://scenes/character/monsters/centaur/centaur.tscn")
	},
	ENEMY_TYPE.DEMON: {
		"scene": preload("res://scenes/character/monsters/demon/demon.tscn")
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
	for monster in enemies.keys():
		enemies[monster].despawn()
	enemies.clear()

func get_random_enemy_type() -> ENEMY_TYPE:
	return ENEMY_TYPE.values()[rng.randi() % ENEMY_TYPE.values().size()]

func spawn_random_enemy(spawn_grid: Vector2i) -> void:
	spawn_enemy(
		get_random_enemy_type(),
		spawn_grid
	)

func spawn_enemy(enemy_type: ENEMY_TYPE, spawn_grid: Vector2i) -> void:
	var enemy = loader[enemy_type]["scene"].instantiate()
	enemy.spawn(spawn_grid)
	enemy.enemy_died.connect(get_parent()._on_enemy_died)
	enemy.set("uuid", uuid_util.v4())
	enemies[enemy.uuid] = enemy
	await call_deferred("add_child", enemy)
