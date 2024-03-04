extends WorldObject
class_name Stairs

signal generate_level

func _on_body_entered(body: Variant):
	generate_level.emit()
