class_name SkeletonPermPressurePlate
extends Node2D

var pressed: bool = false

@onready var normal: Sprite2D = $Normal
@onready var pressed_sprite: Sprite2D = $Pressed
@onready var variable_pitch_audio_stream_player: AudioStreamPlayer = $VariablePitchAudioStreamPlayer

func _process(_delta: float) -> void:
	if pressed:
		pressed_sprite.visible = true
		normal.visible = false
	else:
		pressed_sprite.visible = false
		normal.visible = true


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if pressed:
		return
	if body:
		pressed = true
		variable_pitch_audio_stream_player.play()
