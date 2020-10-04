extends OptionButton

export (Array, String) var imported_items = []

func _ready():
	for i in imported_items:
		add_item(str(i))
	
