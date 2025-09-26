extends CanvasLayer

@export var player: Necromancer
var slots : Array = [TextureButton]

func _ready() -> void:
	if GameEvent.current_level == 1:
		return
	slots = get_children()
	for i in get_child_count():
		slots[0].change_key = "possess"
		slots[1].change_key = "resurrect"

	slots[0].skill = PossessSkill.new(slots[0])
	slots[1].skill = ResurrectSkill.new(slots[1])
