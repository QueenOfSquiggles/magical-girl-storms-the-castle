extends CenterContainer

var level = "res://Level/Base_Level.tscn"
var options_menu = "res://menus/OptionsMenu.tscn"

func _ready():
	Config.load_data()

func switch_scene(scene : String):
	get_tree().change_scene(scene)
	

func _on_btnPlay_pressed():
	switch_scene(level)


func _on_btnOptions_pressed():
	switch_scene(options_menu)


func _on_btnOptionsQuit_pressed():
	get_tree().quit()
