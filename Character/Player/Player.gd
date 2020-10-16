extends CharacterBase

class_name Player

enum Action {
	None, HealBasic, HealArea, HealChannel, ActivateUlt
}
var action_lock : bool = false
var cur_action = Action.None

export (int, 0, 50) var Mana := 50
export (float) var Mana_recharge := 0.75
var mana_recharge_leftover := 0.0

export (float) var Time_HealBasic = 0.25
export (float) var Time_HealArea = 0.75
export (float) var Time_HealChannel = 0.1
export (float) var Time_ActivateUlt = 1.0

export (int) var Cost_HealBasic := 5
export (int) var Cost_HealArea := 15
export (int) var Cost_HealChannel := 1
export (int) var Cost_ActivateUlt := 45

export (int) var Eff_HealBasic := 5
export (int) var Eff_HealArea := 3
export (int) var Eff_HealChannel := 1

export (int) var Range_HealArea := 64

export (AudioStream) var beam_sfx : AudioStream

var cur_mana : int

onready var mana_bar = $Control/ManaBar
onready var action_cooldown = $cooldown

onready var healbeam = $HealBeam
onready var healbeam_fade = $HealBeam/beam_fade_timer
onready var healbeam_heal_timer = $BeamTimer

onready var selection_chevron = $SelectionChevron

onready var anim = $Sprite

func _ready():
	._ready()
	cur_mana = Mana
	mana_bar.init(cur_mana, Mana)
	Util.player = self
	healbeam.hide()
	.connect("on_death", self, "player_game_over")
	healbeam_heal_timer.wait_time = Time_HealChannel * 2
	healbeam_heal_timer.connect("timeout", self, "on_beam_tick")
	
	
func _process(delta):
	._process(delta)
	update_action_intent(delta)

func update_move_intent():
	if cur_action == Action.None:
		move_intent.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		move_intent.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		if anim.animation == "Idle":
			anim.play("Walk")
	else:
		move_intent = Vector2.ZERO
		if anim.animation == "Walk":
			anim.play("Idle")


func update_action_intent(delta):
	if not action_lock:
		if Input.is_action_pressed("act_ult"):
			do_activate_ult(delta)
		elif Input.is_action_pressed("heal_channel"):
			do_channel_heal(delta)
		elif Input.is_action_pressed("heal_area"):
			do_area_heal(delta)
		elif Input.is_action_pressed("heal_basic"):
			do_basic_heal(delta)
		else:
			cur_action = Action.None
	var near = get_nearest_goodie().global_position
	healbeam.update_pos(global_position, near)
	selection_chevron.global_position = near
	if cur_action == Action.None and cur_mana < Mana:
		recharge(delta)

func recharge(delta):
	var inst_vel = Mana_recharge * (1.0 - (float(cur_mana)/float(Mana))) + Mana_recharge
	var amnt = mana_recharge_leftover + inst_vel * delta 
	mana_recharge_leftover = amnt - floor(amnt);
	cur_mana += int(floor(amnt))
	if cur_mana > Mana: cur_mana = Mana
	mana_bar._on_update_health(cur_mana)
	

func do_basic_heal(delta):
	if lock_action(Time_HealBasic, Cost_HealBasic):
		cur_action = Action.HealBasic
		var g = get_nearest_goodie()
		g.deal_health(Eff_HealBasic)
		Juice.camera_shake(Time_HealBasic, 7.5, 7.0, 0.0)

func do_area_heal(delta):
	if lock_action(Time_HealArea, Cost_HealArea):
		cur_action = Action.HealArea
		var gs = get_all_goodies_in_range(Range_HealArea)
		for g in gs:
			(g as CharacterBase).deal_health(Eff_HealArea)
		Juice.camera_shake(Time_HealArea, 10.0, 10.0, 1.0)
	
func do_channel_heal(delta):
	if lock_action(Time_HealChannel, Cost_HealChannel):
		if cur_action != Action.HealChannel:
			healbeam_heal_timer.start()
		cur_action = Action.HealChannel
		healbeam.show()
		healbeam_fade.start(Time_HealChannel+0.06)

func do_activate_ult(delta):
	if lock_action(Time_ActivateUlt, Cost_ActivateUlt):
		cur_action = Action.ActivateUlt
		print("activate ult ability todo")

func lock_action(time : float, cost : int) -> bool:
	if action_lock == false and spend_mana(cost):
		action_lock = true
		action_cooldown.wait_time = time
		action_cooldown.start()
		return true
	else:
		return false

func spend_mana(amnt : int) -> bool:
	if amnt <= cur_mana:
		cur_mana -= amnt
		mana_bar._on_update_health(cur_mana)
		return true
	return false	

func _on_cooldown_timeout():
	action_lock = false

func get_nearest_goodie() -> CharacterBase:
	var arr = get_goodies() as Array
	if arr.size() <= 0: return null
	var mindist = 99999.0
	var cur := arr[0] as CharacterBase
	for g in arr:
		if g == self: continue
		var diff : Vector2 = global_position - g.global_position
		if diff.length_squared() < mindist:
			mindist = diff.length_squared()
			cur = g
	return cur

func get_all_goodies_in_range(ran:float) -> Array:
	var in_arr = []
	var arr = get_goodies() as Array
	if arr.size() <= 0: return []
	var mindist = ran * ran
	var cur := arr[0] as CharacterBase
	for g in arr:
		var diff : Vector2 = global_position - g.global_position
		if diff.length_squared() < mindist:
			in_arr.append(g)
	return in_arr

func get_goodies()->Array:
	return get_tree().get_nodes_in_group("good")

func on_beam_tick():
	Juice.camera_shake(Time_HealChannel, 0.1, 1.5, 0.0)
	AudioManager.play_sfx(beam_sfx)
	var g = get_nearest_goodie()
	g.deal_health(Eff_HealBasic)
	print("Heal tick")
	if cur_action == Action.HealChannel:
		healbeam_heal_timer.start()


func _on_beam_fade_timer_timeout():
	healbeam.hide()
	healbeam_heal_timer.stop()
	

func player_game_over():
	get_tree().change_scene("res://menus/GameOver Screen.tscn")
	AudioManager.stop_all()
