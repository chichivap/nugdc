class_name Skeleton
extends CharacterBody2D

const PLAYER_GROUP: StringName = "player"
const SPEED: int = 100

const ACTION_MOVE_UP: StringName = "move_up" 
const ACTION_MOVE_DOWN: StringName = "move_down"
const ACTION_MOVE_LEFT: StringName = "move_left"
const ACTION_MOVE_RIGHT: StringName = "move_right"

var state_machine := CallableStateMachine.new()
var target_position : Vector2
var last_faced_direction: Vector2

@onready var marker: Sprite2D = $Marker
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var target_acquisition_timer: Timer = $TargetAcquisitionTimer

func _ready() -> void:
	state_machine.add_state(state_follow, Callable(), Callable())
	state_machine.add_state(state_posessed, Callable(), Callable())
	
	state_machine.set_initial_state(state_follow)

	target_acquisition_timer.timeout.connect(_on_target_acquisition_timeout)

func _process(delta: float) -> void:
	state_machine.update()
	
func state_follow() -> void:
	marker.visible = false
	var direction = global_position.direction_to(target_position)


	if global_position.distance_to(target_position) > 0.5:
		velocity = direction * SPEED
		sprite_2d.flip_h = last_faced_direction.x < 0
		if velocity.x != 0:
			last_faced_direction = velocity.normalized()
		move_and_slide()
	else:
		global_position = target_position


func get_player() -> CharacterBody2D:
	return get_tree().get_first_node_in_group(PLAYER_GROUP)

func acquire_target() -> void:
	var player = get_player()
	if player:
		target_position = player.global_position + MathUtils.get_random_direction() * randi_range(16,24)


func _on_target_acquisition_timeout() -> void:
	acquire_target()
	target_acquisition_timer.start(randf_range(1, 2))

func state_posessed() -> void:
	velocity = GameManager.get_direction() * SPEED
	move_and_slide()
	sprite_2d.flip_h = last_faced_direction.x < 0
	if velocity.x != 0:
		last_faced_direction = velocity.normalized()
	marker.visible = true
