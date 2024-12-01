extends Resource
class_name SaveData

## The currency for unlockables in the game.
var play_points : int
# TODO: Add achievements
var achivements
## The saved settings for the file.
var settings : Settings
## The current skin set for the player (Canny).
var current_pskin : int
## The current skin set for the enemy ghost (Uncanny).
var current_gskin : int

## All of the playthroughs made on the save file.
var pthrus : Array[PthruData]
