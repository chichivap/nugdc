class_name Necromancer
extends CharacterBody2D

const SPEED = 100.0

const ACTION_MOVE_UP: StringName = "move_up" 
const ACTION_MOVE_DOWN: StringName = "move_down"
const ACTION_MOVE_LEFT: StringName = "move_left"
const ACTION_MOVE_RIGHT: StringName = "move_right"

const SKELETON_GROUP: StringName = "skeleton"

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var marker: Sprite2D = $Marker

var last_faced_direction: Vector2
var state_machine := CallableStateMachine.new()

func _process(_delta: float) -> void:
	state_machine.update()


func _ready() -> void:
	state_machine.add_state(state_posessed, Callable(), Callable())
	state_machine.add_state(state_normal, Callable(), Callable())
	state_machine.set_initial_state(state_normal)


func state_normal() -> void:
	marker.visible = true
	velocity = GameManager.get_direction() * SPEED
	move_and_slide()
	var skeleton: Skeleton = get_tree().get_first_node_in_group(SKELETON_GROUP)
	if is_instance_valid(skeleton):
		skeleton.necromancer_posessed.emit(false)


func state_posessed() -> void:
	var skeleton: Skeleton = get_tree().get_first_node_in_group(SKELETON_GROUP)
	if is_instance_valid(skeleton):
		skeleton.necromancer_posessed.emit(true)
		velocity = Vector2.ZERO
		marker.visible = false
