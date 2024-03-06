extends CanvasLayer
class_name Hud

const MAX_MESSAGES = 50

signal dev_tools_stat_update(stat_field: String, value: int)

@onready var HealthBar = get_node("HealthBar")
@onready var GameLog: RichTextLabel = get_node("GameLog")

var game_log_messages: Array[String] = []

func _set_up_dev_tools() -> void:
	$DevTools/Health/HBoxContainer/Max.dev_tools_stat_update.connect(Player._on_dev_tools_stat_update)
	$DevTools/Health/HBoxContainer2/Current.dev_tools_stat_update.connect(Player._on_dev_tools_stat_update)

func _ready():
	_set_up_dev_tools()
	Player.health_changed.connect(_player_health_changed)
	_player_health_changed()
	GameLogTransport.game_log_messaged.connect(_on_game_log_messaged)

func _pass_dev_tools_stat_updates(stat_field: String, value: int):
	print("HUD dev tools: ", stat_field, ":", value)
	dev_tools_stat_update.emit(stat_field, value)

func _player_health_changed() -> void:
	HealthBar.value = int(float(Player.current_health * 100) / float(Player.max_health))

func newline_join(input: Array[String]) -> String:
	var result = ""
	for line in input:
		result += "%s\n" % line
	return result.trim_suffix("\n")

func _on_game_log_messaged(contents: String) -> void:
	game_log_messages.append(contents)
	game_log_messages = game_log_messages.slice(0, MAX_MESSAGES)
	GameLog.clear()
	GameLog.add_text(newline_join(game_log_messages))
