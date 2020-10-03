extends CharacterBase

class_name NPCBase

export (float) var refresh_time := 0.75
export (float) var attack_rate := 1.5
export (int) var attack_damage := 1
export  (float) var attack_range := 16.0

const _MaxAcceptableDistance = 1.0

var _cur_target : Vector2
var _cur_pos_obj
var _can_attack := true

onready var refreshTimer = $timer
onready var attackTimer = $attack_timer


func _ready():
	._ready()
	refreshTimer.wait_time = refresh_time
	attackTimer.wait_time = attack_rate
	
func _process(_delta):
	._process(_delta)
	_update_attack()
	
func update_move_intent():
	if _cur_target:
		var dir = _cur_target - global_position
		if dir.length() > _MaxAcceptableDistance:
			move_intent = dir.normalized()
		else:
			move_intent = Vector2.ZERO
		if not refreshTimer.time_left > 0:
			refreshTimer.start()
	else:
		check_new_position()

func _update_attack():
	if _can_attack:
		try_attack_nearest()

func check_new_position():
	var mindist = 9999.0
	var ntarg = null
	if _cur_pos_obj:
		mindist = _cur_pos_obj.distance_from_player
		ntarg = _cur_pos_obj

	var points = get_tree().get_nodes_in_group("npc_pos")
	for i in points:
		var p = i
		if p.enabled and not p.claimed and p.distance_from_player < mindist:
			ntarg = p
			mindist = p.distance_from_player
	if ntarg:
		if _cur_pos_obj: _cur_pos_obj.claimed = false
		_cur_target = ntarg.global_position
		_cur_pos_obj = ntarg
		_cur_pos_obj.claimed = true

func _on_check_for_new_pos_timeout():
	check_new_position()
	
func try_attack_nearest():
	var gobs = get_tree().get_nodes_in_group("bad")
	var min_dist := attack_range # gobs outside of range are rejected
	var nearest : GoblinBase = null
	for g in gobs:
		var d = ((g.global_position - global_position)as Vector2).length()
		if d < min_dist:
			min_dist = d
			nearest = g
	if nearest:
		nearest.deal_damage(attack_damage)
		_can_attack = false
		attackTimer.start()

func _on_attack_timer_timeout():
	_can_attack = true
