extends CanvasLayer

@export var player: Necromancer
var slots : Array = [TextureButton]

func _ready() -> void:
	if GameEvent.current_level == 1:
		return
	slots = get_children()
	for i in get_child_count():
		slots[i].change_key = str(i+1)

	slots[0].skill = PossessSkill.new(slots[0])
	slots[1].skill = ResurrectSkill.new(slots[1])
