class_name Necromancer
extends CharacterBody2D

const SPEED = 85.0

const ACTION_MOVE_UP: StringName = "move_up" 
const ACTION_MOVE_DOWN: StringName = "move_down"
const ACTION_MOVE_LEFT: StringName = "move_left"
const ACTION_MOVE_RIGHT: StringName = "move_right"

const SKELETON_GROUP: StringName = "skeleton"

@onready var marker: Sprite2D = $Marker
@onready var mana_component: Node = $ManaComponent
@onready var resurrection_area: Area2D = $ResurrectionArea
@onready var resurrection_shape: CollisionShape2D = %ResurrectionShape
@onready var possession_shape: CollisionShape2D = $PossessArea/PossessionShape
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var follow_component: FollowComponent = $FollowComponent
@onready var possess_area: Area2D = $PossessArea

var is_resurrecting: bool
var resurrection_shape_shape: CircleShape2D
var possession_shape_shape: CircleShape2D
var last_faced_direction: Vector2
var state_machine := CallableStateMachine.new()

var res_circle_color : Color = Color(0.21, 0.02, 0.36, 0.2)

var pos_circle_color_main : Color = Color(1,0,1,0.2)
var pos_circle_color : Color = Color(1,0,1,0.5)

var circle_color_static : Color = Color(0.439, 0.4, 0.459, 0.2)
var should_draw_res_circle : bool= false
var should_draw_pos_circle : bool = false

var skeleton_status: bool

var resurrection_tween: Tween
var possession_tween : Tween
var corpse: Corpse

var can_possess: bool = false

var is_mana_drained: bool = false 

signal first_resurrection_ended(value: int)
var resurrection_counter: int = 0

func _process(_delta: float) -> void:
	state_machine.update()
	if should_draw_res_circle:
		queue_redraw()

func _ready() -> void:
	state_machine.add_state(state_res, Callable(), Callable())
	state_machine.add_state(state_possessed, Callable(), Callable())
	state_machine.add_state(state_normal, Callable(), Callable())
	state_machine.set_initial_state(state_normal)

	resurrection_area.area_entered.connect(_on_resurrection_area_entered)

	mana_component.mana_drained.connect(_on_mana_drained)

	possession_shape_shape = possession_shape.shape
	resurrection_shape_shape = resurrection_shape.shape
	if is_instance_valid(get_skeleton):
		get_skeleton().health_component.died.connect(_on_skeleton_died)
	
func state_normal() -> void:
	follow_component.stop_follow()
	marker.visible = true
	velocity = GameManager.get_direction() * SPEED
	move_and_slide()
	var skeleton: Skeleton = get_tree().get_first_node_in_group(SKELETON_GROUP)
	if is_instance_valid(skeleton):
		skeleton.necromancer_posessed.emit(false)
	
func state_possessed() -> void:
	var skeleton: Skeleton = get_skeleton()
	if !is_instance_valid(skeleton):
		state_machine.change_state(state_normal)
		return
	if skeleton.health_component.current_health <= 0:
		state_machine.change_state(state_normal)
	skeleton.necromancer_posessed.emit(true)
	marker.visible = false
	follow_component.start_follow(follow_component.TargetType.SKELETON)


func state_res() -> void:
	should_draw_res_circle = true
	is_resurrecting = true
	resurrection_shape_shape.radius = 0
	resurrection_shape.disabled = false

	if resurrection_tween != null && resurrection_tween.is_valid():
		resurrection_tween.kill()

	var tween := create_tween()
	tween.tween_property(resurrection_shape_shape, "radius", 48, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(end_res)
	state_machine.change_state(state_normal)
	#if is_instance_valid(corpse):
	#	corpse.resurrect()

func end_res() -> void:
	resurrection_counter += 1
	is_resurrecting = false
	resurrection_shape.disabled = true
	should_draw_res_circle = false
	queue_redraw()

	if resurrection_tween != null && resurrection_tween.is_valid():
		resurrection_tween.kill()

	if is_instance_valid(corpse):
		corpse.resurrect()
	corpse = null

	var skeleton: Skeleton = get_tree().get_first_node_in_group(SKELETON_GROUP)
	if !is_instance_valid(skeleton):
		return
	first_resurrection_ended.emit(resurrection_counter)


func _on_resurrection_area_entered(other_area: Area2D) -> void:
	if other_area.owner is Corpse:
		corpse = other_area.owner

func get_skeleton() -> Skeleton:
	return get_tree().get_first_node_in_group(SKELETON_GROUP)

func _on_skeleton_died() -> void:
	skeleton_status = false

func _draw() -> void:
	if should_draw_res_circle:
		draw_circle(Vector2.ZERO, resurrection_shape_shape.radius, res_circle_color)
		draw_arc(Vector2.ZERO, resurrection_shape_shape.radius, 0, TAU, 32, res_circle_color, 2.0)
	if should_draw_pos_circle:
		draw_circle(Vector2.ZERO, resurrection_shape_shape.radius, pos_circle_color)
		draw_arc(Vector2.ZERO, resurrection_shape_shape.radius, 0, TAU, 32, pos_circle_color, 2.0)
	
func distance_to_skeleton() -> float:
	return global_position.distance_to(get_skeleton().global_position)

func _on_possess_area_body_entered(body: CharacterBody2D) -> void:
	if body is Skeleton:
		can_possess = true

func _on_possess_area_body_exited(body: CharacterBody2D) -> void:
	if body is Skeleton:
		can_possess = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip"):
		GameEvent.skip_level()

func _on_mana_drained() -> void:
	is_mana_drained = true
