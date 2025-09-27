class_name Goblin
extends CharacterBody2D

const PLAYER_GROUP: StringName = "player"
const SKELETON_GROUP: StringName = "skeleton"
const COMBAT_RANGE: int = 16
const SPEED: int = 70


var state_machine := CallableStateMachine.new()
var last_faced_direction: Vector2
var current_target: CharacterBody2D
@export var damage_amount : int = 1

@onready var target_acquisition_timer: Timer = $TargetAcquisitionTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_timer: Timer = $AttackTimer
@onready var variable_pitch_audio_stream_player: AudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var spawner_component: SpawnerComponent = $SpawnerComponent

func _ready():
	state_machine.add_state(state_idle, Callable(), Callable())
	#state_machine.add_state(state_follow, Callable(), Callable())
	state_machine.add_state(state_attack, Callable(), Callable())
	state_machine.add_state(state_normal, Callable(), Callable())
	state_machine.set_initial_state(state_normal)

	target_acquisition_timer.timeout.connect(_on_target_acquisition_timeout)
	health_component.died.connect(_on_died)
	health_component.health_changed.connect(_on_hurt.unbind(1))
	invincible_timer.timeout.connect(func(): 
		health_component.is_invincible = false
		
		)


func _process(_delta):
	state_machine.update()
	
func state_normal() -> void:

	if !is_instance_valid(current_target) || current_target.state_machine.current_state == "state_corpse":
		acquire_target()
		if !is_instance_valid(current_target) || current_target.state_machine.current_state == "state_corpse":
			state_machine.change_state(state_idle)
			return
	
	var direction = global_position.direction_to(current_target.global_position)
	#velocity = direction * SPEED


	if global_position.distance_to(current_target.global_position) > 0.5:
		velocity = direction * SPEED
		move_and_slide()
		last_faced_direction = velocity.normalized()
	else:
		global_position = current_target.global_position

	if is_instance_valid(current_target):
		if current_target.global_position.distance_to(global_position) < COMBAT_RANGE && state_machine.current_state == "state_normal":
			state_machine.change_state(state_attack)
func state_idle() -> void:
	velocity = Vector2.ZERO
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
	move_and_slide()

	if is_instance_valid(current_target):
		if current_target.global_position.distance_to(global_position) > COMBAT_RANGE && state_machine.current_state == "state_attack":
			state_machine.change_state(state_normal)

	if !is_instance_valid(current_target):
		state_machine.change_state(state_idle)
		return

	if attack_timer.is_stopped():
		current_target.health_component.damage(damage_amount)
		attack_timer.start(1)
		variable_pitch_audio_stream_player.play()

func _on_died() -> void:
	queue_free()
	spawner_component.spawn(global_position)


func _on_hurt() -> void:
	if health_component.is_invincible:
		return
	health_component.is_invincible = true
	invincible_timer.start()
