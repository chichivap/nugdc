class_name PosessSkill
extends Skill

func _init(target) -> void:
	cooldown_duration = 4
	texture = preload("uid://dnkwm5pydd2et")
	super._init(target)
	mana_cost = 2

func cast_spell(target) -> void:
	super.cast_spell(target)
	if !allowed:
		return
	if target.state_machine.current_state != "state_posessed":
		target.state_machine.change_state(target.state_posessed)
	else:
		target.state_machine.change_state(target.state_normal)
	
