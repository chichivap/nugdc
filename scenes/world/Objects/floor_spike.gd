extends Node2D

func _on_detecion_area_body_entered(body:CharacterBody2D) -> void:
	if body is Skeleton || body is Goblin:
		body.health_component.damage(1)

