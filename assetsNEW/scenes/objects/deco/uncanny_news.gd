extends CanvasLayer

const NEWS = 16
const SCROLL_SPEED = 3.0
const TEXT_OFFSET = 256

var scrollboundary = 0.0

func _ready() -> void:
	news_reset()

func _physics_process(delta : float):
	$NewsText.position.x -= SCROLL_SPEED
	if $NewsText.position.x < scrollboundary:
		news_reset()

func news_reset():
	$NewsText.position.x = 800
	$NewsText.text = ""
	$NewsText.size.x = 0
	$NewsText.text = tr("GAME_News" + str(randi_range(1, NEWS)))
	await get_tree().create_timer(0.1).timeout
	scrollboundary = TEXT_OFFSET - $NewsText.size.x
