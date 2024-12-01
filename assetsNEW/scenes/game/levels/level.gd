extends Node2D
class_name Level

enum MODES {
	NORMAL,
	ENDLESS,
	MULTI,
	DEMO,
	MULTI_DEMO
}

signal tv_thought
signal pause
signal progress

##Level ID is a string!
@export var ID : String
@export var lvl_author : String
@export var music : Master.Music
##Determines how large the level is, from the center (0, 0).
@export var bounds := 256
@export var level_shade : Color = Color(1, 1, 1, 1)

@export var par : int
@export var on_time : float

enum Ranks {UNCANNY, ATROCIOUS, STINKY, OK, SWAG, PEAK, RANK_COUNT}
##Starts from worst rank and goes up. There is an entry for each rank.
@export var rank_reqs : Array[int] = [
	0, # uncanny
	1, # atrocious
	4500, # stinky
	5500, # ok
	6000, # swag
	7500, # peak
]

@export var HUD : LevelHUD
@export var camera : Camera2D
@export var player : Player
@export var uncannies : Node2D
@export var switch_tiles : Array[TileMapLayer]
@export var win_confetti : AnimatedSprite2D

var level_active := false
var victory := false
var lose := false

var skipcounter := 0

var dblock_multiplier := 0
var switchState := 0
signal switched

var strokes := 0:
	set(new_value):
		if strokes > par and HUD.strokes_modulate > 0:
			HUD.strokes_modulate = 0.5 - 0.05 * (strokes - par)
		HUD.strokes.text = "[rainbow freq=" + str(HUD.strokes_modulate) + " sat=" + str(HUD.strokes_modulate) + " val=1.0]" + tr("GAME_Strokes").format({"stroke" : str(new_value)})
		strokes = new_value
var time_elapsed := 0.0

var stroke_bonus := 0
var time_bonus := 0
var level_bonus := 0:
	set(new_value):
		HUD.levelB.text = tr("GAME_LevelBonus").format({"bonus" : str(new_value)})
		level_bonus = new_value

var final_score := 0

func _ready():
	#process_mode = PROCESS_MODE_PAUSABLE
	HUD.visible = true
	switch()
	#GS.play_music(music)
	camera.zoom = Vector2(256.0 / bounds, 256.0 / bounds)
	camera.position.x = -128 / camera.zoom.x
	var level_name = tr("GAME_Level" + ID)
	HUD.lvlName.text = ID + ": " + "" + level_name
	HUD.lvlAuthor.text = "Level by: " + lvl_author
	HUD.nameAnim.play("stagenameslide")
	HUD.strokes.text = "[rainbow freq=" + str(HUD.strokes_modulate) + " sat=" + str(HUD.strokes_modulate) + " val=1.0]" + tr("GAME_Strokes").format({"stroke" : str(strokes)})
	HUD.levelB.text = tr("GAME_LevelBonus").format({"bonus" : str(level_bonus)})
	win_confetti.visible = false
	HUD.par.text = str(par)

func _process(delta):
	if level_active:
		time_elapsed += delta
		HUD.time.text = GS.format_seconds(time_elapsed)
		if time_elapsed > on_time + 20:
			HUD.time.modulate = Color(1, 0, 0, 1)
		elif time_elapsed >= on_time:
			HUD.time.modulate = Color(1, 1, 0, 1)
		else:
			HUD.time.modulate = Color(0, 1, 0, 1)

func _physics_process(delta):
	if Input.is_action_just_pressed(&"Click"):
		if !level_active and victory:
			match HUD.resultsAnim.current_animation:
				"ResultsSlideDown":
					HUD.resultsAnim.play("ResultsAppear")
				"ResultsAppear":
					HUD.resultsAnim.play("ResultsRank")
				"":
					progress.emit(PThru.LEVEL_TRANSITION.NORMAL)
	
	if Input.is_action_just_pressed(&"Restart"):
		if level_active or victory or lose:
			progress.emit(PThru.LEVEL_TRANSITION.RESET)
	
	if Input.is_action_just_pressed(&"Click") and lose:
		progress.emit(PThru.LEVEL_TRANSITION.RESET)

	if level_active and Input.is_action_just_pressed(&"Pause"):
		pause.emit()
	
	if level_active and Input.is_action_pressed(&"Skip"):
		skipcounter += 1
		if skipcounter > 30:
			progress.emit(PThru.LEVEL_TRANSITION.SKIP)
	else:
		skipcounter = 0

func switch():
	for i in switch_tiles.size():
		switch_tiles[i].enabled = (i == switchState)
	switched.emit()

func death(type : String):
	level_active = false
	lose = true
	player.transition_to("PLose")
	HUD.death(type)
	tv_thought.emit("Death")

func export_data():
	var data = LevelData.new()
	data.level_ID = ID
	data.highscore = final_score
	data.besttime = time_elapsed
	#TODO: Add rank exporting
	return data

func win():
	level_active = false
	victory = true
	for i in uncannies.get_children():
		i.queue_free()
	player.transition_to("PWin")
	win_confetti.play()
	win_confetti.visible = true
	tv_thought.emit("Win")
	#Bonus calculate
	stroke_bonus = maxi(3000 + 300 * (par - strokes), 0)
	if strokes > 1:
		HUD.tStrokes.text = tr("GAME_Strokes").format({"stroke" : str(strokes)})
	else:
		HUD.tStrokes2.modulate = Color(0, 1, 1, 1)
		HUD.tStrokes.text = tr("GAME_ResultStrokes1") if (strokes == 1) else tr("GAME_ResultStrokes0")
	match (int(strokes > par) - int(strokes < par)):
		-1:
			HUD.tStrokes2.modulate = Color(0, 1, 0, 1)
			HUD.tStrokes2.text = str(par - strokes) + " Under Par!\nBonus: " + str(stroke_bonus)
		0:
			HUD.tStrokes2.modulate = Color(0, 1, 0, 1)
			HUD.tStrokes2.text = "Even With Par!\nBonus: " + str(stroke_bonus)
		1:
			HUD.tStrokes2.modulate = Color(1, 0.2, 0, 1)
			HUD.tStrokes2.text = str(strokes - par) + " Over Par...\nBonus: " + str(stroke_bonus)
	
	print(time_elapsed)
	time_bonus = maxi(2500 - 100 * (time_elapsed - on_time), 0)
	HUD.tTime.text = tr("GAME_Time").format({"time" : GS.format_seconds(time_elapsed)})
	if time_elapsed >= on_time:
		var tardy := int(time_elapsed - on_time)
		if tardy < 1 :
			##TODO: Should be yellow instead of red
			HUD.tTime2.modulate = Color(1, 0.2, 0, 1)
			HUD.tTime2.text ="Just Barely Late...\nBonus: " + str(time_bonus)
		else:
			HUD.tTime2.modulate = Color(1, 0.2, 0, 1)
			HUD.tTime2.text = str(tardy) + " Seconds Late...\nBonus: " + str(time_bonus)
	else:
		HUD.tTime2.modulate = Color(0, 1, 0, 1)
		HUD.tTime2.text = "On Time!\nBonus: " + str(time_bonus)
	
	HUD.tBonus.text = tr("GAME_LevelBonus").format({"bonus" : str(level_bonus)})
	final_score = stroke_bonus + time_bonus + level_bonus
	HUD.fill.max_value = rank_reqs[Ranks.PEAK]
	# HUD.fill.min_value = 0
	
	
	#Play animation
	HUD.resultsAnim.play("ResultsSlideDown")
