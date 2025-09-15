class_name AnimationComponent
extends Node

@export var actor: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D

func _process(_delta: float) -> void:
	if actor.velocity != Vector2.ZERO:
		animated_sprite_2d.play("Walk")
	else:
		animated_sprite_2d.play("Idle")
