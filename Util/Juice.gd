extends Node

var dmg_slash = preload("res://FX/Damage/DamageSlashAnim.tscn")
var blood_spray = preload("res://FX/Damage/FX_Blood.tscn")
var heal_circle = preload("res://FX/Health/HealthCircle.tscn")
var heal_particle = preload("res://FX/Health/HealthParticle.tscn")

func camera_shake():
	pass

func freeze_frame(ms = 25):
	pass

func damage_slash(position : Vector2):
	var slash = dmg_slash.instance()
	slash.position = position
	add_child(slash)
	slash.set_as_toplevel(true)
	
func blood_spray(position : Vector2, amnt : int = 50):
	var bld = blood_spray.instance() as Particles2D
	bld.position = position
	bld.amount = amnt
	add_child(bld)
	bld.set_as_toplevel(true)
	
func heal_circle(position : Vector2):
	var ring = heal_circle.instance()
	ring.position = position
	add_child(ring)
	ring.set_as_toplevel(true)

func heal_particles(position : Vector2, amnt : int = 8, _range : float = 16.0):
	var hlth = heal_particle.instance() as Particles2D
	hlth.position = position
	hlth.amount = amnt
	if hlth.material is ParticlesMaterial:
		(hlth.material as ParticlesMaterial).emission_sphere_radius = _range
	add_child(hlth)
	hlth.set_as_toplevel(true)
