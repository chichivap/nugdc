extends HBoxContainer

var slots : Array

func _ready() -> void:
	slots = get_children()
	for i in get_child_count():
		slots[i].change_key = str(i+1)

	slots[0].skill = Posess.new(slots[0])
