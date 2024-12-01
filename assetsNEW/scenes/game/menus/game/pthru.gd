extends GameScene
class_name PThru

var pthru_data : PthruData
var pthru_HUD : PthruHUD

var current_world : World
var current_level : Level

var world_position : int = 0

var game_active := false

enum LEVEL_TRANSITION {
	NORMAL = 0,
	RESET = 1,
	SKIP = 2
}

func _ready() -> void:
	#pthru_data = Master.game_data.current_pthru
	#TODO: Placeholder!! Change Later
	pthru_data = PthruData.new()
	pthru_HUD = get_node("PthruHUD")
	game_active = true
	print(Master.game_data.worlds)
	current_world = Master.game_data.worlds[1]
	level_switch(LEVEL_TRANSITION.NORMAL)

func _process(delta: float) -> void:
	if game_active:
		pthru_data.total_time += delta
		pthru_HUD.ttime_text.text = Utils.format_seconds_speedrun(pthru_data.total_time)

#func _physics_process(delta: float) -> void:
	#if game_active and Input.is_action_just_pressed(&"Pause"):
		#print("hi")
		#overlay.emit(Master.GameScenes.PAUSE_MENU)

func level_switch(trans_mode : LEVEL_TRANSITION):
	#Level Exit
	if current_level != null:
		match trans_mode:
			LEVEL_TRANSITION.RESET:
				pthru_data.total_resets += 1
				pthru_HUD.resets_text.text = str(pthru_data.total_resets)
			LEVEL_TRANSITION.SKIP:
				$Sounds/skip.play()
				world_position += 1
			LEVEL_TRANSITION.NORMAL:
				world_position += 1
		current_level.queue_free()
	
	#Next
	print(world_position)
	if world_position > current_world.regular_levels.size() - 1:
		match world_position:
			_:
				overlay.emit(Master.GameScenes.WORLD_RESULTS)
	else:
		current_level = current_world.regular_levels[world_position].instantiate() as Level
		current_level.progress.connect(level_switch)
		current_level.pause.connect(pause_game)
		play_music.emit(current_level.music)
		add_child(current_level)

func pause_game():
	play_music.emit(Master.Music.IGNORE, 0.75)
	overlay.emit(Master.GameScenes.PAUSE_MENU)

func on_overlay_return(state : int = 0):
	play_music.emit(Master.Music.IGNORE, 1.0)
	match state:
		_:
			pass
