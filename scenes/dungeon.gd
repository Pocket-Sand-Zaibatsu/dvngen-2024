extends Node
class_name Dungeon

var level_generator_scene = preload("res://scenes/levels/level_generator.tscn")
var player_scene = preload("res://scenes/character/player/player.tscn")
var hud_scene = preload("res://interfaces/hud/hud.tscn")

signal dev_tools_stat_update(stat_field: String, value: int)
signal player_ready
signal player_position_updated(position: Vector2i)

@onready var player: Player
@onready var level_generator: LevelGenerator
@onready var hud: Hud

func _ready() -> void:
	player = player_scene.instantiate()
	player.name = "Player"
	add_child(player)
	player.player_position_updated.connect(_pass_player_position_updated)
	level_generator = level_generator_scene.instantiate()
	level_generator.name = "LevelGenerator"
	add_child(level_generator)
	hud = hud_scene.instantiate()
	hud.name = "Hud"
	add_child(hud)
	hud.dev_tools_stat_update.connect(_pass_dev_tools_stat_updates)

func _pass_dev_tools_stat_updates(stat_field: String, value: int) -> void:
	print("Dungeon dev tools: ", stat_field, ":", value)
	dev_tools_stat_update.emit(stat_field, value)

func _pass_player_position_updated(position: Vector2i) -> void:
	player_position_updated.emit(position)
