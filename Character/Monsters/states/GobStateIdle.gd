extends GoblinState

class_name GoblinState_Idle

const _MinIdleTime = 1.0
const _MaxIdleTime = 5.0

var timer = 0.0

func update(delta : float, cur_target : CharacterBase, data : Dictionary, owner):
	timer -= delta
	if timer < 0.0:
		data.new_state = owner.state_attack

func on_state_enter(owner):
	timer = rand_range(_MinIdleTime, _MaxIdleTime)
	
func on_state_exit(owner):
	pass
	
