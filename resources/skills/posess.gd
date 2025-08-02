class_name Posess
extends Skill

func _init(target) -> void:
    cooldown_duration = 4
    texture = preload("uid://dnkwm5pydd2et")
    super._init(target)

func cast_spell(target) -> void:

    super.cast_spell(target)
    if target.state_machine.current_state != "state_posessed":
        target.state_machine.change_state(target.state_posessed)
    else:
        target.state_machine.change_state(target.state_normal)
    
