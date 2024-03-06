extends WorldObject
class_name Stairs

signal generate_level

func _on_body_entered(body: Variant):
	if is_body_player(body):
		generate_level.emit()
