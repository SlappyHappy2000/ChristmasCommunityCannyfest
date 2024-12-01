extends GameScene
class_name PauseMenu

@onready var button_group = $CanvasLayer/PauseButtons

func _ready() -> void:
	$sound.play()
	for i in button_group.get_children() as Array[PauseButton]:
			if i.does_overlay:
				i.pressed.connect(overlay.emit.bind(i.GO_TO))
			elif i.does_back:
				i.pressed.connect(back.emit)
			else:
				i.pressed.connect(switch.emit.bind(i.GO_TO))
