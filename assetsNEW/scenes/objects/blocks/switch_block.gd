extends Block

func _ready():
	level.switched.connect(change_face)

func hit(player : Player):
	level.switchState = (level.switchState + 1) % level.switch_tiles.size()
	level.switch()
	hit_sound.play()

func change_face():
	$Sprite2D.frame = level.switchState
