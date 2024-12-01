extends Area2D
class_name Collectible

@export var collect_sound : AudioStreamPlayer
@export var graphic : AnimatedSprite2D
@export var collision : CollisionShape2D
@export var popup : ScorePopup
@export var death_FX : String

@export var score_value := 0

@export var does_speed := false
@export var set_speed := 0.0

@export var level : Level

func _ready():
	body_entered.connect(collect)

func collect(body : Node2D):
	level.tv_thought.emit("Money")
	graphic.visible = false
	collision.set_deferred(&"disabled", true)
	collect_sound.play()
	if does_speed:
		body.velocity = set_speed * body.velocity.normalized()
	popup.scoreText.text = str(score_value)
	level.level_bonus += score_value
	popup.popup()
