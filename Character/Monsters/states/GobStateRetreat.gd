extends GoblinState

class_name GoblinState_Retreat

const _DefRetreatLength = 2.5
var timer = 0.0

func update(delta : float,cur_target : CharacterBase, data : Dictionary, owner):
	timer -= delta
	var t : Vector2
	if not cur_target:
		t = owner.global_position + Vector2(randf(), randf())
		data.new_state = owner.state_idle
	else: cur_target.global_position
	data.motion = ((owner.global_position - t) as Vector2).normalized()
	if timer < 0.0:
		data.new_state = owner.state_idle
		data.motion = Vector2.ZERO

func on_state_enter(owner):
	timer = _DefRetreatLength
	if owner.state_data.has("retreat_time"):
		timer = owner.state_data.retreat_time
	
func on_state_exit(owner):
	owner.clear_target()
	
	
