extends Node2D

const FIRST_LEVEL = preload("uid://cd1o03tuhuo40")
const TRANSITION_SCENE: PackedScene = preload("uid://bbwobgmcbrmmi")
@onready var button: Button = $Button
var transition: PixelTransition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PostProcessing.set_shader_param('scanline_strength', 0.16)
	PostProcessing.set_shader_param('vigniette_strength', 1)
	PostProcessing.set_shader_param('noise_strength', 0.047)
	PostProcessing.set_shader_param('glow_strength', 0.3)
	PostProcessing.set_shader_param('glow_radius', 1.0)

	transition = TRANSITION_SCENE.instantiate()
	add_child(transition)

	AudioServer.set_bus_volume_db(0, -20)

	button.disabled = false

func _on_button_pressed() -> void:
	#if FIRST_LEVEL:
		#transition.transition_to(FIRST_LEVEL)
	button.disabled = true
	GameEvent.completed_level()
