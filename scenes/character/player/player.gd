extends Character
class_name PlayerCharacter

var you_won: bool = false


signal player_ready
signal player_position_updated(position: Vector2i)
signal input_received(action: String)
signal player_died
signal atk_bonus_change

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
	PlayerInventory.reset()
	set_starting_equipment()
	level.reset()
	stat_block = StatBlock.new()
	hit_dice = DicePool.new([Dice.new(8)], 0)
	current_health = 100
	max_health = 100
	base_armor_class = 5
	base_attack_bonus = 0
	attack_dice = Dice.new(20, 1)
	unarmed_damage_dice = DicePool.new([Dice.new(3)], 0)
	player_ready.emit()
	health_changed.emit()

func set_starting_equipment() -> void:
	var armor_type: String
	var weapon: String
	var cape: String
	var shield: String
	match player_class.to_lower():
		"fighter":
			armor_type = "Steel"
			weapon = "Sword"
			cape = "Purple"
			shield = "Wood Shield"
		"ranger":
			armor_type = "Leather"
			weapon = "Bow"
			cape = "Leather"
		"wizard":
			armor_type = "Magic"
			cape = "Magic"
			weapon = "Staff"
	#PlayerInventory.equips[PlayerInventory.EquipSlots.HEAD] = ["%s Helmet" % armor_type, 1]
	#PlayerInventory.equips[PlayerInventory.EquipSlots.NECK] = ["%s Cape" % cape, 1]
	#PlayerInventory.equips[PlayerInventory.EquipSlots.BODY] = ["%s Chest" % armor_type, 1]
	#PlayerInventory.equips[PlayerInventory.EquipSlots.ARMS] = ["%s Gloves" % armor_type, 1]
	#PlayerInventory.equips[PlayerInventory.EquipSlots.LEGS] = ["%s Pants" % armor_type, 1]
	#PlayerInventory.equips[PlayerInventory.EquipSlots.FEET] = ["%s Boots" % armor_type, 1]
	PlayerInventory.equips[PlayerInventory.EquipSlots.RHAND] = [weapon, 1]

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
		animated_sprite.play(attack_to_direction[action])
		var attacked: bool = false
		var right_hand = PlayerInventory.get_item_in_slot(PlayerInventory.EquipSlots.RHAND)
		if right_hand && right_hand.damage:
			spawn_projectile.emit(
				get_grid(),
				direction_vector[attack_to_direction[action]],
				right_hand.projectile_type,
				log_name,
				roll_attack(),
				right_hand.damage.roll()
			)
			attacked = true
		var left_hand = PlayerInventory.get_item_in_slot(PlayerInventory.EquipSlots.LHAND)
		if left_hand && left_hand.damage:
			spawn_projectile.emit(
				get_grid(),
				direction_vector[attack_to_direction[action]],
				left_hand.projectile_type,
				log_name,
				roll_attack(),
				left_hand.damage.roll()
			)
			attacked = true
		if not attacked:
			spawn_projectile.emit(get_grid(), direction_vector[attack_to_direction[action]], "bash")
			spawn_projectile.emit(
				get_grid(),
				direction_vector[attack_to_direction[action]],
				"bash",
				log_name,
				roll_attack(),
				unarmed_damage_dice.roll()
			)

func move(ui_action: String) -> void:
	frames_since_last_action = 0
	super(ui_action)
	player_position_updated.emit(position)
	$Footsteps.play()

func compute_attack_bonus() -> int:
	return base_attack_bonus + PlayerInventory.get_equipped_attack_bonus()
	

func compute_armor_class() -> int:
	return base_armor_class + PlayerInventory.get_equipped_armor_class()

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
			frames_since_last_action = 0
			input_received.emit(direction)
	for direction in attack_to_direction.keys():
		if event.is_action_pressed(direction):
			frames_since_last_action = 0
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

func _on_damage_sent(actor: String, attack_roll: int, amount: int) -> void:
	super(actor, attack_roll, amount)
	$Damage.play()
