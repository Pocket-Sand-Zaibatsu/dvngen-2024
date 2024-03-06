@icon("res://assets/sprites/world/td_world_door_stone_h_closed.png")
extends WorldObject
class_name EwDoor

func _on_body_entered(_body: Variant):
	sprite.texture = load("res://assets/sprites/world/td_world_door_stone_h_open.png")

func _on_body_exited(_body: Variant):
	sprite.texture = load("res://assets/sprites/world/td_world_door_stone_h_closed.png")
