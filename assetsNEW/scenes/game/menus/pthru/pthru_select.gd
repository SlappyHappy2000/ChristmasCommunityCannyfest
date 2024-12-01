extends Menu

enum FILE_ACTIONS {
	CREATE = 0,
	LOAD = 1,
	DELETE = 2
}

var acc_file : SaveFile
var pthru_file : SaveFile
var pthru_collection : Array[String]
@onready var action_buttons = $Actions.get_children()
@onready var confirm_buttons = $Confirmation.get_children()
@onready var status = $LoadStatus

var pthru_name : String

func _ready():
	RenderingServer.set_default_clear_color(bg_color)
	GS.play_music(music)
	
	acc_file = parent.emit(GS.MAN_ID.NULL, "GET ACCOUNTS")
	pthru_file = parent.emit(GS.MAN_ID.NULL, "GET PTHRUS")
	
	for key in pthru_file.get_sections():
		pthru_collection.append(key)
	
	pthru_collection.sort()
	
	for key in pthru_collection:
		if key.begins_with(acc_file.current_section + "_"):
			var user = Button.new()
			user.alignment = HORIZONTAL_ALIGNMENT_LEFT
			user.custom_minimum_size = Vector2(256, 20)
			#user.theme = load("res://assetsNEW/graphics/themes/button_file.tres")
			user.text = key.trim_prefix(acc_file.current_section + "_")
			user.pressed.connect(set_textbox.bind(user.text))
			button_group.add_child(user)
	
	for i in range(0, action_buttons.size()):
		action_buttons[i].pressed.connect(acc_action.bind(i))
	for i in confirm_buttons:
		i.pressed.connect(delete_data.bind(i.text))

func set_textbox(pthru_name : String):
	if $UserTextbox.editable:
		$UserTextbox.text = pthru_name

func acc_action(action : FILE_ACTIONS):
	pthru_name = $UserTextbox.text
	var full_pthru = acc_file.current_section + "_" + pthru_name
	if action == FILE_ACTIONS.CREATE:
		if pthru_name == "":
			status.text = "Create what? There's nothing here!"
		elif full_pthru in pthru_file.all_props:
			status.text = "\"" + str(pthru_name) + "\" already exists. Get rid of it first if you wanna use this name."
		else:
			enable(false)
			status.text = "Created new playthrough \"" + str(pthru_name) + "\". Have fun!!"
			start_game()
	elif action == FILE_ACTIONS.LOAD:
		if pthru_name == "":
			status.text = "Load what? There's nothing here!"
		elif !full_pthru in pthru_file.all_props:
			status.text = "\"" + str(pthru_name) + "\" doesn't exist. It's fiction. You can't load it."
		else:
			enable(false)
			status.text = "Loaded playthrough \"" + str(pthru_name) + "\". Have fun!!"
			start_game()
	else:
		if pthru_name == "":
			status.text = "Delete what? There's nothing here!"
		elif !full_pthru in pthru_file.all_props:
			status.text = "\"" + str(pthru_name) + "\" doesn't exist. It's fiction. You can't delete it."
		else:
			enable(false)
			status.text = "Delete playthrough \"" + str(pthru_name) + "\"? You can't undo this!"
			$Confirmation.visible = true

func enable(enable : bool):
	for i in action_buttons:
		i.disabled = !enable
	$UserTextbox.editable = enable
	$FakeButton.visible = enable

func start_game():
	pthru_file.current_section = acc_file.current_section + "_" + pthru_name
	await get_tree().create_timer(1.0).timeout
	parent.emit(GS.MAN_ID.MENU, "B-5")

func delete_data(confirm : String):
	if confirm == "Yes":
		$Confirmation.visible = false
		#Removes the playthrough
		pthru_file.delete_section(acc_file.current_section + "_" + pthru_name)
		status.text = "Deletion completion.\nBye bye, \"" + str(pthru_name) + "\"..."
		enable(true)
	else:
		$Confirmation.visible = false
		status.text = "Delete cancelled."
		enable(true)
