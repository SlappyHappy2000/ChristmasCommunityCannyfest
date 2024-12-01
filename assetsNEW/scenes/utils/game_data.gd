extends Resource
class_name GameData

## A collection of data for each world in the game, including every level.
## Loaded during runtime.
var worlds : Array[World]

## Whatever playthrough is loaded for play.
## Set during runtime.
var current_pthru : PthruData
