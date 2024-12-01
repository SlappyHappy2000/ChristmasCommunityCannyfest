extends State

func enter(type : int = 0):
	player.velocity = Vector2.ZERO
	player.hitbox.set_deferred(&"disabled", true)

func exit():
	pass

func update():
	pass
