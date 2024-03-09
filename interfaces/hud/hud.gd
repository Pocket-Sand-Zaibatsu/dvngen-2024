extends CanvasLayer
class_name Hud

const MAX_MESSAGES = 50

signal dev_tools_stat_update(stat_field: String, value: int)

@onready var HealthBar = get_node("HealthBar")
@onready var GameLog: RichTextLabel = get_node("GameLogControl").get_node("GameLog")
@onready var Minimap: TileMap = get_node("MinimapContainer/MinimapViewportContainer/MinimapViewport/Minimap")
@onready var MinimapCamera = get_node("MinimapContainer/MinimapViewportContainer/MinimapViewport/MinimapCamera")

var game_log_messages: Array[String] = []

func _set_up_dev_tools() -> void:
	$DevTools/Health/HBoxContainer/Max.dev_tools_stat_update.connect(Player._on_dev_tools_stat_update)
	$DevTools/Health/HBoxContainer2/Current.dev_tools_stat_update.connect(Player._on_dev_tools_stat_update)

func _ready():
	GameLog.clear()
	_set_up_dev_tools()
	Player.health_changed.connect(_player_health_changed)
	_player_health_changed()
	GameLogTransport.game_log_messaged.connect(_on_game_log_messaged)
	$PortraitBackground/Portrait.texture = load ("res://assets/sprites/scaled_portraits/%s.png" % Player.player_class.to_lower()) 
	get_player_stats()
	Player.level.exp_increased.connect(get_player_stats)
	Player.atk_bonus_chaged.connect(get_player_stats)
	$Inventory.initialize_inventory()
	$Inventory.initialize_equips()

func get_player_stats():
	$StatsBackground/ClassLabel.text = str(Player.player_class)
	$StatsBackground/HPStat.text = str(Player.max_health)
	$StatsBackground/DefStat.text = str(Player.compute_armor_class())
	$StatsBackground/ATKStat.text = str(Player.compute_attack_bonus())
	$StatsBackground/XPStat.text = str(Player.level.current_experience)


func _pass_dev_tools_stat_updates(stat_field: String, value: int):
	print("HUD dev tools: ", stat_field, ":", value)
	dev_tools_stat_update.emit(stat_field, value)

func _player_health_changed() -> void:
	HealthBar.value = int(float(Player.current_health * 100) / float(Player.max_health))
	$DevTools/Health/HBoxContainer/Max.text = str(Player.max_health)
	$DevTools/Health/HBoxContainer2/Current.text = str(Player.current_health)

func reverse_newline_join(input: Array[String]) -> String:
	var result = ""
	for line in input:
		result = "%s\n%s" % [line, result]
	return result.trim_suffix("\n")

func _on_game_log_messaged(contents: String) -> void:
	game_log_messages.push_front(contents)
	game_log_messages = game_log_messages.slice(0, MAX_MESSAGES)
	GameLog.clear()
	GameLog.add_text(reverse_newline_join(game_log_messages))


func _on_cell_painted(cell_grid: Vector2i, cell_type: LevelGrid.CELL_TYPE) -> void:
	if LevelGrid.CELL_TYPE.PLAYER == cell_type:
		MinimapCamera.position = LevelGrid.grid_to_position(cell_grid) / 4
	Minimap.set_cell(0, cell_grid, 0, Vector2i(cell_type, 0))


func _on_menu_2_pressed():
	Player.change_health(-9223372036854775808)
