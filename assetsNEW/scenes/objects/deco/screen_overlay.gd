extends Polygon2D

var frame = true
var buffer = true

func _physics_process(delta: float) -> void:
	buffer = !buffer
	if buffer:
		frame = !frame
		if frame:
			texture = load("res://assetsNEW/graphics/stage/deco/W2/screen_overlay.png")
		else:
			texture = load("res://assetsNEW/graphics/stage/deco/W2/screen_overlay_2.png")
