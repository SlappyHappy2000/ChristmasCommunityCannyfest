extends Menu

enum FILE_ACTIONS {
	CREATE = 0,
	LOAD = 1,
	DELETE = 2
}

var acc_file : SaveFile
var pthru_file : SaveFile
@onready var action_buttons = $Actions.get_children()
@onready var confirm_buttons = $Confirmation.get_children()
@onready var status = $LoadStatus

var acc_name : String

var user_collection : Array[String]

func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	
	acc_file = parent.emit(GS.MAN_ID.NULL, "GET ACCOUNTS")
	pthru_file = parent.emit(GS.MAN_ID.NULL, "GET PTHRUS")
	
	for key in acc_file.get_sections():
		user_collection.append(key)
	
	user_collection.sort()
	
	for key in user_collection:
		var user = Button.new()
		user.alignment = HORIZONTAL_ALIGNMENT_LEFT
		user.custom_minimum_size = Vector2(256, 20)
		user.theme = load("res://assetsNEW/graphics/themes/button_file.tres")
		user.text = key
		user.pressed.connect(set_textbox.bind(user.text))
		button_group.add_child(user)
	
	for i in range(0, action_buttons.size()):
		action_buttons[i].pressed.connect(acc_action.bind(i))
	for i in confirm_buttons:
		i.pressed.connect(delete_data.bind(i.text))

func set_textbox(acc_name : String):
	if $UserTextbox.editable:
		$UserTextbox.text = acc_name

func acc_action(action : FILE_ACTIONS):
	acc_name = $UserTextbox.text
	if action == FILE_ACTIONS.CREATE:
		if acc_name == "":
			status.text = "User Creation Unsuccessful.\nNothing is typed in."
		elif acc_name in acc_file.all_props:
			status.text = "User Creation Unsuccessful.\nUser " + str(acc_name) + "already exists."
		else:
			enable(false)
			status.text = "User Creation Successful!\nRunning game as " + str(acc_name) + "..."
			start_game()
	elif action == FILE_ACTIONS.LOAD:
		if acc_name == "":
			status.text = "User Load Unsuccessful.\nNothing is typed in."
		elif !acc_name in acc_file.all_props:
			status.text = "User Load Unsuccessful.\nUser " + str(acc_name) + " does not exist."
		else:
			enable(false)
			status.text = "User Load Successful!\nRunning game as " + str(acc_name) + "..."
			start_game()
			process_data()
	else:
		if acc_name == "":
			status.text = "User Deletion Unsuccessful.\nNothing is typed in."
		elif !acc_name in acc_file.all_props:
			status.text = "User Deletion Unsuccessful.\nUser " + str(acc_name) + " does not exist."
		else:
			enable(false)
			status.text = "Are you sure you want to delete User " + str(acc_name) + "? This cannot be undone."
			$Confirmation.visible = true

func enable(enable : bool):
	for i in action_buttons:
		i.disabled = !enable
	$UserTextbox.editable = enable

func start_game():
	acc_file.current_section = acc_name
	await get_tree().create_timer(1.0).timeout
	parent.emit(GS.MAN_ID.MENU, "A-2")

func process_data():
	#Settings
	var loaded_settings = acc_file.current()["settings"]
	if loaded_settings.SETTINGS["FULLSCREEN"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	GS.sound_volume = linear_to_db(loaded_settings.SETTINGS["SOUND_VOL"])
	GS.music_player.volume_db = linear_to_db(loaded_settings.SETTINGS["MUSIC_VOL"])

func delete_data(confirm : String):
	if confirm == "Yes":
		$Confirmation.visible = false
		#Removes the playthroughs associated with the account
		for i in pthru_file.get_sections():
			if i.begins_with(acc_name + "_"):
				pthru_file.delete_section(i)
		#Removes the account
		acc_file.delete_section(acc_name)
		status.text = "User Deletion Successful.\n" + str(acc_name) + " has been deleted."
		enable(true)
	else:
		$Confirmation.visible = false
		status.text = "User Deletion Cancelled."
		enable(true)
