class_name Utils

static func format_seconds(time : float) -> String:
	if is_finite(time):
		var minutes := time / 60
		var seconds := fmod(time, 60)
		return "%02d:%02d" % [minutes, seconds]
	else:
		return "--:--"

static func format_seconds_speedrun(time : float) -> String:
	if is_finite(time):
		var minutes := time / 60
		var hours := minutes / 60
		var seconds := fmod(time, 60)
		var msec := fmod(time, 1) * 100
		return "%02d:%02d:%02d.%02d" % [hours, minutes, seconds, msec]
	else:
		return "--:--:--.--"

#lerp with t^4
#func smoothMove(obj, start, end, duration : float):
	#var t : float
	#var start_time = Time.get_ticks_msec()
	#while t <= 1.0:
		#var current_time = Time.get_ticks_msec()
		#t = (current_time - start_time) / (duration * 1000)
		#if t > 1.0:
			#obj = end
			#return
		#obj = (end * t) + (start * (1 - t))
