class_name GameLoseComponent
extends Node

@export var necromancer: Necromancer
@onready var label_timer: Label = $LabelTimer

var timer : Timer = Timer.new()

func _ready() -> void:
	necromancer.mana_component.mana_drained.connect(_on_mana_drained)

func _on_mana_drained() -> void:
	timer.start(10)
	label_timer.text = str(timer.time_left)
