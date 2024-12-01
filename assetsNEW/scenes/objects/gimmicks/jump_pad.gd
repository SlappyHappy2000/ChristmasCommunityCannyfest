extends Area2D
class_name JumpPad

@export var direction := 0.0

func _ready() -> void:
	direction *= PI / 180
	$arrow.rotation = direction + PI / 2

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.velocity.length() <= body.STOP_SPEED:
			body.velocity = Vector2(body.STOP_SPEED, 0).rotated(direction)
		body.velocity = Vector2(body.velocity.length(), 0).rotated(direction)
		body.transition_to("PJump")
		$jump.play()
