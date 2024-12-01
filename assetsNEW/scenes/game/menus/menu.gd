extends GameScene
class_name Menu

var parent : Manager

@export var ID : String
@export var bg_color : Color
@export var music : Master.Music
@export var button_group : Control

func _ready():
	#RenderingServer.set_default_clear_color(bg_color)
	#GS.play_music(music)
	play_music.emit(music)
	if button_group != null:
		for i in button_group.get_children():
			if i.does_overlay:
				i.pressed.connect(overlay.emit.bind(i.GO_TO))
			else:
				i.pressed.connect(switch.emit.bind(i.GO_TO))
