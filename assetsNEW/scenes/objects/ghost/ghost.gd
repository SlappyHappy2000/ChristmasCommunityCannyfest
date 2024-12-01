extends CharacterBody2D
class_name Ghost

@export var target : Player
@export var level : Level

@onready var sprite := $Sprite2D

const ACCEL_NORMAL = 0.35
const LIMIT_NORMAL = 40.0
const ACCEL_HARD = 2.0
const LIMIT_HARD = 150.0

var acceleration := ACCEL_NORMAL
var speed_limit := LIMIT_NORMAL
var direction := Vector2.ZERO

signal caught

func _ready():
	#if global_vars.modifier_easymode:
		#queue_free()
		#return
	#if global_vars.modifier_hardmode:
		#acceleration = ACCEL_HARD
		#speed_limit = 150.0
	
	caught.connect(level.death)
	sprite.modulate = level.level_shade

func _physics_process(delta):
	if target != null:
		direction = (target.global_position - global_position).normalized()
	velocity += direction * acceleration
	velocity = velocity.limit_length(speed_limit)
	
	var collision_info = move_and_collide(velocity * delta * scale)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())

func _on_hitbox_body_entered(body: Node2D):
	caught.emit("")
