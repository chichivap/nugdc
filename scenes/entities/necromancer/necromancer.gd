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

var circle_color : Color = Color(0.21, 0.02, 0.36, 0.2)
var should_draw_circle := false

var skeleton_status: bool

var resurrection_tween: Tween
var corpse: Corpse

var can_possess: bool = false
func _process(_delta: float) -> void:
	state_machine.update()
	if should_draw_circle:
		queue_redraw()
	if is_instance_valid(get_skeleton):
		print(distance_to_skeleton())
	


func _ready() -> void:
	state_machine.add_state(state_res, Callable(), Callable())
	state_machine.add_state(state_posessed, Callable(), Callable())
	state_machine.add_state(state_normal, Callable(), Callable())
	state_machine.set_initial_state(state_normal)

	resurrection_area.area_entered.connect(_on_resurrection_area_entered)

	resurrection_shape_shape = resurrection_shape.shape
	if is_instance_valid(get_skeleton):
		get_skeleton().health_component.died.connect(_on_skeleton_died)
	


func state_normal() -> void:
	marker.visible = true
	velocity = GameManager.get_direction() * SPEED
	move_and_slide()
	var skeleton: Skeleton = get_tree().get_first_node_in_group(SKELETON_GROUP)
	if is_instance_valid(skeleton):
		skeleton.necromancer_posessed.emit(false)


func state_posessed() -> void:
	var skeleton: Skeleton = get_skeleton()
	if !is_instance_valid(skeleton):
		state_machine.change_state(state_normal)
		return
	if skeleton.health_component.current_health <= 0:
		state_machine.change_state(state_normal)

	skeleton.necromancer_posessed.emit(true)
	velocity = Vector2.ZERO
	marker.visible = false


func state_res() -> void:
	should_draw_circle = true
	is_resurrecting = true
	resurrection_shape_shape.radius = 0
	resurrection_shape.disabled = false

	if resurrection_tween != null && resurrection_tween.is_valid():
		resurrection_tween.kill()

	var tween := create_tween()
	tween.tween_property(resurrection_shape_shape, "radius", 48, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(end_res)
	state_machine.change_state(state_normal)

func end_res() -> void:
	is_resurrecting = false
	resurrection_shape.disabled = true
	should_draw_circle = false
	queue_redraw()

	if resurrection_tween != null && resurrection_tween.is_valid():
		resurrection_tween.kill()

	if is_instance_valid(corpse):
		corpse.resurrect()
	corpse = null

	var skeleton: Skeleton = get_tree().get_first_node_in_group(SKELETON_GROUP)
	if !is_instance_valid(skeleton):
		return
	skeleton_status = true
	skeleton.add_to_group("skeleton")

	
	

func _on_resurrection_area_entered(other_area: Area2D) -> void:
	if other_area.owner is Corpse:
		corpse = other_area.owner

func get_skeleton() -> Skeleton:
	return get_tree().get_first_node_in_group(SKELETON_GROUP)

func _on_skeleton_died() -> void:
	skeleton_status = false

func _draw() -> void:
	if should_draw_circle:
		draw_circle(Vector2.ZERO, resurrection_shape_shape.radius, circle_color)
		draw_arc(Vector2.ZERO, resurrection_shape_shape.radius, 0, TAU, 32, circle_color, 2.0)

	
func distance_to_skeleton() -> float:
	return global_position.distance_to(get_skeleton().global_position)



func _on_possess_area_body_entered(body: CharacterBody2D) -> void:
	if body is Skeleton:
		can_possess = true


func _on_possess_area_body_exited(body: CharacterBody2D) -> void:
	if body is Skeleton:
		can_possess = false
