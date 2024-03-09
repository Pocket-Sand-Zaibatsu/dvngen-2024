extends Node
class_name Dungeon

var level_generator_scene = preload("res://scenes/levels/level_generator.tscn")
var hud_scene = preload("res://interfaces/hud/hud.tscn")

signal player_ready
signal player_position_updated(position: Vector2i)

@onready var level_generator: LevelGenerator
@onready var hud: Hud

func _ready() -> void:
	level_generator = level_generator_scene.instantiate()
	level_generator.name = "LevelGenerator"
	add_child(level_generator)
	level_generator.bottom_reached.connect(_on_player_died)
	Player.reset()
	hud = hud_scene.instantiate()
	hud.name = "Hud"
	LevelGrid.cell_painted.connect(hud._on_cell_painted)
	add_child(hud)
	level_generator.stairs.generate_level.emit()
	Player.player_died.connect(_on_player_died)
	Player.spawn_projectile.connect(level_generator.projectile_manager.spawn_projectile)


func _on_player_died() -> void:
	Player.visible = false
	await level_generator.enemy_manager.reset()
	await level_generator.world_object_manager.reset()
	SceneChanger.change_scene(SceneChanger.PossibleScene.DEATH)
