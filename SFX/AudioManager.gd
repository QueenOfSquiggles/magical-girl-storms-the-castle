extends Node2D

onready var p_music = $Music
onready var p_dialogue = $dialogue
onready var sfx = $sfx

var music_position : float = 0.0
var priorities := {"music" : 0, "dialogue" : 0, "sfx" : [0,0,0]}

func play_music(track : AudioStream, priority : int = 0):
	if not track: return
	if p_music.playing:
		if priority > priorities.music:
			p_music.stop()
			p_music.stream = track
			p_music.play()
			priorities.music = priority
	else:
		p_music.stream = track
		p_music.play()
		priorities.music = priority
		

func play_sfx(track : AudioStream, priority : int = 0):
	if not track: return
	if track is AudioStreamOGGVorbis:
		(track as AudioStreamOGGVorbis).loop = false
	for i in range(sfx.get_children().size()):
		var p = sfx.get_child(i) as AudioStreamPlayer
		if p.playing:
			if priority > priorities.music:
				p.stop()
				p.stream = track
				p.play()
				priorities.sfx[i] = priority
				break
		else:
			p.stream = track
			p.play()
			priorities.sfx[i] = priority
			break
	
func play_dialogue(track : AudioStream, priority : int = 0):
	pass
	
func continue_all():
	continue_music()
	
func continue_music():
	p_music.play(music_position)

func stop_all():
	stop_dialogue()
	stop_music()
	stop_sfx()

func stop_music(save_pos : bool = false):
	if save_pos: music_position = p_music.get_playback_position()
	p_music.stop()
	
func stop_dialogue():
	p_dialogue.stop()
	
func stop_sfx():
	for p in sfx.get_children():
		(p as AudioStreamPlayer).stop()


func _on_Music_finished():
	music_position = 0.0
	priorities.music = 0
	p_music.stop()


func _on_dialogue_finished():
	priorities.dialogue = 0
	p_dialogue.stop()


func _on_sfx0_finished():
	priorities.sfx[0] = 0
	sfx.get_child(0).stop()

func _on_sfx1_finished():
	priorities.sfx[1] = 0
	sfx.get_child(1).stop()


func _on_sfx2_finished():
	priorities.sfx[2] = 0
	sfx.get_child(2).stop()
