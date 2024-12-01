extends Node2D
class_name GameScene

## Leave the current scene and all overlays, swapping to the new scene 
signal switch(going_to : Master.GameScenes, with_state : int)
## Adds another scene on top of this scene.
signal overlay(going_to : Master.GameScenes, with_state : int)
## Quit this scene when it is an overlay, and go back to the last scene.
## Does nothing when this scene is the current base scene.
signal back

signal play_music(song : Master.Music, pitch : float)

## The state of this scene.
## Used when it enters to define different behavior.
var state := 0

## Whether or not to pause the last overlayed scene, when this is overlayed.
@export var pause_last_scene := true
## Whether or not to hide the last overlayed scene, when this is overlayed.
@export var hide_last_scene := false

func on_overlay_return(state : int = 0):
	pass
