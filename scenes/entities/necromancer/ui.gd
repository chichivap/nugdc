extends CanvasLayer

@export var player: Necromancer
var slots : Array

func _ready() -> void:
	slots = get_children()
	for i in get_child_count():
		slots[i].change_key = str(i+1)

	slots[0].skill = PosessSkill.new(slots[0])
	slots[1].skill = ResurrectSkill.new(slots[1])

func _process(_delta: float) -> void:
	pass
