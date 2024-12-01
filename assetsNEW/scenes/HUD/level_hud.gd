extends CanvasLayer
class_name LevelHUD

@export var level : Level

@onready var strokes := $Strokes as RichTextLabel
var strokes_modulate := 0.5
@onready var par := $Par/par as Label
@onready var time := $Timer/Time as Label
@onready var levelB := $LevelB as Label
@onready var lvlName := $Name as Label
@onready var lvlAuthor := $Author as Label
@onready var nameAnim := $NameAnim as AnimationPlayer
@onready var resultsAnim := $ResultsAnim as AnimationPlayer

@onready var tStrokes := $Results/Calculated/Strokes as Label
@onready var tStrokes2 := $Results/Calculated/Strokes2 as Label
@onready var tTime := $Results/Calculated/Time as Label
@onready var tTime2 := $Results/Calculated/Time2 as Label
@onready var tBonus := $Results/Calculated/Bonus as Label
@onready var fill := $Results/Fill as TextureProgressBar
@onready var rank := $Results/Calculated/Rank as AnimatedSprite2D
@onready var final := $Results/Final as Label

@onready var crosshair := $Crosshair as Crosshair

@onready var jumpscare := $Jumpscare as Sprite2D
@onready var soundJumpscare := $Sounds/jumpscare as AudioStreamPlayer

@onready var skipping := $skipping as AnimatedSprite2D

@onready var rank_sounds : Array[AudioStreamPlayer] = [
	$Sounds/uncanny_rank as AudioStreamPlayer, # uncanny
	$Sounds/atrocious_rank as AudioStreamPlayer, # atrocious
	$Sounds/stinky_rank as AudioStreamPlayer, # stinky
	$Sounds/ok_rank as AudioStreamPlayer, # ok
	$Sounds/swag_rank as AudioStreamPlayer, # swag
	$Sounds/peak_rank as AudioStreamPlayer, # peak
]

var scoreFill := 0

func _ready():
	rank.visible = false
	jumpscare.visible = false
	crosshair.visible = false
	final.text = tr("GAME_ResultFinal").format({"score" : str(scoreFill)})

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Click"):
		#crosshair.global_position = level.get_global_mouse_position() * (level.bounds / 256) + Vector2(384 + 128, 256)
		crosshair.global_position = level.get_global_mouse_position() * level.camera.zoom + Vector2(384 + 128, 256)
		crosshair.visible = true
	if Input.is_action_just_released("Click"):
		crosshair.visible = false
	
	if Input.is_action_pressed(&"Skip") and level.level_active:
		skipping.play("default")
		skipping.visible = true
	if Input.is_action_just_released(&"Skip"):
		skipping.visible = false
		skipping.stop()

func show_rank():
	final.text = tr("GAME_ResultFinal").format({"score" : str(level.final_score)})
	fill.value = level.final_score
	# I mean when is it never gonna be true without crashing somewhere else haha
	if true:
		var rank_calc := 0
		for i in range(Level.Ranks.RANK_COUNT - 1, -1, -1):
			if level.final_score > level.rank_reqs[i]:
				rank_calc = i
				break
		rank.play(str(rank_calc))
		rank_sounds[rank_calc].play()
	else:
		rank.play("_")
		get_node("Sounds/_").play()
	rank.visible = true

func fill_call(dur : float):
	fill_bar(0, level.final_score, dur)

func fill_bar(start : int, end : int, duration : float):
	var t : float
	var start_time := Time.get_ticks_msec()
	while t <= 1.0:
		var current_time := Time.get_ticks_msec()
		t = (current_time - start_time) / (duration * 1000.0)
		t = (1 - pow(2, -8 * t)) / (1 - pow(2, -8))
		if t >= 1.0:
			scoreFill = end
		else:
			scoreFill = (end * t) + (start * (1 - t))
		final.text = tr("GAME_ResultFinal").format({"score" : str(scoreFill)})
		fill.value = scoreFill
		await get_tree().create_timer(get_physics_process_delta_time()).timeout

func _on_results_anim_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"ResultsSlideDown":
			resultsAnim.play("ResultsAppear")
		"ResultsAppear":
			show_rank()
		_:
			pass

func death(type : String):
	jumpscare.visible = true
	soundJumpscare.play()
