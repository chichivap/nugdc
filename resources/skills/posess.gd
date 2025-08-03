class_name PosessSkill
extends Skill

var skeleton: PackedScene = preload("uid://bqvghd16833cq")

func _init(target) -> void:
	cooldown_duration = 1
	texture = preload("uid://kyb2sn0yy0sw")
	super._init(target)
	mana_cost = 1

func cast_spell(target) -> void:
	super.cast_spell(target)
	if !allowed:
		return
	else:

		if target.state_machine.current_state == "state_normal":
			target.state_machine.change_state(target.state_posessed)
			target.mana_component.cast(mana_cost)
		else:
			target.state_machine.change_state(target.state_normal)
			target.mana_component.cast(mana_cost)
	
