extends Menu

@onready var fullscreen = $CanvasLayer/Settings/FullscreenSwitch as CheckButton
@onready var sound_slider = $CanvasLayer/Settings/SoundSlider as HSlider
@onready var music_slider = $CanvasLayer/Settings/MusicSlider as HSlider
@onready var master_slider = $CanvasLayer/Settings/MasterSlider as HSlider
@onready var sound = $Sounds/sound as AudioStreamPlayer

var cur_set : Settings = Settings.new()

func _ready():
	super()
	if Master.save_data.settings != null:
		print("hello i am settings")
		cur_set = Master.save_data.settings
		fullscreen.button_pressed = cur_set.fullscreen
		master_slider.value = cur_set.master_volume * master_slider.max_value
		sound_slider.value = cur_set.sound_volume * sound_slider.max_value
		music_slider.value = cur_set.music_volume * music_slider.max_value
	match state:
		1:
			$CanvasLayer/Header.text = tr("MENU_SettingsFirst")
			$CanvasLayer/SaveSet.text = tr("MENU_SettingsSaveFirst")
			$CanvasLayer/FakeButton.queue_free()
		_:
			$CanvasLayer/Header.text = tr("MENU_Settings")
			$CanvasLayer/SaveSet.text = tr("MENU_SettingsSave")
	#cur_set = parent.emit(GS.MAN_ID.NULL, "GET ACCOUNTS").get_prop("settings").duplicate()
	
	#fullscreen.button_pressed = Master.game_data.settings.fullscreen
	#master_slider.value = Master.game_data.settings.master_volume
	#sound_slider.value = Master.game_data.settings.sound_volume
	#music_slider.value = Master.game_data.settings.music_volume

func _on_save_set_pressed():
	#TODO: EVERYTHING.
	#parent.emit(GS.MAN_ID.NULL, "GET ACCOUNTS").set_prop("settings", cur_set)
	Master.save_data.settings = cur_set
	print(Master.save_data.settings.music_volume)
	match state:
		1:
			back.emit()
		_:
			pass

func _on_fullscreen_switch_pressed() -> void:
	cur_set.fullscreen = fullscreen.button_pressed
	if cur_set.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	

func _on_sound_slider_value_changed(value: float) -> void:
	cur_set.sound_volume = value / sound_slider.max_value
	AudioServer.set_bus_volume_db(2, linear_to_db(cur_set.sound_volume))
	$CanvasLayer/SoundVolumeText.text = "Sound Volume: " + str(int(cur_set.sound_volume * 100)) + "%"

func _on_music_slider_value_changed(value: float) -> void:
	cur_set.music_volume = value / music_slider.max_value
	AudioServer.set_bus_volume_db(1, linear_to_db(cur_set.music_volume))
	$CanvasLayer/MusicVolumeText.text = "Music Volume: " + str(int(cur_set.music_volume * 100)) + "%"

func _on_master_slider_value_changed(value: float) -> void:
	cur_set.master_volume = value / master_slider.max_value
	AudioServer.set_bus_volume_db(0, linear_to_db(cur_set.master_volume))
	$CanvasLayer/MasterVolumeText.text = "Master Volume: " + str(int(cur_set.master_volume * 100)) + "%"
