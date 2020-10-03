extends CharacterBase

class_name Player



func update_move_intent():
	move_intent.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_intent.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
