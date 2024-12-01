extends State

func enter(type : int = 0):
	player.hit_dir.visible = false
	player.velocity = Vector2.ZERO
	player.hitbox.set_deferred(&"disabled", true)

func exit():
	pass

func update():
	player.global_position = lerp(player.global_position, player.goal.global_position, 0.05)
	if player.sprite.scale > Vector2(0.001, 0.001):
		player.sprite.scale -= Vector2(0.001, 0.001)
