extends Node
class_name SaveFile

var dir_path : PackedStringArray
var file_path : String
var all_props : Dictionary
var current_section := ""
var keys : Array
var make_default_entry : Callable

func _init(path : String, make_default : Callable):
	path = path.simplify_path()
	dir_path = path.rsplit("/", true, 1)
	file_path = path
	make_default_entry = make_default
	keys = make_default_entry.call().keys()
	
	var dir := DirAccess.open("user://")
	if dir.dir_exists(dir_path[0]):
		read()
	else:
		dir.make_dir(dir_path[0])

#Loads file into properties
func read():
	var conf := ConfigFile.new()
	conf.load(file_path)
	for section in conf.get_sections():
		for i in keys:
			all_props[current_section][i] = conf.get_value(section, i)

#Writes properties into the file, overwrites old file contents
func write():
	var conf := ConfigFile.new()
	for sections in all_props:
		for i in all_props[sections]:
			conf.set_value(current_section, i, all_props[current_section][i])
	conf.save(file_path)

func get_prop(prop : String):
	if !all_props.has(current_section):
		all_props[current_section] = make_default_entry.call()
	return all_props[current_section].get(prop)

func set_prop(prop : String, new_val):
	if !all_props.has(current_section):
		all_props[current_section] = make_default_entry.call()
	all_props[current_section][prop] = new_val

func get_sections():
	return all_props.keys()

func current():
	return all_props[current_section]

func delete_section(section_name):
	all_props.erase(section_name)

#Because Godot's duplicate function is kinda doo doo actually
func deep_copy(obj):
	pass
