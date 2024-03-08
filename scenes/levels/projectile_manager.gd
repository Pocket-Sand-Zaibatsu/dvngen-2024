extends Node
class_name ProjectileManager

const uuid_util = preload("res://addons/uuid/uuid.gd")
const projectile_scene: PackedScene = preload("res://scenes/character/projectile/projectile.tscn")

@onready var projectiles: Dictionary = {}
@onready var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

func reset():
	for projectile in projectiles.keys():
		projectiles[projectile].despawn()
	projectiles.clear()

func spawn_projectile(spawn_grid: Vector2i, velocity: Vector2i, projectile_type: String = "slash") -> void:
	if LevelGrid.CELL_TYPE.OBSTACLE == LevelGrid.get_cell(spawn_grid + velocity):
		return
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.set_velocity(velocity)
	projectile.spawn(spawn_grid)
	projectile.set_projectile_type(projectile_type)
	Player.input_received.connect(projectile._on_input_received)
	projectile.set("uuid", uuid_util.v4())
	projectiles[projectile.uuid] = projectile
	await call_deferred("add_child", projectile)
