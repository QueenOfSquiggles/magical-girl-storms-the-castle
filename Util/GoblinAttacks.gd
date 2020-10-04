extends Node

var Max_Attackers = 15
var _attack_tokens = 0

var available_goodies = []
var cur_attackers = []

func avaiable_tokens() -> bool:
	return _attack_tokens < Max_Attackers
	
func reload():
	randomize()
	calc_tokens(Config.difficulty)
	available_goodies = get_tree().get_nodes_in_group("good")
	print("Goblin attacks loaded ", available_goodies.size(), " good guys")
	debug_print()
	

func calc_tokens(diff):
	Max_Attackers = (diff+1) * Config.AttackTokensPerDiffLevel

func add_attacker(gob) -> CharacterBase:
	#assert(gob is GoblinBase)
	if _attack_tokens < Max_Attackers and not available_goodies.empty() and cur_attackers.size() < Max_Attackers:
		gob.connect("token_consumed", self, "on_token_consumed")
		_attack_tokens += 1
		cur_attackers.append(gob)
		print("token given")
		debug_print()
		return get_rand_target()
	return null
	
func get_rand_target() -> CharacterBase:
	if available_goodies.empty(): return null
	var index = randi() % available_goodies.size()
	return available_goodies[index]

func on_token_consumed(gob):
	_attack_tokens -= 1
	_attack_tokens = max(_attack_tokens, 0)
	cur_attackers.erase(gob)
	print("token consumed by ", gob.name)
	debug_print()
	

func debug_print():
	print("Max Tokens (",Max_Attackers,") : Current Tokens (",_attack_tokens , ") : Current Attackers (", cur_attackers.size(), ")")
