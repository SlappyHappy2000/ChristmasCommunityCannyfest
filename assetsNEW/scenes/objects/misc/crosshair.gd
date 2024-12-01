extends Node2D
class_name Crosshair

var body_hue := 0.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	body_hue += 1/360.0
	if body_hue > 1.0:
		body_hue = 0/360.0
	$body.modulate = Color.from_hsv(body_hue, 1.0, 1.0, 1)

func _on_eyes_animation_finished() -> void:
	var animations = $eyes.sprite_frames.get_animation_names()
	$eyes.play(animations[randi() % animations.size()])
