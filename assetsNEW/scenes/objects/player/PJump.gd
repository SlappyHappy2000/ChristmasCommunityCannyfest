extends State

var anim_timer := 0

func enter(type : int = 0):
	anim_timer = 0
	player.hit_dir.visible = false
	player.hitbox.set_deferred(&"disabled", true)

func exit():
	pass

func update():
	anim_timer += 1
	if anim_timer > player.JUMP_TIME:
		player.sprite.scale = Vector2(0.064, 0.064)
		player.hitbox.set_deferred(&"disabled", false)
		player.transition_to("PMoving")
	elif anim_timer > player.JUMP_TIME / 2:
		player.sprite.scale = lerp(player.sprite.scale, Vector2(0.15, 0.15), -0.13)
	else:
		player.sprite.scale = lerp(player.sprite.scale, Vector2(0.15, 0.15), 0.13)
