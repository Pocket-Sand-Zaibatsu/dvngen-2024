extends Character
class_name Player

func _unhandled_input(event: InputEvent):
	if moving:
		return
	for direction in input_to_direction.keys():
		if event.is_action_pressed(direction):
			move(input_to_direction[direction])
			audio_player.play()
