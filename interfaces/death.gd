extends Node2D

var death_stats: Array[String] = []

@onready var StatsContainer: VBoxContainer = get_node("CenterContainer/VBoxContainer/VBoxContainer")
@onready var label_theme: Theme = preload("res://assets/themes/menu_theme.tres")

func _ready():
	$CenterContainer/VBoxContainer/MainMenuButton.grab_focus()
	for stat in death_stats:
		var label = Label.new()
		print("Font: ", label_theme.default_font.get_font_name())
		label.text = stat
		label.set_theme(label_theme)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 32)
		StatsContainer.add_child(label)


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main-menu/main_menu.tscn")
