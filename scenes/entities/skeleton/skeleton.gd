class_name Skeleton
extends CharacterBody2D

const PLAYER_GROUP: StringName = "player"
const ENEMY_GROUP: StringName = "enemy"
const SPEED: int = 100
const COMBAT_RANGE: int = 16

const ACTION_MOVE_UP: StringName = "move_up" 
const ACTION_MOVE_DOWN: StringName = "move_down"
const ACTION_MOVE_LEFT: StringName = "move_left"
const ACTION_MOVE_RIGHT: StringName = "move_right"



var state_machine := CallableStateMachine.new()
var target_position : Vector2
var last_faced_direction: Vector2
var enemy_target: CharacterBody2D

@onready var marker: Sprite2D = $Marker
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var target_acquisition_timer: Timer = $TargetAcquisitionTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	state_machine.add_state(state_follow, Callable(), Callable())
	state_machine.add_state(state_posessed, Callable(), Callable())
	state_machine.add_state(state_attack, Callable(), Callable())
	
	state_machine.set_initial_state(state_follow)

	target_acquisition_timer.timeout.connect(_on_target_acquisition_timeout)

	health_component.died.connect(_on_died)
func _process(_delta: float) -> void:
	state_machine.update()
	
func state_follow() -> void:
	marker.visible = false
	var direction = global_position.direction_to(target_position)

	if is_instance_valid(enemy_target):
		state_machine.change_state(state_attack)

	if global_position.distance_to(target_position) > 0.5:
		velocity = direction * SPEED
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
	marker.visible = true

	var enemies	= get_tree().get_nodes_in_group(ENEMY_GROUP)
	for enemy in enemies:
		if enemy_target == null:
			enemy_target = enemy
			print("Target acquired: ", enemy_target.name)
			continue
		
		if enemy.global_position.distance_squared_to(global_position) < enemy_target.global_position.distance_squared_to(global_position):
			enemy_target = enemy

		
	print(enemy_target.global_position.distance_to(global_position))
	if enemy_target.global_position.distance_to(global_position) < COMBAT_RANGE:
		state_machine.change_state(state_attack)


	

func state_attack() -> void:
	velocity = Vector2.ZERO
	if !is_instance_valid(enemy_target):
		state_machine.change_state(state_follow)
		return

	if attack_timer.is_stopped():
		enemy_target.health_component.damage(randf_range(.5, 1.5))
		attack_timer.start(randf_range(0.1,0.2))


#func is_within_combat_range() -> bool:
	#if !is_instance_valid():
	#	return false
	#pass
func _on_died() -> void:
	queue_free()
