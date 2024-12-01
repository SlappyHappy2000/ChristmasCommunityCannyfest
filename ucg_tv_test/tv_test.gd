extends Node2D

@onready var tv_animations: Sprite2D = $TVAnimations

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		tv_animations.play("goopy")
