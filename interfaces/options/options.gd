extends CanvasLayer

enum AudioBus {
	MAIN,
	MUSIC,
	SFX,
}


func _on_close_pressed():
	queue_free()

func toggle_bus_mute(bus: AudioBus) -> void:
	AudioServer.set_bus_mute(bus, not AudioServer.is_bus_mute(bus))

func _on_main_check_toggled(toggled_on):
	toggle_bus_mute(AudioBus.MAIN)

func _on_music_check_toggled(toggled_on):
	toggle_bus_mute(AudioBus.MUSIC)

func _on_sfx_check_toggled(toggled_on):
	toggle_bus_mute(AudioBus.SFX)

func change_bus_volume(bus: AudioBus, value: float) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))

func _on_main_slider_value_changed(value):
	change_bus_volume(AudioBus.MAIN, value)


func _on_music_slider_value_changed(value):
	change_bus_volume(AudioBus.MUSIC, value)


func _on_sfx_slider_value_changed(value):
	change_bus_volume(AudioBus.SFX, value)
