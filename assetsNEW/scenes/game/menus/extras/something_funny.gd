extends Menu

const VID_DIR = "assetsNEW/videos"

var videos : PackedStringArray

func _ready():
	play_music.emit(music)
	var directory = DirAccess.open("res://" + VID_DIR)
	for file in directory.get_files():
		if file.ends_with(".ogv"):
			videos.append(file)
	$Vid.stream = load("res://%s/%s" % [VID_DIR, videos[randi_range(0, videos.size() - 1)]])
	$Vid.play()

func _on_vid_finished() -> void:
	switch.emit(Master.GameScenes.EXTRAS_MENU)
