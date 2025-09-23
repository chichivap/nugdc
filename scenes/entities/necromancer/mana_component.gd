class_name ManaComponent
extends Node

@export var max_mana: float = 8

signal mana_changed(value)
signal mana_drained()

var current_mana: float

func _enter_tree() -> void:
	current_mana = max_mana

func cast(amount: int) -> void:
	current_mana -= amount
	mana_changed.emit(current_mana)
	if current_mana <= 0:
		current_mana = 0
		mana_drained.emit()






