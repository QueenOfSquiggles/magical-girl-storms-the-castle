extends YSort

export (AudioStream) var bg_music : AudioStream

func _ready():
	GoblinAttacks.reload()
	AudioManager.play_music(bg_music, 1)
	
func _input(event):
	if event.is_action_pressed("exit_to_menu"):
		get_tree().change_scene("res://menus/MainMenu.tscn")
		AudioManager.stop_all()
