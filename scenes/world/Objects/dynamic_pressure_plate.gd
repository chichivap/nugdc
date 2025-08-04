class_name DynamicPressurePlate
extends Node2D

var pressed: bool = false

@onready var normal: Sprite2D = $Normal
@onready var pressed_sprite: Sprite2D = $Pressed
@onready var variable_pitch_audio_stream_player: AudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var area_2d: Area2D = $Area2D
var bodies: Array

func _process(_delta: float) -> void:
	if pressed:
		pressed_sprite.visible = true
		normal.visible = false
	else:
		pressed_sprite.visible = false
		normal.visible = true

func _on_area_2d_body_entered(body:Node2D) -> void:
	bodies = area_2d.get_overlapping_bodies()
	if bodies.size() > 1:
		return
	if body is Necromancer or Skeleton:
		pressed = true
		variable_pitch_audio_stream_player.play()
		


func _on_area_2d_body_exited(body:Node2D) -> void:
	bodies = area_2d.get_overlapping_bodies()
	if bodies.size() > 0:
		return
	if body is Necromancer or Skeleton:
		pressed = false

