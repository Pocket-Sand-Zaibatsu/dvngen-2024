extends CanvasLayer

@onready var class_select_scene = preload("res://scenes/class_select/class_Select.tscn")

func _ready():
	$TitleMusic.play()
	$Center/MainColumn/MenuVBox/StartButton.grab_focus()
	
func _on_start_button_pressed():
	SceneChanger.change_scene(SceneChanger.PossibleScene.CLASS_SELECT)

func _on_quit_button_pressed():
	get_tree().quit()
