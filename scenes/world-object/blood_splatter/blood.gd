@icon("res://assets/sprites/world/td_world_blood_a.png")
extends WorldObject
class_name Blood

func _ready():
	super()
	available_textures = [
		"res://assets/sprites/world/td_world_blood_a.png",
		"res://assets/sprites/world/td_world_blood_b.png",
		"res://assets/sprites/world/td_world_blood_bone.png",
		"res://assets/sprites/world/td_world_blood_c.png",
		"res://assets/sprites/world/td_world_blood_d.png",
	]
	choose_and_set_random_texture()
