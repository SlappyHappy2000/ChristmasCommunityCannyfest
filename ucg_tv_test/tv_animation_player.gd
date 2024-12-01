extends Sprite2D

## size of individual frames
const FRAME_SIZE := Vector2(109, 89)

## emitted when an animation finishes playing
signal animation_finished()

class TVAnimation:
	var path: String
	var fps: int
	var empty_frames: int
	var loops: int

## directory of texture files
@export_dir var textures_path: String
## csv file that lists animation info
@export_file("*.csv") var info_file: String
## TV static animation node
@export var tv_static: CanvasItem
## Minimum amount of time to show the TV static before playing animation
@export var tv_static_time: float

var animations: Dictionary = {}
var current_animation: TVAnimation = null
# whether an animation is currently loading
var loading: bool = false
# amount of time the animation has been loading
var load_time: float = 0.0
var tween: Tween = null

func _ready() -> void:
	load_animation_info(info_file)

func _process(delta: float) -> void:
	if loading:
		load_time += delta
		print(load_time)
		if load_time >= tv_static_time:
			var status = ResourceLoader.load_threaded_get_status(current_animation.path)
			if status == ResourceLoader.THREAD_LOAD_LOADED:
				_start_playback()

func play(anim_name: String) -> void:
	current_animation = animations.get(anim_name)
	if current_animation:
		ResourceLoader.load_threaded_request(current_animation.path)
		loading = true
		tv_static.visible = true
		load_time = 0.0

func _start_playback() -> void:
	# retrieve and set up texture
	texture = ResourceLoader.load_threaded_get(current_animation.path)
	hframes = texture.get_width() / FRAME_SIZE.x
	vframes = texture.get_height() / FRAME_SIZE.y
	
	# kill potentially existing tween, having two at once is no good
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	
	# calculate frame and timing information
	var total_frames = (hframes * vframes) - current_animation.empty_frames
	var loop_time = (1.0 / current_animation.fps) * total_frames
	frame = 0
	
	tv_static.visible = false
	loading = false
	
	for i in current_animation.loops:
		tween.tween_property(self, ^"frame", total_frames - 1, loop_time).from(0)
	tween.tween_callback(tv_static.show)
	tween.tween_callback(animation_finished.emit)

func load_animation_info(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	
	var line := file.get_csv_line()
	while not file.eof_reached():
		line = file.get_csv_line()
		if line.size() < 4:
			break
		
		var anim = TVAnimation.new()
		anim.path = textures_path + "/%s.png" % line[0]
		anim.fps = line[1]
		anim.empty_frames = line[2]
		anim.loops = line[3]
		
		animations[line[0]] = anim
