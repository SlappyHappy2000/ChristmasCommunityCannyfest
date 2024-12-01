extends Resource
## All of the data for one playthrough
class_name PthruData

## The name of the playthrough, for file saving purposes.
var pthru_name : String
## The name of the player, for saving the best stats of a playthrough.
## Should default to the file's default_player_name.
var player_name : String
## Which modifiers are set to be active for the playthrough.
var modifiers : Modifiers

var total_prisms : int = 0
var total_score : int = 0
var total_time : float = 0.0
var total_resets : int = 0

var level_datas : Array[PthruLevelData]
