extends Node2D

func _ready():
	if randi() % 2 == 0:
		$TextureRect.texture = load("res://assets/sprites/items/td_items_coins_gold.png")
	else:
		$TextureRect.texture = load("res://assets/sprites/items/td_items_key_gold.png")
