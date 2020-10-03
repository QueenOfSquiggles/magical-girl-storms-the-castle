extends CharacterBase

class_name Player

func _ready():
	._ready()
	Util.player = self

func update_move_intent():
	move_intent.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_intent.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if Input.is_action_just_pressed("space_bar"):
		Util.play_sfx(sfx_damage, 0)
