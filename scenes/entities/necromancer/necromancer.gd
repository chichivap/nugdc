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
@onready var mana_component: Node = $ManaComponent

@onready var resurrection_area: Area2D = $ResurrectionArea
@onready var resurrection_shape: CollisionShape2D = %ResurrectionShape
var is_resurrecting: bool
var resurrection_shape_shape: CircleShape2D
var last_faced_direction: Vector2
var state_machine := CallableStateMachine.new()

var resurrection_tween: Tween
var corpse: Corpse
func _process(_delta: float) -> void:
	state_machine.update()


func _ready() -> void:
	state_machine.add_state(state_res, Callable(), Callable())
	state_machine.add_state(state_posessed, Callable(), Callable())
	state_machine.add_state(state_normal, Callable(), Callable())
	state_machine.set_initial_state(state_normal)

	resurrection_area.area_entered.connect(_on_resurrection_area_entered)

	resurrection_shape_shape = resurrection_shape.shape
	


func state_normal() -> void:
	marker.visible = true
	velocity = GameManager.get_direction() * SPEED
	move_and_slide()
	var skeleton: Skeleton = get_tree().get_first_node_in_group(SKELETON_GROUP)
	if is_instance_valid(skeleton):
		skeleton.necromancer_posessed.emit(false)


func state_posessed() -> void:
	var skeleton: Skeleton = get_tree().get_first_node_in_group(SKELETON_GROUP)
	if !is_instance_valid(skeleton):
		state_machine.change_state(state_normal)
		return
	if skeleton.health_component.current_health <= 0:
		state_machine.change_state(state_normal)
	if is_instance_valid(skeleton):
		skeleton.necromancer_posessed.emit(true)
		velocity = Vector2.ZERO
		marker.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("resurrect"):
		is_resurrecting = true
	elif event.is_action_released("resurrect"):
		if is_resurrecting:
			end_res()

func state_res() -> void:
	is_resurrecting = true
	resurrection_shape_shape.radius = 0
	resurrection_shape.disabled = false

	if resurrection_tween != null && resurrection_tween.is_valid():
		resurrection_tween.kill()

	var tween := create_tween()
	tween.tween_property(resurrection_shape_shape, "radius", 48, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(end_res)

func end_res() -> void:
	is_resurrecting = false
	resurrection_shape.disabled = true

	if resurrection_tween != null && resurrection_tween.is_valid():
		resurrection_tween.kill()

	if is_instance_valid(corpse):
		corpse.resurrect()
	corpse = null
	state_machine.change_state(state_normal)



func _on_resurrection_area_entered(other_area: Area2D) -> void:
	if other_area.owner is Corpse:
		corpse = other_area.owner
