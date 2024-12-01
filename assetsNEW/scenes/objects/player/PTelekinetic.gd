extends State

var mouse_pos := Vector2.ZERO
var previous_mouse_pos := Vector2.ZERO

func enter(type : int = 0):
	Input.warp_mouse(Vector2((get_viewport().size.x / 2), (get_viewport().size.y / 2)))

func exit():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func update():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	mouse_pos += player.get_global_mouse_position() - Vector2(384, 256)
	var mouse_speed = mouse_pos - previous_mouse_pos
	player.velocity = lerp(player.velocity, (mouse_speed * 25), 0.01)
	previous_mouse_pos = mouse_pos
	Input.warp_mouse(Vector2((get_viewport().size.x / 2), (get_viewport().size.y / 2)))
	
	if Input.is_action_just_pressed("Click") and player.global_vars.modifier_burst:
		player.velocity = -player.velocity
		player.sfxBurstLaunched.play()
