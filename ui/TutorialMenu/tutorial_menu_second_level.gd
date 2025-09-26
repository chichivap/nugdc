class_name TutorialSecondLevel
extends TutorialLayer

@onready var spacebar_box: Control = $TutorialBox/SpacebarBox
@onready var key_r: TextureRect = $TutorialBox/KeyR
@onready var proceed_r_button: Button = $TutorialBox/ProceedRButton
@onready var spacebar_proceed_button: Button = $TutorialBox/ProceedSpaceButton


func show_key_r(value: bool) -> void:
	label.visible = value
	key_r.visible = value
	panel_container.visible = value
	get_tree().paused = value
	proceed_r_button.visible = value


func show_spacebar(value: bool) -> void:
	spacebar_box.visible = value
	panel_container.visible = value
	get_tree().paused = value
	spacebar_proceed_button.visible = value


func _on_proceed_r_button_pressed() -> void:
	show_key_r(false)


func _on_proceed_space_button_pressed() -> void:
	show_spacebar(false)
