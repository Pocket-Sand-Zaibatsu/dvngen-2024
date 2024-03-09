extends CanvasLayer

@onready var class_select_scene = preload("res://scenes/class_select/class_Select.tscn")


func _ready():
	$Center/MainColumn/MenuVBox/StartButton.grab_focus()
	$TitleMusic.play()
	
	
func _on_start_button_pressed():
	$StartbuttonAudio.play()
	await get_tree().create_timer(1.0).timeout
	SceneChanger.change_scene(SceneChanger.PossibleScene.CLASS_SELECT)


func _on_quit_button_pressed():
	get_tree().quit()
