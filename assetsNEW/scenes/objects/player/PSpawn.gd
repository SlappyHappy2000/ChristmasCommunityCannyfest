extends State

func enter(type : int = 0):
	player.sprite.scale = Vector2(0.003, 0.003)
	player.sfxJoin.play()

func exit():
	pass

func update():
	player.sprite.scale += Vector2(0.001, 0.001)
	if player.sprite.scale >= Vector2(0.064, 0.064):
		player.sprite.scale = Vector2(0.064, 0.064)
		player.level.level_active = true
		#if player.global_vars.modifier_telekinetic:
			#player.transition_to("PTelekinetic")
		#else:
			#player.transition_to("PIdle")
		player.transition_to("PIdle")
		#player.spawned.emit()
		return
