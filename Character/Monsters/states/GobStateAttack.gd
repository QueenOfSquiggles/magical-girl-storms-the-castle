extends GoblinState

class_name GoblinState_Attack


func update(delta : float,cur_target : CharacterBase, data : Dictionary, owner):
	data.motion = Vector2.ZERO
	if not cur_target:
		data.new_state = owner.state_idle
		return
	var dir = (cur_target.global_position - owner.global_position) as Vector2
	if dir.length() > owner.attack_range:
		if data.has("last_chance") && data.last_chance && dir.length() > owner.attack_range * 2:
			data.new_state = owner.state_retreat
		else:
			data.motion = dir.normalized()
		
	else:
		cur_target.deal_damage(owner.damage)
		data.motion = Vector2.ZERO
		data.new_state = owner.state_retreat

func on_state_enter(owner):
	owner.cur_target = GoblinAttacks.add_attacker(owner)
	
	
func on_state_exit(owner):
	owner.emit_signal("token_consumed", owner)
	pass

func on_hit(owner):
	owner.state_data.last_chance = true
	
