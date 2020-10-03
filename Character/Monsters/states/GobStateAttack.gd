extends GoblinState

class_name GoblinState_Attack


func update(delta : float,cur_target : CharacterBase, data : Dictionary, owner):
	data.motion = Vector2.ZERO
	if not cur_target:
		owner.manage_target()
		return
	var dir = (cur_target.global_position - owner.global_position) as Vector2
	if dir.length() > owner.attack_range:
		data.motion = dir.normalized()
	else:
		cur_target.deal_damage(owner.damage)
		data.motion = Vector2.ZERO
		data.new_state = owner.state_retreat

func on_state_enter(owner):
	GoblinAttacks.add_attacker(owner)
	#owner.manage_target()
	
	
func on_state_exit(owner):
	owner.emit_signal("token_consumed", owner)
	#owner.clear_target()
	pass
	
