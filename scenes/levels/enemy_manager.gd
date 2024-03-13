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
	ZOMBIE,
	PEEPER,
	MUMMY,
	FLIES,
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
	},
	ENEMY_TYPE.ZOMBIE: {
		"scene": preload("res://scenes/character/monsters/zombie/zombie.tscn")
	},
	ENEMY_TYPE.PEEPER: {
		"scene": preload("res://scenes/character/monsters/peeper/peeper.tscn")
	},
	ENEMY_TYPE.MUMMY: {
		"scene": preload("res://scenes/character/monsters/mummy/mummy.tscn")
	},
	ENEMY_TYPE.FLIES: {
		"scene": preload("res://scenes/character/monsters/Flies/flies.tscn")
	}
}

@onready var enemies: Dictionary = {}
@onready var rng: RandomNumberGenerator
@onready var m_randomizer = preload("res://assets/audio/MonsterDeathRandomizer.tres")
@onready var deathplayer = AudioStreamPlayer2D.new()

var world_object_manager: WorldObjectManager

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	world_object_manager = get_parent().world_object_manager
	deathplayer.set_stream(m_randomizer)
	add_child(deathplayer)

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
	enemy.enemy_died.connect(_on_monster_death)
	enemy.items_dropped.connect(world_object_manager.spawn_item_drops)
	enemy.set("uuid", uuid_util.v4())
	enemy.set("desired_level", int(float(get_parent().dungeon_level) / 5) + 1)
	enemies[enemy.uuid] = enemy
	await call_deferred("add_child", enemy)


func _on_monster_death(_uuid: String, _location_grid: Vector2i):
	deathplayer.volume_db = -7
	deathplayer.play()
	
