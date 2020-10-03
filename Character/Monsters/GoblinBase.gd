extends CharacterBase

class_name GoblinBase

signal token_consumed(goodie)

export (float, 0.0, 32.0) var attack_range = 2.5
export (int, 0, 20) var damage = 1

enum State{
	Idle, Attack, Retreat
}

var state_idle = GoblinState_Idle.new()
var state_attack = GoblinState_Attack.new()
var state_retreat = GoblinState_Retreat.new()


var state : GoblinState
var cur_target : CharacterBase
var state_data : Dictionary = {}

func _ready():
	._ready()
	set_state(state_attack)
	.connect("on_death", self, "on_gob_die")
	.connect("on_hit", self, "on_gob_hit")

func _process(delta):
	if state:
		state.update(delta, cur_target, state_data, self)
		if state_data.has("motion"):
			self.move_intent = state_data.motion as Vector2
		if state_data.has("new_state"):
			self.set_state(state_data.new_state)
			state_data.clear()
	manage_state()


func manage_state():
	pass
	
func manage_target():
	if cur_target:
		pass
	else:
		var character = GoblinAttacks.find_target(self)
		if character:
			cur_target = character
		else:
			set_state(state_idle)

func clear_target():
	cur_target = null

func set_state(state):
	if self.state:
		self.state.on_state_exit(self)
	self.state = state
	if self.state:
		self.state.on_state_enter(self)

func on_gob_die():
	queue_free()
	
func on_gob_hit(dmg):
	pass
