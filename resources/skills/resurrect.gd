class_name ResurrectSkill
extends Skill

var skeleton: PackedScene = preload("uid://bqvghd16833cq")
var corpse: PackedScene = preload("uid://cvr06bsxotsvl")

func _init(target) -> void:
	cooldown_duration = 2
	texture = preload("uid://di6vu2wndjhdy")
	super._init(target)
	mana_cost = 3
func cast_spell(target) -> void:
	super.cast_spell(target)
	if target.state_machine.current_state == "state_possessed":
		return
	if !is_instance_valid(corpse):
		return
	target.state_machine.change_state(target.state_res)
	target.mana_component.cast(mana_cost)
	
