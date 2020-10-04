extends Node

var Max_Attackers = 15
var _attack_tokens = 0

var available_goodies = []
	
func reload():
	randomize()
	calc_tokens(Config.difficulty)
	available_goodies = get_tree().get_nodes_in_group("good")
	print("Goblin attacks loaded ", available_goodies.size(), " good guys")
	

func calc_tokens(diff):
	Max_Attackers = (diff+1) * Config.AttackTokensPerDiffLevel

func add_attacker(gob) -> CharacterBase:
	#assert(gob is GoblinBase)
	if _attack_tokens < Max_Attackers and not available_goodies.empty():
		gob.connect("token_consumed", self, "on_token_consumed")	
		_attack_tokens += 1
		print("token given, ", (Max_Attackers-_attack_tokens), " tokens left")
		return get_rand_target()
	return null
	
func get_rand_target() -> CharacterBase:
	if available_goodies.empty(): return null
	var index = randi() % available_goodies.size()
	return available_goodies[index]

func on_token_consumed(gob):
	_attack_tokens -= 1
	print("token consumed by ", gob.name)
