class_name PosessComponent
extends Node2D

const POSESS_DURATION: float = 5.0
@onready var posess_timer: Timer = $PosessTimer


@export var necromancer: CharacterBody2D
@export var skeleton: CharacterBody2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("posess"):
		necromancer.state_machine.change_state(necromancer.state_posessed)
		skeleton.state_machine.change_state(skeleton.state_posessed)
		posess_timer.start(POSESS_DURATION)


func _ready() -> void:
	posess_timer.timeout.connect(_on_posess_timeout)

func _on_posess_timeout() -> void:
	necromancer.state_machine.change_state(necromancer.state_normal)
	skeleton.state_machine.change_state(skeleton.state_follow)
	posess_timer.stop()
	print("Posession ended, returning to normal state.")
