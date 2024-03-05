@icon("res://assets/sprites/world/td_world_bones_a.png")
extends WorldObject
class_name Bones

func _ready():
	super()
	available_textures = [
		"res://assets/sprites/world/td_world_bones_a.png",
		"res://assets/sprites/world/td_world_bones_b.png",
		"res://assets/sprites/world/td_world_bones_d.png",
	]
	choose_and_set_random_texture()
