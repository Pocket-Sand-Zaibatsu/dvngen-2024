extends Node
class_name GameLogTransportClass

signal game_log_messaged(contents: String)

func _on_log_messaged(contents: String) -> void:
	# this is where we'd filter if we want to
	game_log_messaged.emit(contents)
