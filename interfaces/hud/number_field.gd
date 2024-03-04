extends LineEdit
class_name NumberEdit

var regex = RegEx.new()
var oldtext := "100"

@export var stat_field: String

signal dev_tools_stat_update(field: String, value: int)

func _ready():
	regex.compile("^[0-9]*$")
	text_changed.connect(_on_LineEdit_text_changed)

func _on_LineEdit_text_changed(new_text):
	if regex.search(new_text):
		oldtext = new_text
	else:
		text = oldtext
	set_caret_column(text.length())
	dev_tools_stat_update.emit(stat_field, get_value())

func get_value():
	return(int(text))
