extends Node2D

enum PossibleScene {
	MAIN_MENU,
	CLASS_SELECT,
	DUNGEON,
	DEATH,
}

var scenes = {
	PossibleScene.MAIN_MENU: {
		"scene": preload("res://scenes/main-menu/main_menu.tscn"),
	},
	PossibleScene.CLASS_SELECT: {
		"scene": preload("res://scenes/class_select/class_Select.tscn"),
	},
	PossibleScene.DUNGEON: {
		"scene": preload("res://scenes/dungeon.tscn"),
	},
	PossibleScene.DEATH: {
		"scene": preload("res://interfaces/death.tscn"),
	},
}

@onready var scene_holder: Node = Node2D.new()

func _ready():
	add_child(scene_holder)
	change_scene(PossibleScene.MAIN_MENU)

func change_scene(scene: PossibleScene) -> void:
	scene_holder.get_tree().change_scene_to_packed.bind(scenes.get(scene, PossibleScene.MAIN_MENU)["scene"]).call_deferred()
