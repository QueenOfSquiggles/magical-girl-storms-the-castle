extends KinematicBody2D

class_name CharacterBase

# how fast it moves
export (float, 10.0, 100.0, 2.0) var Speed := 10.0
# How much damage it can take
export (int, 0, 999)  var Health := 10
# How much incoming damage is absorbed
export (int, 0, 20) var Armour := 0

export (AudioStream) var sfx_damage : AudioStream
export (AudioStream) var sfx_attack : AudioStream
export (AudioStream) var sfx_footstep : AudioStream
export (AudioStream) var sfx_heal : AudioStream


var move_intent = Vector2.ZERO

const _VEL_DRAG := 0.2
var _velocity := Vector2.ZERO
var _target_health := 0.0
var _cur_health := Health

signal on_hit(dmg)
signal on_heal(hl)
signal on_death
signal on_full_health

enum AnimState {
	Idle, Walk, Attack, Damage, Healing
}

const _MIN_VEL_FOR_MOVEMENT = 1.0
var anim_state = AnimState.Idle

func _ready():
	_cur_health = Health

func _process(_delta):
	_process_anim()

func _physics_process(_delta):
	update_move_intent()
	var nv = move_intent * Speed
	_velocity = lerp(_velocity, nv, _VEL_DRAG)
	_velocity = move_and_slide(_velocity)
	

func _process_anim():
	if _velocity.length_squared() > _MIN_VEL_FOR_MOVEMENT and anim_state <= AnimState.Walk:
		anim_state = AnimState.Walk

func deal_damage(damage : int, pierce_armour : bool = false):
	assert(damage >= 0)
	if not pierce_armour: 
		damage -= Armour
		damage = max(0, damage)
	_cur_health -= damage
	Util.audio.play_sfx(sfx_damage, 0)
	emit_signal("on_hit", damage)
	if _cur_health <= 0:
		emit_signal("on_death")

func deal_health(heal : int):
	assert(heal >= 0)
	_cur_health += heal
	emit_signal("on_heal", heal)
	if _cur_health > Health:
		_cur_health = Health
		emit_signal("on_full_health")
	
func update_move_intent():
	pass

