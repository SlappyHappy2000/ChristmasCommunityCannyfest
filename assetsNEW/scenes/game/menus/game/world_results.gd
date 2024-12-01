extends Menu

func _ready():
	pass

func _on_ls_button_pressed() -> void:
	switch.emit(Master.GameScenes.GAME_MENU)

func _on_nw_button_pressed() -> void:
	back.emit()
