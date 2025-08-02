class_name ResurrectSkill
extends Skill


func _init(target) -> void:
	cooldown_duration = 4
	texture = preload("uid://b4mm1hufsjdsg")
	super._init(target)
	mana_cost = 3
func cast_spell(target) -> void:
	super.cast_spell(target)
	if !allowed:
		return
	target.state_machine.change_state(target.state_res)
	
