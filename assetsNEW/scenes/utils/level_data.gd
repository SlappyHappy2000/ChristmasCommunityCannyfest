class_name LevelData

var level_path : String
var level_ID : String

var highscore : int = 0
var besttime : float = INF
var bestrank : int = 0

func update_data(other : LevelData):
	if other.highscore > highscore:
		highscore = other.highscore
	if other.besttime < besttime:
		besttime = other.besttime
	if other.bestrank > bestrank:
		bestrank = other.bestrank
	return self

func get_world():
	return level_ID.get_slice("-", 0)

func get_level():
	return level_ID.get_slice("-", 1)

func format(format_str : String):
	return format_str % [highscore, Utils.format_seconds(besttime), bestrank]

func duplicate(deep : bool):
	if deep:
		var new_data = LevelData.new()
		new_data.level_path = level_path
		new_data.level_ID = level_ID
		new_data.highscore = highscore
		new_data.besttime = besttime
		new_data.bestrank = bestrank
		return new_data
	else:
		return self
