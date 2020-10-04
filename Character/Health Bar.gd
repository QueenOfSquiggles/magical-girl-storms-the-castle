extends Node2D

export (Color) var colour_high := Color.green
export (Color) var colour_medium := Color.orange
export (Color) var colour_low := Color.red

export (float, 0.0, 1.0) var medium_range := 0.5
export (float, 0.0, 1.0) var low_range := 0.2

onready var healthbar : TextureProgress = $bar_main
onready var damagebar : TextureProgress = $bar_dmg
onready var tween = $Tween

func init(health, max_health):
	healthbar.max_value = max_health
	damagebar.max_value = max_health
	healthbar.value = health
	damagebar.value = health
	_assign_colour(health)
	
	
func _on_update_health(health):
	# instant update
	healthbar.value = health
	# interpolated update
	_assign_colour(health)
	tween.interpolate_property(damagebar, "value", damagebar.value, health, 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func _assign_colour(hp):
	if hp < healthbar.max_value*low_range:
		healthbar.tint_progress = colour_low
	elif hp < healthbar.max_value*medium_range:
		healthbar.tint_progress = colour_medium
	else:
		healthbar.tint_progress = colour_high
		
func _on_update_max_health(max_health):
	healthbar.max_value = max_health
	damagebar.max_value = max_health
