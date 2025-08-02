class_name Goblin
extends CharacterBody2D

const PLAYER_GROUP: StringName = "player"
const SKELETON_GROUP: StringName = "skeleton"
const SPEED: int = 50
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var target_acquisition_timer: Timer = $TargetAcquisitionTimer
@onready var health_component: HealthComponent = $HealthComponent

var state_machine := CallableStateMachine.new()
var last_faced_direction: Vector2
var current_target: CharacterBody2D

func _ready():
	state_machine.add_state(state_idle, Callable(), Callable())
	#state_machine.add_state(state_follow, Callable(), Callable())
	state_machine.add_state(state_attack, Callable(), Callable())
	#state_machine.set_initial_state(state_follow)
	state_machine.add_state(state_normal, Callable(), Callable())
	state_machine.set_initial_state(state_idle)

	target_acquisition_timer.timeout.connect(_on_target_acquisition_timeout)
	health_component.died.connect(_on_died)
	health_component.health_changed.connect(_on_health_changed)

func _on_health_changed(value: int) -> void:
	print("Health changed to: ", value)
func _process(_delta):
	state_machine.update()
	

func state_normal() -> void:
	if !is_instance_valid(current_target):
		acquire_target()
		if !is_instance_valid(current_target):
			state_machine.change_state(state_idle)
			return
	
	var direction = global_position.direction_to(current_target.global_position)
	#velocity = direction * SPEED



	if global_position.distance_to(current_target.global_position) > 0.5:
		velocity = direction * SPEED
		move_and_slide()
	else:
		global_position = current_target.global_position
func state_idle() -> void:


	
	
	if is_instance_valid(current_target):
		state_machine.change_state(state_normal)


		

func get_player() -> CharacterBody2D:
	return get_tree().get_first_node_in_group(PLAYER_GROUP)

func _on_target_acquisition_timeout() -> void:
	acquire_target()
	target_acquisition_timer.start(randf_range(1, 2))

func acquire_target() -> void:
	var skeleton = get_tree().get_first_node_in_group(SKELETON_GROUP)

	var target: CharacterBody2D = null

	if target == null and is_instance_valid(skeleton):
		target = skeleton
	current_target = target


func state_attack() -> void:
	velocity = Vector2.ZERO

func _on_died() -> void:
	queue_free()
