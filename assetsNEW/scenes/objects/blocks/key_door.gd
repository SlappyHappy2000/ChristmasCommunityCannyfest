extends Block

@export var size := Vector2(32, 32)
@export var special_graphic : NinePatchRect
@export var color : Color = Color(1, 1, 1, 1)

func _ready():
	special_graphic.material = shader
	special_graphic.material.set_shader_parameter(&"MidShade", color)
	special_graphic.material.set_shader_parameter(&"ExtraShade", color)
	special_graphic.size = size
	special_graphic.position = Vector2(-0.5 * size.x, -0.5 * size.y)
	collision.shape = collision.shape.duplicate()
	collision.shape.size = size

func hit(player : Player):
	for key in player.has_keys:
		if key.modulate == color:
			player.has_keys.erase(key)
			special_graphic.visible = false
			collision.set_deferred(&"disabled", true)
			hit_sound.play()
			if dblock_score:
				level.dblock_multiplier += 1
				popup.scoreText.text = str(score_value * level.dblock_multiplier)
				level.level_bonus += score_value * level.dblock_multiplier
			else:
				popup.scoreText.text = str(score_value)
				level.level_bonus += score_value
			popup.popup()
			break
