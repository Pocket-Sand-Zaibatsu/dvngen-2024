extends Area2D
class_name WorldObject

@export var tile_size = 16

func spawn(spawn_position: Vector2i) -> void:
	position = spawn_position * tile_size
	position += Vector2.ONE * tile_size / 2

func _on_body_entered(body):
	print("collided")
