extends AnimatedSprite2D

@export var event : Collectible

var moving := false

func _ready() -> void:
	if event != null:
		event.body_entered.connect(get_moving)

func _physics_process(delta: float) -> void:
	if moving:
		print("hi")
		global_position.x -= 4

func get_moving(dummy):
	moving = true
