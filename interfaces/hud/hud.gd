extends CanvasLayer
class_name Hud

signal dev_tools_stat_update(stat_field: String, value: int)

@onready var HealthBar = get_node("HealthBar")

func _set_up_dev_tools() -> void:
	$DevTools/Health/HBoxContainer/Max.dev_tools_stat_update.connect(Player._on_dev_tools_stat_update)
	$DevTools/Health/HBoxContainer2/Current.dev_tools_stat_update.connect(Player._on_dev_tools_stat_update)

func _ready():
	_set_up_dev_tools()
	Player.health_changed.connect(_player_health_changed)
	_player_health_changed()

func _pass_dev_tools_stat_updates(stat_field: String, value: int):
	print("HUD dev tools: ", stat_field, ":", value)
	dev_tools_stat_update.emit(stat_field, value)

func _player_health_changed() -> void:
	HealthBar.value = int(float(Player.current_health * 100) / float(Player.max_health))
