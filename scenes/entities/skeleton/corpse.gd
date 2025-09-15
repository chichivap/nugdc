class_name Corpse
extends Node2D

const SKELETON_SCENE: PackedScene = preload("uid://bqvghd16833cq")

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if randf() < .5:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false

func resurrect() -> void:
	var skeleton = SKELETON_SCENE.instantiate() as CharacterBody2D
	skeleton.global_position = global_position
	get_parent().add_child(skeleton)
	queue_free()