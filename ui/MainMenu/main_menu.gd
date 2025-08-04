extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PostProcessing.set_shader_param('scanline_strength', 0.16)
	PostProcessing.set_shader_param('vigniette_strength', 1)
	PostProcessing.set_shader_param('noise_strength', 0.047)
	PostProcessing.set_shader_param('glow_strength', 0.3)
	PostProcessing.set_shader_param('glow_radius', 1.0)





func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://cd1o03tuhuo40")
