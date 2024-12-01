extends Area2D
class_name FakeButton

@export var parent : Node2D
#@export var manager : GS.MAN_ID
#@export var ID : String
@export var GO_TO : Master.GameScenes
@export var overlay_back := false

var mouse_on := false

func _physics_process(delta):
	if Input.is_action_just_pressed("Click"):
		if mouse_on:
			#parent.parent.emit(manager, ID)
			if overlay_back:
				parent.back.emit()
			else:
				parent.switch.emit(GO_TO)

func _on_mouse_entered() -> void:
	mouse_on = true

func _on_mouse_exited() -> void:
	mouse_on = false
