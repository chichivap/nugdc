class_name SpriteFlipManager
extends Node

@export var actor: CharacterBody2D


func _process(_delta: float) -> void:
	actor.sprite_2d.flip_h = actor.last_faced_direction.x < 0
	if actor.velocity.x != 0:
		actor.last_faced_direction = actor.velocity.normalized()
