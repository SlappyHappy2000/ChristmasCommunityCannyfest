extends Area2D

func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is Player:
			body.velocity = lerp(body.velocity, Vector2.ZERO, 0.15)
		elif body is Baddie:
			pass
