extends CharacterBody2D
class_name Baddie

signal on_death

const DESPAWN_RADIUS := 128
var dead := false

@export var death_sound : AudioStreamPlayer
@export var death_sound_pitch : Vector2
@export var graphic : AnimatedSprite2D
@export var collision : CollisionShape2D
@export var popup : ScorePopup
@export var death_FX : String

@export var direction := Vector2.ZERO
@export var speed : int
@export var score_value := 0
@export var rotate : float

@export var level : Level

##Chases the player if set to true
@export var chaser := false
##Only used if a chaser
@export var chase_accel := 4.0
##Only used if a chaser
@export var chase_limit := 200.0
##Only used if a chaser
@export var target : Player

func _ready():
	graphic.rotation_degrees = rotate
	
	if !chaser:
		velocity = speed * direction.normalized()

func _physics_process(delta):
	if max(abs(global_position.x), abs(global_position.y)) > (level.bounds + DESPAWN_RADIUS):
		queue_free()
	
	if chaser and !dead:
		if target != null:
			direction = (target.global_position - global_position).normalized()
		velocity += direction * chase_accel
		velocity = velocity.limit_length(chase_limit)
	
	var collision_info = move_and_collide(velocity * delta * scale)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())

func death():
	dead = true
	on_death.emit()
	graphic.visible = false
	velocity = Vector2.ZERO
	collision.disabled = true
	death_sound.pitch_scale = randf_range(death_sound_pitch.x, death_sound_pitch.y)
	death_sound.play()
	popup.scoreText.text = str(score_value)
	level.level_bonus += score_value
	popup.popup()
	
