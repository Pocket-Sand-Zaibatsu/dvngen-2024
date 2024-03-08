extends Character
class_name Monster

signal enemy_died(uuid: String, location_grid: Vector2i)
signal xp_dropped(amount: int)

@onready var rng: RandomNumberGenerator
var xp_dice: DicePool

func _init():
	log_name = "monster"

func _ready():
	super()
	rng = RandomNumberGenerator.new()
	rng.seed = 0
	damage_sent.connect(Player._on_damage_sent)
	Player.damage_sent.connect(_on_damage_sent)
	xp_dropped.connect(Player._on_xp_dropped)
	xp_dice = DicePool.new([Dice.new(10, 2 * level.level)])
	spawn_projectile.connect(get_parent().get_parent().projectile_manager.spawn_projectile)

func move(_ui_action: String) -> void:
	var adjacent_player_direction = Player.get_grid() - get_grid()
	match adjacent_player_direction:
		Vector2i.LEFT:
			fire_projectile("attack_left")
		Vector2i.RIGHT:
			fire_projectile("attack_right")
		Vector2i.UP:
			fire_projectile("attack_up")
		Vector2i.DOWN:
			fire_projectile("attack_down")
		_:
			super(LevelGrid.a_star_to_player(position))

func die() -> void:
	enemy_died.emit(uuid, get_grid())
	var xp = xp_dice.roll()
	xp_dropped.emit(xp)
	log_messaged.emit("%s died and gave %d XP" % [log_name, xp])
	despawn()

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid)
	LevelGrid.spawn_enemy(spawn_grid)

func despawn() -> void:
	LevelGrid.despawn_actor(position)
	get_parent().enemies.erase(uuid)
	self.queue_free()
