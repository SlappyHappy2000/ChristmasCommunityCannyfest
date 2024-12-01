extends Node2D
class_name ScorePopup

const ASCENT_RATE = -1
const TRANS_RATE = -0.02

@export var object : Node2D
@onready var sprite : AnimatedSprite2D = $fx1
@onready var scoreText : Label = $Label

var death_FX := "NULL"

var active := false

func _ready():
	visible = false

func _physics_process(delta: float) -> void:
	if active:
		scoreText.position.y += ASCENT_RATE
		scoreText.modulate.a += TRANS_RATE
		if scoreText.modulate.a <= 0:
			finish()

func popup():
	visible = true
	active = true
	if scoreText.text == "0":
		scoreText.text = ""
	sprite.play(object.death_FX)

func finish():
	object.queue_free()
