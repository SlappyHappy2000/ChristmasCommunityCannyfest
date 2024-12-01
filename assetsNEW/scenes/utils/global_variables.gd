extends Node
class_name Global

enum MAN_ID {
	NULL = -1,
	MAIN = 0,
	MENU = 1,
	LEVEL = 2,
	MINIGAME = 3
}

#Skins
var player_skins := []
var ghost_skins := []

const MUSIC : Dictionary = {
	"" = null,
	"DISCLAIMER" = preload("res://assetsNEW/music/musStartup.ogg"),
	"TITLE" = preload("res://assetsNEW/music/musTitle.ogg"),
	"SETTINGS" = preload("res://assetsNEW/music/musSelect.ogg"),
	"CREDITS" = preload("res://assetsNEW/music/musCredits.ogg"),
	"W0" = preload("res://assetsNEW/music/musW0.ogg"),
	"Clear0" = preload("res://assetsNEW/music/musClear0.ogg"),
	"From0" = preload("res://assetsNEW/music/musOnto1.ogg"),
	"W1" = preload("res://assetsNEW/music/musW1.ogg"),
	"Clear1" = preload("res://assetsNEW/music/musClear1.ogg"),
	"From1" = preload("res://assetsNEW/music/musOnto2.ogg"),
	"W2" = preload("res://assetsNEW/music/musW2.ogg"),
	"Clear2" = preload("res://assetsNEW/music/musClear2.ogg"),
	"From2" = preload("res://assetsNEW/music/musOnto3.ogg"),
	"W3" = preload("res://assetsNEW/music/musW3.ogg"),
	"Clear3" = preload("res://assetsNEW/music/musClear3.ogg")
}

var music_player : AudioStreamPlayer = null
var sound_volume := linear_to_db(1.0)

func format_seconds(time : float) -> String:
	if is_finite(time):
		var minutes := time / 60
		var seconds := fmod(time, 60)
		return "%02d:%02d" % [minutes, seconds]
	else:
		return "--:--"

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

func play_music(music : String, pitch : float = 1.0):
	if music_player.stream != MUSIC[music]:
		music_player.stop()
		music_player.stream = MUSIC[music]
		music_player.play()
	music_player.pitch_scale = pitch
