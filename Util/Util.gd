extends Node

var player

onready var audio : AudioManager

func _ready():
	var obj = get_tree().get_nodes_in_group("player")
	if obj.size() > 0:
		player = obj[0]
	var am = get_tree().get_nodes_in_group("audio_manager")
	if am.size() > 0:
		audio = am[0] as AudioManager
	else:
		print("Failed to find audio manager in tree!")

func play_sfx(track : AudioStream, priority : int = 0):
	(audio as AudioManager).play_sfx(track, priority)
