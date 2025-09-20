extends Node2D

const FIRST_LEVEL = preload("uid://cd1o03tuhuo40")
const TRANSITION_SCENE: PackedScene = preload("uid://bbwobgmcbrmmi")
@onready var button: Button = %Button
var transition: PixelTransition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.toggle_crt(true)
	transition = TRANSITION_SCENE.instantiate()
	add_child(transition)

	button.disabled = false

func _on_button_pressed() -> void:
	#if FIRST_LEVEL:
		#transition.transition_to(FIRST_LEVEL)
	button.disabled = true
	GameEvent.completed_level()
