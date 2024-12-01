extends CanvasLayer
class_name PthruHUD

@onready var resets_text = $Resets as Label
@onready var ttime_text = $TotalTime as Label

var next_thought = ""

var thought_ranges := {
	"Backrooms" = Vector2(1, 1),
	"Death" = Vector2(1, 30),
	"Idle" = Vector2(1, 29),
	"Money" = Vector2(1, 2),
	"Moving" = Vector2(1, 18),
	"Skull" = Vector2(1, 3),
	"Win" = Vector2(1, 15)
}

#func _ready():
	#pause_menu.visible = false
#
#@onready var thoughts = $ThoughtDisplayer/Thoughts
#
#func play_animation(anim : String):
	#next_thought = anim
	#if thoughts.animation.contains(next_thought):
		#next_thought = ""
		#return
	#thoughts.play("Static")
#
#func _on_thoughts_animation_finished():
	#if thoughts.animation == "Static":
		#if next_thought == "":
			#thoughts.play("Idle" + str(randi_range(thought_ranges["Idle"].x, thought_ranges["Idle"].y)))
		#else:
			#thoughts.play(next_thought + str(randi_range(thought_ranges[next_thought].x, thought_ranges[next_thought].y)))
			#next_thought = ""
	#else:
		#thoughts.play("Static")
