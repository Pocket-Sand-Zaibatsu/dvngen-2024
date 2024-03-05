extends Area2D
class_name WorldObject

@export var tile_size = 16

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid)

func _on_body_entered(_body: Variant):
	pass
