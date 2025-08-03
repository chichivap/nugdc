class_name DynamicPressurePlate
extends Node2D

var pressed: bool = false

@onready var normal: Sprite2D = $Normal
@onready var pressed_sprite: Sprite2D = $Pressed

func _process(_delta: float) -> void:
	if pressed:
		pressed_sprite.visible = true
		normal.visible = false
	else:
		pressed_sprite.visible = false
		normal.visible = true

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body is Necromancer or Skeleton:
		pressed = true


func _on_area_2d_body_exited(body:Node2D) -> void:
	if body is Necromancer or Skeleton:
		pressed = false
