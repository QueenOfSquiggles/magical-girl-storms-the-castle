extends Node

var _save_file = ConfigFile.new()

var _settings := {
	"game_data" :{		
		"difficulty" : 2,
		"music_vol" : 0.5,
		"sfx_vol" : 0.5
	}
}

const AttackTokensPerDiffLevel := 3

# proxy vars?
var difficulty setget set_diff, get_diff
var music_vol setget set_music_vol, get_music_vol
var sfx_vol setget set_sfx_vol, get_sfx_vol

const SAVE_PATH = "user://config.cfg"

func _ready():
	load_data()

func set_diff(value):
	_settings.game_data.difficulty = value
	GoblinAttacks.calc_tokens(_settings.game_data.difficulty)

func set_music_vol(value):
	_settings.game_data.music_vol = value
	refresh_audio_bus()

func set_sfx_vol(value):
	_settings.game_data.sfx_vol = value
	refresh_audio_bus()

func get_diff():
	return _settings.game_data.difficulty

func get_music_vol():
	return _settings.game_data.music_vol
	
func get_sfx_vol():
	return _settings.game_data.sfx_vol

func save_data():
	for section in _settings.keys():
		for key in _settings[section]:
			var value = _settings[section][key]
			_save_file.set_value(section, key, value)
	_save_file.save(SAVE_PATH)

func load_data():
	var err = _save_file.load(SAVE_PATH)
	if err != OK:
		print("Failed to load save data : Error %s" % err)
		return []
	for section in _settings.keys():
		for key in _settings[section]:
			var value = _save_file.get_value(section, key)
			_settings[section][key] = value
	refresh_audio_bus()

const lower_db_bound := -32.0
const upper_db_bound := 10.0
const diff = upper_db_bound - lower_db_bound

func refresh_audio_bus():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lower_db_bound + diff * _settings.game_data.music_vol)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), lower_db_bound + diff * _settings.game_data.sfx_vol)
