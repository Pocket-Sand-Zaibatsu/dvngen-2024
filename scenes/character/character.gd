extends CharacterBody2D
class_name Character

@export var animation_speed := 10
@export var tile_size = 16
@export var volume_db = 5

signal actor_spawned(grid: Vector2i)
signal health_changed
signal damage_sent(target_grid: Vector2i, actor: String, attack_roll: int, amount: int)
signal log_messaged(contents: String)
signal position_changed
signal spawn_projectile(spawn_grid: Vector2i, velocity: Vector2i, projectile_type: String)

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
#@onready var audio_player = get_node("AudioStreamPlayer2D")
@onready var level: CharacterLevel = CharacterLevel.new()

var uuid: String

var desired_level: int = 1
var log_name: String = "character"
var stat_block: StatBlock = StatBlock.new()
var hit_dice: DicePool = DicePool.new([Dice.new(8)], 0)
var current_health: int = 0
var max_health: int = 0
var base_armor_class: int = 10
var base_attack_bonus: int = 0
var attack_dice: Dice = Dice.new(20, 1)
var unarmed_damage_dice: DicePool = DicePool.new([Dice.new(3)], 0)

var action_mapping: Dictionary = {
	"ui_right": move,
	"ui_left": move,
	"ui_down": move,
	"ui_up": move,
	"attack_right": move,
	"attack_left": move,
	"attack_down": move,
	"attack_up": move,
}

var direction_vector = {
	"Right": Vector2.RIGHT,
	"Left": Vector2.LEFT,
	"Up": Vector2.UP,
	"Down": Vector2.DOWN
}
var input_to_direction = {
	"ui_right": "Right",
	"ui_left": "Left",
	"ui_up": "Up",
	"ui_down": "Down",
}
var attack_to_direction = {
	"attack_right": "Right",
	"attack_left": "Left",
	"attack_up": "Up",
	"attack_down": "Down",
}

func _ready() -> void:
	log_messaged.connect(GameLogTransport._on_log_messaged)
	animated_sprite.play("Down")
	Player.input_received.connect(_on_input_received)
	add_child(level)
	level.level_increased.connect(_on_level_increased)
	level.set_level(desired_level)

func compute_attack_bonus() -> int:
	return base_attack_bonus

func compute_armor_class() -> int:
	return base_armor_class

func roll_attack() -> int:
	return attack_dice.roll() + compute_attack_bonus()

func get_grid() -> Vector2i:
	return LevelGrid.position_to_grid(position)

func fire_projectile(action: String) -> void:
	if action.begins_with("attack"):
		animated_sprite.play(attack_to_direction[action])
		spawn_projectile.emit(
			get_grid(),
			direction_vector[attack_to_direction[action]],
			"bash",
			log_name,
			roll_attack(),
			unarmed_damage_dice.roll()
		)

func spawn(_spawn_grid: Vector2i) -> void:
	pass

func move(ui_action: String):
	if ui_action in input_to_direction.keys():
		var direction = input_to_direction[ui_action]
		animated_sprite.play(direction)
		position = LevelGrid.request_move(position, direction)

func change_health(amount: int) -> void:
	current_health += amount
	health_changed.emit()
	if max_health < current_health:
		current_health = max_health
	elif current_health < 0:
		current_health = 0
		die()

func _on_damage_sent(actor: String, attack_roll: int, amount: int) -> void:
	if attack_roll >= compute_armor_class():
		change_health( - 1 * amount)
		log_messaged.emit("%s takes %d damage from %s" % [log_name, amount, actor])
	else:
		log_messaged.emit("%s dodges an attack from %s" % [log_name, actor])

func die() -> void:
	pass

func _on_input_received(action: String) -> void:
	action_mapping.get(action, func(_action): pass).call(action)

func _on_level_increased() -> void:
	var new_health = hit_dice.roll()
	max_health += new_health
	change_health(new_health)
