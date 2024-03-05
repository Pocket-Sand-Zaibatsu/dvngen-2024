extends CanvasLayer

func _ready():
	$Camera2D.make_current()
	$ClassMusic.play()
	$HBoxContainer/FighterButton.grab_focus()


func _on_fighter_button_pressed():
	$HBoxContainer/FighterButton/FighterAudio.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/dungeon.tscn")


func _on_ranger_button_pressed():
	$HBoxContainer/RangerButton/RangerAudio.play()
	await get_tree().create_timer(1.0).timeout


func _on_wizard_button_pressed():
	$HBoxContainer/WizardButton/WizardAudio.play()
	await get_tree().create_timer(1.0).timeout
