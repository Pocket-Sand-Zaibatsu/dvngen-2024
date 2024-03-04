extends Node2D


func _ready() -> void:
	var main_menu_scene = preload("res://scenes/main-menu/main_menu.tscn")
	var main_menu = main_menu_scene.instantiate()
	add_child(main_menu)
