class_name HealthStats
extends Control

@onready var label: Label = $Health

@export var health_component: HealthComponent

func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)
	update_progress()

func update_progress() -> void:
	var value : int = health_component.current_health
	label.text = str(value)

func _on_health_changed(_value: int) -> void:
	update_progress()
