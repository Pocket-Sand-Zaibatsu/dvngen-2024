@icon("res://assets/sprites/world/td_world_door_stone_h_closed.png")
extends WorldObject
class_name EwDoor

signal player_entered

func _on_body_entered(body: Variant):
	sprite.texture = load("res://assets/sprites/world/td_world_door_stone_h_open.png")
	if is_body_player(body):
		player_entered.emit()

func _on_body_exited(_body: Variant):
	sprite.texture = load("res://assets/sprites/world/td_world_door_stone_h_closed.png")
