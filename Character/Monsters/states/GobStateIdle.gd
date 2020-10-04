extends GoblinState

class_name GoblinState_Idle


var timer = 0.0

func update(delta : float, cur_target : CharacterBase, data : Dictionary, owner):
	timer -= delta
	if timer < 0.0:
		data.new_state = owner.state_attack

func on_state_enter(owner):
	timer = rand_range(0.25, 1.5)
	owner.anim.play("Idle")
	
func on_state_exit(owner):
	owner.anim.play("Walk")
	
