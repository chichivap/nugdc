extends Control
@onready var vbox_container: VBoxContainer = $VBoxContainer
@onready var panel_container: PanelContainer = $PanelContainer

signal settings_pressed()

func resume() -> void:
	get_tree().paused = false
	visible = false

func pause() -> void:
	get_tree().paused = true
	visible = true

func esc() -> void:
	if Input.is_action_just_pressed("escape") and !get_tree().paused and !visible:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused and visible:
		resume()

 
func _on_resume_button_pressed() -> void:
	resume()


func _on_settings_button_pressed() -> void:
	settings_pressed.emit()

func _on_restart_button_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _process(_delta) -> void:
	esc()
	
