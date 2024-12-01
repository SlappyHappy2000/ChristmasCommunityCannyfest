extends Collectible
class_name Key

var player : Player

var velocity := Vector2.ZERO
var accel := ACCEL_START
const ACCEL_START := -0.2
const ACCEL_RAMP := 0.01
const ACCEL_MAX := 5.0
const FRICTION := 0.35
const SPEED := 0.75

var follow_mode := false
var rotate_offset := Vector2(64.0, 0.0)

#func _ready() -> void:
	#super()
	#modulate = Color(randf(), randf(), randf())

func _ready():
	super()
	$ColorblindLabel.text = "#" + str(modulate.to_html(false))

func _physics_process(delta):
	#if follow_mode:
		#position = lerp(position, (player.position + rotate_offset), 0.1)
		#rotate_offset = rotate_offset.rotated(delta * 3)
	
	if is_instance_valid(player):
		var index := player.has_keys.find(self)
		if index == -1:
			remove()
			return
		velocity += (
			(player.global_position + 
			player.key_rotation_offset.rotated(2 * PI * index / player.has_keys.size())
			) - global_position) * accel
		velocity *= FRICTION
		accel = min(ACCEL_MAX, accel + ACCEL_RAMP)
		position += velocity * SPEED
	else:
		player = null
		accel = ACCEL_START

func collect(body : Node2D):
	var p := body as Player
	if true or !p.has_keys.has(modulate):
		# DO NOT REACTIVATE THIS CODE UNDER ANY CIRCUMSTANCES
		#var mistake := self.duplicate()
		#mistake.modulate = Color(randf(), randf(), randf())
		#get_parent().add_child(self.duplicate())
		
		player = p
		player.has_keys.append(self)
		collision.set_deferred(&"disabled", true)
		collect_sound.play()
		if does_speed:
			player.velocity = set_speed * player.velocity.normalized()
		popup.scoreText.text = str(score_value)
		level.level_bonus += score_value
		popup.popup()
		z_index += 1

func remove():
	queue_free()
