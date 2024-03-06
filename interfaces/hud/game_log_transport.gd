extends Node
class_name GameLogTransportClass

signal game_log_messaged(contents: String)

func _on_log_messaged(contents: String) -> void:
	# this is where we'd filter if we want to
	if contents.ends_with("\n"):
		contents = contents.trim_suffix("\n")
	game_log_messaged.emit(contents)
