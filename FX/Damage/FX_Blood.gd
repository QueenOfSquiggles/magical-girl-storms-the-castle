extends Particles2D

onready var timer  = $Timer

func _ready():
	emitting = true
	timer.wait_time = lifetime+0.1
	
func _on_Timer_timeout():
	queue_free()
