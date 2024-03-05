extends Character
class_name PlayerCharacter

signal player_ready
signal player_position_updated(position: Vector2i)

@onready var camera = get_node("PlayerCamera")

func _ready() -> void:
	player_ready.emit()

func _on_dev_tools_stat_update(stat_field: String, value: int) -> void:
	print("Player dev tools: ", stat_field, ":", value)
	match stat_field:
		"max_health":
			max_health = value
			health_changed.emit()
		"current_health":
			current_health = value
			health_changed.emit()

func spawn(spawn_grid: Vector2i) -> void:
	super(spawn_grid)
	camera.set_enabled(true)
	camera.make_current()

func _unhandled_input(event: InputEvent):
	if not visible:
		return
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move(input_to_direction[direction])
			audio_player.play()
			player_position_updated.emit(position)
