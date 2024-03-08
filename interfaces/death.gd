extends CanvasLayer

var death_stats: Array[String] = []

@onready var StatsContainer: VBoxContainer = get_node("CenterContainer/VBoxContainer/VBoxContainer")
@onready var label_theme: Theme = preload("res://assets/themes/menu_theme.tres")
@onready var main_menu_scene = preload("res://scenes/main-menu/main_menu.tscn")

func _ready():
	$CenterContainer/VBoxContainer/MainMenuButton.grab_focus()
	if Player.you_won:
		$CenterContainer/VBoxContainer/Label.text = "YOU WON"
	for stat in death_stats:
		var label = Label.new()
		label.text = stat
		label.set_theme(label_theme)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 48)
		StatsContainer.add_child(label)


func _on_main_menu_button_pressed():
	SceneChanger.change_scene(SceneChanger.PossibleScene.MAIN_MENU)

func _on_v_box_container_tree_entered():
	death_stats.push_back("LEVEL: %d" % Player.level.level)
	death_stats.push_back("TOTAL XP: %d" % Player.level.current_experience)
	Player.position = Vector2(0, 0)
