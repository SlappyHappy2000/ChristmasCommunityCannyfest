extends Node2D
class_name Master

static var game_data : GameData = GameData.new()
static var save_data : SaveData = SaveData.new()

## The list of all packed scenes that can be switched to/overlayed.
## MUST match the enum order on the botton as well.
@export var packed_game_scenes : Array[PackedScene] = []
enum GameScenes {
	GAME_LOAD,#0
	TITLE,#1
	MAIN_MENU,#2
	GAME_MENU,#3
	PTHRU_SELECT,#4
	PTHRU_MENU,#5
	PTHRU_MANAGER,#6
	PAUSE_MENU,#7
	WORLD_RESULTS,#8
	SETTINGS_MENU,#9
	ACHIEVEMENTS_MENU,
	EXTRAS_MENU,
	CREDITS,
	SOMETHING_FUNNY,#13
	EXIT_GAME#14
}

@export var songs : Array[AudioStreamPlayer]
enum Music {
	NONE = -2,
	IGNORE = -1,
	TITLE = 0,
	MENU = 1,
	W0 = 2,
	W1 = 3,
	W2 = 4,
	W3 = 5,
	W4 = 6
}

## The bottom scene of the stack.
## Cannot quit from this scene.
var base_scene : GameScene
## The stack of overlays on top of the base scene.
var overlays : Array[GameScene] = []

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	switch_scene(GameScenes.GAME_LOAD)

## Switches from the current base scene to a new base scene.
## Quits all current overlays.
func switch_scene(to_scene : GameScenes, with_state : int = 0) -> void:
	if is_instance_valid(base_scene):
		base_scene.queue_free()
	for overlay in overlays:
		overlay.queue_free()
	overlays.clear()
	
	base_scene = packed_game_scenes[to_scene].instantiate() as GameScene
	base_scene.switch.connect(switch_scene)
	base_scene.overlay.connect(overlay_scene)
	base_scene.state = with_state
	base_scene.play_music.connect(play_music)
	add_child(base_scene)

## Overlays a new scene on top of this scene.
func overlay_scene(to_scene : GameScenes, with_state : int = 0) -> void:
	var overlay := packed_game_scenes[to_scene].instantiate() as GameScene
	if overlay.pause_last_scene:
		get_topmost_scene().process_mode = Node.PROCESS_MODE_DISABLED
	if overlay.hide_last_scene:
		get_topmost_scene().visible = false
	
	overlay.switch.connect(switch_scene)
	overlay.overlay.connect(overlay_scene)
	overlay.back.connect(back)
	overlay.state = with_state
	overlays.append(overlay)
	add_child(overlay)

## Quits the current overlay, returns to the old scene.
## Only call back when we have an overlay.
func back(with_state : int = 0) -> void:
	assert(overlays.size() > 0, "Called back with no overlays.")
	overlays[-1].queue_free()
	overlays.remove_at(overlays.size() - 1)
	
	get_topmost_scene().set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	get_topmost_scene().visible = true
	get_topmost_scene().on_overlay_return(with_state)

func get_topmost_scene() -> GameScene:
	return base_scene if overlays.is_empty() else overlays[-1]

func play_music(new_song_ID : Music, pitch : float = 1.0) -> void:
	# Change Music
	if new_song_ID != Master.Music.IGNORE:
		for song_ID in songs.size():
			var song := songs[song_ID]
			if song_ID != new_song_ID:
				song.playing = false
				song.pitch_scale = 1.0
				continue
			if !song.playing:
				song.playing = true
				song.pitch_scale = pitch
	else:
		print("ignore")
		for song_ID in songs.size():
			if songs[song_ID].is_playing:
				print("change pitch", pitch)
				songs[song_ID].pitch_scale = pitch

func format_seconds(time : float) -> String:
	if is_finite(time):
		var minutes := time / 60
		var seconds := fmod(time, 60)
		return "%02d:%02d" % [minutes, seconds]
	else:
		return "--:--"
