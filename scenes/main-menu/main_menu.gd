extends Control


func _ready():
	$TitleMusic.play()
	$VBoxContainer/StartButton.grab_focus()
	
func _on_start_button_pressed():
	
	get_tree().change_scene_to_file("res://scenes/class_select/class_Select.tscn")



func _on_quit_button_pressed():
	get_tree().quit()
