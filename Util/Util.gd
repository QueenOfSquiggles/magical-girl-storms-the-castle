extends Node

var player

func _ready():
	var obj = get_tree().get_nodes_in_group("player")
	if obj.size() > 0:
		player = obj[0]

func play_sfx(track : AudioStream, priority : int = 0):
	AudioManager.play_sfx(track, priority)
