extends Node2D


func _on_button_pressed() -> void:
	GameEvent.current_level = 1
	get_tree().change_scene_to_file("uid://3ghf3epre4kc")
