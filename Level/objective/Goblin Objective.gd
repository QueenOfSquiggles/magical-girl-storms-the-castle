extends Control

onready var lbl = $"Kill % Goblins!"
onready var scroll = $"Kill % Goblins!/DisplayScroll"

func _ready():
	reload()
	
func reload():
	var gs = get_tree().get_nodes_in_group("bad")
	for g in gs:
		(g as GoblinBase).connect("on_death", self, "on_gob_die")
	var s = gs.size()
	lbl.text = "Kill %s Goblins" % s;
	scroll.interpolate_property(lbl, "percent_visible", 0.0, 1.0, 3.0)
	scroll.start()
	
func on_gob_die():
	var gs = get_tree().get_nodes_in_group("bad")
	var s = gs.size()-1
	if s <= 0:
		game_win()
	lbl.text = "Kill %s Goblins" % s;

func game_win():
	AudioManager.stop_all()
	get_tree().change_scene("res://menus/WinScreen.tscn")
	
