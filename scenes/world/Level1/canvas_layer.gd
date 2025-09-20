extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $SettingsMenu

func _ready() -> void:
	pause_menu.settings_pressed.connect(_on_settings_pressed)
	settings_menu.returned_to_pause_menu.connect(_on_returned_to_pause)


func _on_settings_pressed() -> void:
	settings_menu.visible = true
	pause_menu.visible = false

func _on_returned_to_pause() -> void:
	settings_menu.visible = false
	pause_menu.visible = true