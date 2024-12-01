extends CustomButton

func _ready():
	sprite.texture = icon_texture
	main_label.text = main_text
	sub_label.text = sub_text
