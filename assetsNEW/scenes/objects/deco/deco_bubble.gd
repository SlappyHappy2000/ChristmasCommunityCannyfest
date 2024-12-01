extends Sprite2D

@export var start_down : bool

func _ready():
	$AnimationPlayer.play("bob" + str(int(start_down)))
