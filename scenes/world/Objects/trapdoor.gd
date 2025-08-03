class_name Trapdoor
extends Node2D

@onready var closed: Sprite2D = $Closed
@onready var opened: Sprite2D = $Opened
@onready var collision_shape_2d: CollisionShape2D = $PlayerDetectionArea2D/CollisionShape2D


func _ready() -> void:
	close()

func open() -> void:
	closed.visible = false
	opened.visible = true
	collision_shape_2d.disabled = false


func close() -> void:
	closed.visible = true
	opened.visible = false
	collision_shape_2d.disabled = true



func _on_player_detection_area_2d_body_entered(body:Node2D) -> void:
	if body is Necromancer or Skeleton:
		next_level()

func next_level():
	GameEvent.completed_level()