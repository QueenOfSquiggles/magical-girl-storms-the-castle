extends Node2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amp = 0

var cam : Camera2D

onready var shake = $ShakeTween
onready var freq = $Frequencey
onready var duration = $Duration

var priority = 0

func _ready():
	reload()
	
func reload():
	print("Screenshake node searching for camera")
	var cs = get_tree().get_nodes_in_group("camera")
	if cs.size() > 0:
		cam = cs[0] as Camera2D
		print("Screenshake node has found the camera")

func start(duration := 0.2, frequency := 15.0, amplitude:=16.0, priority := 0):
	if not cam:
		reload()
	if priority >= self.priority:
		self.priority = priority
		amp = amplitude
		freq.wait_time = 1.0 / float(frequency)
		self.duration.wait_time = duration
		self.duration.start()
		freq.start()
		new_shake()


func _reset():
	if not cam: return
	shake.interpolate_property(cam, "offset", cam.offset, Vector2.ZERO, freq.wait_time, TRANS, EASE)
	shake.start()
	priority = 0


func new_shake():
	if not cam:
		reload()
		return
	var rand = Vector2()
	rand.x = rand_range(-amp, amp)
	rand.y = rand_range(-amp, amp)
	shake.interpolate_property(cam, "offset", cam.offset, rand, freq.wait_time, TRANS, EASE)
	shake.start()

func _on_Frequencey_timeout():
	new_shake()


func _on_Duration_timeout():
	_reset()
	freq.stop()


