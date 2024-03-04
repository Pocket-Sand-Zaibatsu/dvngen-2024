extends CanvasLayer
class_name Hud

signal dev_tools_stat_update(stat_field: String, value: int)

@onready var player: Player
@onready var HealthBar = get_node("HealthBar")

func _set_up_dev_tools() -> void:
	$DevTools/Health/HBoxContainer/Max.dev_tools_stat_update.connect(_pass_dev_tools_stat_updates)
	$DevTools/Health/HBoxContainer2/Current.dev_tools_stat_update.connect(_pass_dev_tools_stat_updates)

func _ready():
	_set_up_dev_tools()
	player = get_parent().get_node("Player")
	player.health_changed.connect(_player_health_changed)

func _pass_dev_tools_stat_updates(stat_field: String, value: int):
	print("HUD dev tools: ", stat_field, ":", value)
	dev_tools_stat_update.emit(stat_field, value)

func _player_health_changed() -> void:
	print("HUD health changed")
	HealthBar.value = player.current_health * 100 / player.max_health
