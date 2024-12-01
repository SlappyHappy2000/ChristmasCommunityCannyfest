extends Node2D
class_name ThoughtDisplayer

#@onready var thoughts = $Thought as Sprite2D
#var next_thought = ""
#
#func _ready() -> void:
	#pass
#
#func _physics_process(delta: float) -> void:
	#pass
#
#func play_animation(anim : String):
	#next_thought = anim
	#if thoughts.animation.contains(next_thought):
		#next_thought = ""
		#return
	#thoughts.play("Static")
#
#func anim_finished():
	#if thoughts.animation == "Static":
		#if next_thought == "":
			##thoughts.play("Idle" + str(randi_range(thought_ranges["Idle"].x, thought_ranges["Idle"].y)))
			#pass
		#else:
			##thoughts.play(next_thought + str(randi_range(thought_ranges[next_thought].x, thought_ranges[next_thought].y)))
			#next_thought = ""
	#else:
		#thoughts.play("Static")
