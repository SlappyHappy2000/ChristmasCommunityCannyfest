extends Collectible
class_name Spawner

@export var enemy_folder : Node2D

@export var enemy_to_spawn : PackedScene
@export var spawn_rate : int
@export var spawn_countdown : int
@export var max_baddies : int = 0

@export var b_direction := Vector2.ZERO
@export var b_speed : int
@export var b_score_value := 0
@export var b_rotate : float
@export var b_target : Player

var spawned_baddies : Array[Baddie] = []

func _physics_process(delta):
	spawn_countdown -= 1
	if spawn_countdown <= 0 and spawned_baddies.size() < max_baddies and graphic.visible:
		var c := enemy_to_spawn.instantiate() as Baddie
		c.level = level
		c.direction = b_direction
		c.speed = b_speed
		c.score_value = b_score_value
		c.rotate = b_rotate
		c.target = b_target
		c.global_position = global_position
		spawned_baddies.append(c)
		c.on_death.connect(spawned_baddies.erase.bind(c))
		enemy_folder.add_child(c)
		$Door.play("Open")
		spawn_countdown = spawn_rate
