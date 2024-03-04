extends Character
class_name Player

signal player_ready
signal player_position_updated(position: Vector2i)

func _ready() -> void:
	get_parent().dev_tools_stat_update.connect(_process_dev_tools)
	player_ready.emit()

func _process_dev_tools(stat_field: String, value: int) -> void:
	print("Player dev tools: ", stat_field, ":", value)
	match stat_field:
		"max_health":
			max_health = value
			health_changed.emit()
		"current_health":
			current_health = value
			health_changed.emit()

func _unhandled_input(event: InputEvent):
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move(input_to_direction[direction])
			audio_player.play()
			player_position_updated.emit(position)
