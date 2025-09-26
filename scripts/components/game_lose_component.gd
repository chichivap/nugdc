class_name GameLoseComponent
extends Node

@export var necromancer: Necromancer
@onready var label_timer: Label = $LabelTimer
@onready var timer: Timer = $Timer

func _ready() -> void:
	necromancer.mana_component.mana_drained.connect(_on_mana_drained)
	label_timer.visible = false
	timer.timeout.connect(_on_timer_timeout)

func _process(_delta: float) -> void:
	update_label(int(timer.time_left))

func _on_mana_drained() -> void:
	timer.start(10)
	label_timer.visible = true

func update_label(value: int) -> void:
	label_timer.text = str(value)

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
