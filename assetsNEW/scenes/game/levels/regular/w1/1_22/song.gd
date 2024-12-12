extends AnimatedSprite2D
@export var level : Level

func _on_animation_finished():
	level.death("")
