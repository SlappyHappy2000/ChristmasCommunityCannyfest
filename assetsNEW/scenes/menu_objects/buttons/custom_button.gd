extends Button
class_name CustomButton

## Which scene the button goes to.
@export var GO_TO : Master.GameScenes
## If true, then it emits the "overlay" signal instead of the "switch" signal.
@export var does_overlay := false

@export var sprite : Sprite2D
@export var main_label : Label
@export var sub_label : Label

@export var icon_texture : Texture2D
@export var main_text : String
@export var sub_text : String
