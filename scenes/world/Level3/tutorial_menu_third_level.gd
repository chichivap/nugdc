class_name CombatTutorialMenu
extends CanvasLayer
	
@onready var tutorial_box: Control = $TutorialBox
@onready var proceed_button: Button = $TutorialBox/ProceedButton
@onready var timer: Timer = $Timer

func show_tutorial(value: bool):
	tutorial_box.visible = value
	get_tree().paused = value
	proceed_button.visible = value

func _on_proceed_button_pressed() -> void:
	show_tutorial(false)
