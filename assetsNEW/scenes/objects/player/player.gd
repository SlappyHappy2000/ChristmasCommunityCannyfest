extends CharacterBody2D
class_name Player

@export var level : Level
#Only mess with these under specific circumstances
@export var state : Node
#Don't mess with these
@export var hit_dir : Line2D
@onready var sprite := $Sprite2D
@onready var hitbox := $CollisionShape2D

#Sound effect collection
@onready var sfxJoin := $Sounds/Join
@onready var sfxLaunched := $Sounds/Launched
@onready var sfxBurst := $Sounds/Burst
@onready var sfxWallBump := $Sounds/WallBump
@onready var sfxPush := $Sounds/Push
@onready var sfxGrab := $Sounds/Grab
@onready var sfxGrabCancel := $Sounds/GrabCancel
@onready var sfxPickUp := $Sounds/PickUp

#Constants for moving and stuff
const MAX_DRAG = 175
const DRAG_MULTIPLIER = 5
const DRAG_CANCEL = 20
const FRIC_COEFF = 0.04
const FRIC_POW = 1.06
const STOP_SPEED = 20
const JUMP_TIME = 26

const HUE_WEAKEST = 0.69
const HUE_STRONGEST = 0

#Game related variables
var click_pos : Vector2
var goal : Goal = null

# key variables
var has_keys : Array[Key] = []
var key_rotation_offset := Vector2(48.0, 0.0)
const KEY_ROTATE_SPEED = 2.5

var portal_sick := false
#Modifier related variables
var glass_health := 3

func transition_to(target_state_name: String, type: int = 0):
	assert(has_node("States/" + target_state_name))
	state.exit()
	state = get_node("States/" + target_state_name)
	state.enter(type)
	state.update()

func _ready():
	state.enter()
	#sprite.set_deferred("modulate", level.level_shade)
	sprite.modulate = level.level_shade

func _physics_process(delta):
	state.update()
	
	if Input.is_action_just_pressed("Click"):
		click_pos = get_global_mouse_position()
	
	var collision_info = move_and_collide(velocity * delta * scale)
	if collision_info:
		if (state == $States/PMoving or (state == $States/PTelekinetic and velocity.length() > 32)):
			if collision_info.get_collider() is Baddie:
				collision_info.get_collider().death()
				sfxWallBump.play()
			elif collision_info.get_collider() is Block:
				collision_info.get_collider().hit(self)
				sfxWallBump.play()
			else:
				sfxWallBump.play()
				#if global_vars.modifier_glass:
					#glass_health -= 1
					#if glass_health == 0:
						#pass
		else:
			if !sfxPush.is_playing():
				sfxPush.play()
		velocity = velocity.bounce(collision_info.get_normal())
	
	# key code
	
	key_rotation_offset = key_rotation_offset.rotated(delta * KEY_ROTATE_SPEED)
