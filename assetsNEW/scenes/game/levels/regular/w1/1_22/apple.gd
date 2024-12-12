extends Collectible

@onready var slowjingle = $"/root/1-22/jingle"
@onready var badapplemp3 = $"/root/1-22/BADapple"

@onready var darkness = $"/root/1-22/darkness/bad apple bg"
@onready var badapple = $"/root/1-22/bad apple"

@onready var removestuff = [
	$"/root/1-22/tiles/main",
	$"/root/1-22/the grinch",
	$"/root/1-22/deco",
	$"/root/1-22/collectibles",
	$"/root/1-22/goal"
]

func collect(body: Node2D):
	darkness.visible = true
	for node in removestuff:
		node.queue_free()
	slowjingle.pitch_scale = 0.8
	slowjingle.play()
	
	badapplemp3.play()
	badapple.visible = true
	badapple.play("default")
