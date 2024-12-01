extends Area2D
class_name Goal

@export var level : Level

func _on_body_entered(body: Node2D):
	if body is Player:
		if body.state == body.get_node("States/PWin"):
			return
		body.goal = self
		level.win()
