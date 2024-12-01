extends State

var burst_buffer = 0

func enter(type : int = 0):
	burst_buffer = 0

func exit():
	pass

func update():
	if player.velocity.length() <= player.STOP_SPEED:
		player.velocity = Vector2.ZERO
		player.transition_to("PIdle")
	
	if player.velocity.length() == 0:
		return
	player.velocity = lerp(player.velocity, Vector2.ZERO, player.MAX_DRAG * pow(player.FRIC_COEFF / player.velocity.length(), player.FRIC_POW))
	
	#if player.global_vars.modifier_burst and burst_buffer > 0:
		#if Input.is_action_just_pressed("Click"):
			#player.click_pos = player.get_global_mouse_position()
			##player.get_node("Sounds").get_node("sfxGrab").play()
			#
		#if Input.is_action_pressed("Click"):
			#player.hit_dir.visible = true
			#player.hit_dir.points[1] = (player.click_pos - player.get_global_mouse_position()).limit_length(player.MAX_DRAG)
			#if (player.hit_dir.points[1] - player.hit_dir.points[0]).length() < player.DRAG_CANCEL:
				#player.hit_dir.default_color = Color.from_hsv(0, 1, 0.5, 1)
			#else:
				#var hue = ((player.hit_dir.points[1] - player.hit_dir.points[0]).length() - player.DRAG_CANCEL) / (player.MAX_DRAG - player.DRAG_CANCEL)
				#player.hit_dir.default_color = Color.from_hsv(lerpf(player.HUE_WEAKEST, player.HUE_STRONGEST, hue), 0.68, 1, 0.5)
			#
		#if Input.is_action_just_released("Click"):
			#player.hit_dir.visible = false
			#if (player.hit_dir.points[1] - player.hit_dir.points[0]).length() < player.DRAG_CANCEL:
				#player.sfxGrabCancel.play()
				#return
			#player.velocity = player.DRAG_MULTIPLIER * (player.hit_dir.points[1] - player.hit_dir.points[0])
			#player.level.strokes += 1
			#player.sfxBurstLaunched.play()
			##if player.velocity.length() > 500:
				##player.tv_p.emit("Move")
			#return
	#
	burst_buffer += 1
