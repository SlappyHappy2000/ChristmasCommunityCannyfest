extends StaticBody2D
class_name Block

@export var graphic : Sprite2D
@export var collision : CollisionShape2D
@export var hit_sound : AudioStreamPlayer
@export var popup : ScorePopup
@export var death_FX : String

@export var score_value := 0

@export var dblock_score := false
@export var shader : ShaderMaterial

@export var level : Level

func _ready():
	if graphic != null:
		graphic.material = shader

func hit(player : Player):
	graphic.visible = false
	collision.set_deferred(&"disabled", true)
	hit_sound.play()
	if dblock_score:
		level.dblock_multiplier += 1
		popup.scoreText.text = str(score_value * level.dblock_multiplier)
		level.level_bonus += score_value * level.dblock_multiplier
	else:
		popup.scoreText.text = str(score_value)
		level.level_bonus += score_value
	popup.popup()
