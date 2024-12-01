extends Control
class_name LevelSelectButton

var button = Button.new()
var textbox = Label.new()

var ID : int

func _init(data : LevelData, index : int, function : Callable, table_format : String):
	size = Vector2(288, 32)
	custom_minimum_size = size
	button.size = Vector2(48, 32)
	textbox.size = Vector2(240, 32)
	textbox.position = Vector2(48, 0)
	add_child(button)
	add_child(textbox)
	button.pressed.connect(function.bind(data))
	ID = index
	button.text = data.level_ID
	textbox.text = data.format(table_format)
