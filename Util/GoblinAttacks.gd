extends Node

var Max_Attackers = 5
var _attack_tokens = 0

var available_goodies = []
var targeted_goodies = {}

func _ready():
	randomize()
	available_goodies = get_tree().get_nodes_in_group("good")
	print("Goblin attacks loaded ", available_goodies.size(), " good guys")
	

func add_attacker(gob) -> CharacterBase:
	#assert(gob is GoblinBase)
	if _attack_tokens < Max_Attackers and not available_goodies.empty():
		gob.connect("token_consumed", self, "on_token_consumed")	
		_attack_tokens += 1
		var targ = get_rand_target()
		if not targ: return null
		available_goodies.erase(targ)
		targeted_goodies[gob] = targ
		return targ
	return null
	
func get_rand_target() -> CharacterBase:
	if available_goodies.empty(): return null
	var index = randi() % available_goodies.size()
	return available_goodies[index]

func on_token_consumed(gob):
	_attack_tokens -= 1
	if not targeted_goodies.has(gob):
		return
	var targ_goodie = targeted_goodies[gob]
	if targ_goodie: available_goodies.append(targ_goodie)
	targeted_goodies.erase(gob)
	
func find_target(gob) -> CharacterBase:
	if targeted_goodies.has(gob):
		return targeted_goodies[gob]
	return null
