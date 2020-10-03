extends Position2D

class_name NPCDefendPoint


enum AcceptedClasses {
	All, Normal, WallSoldier, Merchant, Princess
}

export (AcceptedClasses) var accepted := AcceptedClasses.All
export (float) var position_update_rate := 1.5

var enabled = false
var distance_from_player = 999.0

var claimed := false

onready var timer = $update_timer

func _ready():
	timer.wait_time = position_update_rate
	timer.start()


func _on_VisibilityNotifier2D_screen_entered():
	enabled = true

func _on_VisibilityNotifier2D_screen_exited():
	enabled = false


func _on_position_update_timer_timeout():
	if Util.player:
		distance_from_player = ((Util.player.global_position - global_position) as Vector2).length()
	#print("checking distance : ", distance_from_player, " units")
	timer.start()
	
