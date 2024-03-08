extends Character
class_name PlayerCharacter

var you_won: bool = false

signal player_ready
signal player_position_updated(position: Vector2i)
signal input_received(action: String)
signal player_died

const FRAMES_PER_ACTION: int = 10

@onready var camera = get_node("PlayerCamera")
@onready var player_class: String
@onready var frames_since_last_action: int = 0

func _ready() -> void:
	super()
	log_name = "player"
	action_mapping["attack_down"] = fire_projectile
	action_mapping["attack_left"] = fire_projectile
	action_mapping["attack_right"] = fire_projectile
	action_mapping["attack_up"] = fire_projectile

func reset() -> void:
	you_won = false
	level.reset()
	stat_block = StatBlock.new()
	hit_dice = DicePool.new([Dice.new(8)], 0)
	current_health = 100
	max_health = 100
	base_armor_class = 10
	base_attack_bonus = 0
	attack_dice = Dice.new(20, 1)
	unarmed_damage_dice = DicePool.new([Dice.new(3)], 0)
	player_ready.emit()
	health_changed.emit()

func _on_dev_tools_stat_update(stat_field: String, value: int) -> void:
	print("Player dev tools: ", stat_field, ":", value)
	match stat_field:
		"max_health":
			max_health = value
			health_changed.emit()
		"current_health":
			current_health = value
			health_changed.emit()

func change_health(amount: int) -> void:
	super(amount)
	if 0 >= current_health:
		player_died.emit()

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid)
	LevelGrid.spawn(LevelGrid.CELL_TYPE.PLAYER, spawn_grid)
	camera.set_enabled(true)
	camera.make_current()

func fire_projectile(action: String) -> void:
	if action.begins_with("attack"):
		spawn_projectile.emit(get_grid(), direction_vector[input_to_direction[action]])

func move(ui_action: String) -> void:
	frames_since_last_action = 0
	super(ui_action)
	audio_player.play()
	player_position_updated.emit(position)

func _on_xp_dropped(amount: int) -> void:
	level.add_experience(amount)

func _on_level_increased() -> void:
	super()
	log_messaged.emit("Player has grown to level %d!" % level.level)

func _unhandled_input(event):
	if not visible:
		return
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			input_received.emit(direction)

func _physics_process(_delta):
	if not visible:
		return
	frames_since_last_action += 1
	if 0 != frames_since_last_action % FRAMES_PER_ACTION:
		return
	frames_since_last_action -= FRAMES_PER_ACTION
	for direction in input_to_direction.keys():
		if Input.is_action_pressed(direction):
			input_received.emit(direction)
