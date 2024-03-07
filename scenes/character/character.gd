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

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var audio_player = get_node("AudioStreamPlayer2D")

var uuid: String

var log_name: String = "character"
var stat_block: StatBlock = StatBlock.new()
var level: CharacterLevel = CharacterLevel.new(1)
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
	"ui_down": "Down"
}

func _ready() -> void:
	log_messaged.connect(GameLogTransport._on_log_messaged)
	audio_player.set_volume_db(volume_db)
	animated_sprite.play("Down")
	Player.input_received.connect(_on_input_received)

func set_level(new_level: int) -> void:
	level = CharacterLevel.new(new_level)

func update_max_health(levels_gained: int=0) -> void:
	if 0 < levels_gained:
		for _index in range(levels_gained):
			max_health += hit_dice.roll()
	if current_health > max_health:
		current_health = max_health

func compute_attack_bonus() -> int:
	return base_attack_bonus

func compute_armor_class() -> int:
	return base_armor_class

func roll_attack() -> int:
	return attack_dice.roll() + compute_attack_bonus()

func get_grid() -> Vector2i:
	return LevelGrid.position_to_grid(position)

func spawn(_spawn_grid: Vector2i) -> void:
	pass

func move(ui_action: String):
	if ui_action:
		var direction = input_to_direction[ui_action]
		animated_sprite.play(direction)
		damage_sent.emit(get_grid() + Vector2i(direction_vector[direction]), log_name, roll_attack(), unarmed_damage_dice.roll())
		position = LevelGrid.request_move(position, direction)

func change_health(amount: int) -> void:
	current_health += amount
	health_changed.emit()
	if max_health < current_health:
		current_health = max_health
	elif current_health < 0:
		current_health = 0
		die()

func _on_damage_sent(target_grid: Vector2i, actor: String, attack_roll: int, amount: int) -> void:
	if get_grid() == target_grid:
		if attack_roll >= compute_armor_class():
			change_health( - 1 * amount)
			log_messaged.emit("%s takes %d damage from %s" % [log_name, amount, actor])
		else:
			log_messaged.emit("%s dodges an attack from %s" % [log_name, actor])

func die() -> void:
	pass

func _on_input_received(action: String) -> void:
	action_mapping.get(action, func(): pass).call(action)
