extends Node2D

@onready var variable_pitch_audio_stream_player: AudioStreamPlayer = $VariablePitchAudioStreamPlayer

func _on_detecion_area_body_entered(body:CharacterBody2D) -> void:
	if body is Skeleton || body is Goblin:
		if body.health_component.is_invincible:
			return
		body.health_component.damage(1)
		variable_pitch_audio_stream_player.play()

