extends Node
class_name Dungeon
var level_generator_scene = preload("res://scenes/levels/level_generator.tscn")
var player_scene = preload("res://scenes/character/player/player.tscn")

@onready var player: Player
@onready var level_generator: LevelGenerator
@onready var hud: Hud = get_node("Hud")

func _ready() -> void:
	player = player_scene.instantiate()
	player.name = "Player"
	add_child(player)
	level_generator = level_generator_scene.instantiate()
	add_child(level_generator)
