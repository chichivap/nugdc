class_name HealthBarComponent
extends Control

@export var health_component: HealthComponent

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)
	update_progress()

func update_progress() -> void:
	var percentage = health_component.current_health / (1.0 if health_component.max_health == 0 else health_component.max_health)
	progress_bar.value = percentage
	progress_bar.visible = percentage < 1.0
func _on_health_changed(_value: int) -> void:
	update_progress()