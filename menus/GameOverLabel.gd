extends Label

onready var display = $Display
onready var shake = $Shake
onready var time = $WaitTime
export (AudioStream) var music_fx : AudioStream
export (float) var amp = 10.0

var shake_dir = 1.0

const DispTime = 1.75 # based on audio clip
const ShakeTime = 0.125
const HoldTime = 1.837 # based on audio clip

func _ready():
	self.percent_visible = 0
	display.interpolate_property(self, "percent_visible", 0.0, 1.0, DispTime)
	shake.interpolate_property(self, "rect_rotation", 0.0, amp * shake_dir, ShakeTime)
	shake_dir *= -1
	time.wait_time = 0.5
	display.start()
	AudioManager.play_music(music_fx)

func _on_Shake_tween_all_completed():
	shake.interpolate_property(self, "rect_rotation", 0.0, amp * shake_dir, ShakeTime)
	shake_dir *= -1
	shake.start()

func _on_Display_tween_all_completed():
	time.start()
	shake.start()

func _on_WaitTime_timeout():
	AudioManager.stop_music()
	get_tree().change_scene("res://menus/MainMenu.tscn")
