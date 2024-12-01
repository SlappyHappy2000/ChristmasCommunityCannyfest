extends Button
class_name PauseButton

## Which scene the button goes to.
@export var GO_TO : Master.GameScenes
## If true, then it emits the "overlay" signal instead of the "switch" signal.
@export var does_overlay := false
## If true, then it emits the "back" signal instead of the "switch" signal.
## Should never be on at the same time as does_overlay.
@export var does_back := false
