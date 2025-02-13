extends CenterContainer

export (AudioStream) var music_bg : AudioStream

var level = "res://Level/Base_Level.tscn"
var options_menu = "res://menus/OptionsMenu.tscn"

onready var btnPlay =  $HSplitContainer/VSplitContainer/btnPlay

func _ready():
	Config.load_data()
	AudioManager.play_music(music_bg)
	btnPlay.grab_focus()

func switch_scene(scene : String):
	get_tree().change_scene(scene)
	AudioManager.stop_music()
	

func _on_btnPlay_pressed():
	switch_scene(level)


func _on_btnOptions_pressed():
	switch_scene(options_menu)


func _on_btnOptionsQuit_pressed():
	get_tree().quit()
