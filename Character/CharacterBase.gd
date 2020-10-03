extends KinematicBody2D

class_name CharacterBase

# how fast it moves
export (float, 10.0, 100.0, 2.0) var Speed := 10.0
# How much damage it can take
export (int, 0, 999)  var Health := 10
# How much incoming damage is absorbed
export (int, 0, 20) var Armour := 0

var move_intent = Vector2.ZERO

const _VEL_DRAG := 0.2
var _velocity := Vector2.ZERO
var _target_health := 0.0

enum AnimState {
	Idle, Walk, Attack, Damage, Healing
}

const _MIN_VEL_FOR_MOVEMENT = 1.0
var anim_state = AnimState.Idle

func _process(_delta):
	_process_anim()


func _physics_process(delta):
	update_move_intent()
	var nv = move_intent * Speed
	_velocity = lerp(_velocity, nv, _VEL_DRAG)
	_velocity = move_and_slide(_velocity)
	

func _process_anim():
	if _velocity.length_squared() > _MIN_VEL_FOR_MOVEMENT and anim_state <= AnimState.Walk:
		anim_state = AnimState.Walk
	
func update_move_intent():
	pass

