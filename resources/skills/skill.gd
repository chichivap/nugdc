class_name Skill
extends Resource

var cooldown_duration: float
var texture: Texture2D

func _init(target) -> void:
	target.cooldown.max_value = cooldown_duration
	target.texture_normal = texture
	target.timer.wait_time = cooldown_duration

func cast_spell(target) -> void:
	pass
