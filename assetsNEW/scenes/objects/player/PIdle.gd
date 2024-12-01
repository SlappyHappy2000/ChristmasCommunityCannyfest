extends State

func enter(type : int = 0):
	player.sfxPickUp.play()
	player.hit_dir.visible = false
	if Input.is_action_pressed("Click"):
		player.sfxGrab.play()

func exit():
	pass

func update():
	if Input.is_action_just_pressed("Click"):
		player.click_pos = player.get_global_mouse_position()
		player.sfxGrab.play()
		
	if Input.is_action_pressed("Click"):
		player.hit_dir.visible = true
		player.hit_dir.points[1] = (player.click_pos - player.get_global_mouse_position()).limit_length(player.MAX_DRAG)
		if (player.hit_dir.points[1] - player.hit_dir.points[0]).length() < player.DRAG_CANCEL:
			player.hit_dir.default_color = Color.from_hsv(0, 1, 0.5, 1)
		else:
			var hue = ((player.hit_dir.points[1] - player.hit_dir.points[0]).length() - player.DRAG_CANCEL) / (player.MAX_DRAG - player.DRAG_CANCEL)
			player.hit_dir.default_color = Color.from_hsv(lerpf(player.HUE_WEAKEST, player.HUE_STRONGEST, hue), 0.68, 1, 0.5)
		
	if Input.is_action_just_released("Click"):
		player.hit_dir.visible = false
		player.velocity = player.DRAG_MULTIPLIER * (player.hit_dir.points[1] - player.hit_dir.points[0])
		if player.velocity.length() < player.DRAG_CANCEL * player.DRAG_MULTIPLIER:
			player.velocity = Vector2.ZERO
			player.sfxGrabCancel.play()
			return
		player.level.strokes += 1
		#if player.velocity.length() > 500:
			#player.tv_p.emit("Move")
		player.transition_to("PMoving")
		player.sfxLaunched.play()
		player.level.tv_thought.emit("Moving")
		return
