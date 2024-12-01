extends GameScene
class_name GameLoader

const LEVEL_PATH = "res://assetsNEW/scenes/game/levels/regular"

var progress := 0

var thread_worlds : Thread = Thread.new()
var thread_saveload : Thread = Thread.new()

func _ready() -> void:
	if ResourceLoader.exists("user://save"):
		on_overlay_return()
	else:
		overlay.emit(Master.GameScenes.SETTINGS_MENU, 1)

func _physics_process(delta: float) -> void:
	#print(progress)
	pass

## Calls the function to load each world
func load_worlds(DIR : String, worlds_to_load : PackedStringArray, destination : Array[World]):
	# size worlds array to fit all
	destination.resize(worlds_to_load.size())
	##TODO: USE WorkerThreadPool
	var dispatch_bound : Callable = func(index : int) : return dispatch_load_world(DIR, worlds_to_load, destination, index)
	var task_id : int = WorkerThreadPool.add_group_task(dispatch_bound, worlds_to_load.size())
	WorkerThreadPool.wait_for_group_task_completion(task_id)
	return call_deferred("load_complete")

func dispatch_load_world(DIR : String, worlds_to_load : PackedStringArray, destination : Array[World], index : int):
	print("loading world %s at index %s" % [worlds_to_load[index], index])
	#destination[index] = load_world(DIR, worlds_to_load[index])
	load_world(DIR, worlds_to_load[index], index)

##Initializes the world data.
##Loads all of the levels of the world into arrays, separating regular and bonus levels.
func load_world(DIR : String, W_ID : String, index : int, SCENE_EXT : String = ".tscn"):
	var new_world : World = World.new()
	new_world.world_ID = W_ID
	new_world.world_name = "GAME_World" + W_ID
	var dir_path := DIR + "/w" + W_ID
	var directory : DirAccess = DirAccess.open(dir_path)
	for file in directory.get_files():
		if file.ends_with(SCENE_EXT):
			var level := load(dir_path + "/" + file) as PackedScene
			var level_inst := level.instantiate() as Level
			var level_num := level_inst.ID.split("-")[1].to_int()
			var level_pos := level_num - 1
			print(level_inst.ID, ", ", level_pos)
			if level_pos >= new_world.regular_levels.size():
				for i in level_pos - new_world.regular_levels.size():
					new_world.regular_levels.append(null)
				new_world.regular_levels.append(level)
			else:
				new_world.regular_levels[level_pos] = level
			progress += 1
	#TODO: Make the system add bonus levels as well
	if index >= Master.game_data.worlds.size():
		for i in index - Master.game_data.worlds.size():
			Master.game_data.worlds.append(null)
		Master.game_data.worlds.append(new_world)
	else:
		Master.game_data.worlds[index] = new_world
	print("World " + W_ID + " OK")

func load_complete():
	print("we did it!")
	switch.emit(Master.GameScenes.TITLE)

func on_overlay_return(state : int = 0):
	$startup.play()
	thread_worlds.start(load_worlds.bind(LEVEL_PATH, ["1"], Master.game_data.worlds))
