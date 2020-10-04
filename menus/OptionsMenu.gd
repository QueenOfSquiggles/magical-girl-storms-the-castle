extends VBoxContainer

var main_menu = "res://menus/MainMenu.tscn"

export (AudioStream) var music_bg : AudioStream

const lower_db_bound := -32.0
const upper_db_bound := 10.0
const diff = upper_db_bound - lower_db_bound

onready var btn_difficulty = $selDifficulty
onready var slider_music = $slideVolumeMain
onready var slider_sfx = $slideSFXMain

func _ready():
	btn_difficulty.select(Config.difficulty)
	slider_music.value = Config.music_vol
	slider_sfx.value = Config.sfx_vol
	AudioManager.play_music(music_bg)
	
func _on_OptionButton_item_selected(index):
	Config.difficulty = index

func _on_slideVolumeMain_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lower_db_bound + diff*value)
	Config.music_vol = value

func _on_slideSFXMain_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), lower_db_bound + diff*value)
	Config.sfx_vol = value

func _on_btnMainMenu_pressed():
	Config.save_data()
	get_tree().change_scene(main_menu)
	AudioManager.stop_music()
	
func _input(event):
	if event.is_action_pressed("exit_to_menu"):
		_on_btnMainMenu_pressed()
	AudioManager.stop_music()

