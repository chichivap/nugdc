class_name Skill
extends Resource

var cooldown_duration: float
var texture: Texture2D
var mana_cost: float
var allowed: bool = true
func _init(target) -> void:
	target.cooldown.max_value = cooldown_duration
	target.texture_normal = texture
	target.timer.wait_time = cooldown_duration

func cast_spell(target) -> void:
	if target.mana_component.current_mana < mana_cost:
		print("Not enough mana to cast the spell.")
		allowed = false
		return
	target.mana_component.cast(mana_cost)
