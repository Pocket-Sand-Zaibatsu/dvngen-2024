extends Character
class_name Monster

signal enemy_died(uuid: String, location_grid: Vector2i)
signal xp_dropped(amount: int)
signal items_dropped(target_grid: Vector2i, items: Array[String])

@onready var rng: RandomNumberGenerator

var xp_dice: DicePool
var armor_class_bonus: int = 0
var extra_attack_bonus: int = 0
# Set these to something higher
var drop_table: Dictionary = {
	"td_items_coins_gold": 0,
	"td_items_potion_red": 0,
	"td_items_weapon_shortsword": 0,
}
var drop_dice: DicePool = DicePool.new([Dice.new(100)])

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

func compute_attack_bonus() -> int:
	return base_attack_bonus + extra_attack_bonus

func compute_armor_class() -> int:
	return base_armor_class + armor_class_bonus

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

func roll_drop_table() -> Array[String]:
	var drops: Array[String] = []
	for item in drop_table.keys():
		if drop_dice.roll() >= drop_table[item]:
			drops.push_back(item)
	return drops

func die() -> void:
	enemy_died.emit(uuid, get_grid())
	var xp = xp_dice.roll()
	xp_dropped.emit(xp)
	items_dropped.emit(get_grid(), roll_drop_table())
	log_messaged.emit("%s died and gave %d XP" % [log_name, xp])
	despawn()

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid)
	LevelGrid.spawn_enemy(spawn_grid)

func despawn() -> void:
	LevelGrid.despawn_actor(position)
	get_parent().enemies.erase(uuid)
	self.queue_free()
