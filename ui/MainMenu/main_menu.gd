extends Node2D

const FIRST_LEVEL = preload("uid://cd1o03tuhuo40")
const TRANSITION_SCENE: PackedScene = preload("uid://bbwobgmcbrmmi")

@onready var play_button: Button = %PlayButton

var SETTINGS_SCENE: PackedScene= preload("uid://cnuesfgv4etu1")
@onready var settings_menu: Control = $CanvasLayer/SettingsMenu

var transition: PixelTransition

func _ready() -> void:
	GameManager.toggle_crt(true)
	transition = TRANSITION_SCENE.instantiate()
	add_child(transition)
	settings_menu.returned_to_pause_menu.connect(_on_settings_closed)



func _on_button_pressed() -> void:
	GameEvent.completed_level()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	settings_menu.visible = true
	visible = false

func _on_settings_closed() -> void:
	settings_menu.visible = false
	visible = true