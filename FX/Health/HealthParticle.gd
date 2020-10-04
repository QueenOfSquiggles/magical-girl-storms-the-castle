extends Particles2D

onready var timer = $Timer

func _ready():
	timer.wait_time = lifetime + 0.1
	timer.start()


func _on_Timer_timeout():
	queue_free()
