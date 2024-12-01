extends Collectible

@export var ring : Collectible

var newPopup = preload("res://assetsNEW/scenes/objects/misc/score_popup.tscn")

func _ready():
	deactivate()
	modulate = ring.modulate
	body_entered.connect(collect)

func collect(body : Node2D):
	collect_sound.pitch_scale = 1.0 + (ring.coins_grabbed * 0.05)
	collect_sound.play()
	ring.coins_grabbed += 1
	var p := newPopup.instantiate()
	p.object = p
	add_child(p)
	p.scoreText.text = str(ring.coins_grabbed)
	p.popup()
	deactivate()

func activate():
	graphic.visible = true
	collision.set_deferred(&"disabled", false)

func deactivate():
	graphic.visible = false
	collision.set_deferred(&"disabled", true)
