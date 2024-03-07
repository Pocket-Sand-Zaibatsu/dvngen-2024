extends Character
class_name Monster

signal enemy_died(uuid: String, location_grid: Vector2i)

@onready var rng: RandomNumberGenerator

func _init():
	log_name = "monster"

func _ready():
	super()
	rng = RandomNumberGenerator.new()
	rng.seed = 0
	damage_sent.connect(Player._on_damage_sent)
	Player.damage_sent.connect(_on_damage_sent)

func move(_ui_action: String) -> void:
	super(LevelGrid.a_star_to_player(position))

func die() -> void:
	enemy_died.emit(uuid, get_grid())
	despawn()

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid)
	LevelGrid.spawn_enemy(spawn_grid)

func despawn() -> void:
	LevelGrid.despawn_actor(position)
	get_parent().enemies.erase(uuid)
	self.queue_free()
