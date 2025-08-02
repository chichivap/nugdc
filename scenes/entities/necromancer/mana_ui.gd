class_name ManaUI
extends CanvasLayer

@onready var mana_label: Label = $ManaNumber


@export var mana_component: ManaComponent

func _ready() -> void:
	mana_component.mana_changed.connect(_on_mana_changed)
	
func _on_mana_changed(value: float) -> void:
	mana_label.text = "%d/%d" % [value, mana_component.max_mana]
	if value <= 0:
		mana_label.text = "0/0"
	else:
		mana_label.text = "%d/%d" % [value, mana_component.max_mana]
