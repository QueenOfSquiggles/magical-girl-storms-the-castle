extends Node2D

const MaxLength = 2000

onready var begin = $start
onready var beam = $beam
onready var end = $end

onready var raycast : RayCast2D = $raycast

export (Vector2) var target_pos := Vector2(150, 50)

func _physics_process(_delta):
	raycast.cast_to = target_pos
	if raycast.is_colliding():
		end.global_position = raycast.get_collision_point()
	else:
		end.global_position = raycast.cast_to
	beam.rotation = raycast.cast_to.angle()
	beam.region_rect.end.x = end.position.length()
	
func set_target(targ : Vector2):
	target_pos = targ
	
func update_pos(pos_start : Vector2, pos_end : Vector2):
	self.global_position = pos_start
	set_target(pos_end - pos_start)

func hide():
	beam.hide()
	begin.hide()
	end.hide()

func show():
	beam.show()
	begin.show()
	end.show()
