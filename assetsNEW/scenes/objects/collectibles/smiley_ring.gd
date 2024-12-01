extends Collectible

@export var redoable := false
@export var c_parent : Node2D
@export var timer : Timer
@export var time_given : float
@export var timeSound : AudioStreamPlayer
@export var timeText : Label

var collection : Array[Collectible]

const PITCH_START := 0.5
const PITCH_END := 3.0

var coins_grabbed := 0

func _ready():
	super._ready()
	for i in c_parent.get_children():
		collection.push_back(i)
	timeText.visible = false
	timer.wait_time = time_given
	timer.timeout.connect(clear.bind(false))

func _physics_process(delta):
	if timeSound.playing:
		timeSound.pitch_scale = lerp(PITCH_END, PITCH_START, timer.time_left/timer.wait_time)
		timeText.text = str(ceil(timer.time_left))
		if coins_grabbed == collection.size():
			clear(true)

func collect(body : Node2D):
	graphic.modulate.a = 0.5
	collision.set_deferred(&"disabled", true)
	collect_sound.play()
	for i in collection:
		i.activate()
	timeSound.play()
	timeText.visible = true
	timer.start()

func clear(win : bool):
	coins_grabbed = 0
	timeSound.stop()
	for i in collection:
		i.deactivate()
	if win:
		timer.stop()
		$win.play()
		if score_value > 0:
			timeText.text = "Good!\n+" + str(score_value) + " pts."
		else:
			timeText.text = "Good!"
		level.level_bonus += score_value
		$win.finished.connect(remove)
	else:
		$lose.play()
		timeText.text = "Fail..."
		if redoable:
			$lose.finished.connect(reset)
		else:
			$lose.finished.connect(remove)

func reset():
	$lose.finished.disconnect(reset)
	graphic.modulate.a = 1.0
	collision.set_deferred(&"disabled", false)
	timeText.visible = false

func remove():
	queue_free()
