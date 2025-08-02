class_name HealthComponent
extends Node

@export var max_health: int = 10

signal died
signal health_changed(value)

var current_health: int

func _enter_tree() -> void:
	current_health = max_health

func damage(amount: int) -> void:
	current_health -= amount
	health_changed.emit(current_health)
	if current_health <= 0:
		current_health = 0
		died.emit()

