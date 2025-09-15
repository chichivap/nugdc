class_name Skeleton
extends CharacterBody2D

const PLAYER_GROUP: StringName = "player"
const ENEMY_GROUP: StringName = "enemy"
var SPEED: int = 140
const COMBAT_RANGE: int = 16

const ACTION_MOVE_UP: StringName = "move_up" 
const ACTION_MOVE_DOWN: StringName = "move_down"
const ACTION_MOVE_LEFT: StringName = "move_left"
const ACTION_MOVE_RIGHT: StringName = "move_right"

signal necromancer_posessed(value: bool)

@export var damage_amount :int = 1

var state_machine := CallableStateMachine.new()
var target_position : Vector2
var last_faced_direction: Vector2
var enemy_target: CharacterBody2D

var is_invincible: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var target_acquisition_timer: Timer = $TargetAcquisitionTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_timer: Timer = $AttackTimer
@onready var marker: Sprite2D = $Marker
@onready var variable_pitch_audio_stream_player: AudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var follow_component: FollowComponent = $FollowComponent
@onready var health_stats: HealthStats = $HealthStats
@onready var flash_component: FlashComponent = $FlashComponent
@onready var invincible_timer: Timer = $InvincibleTimer



func _ready() -> void:
	necromancer_posessed.connect(_on_necromancer_posessed)
	state_machine.add_state(state_follow, Callable(), Callable())
	state_machine.add_state(state_posessed, Callable(), Callable())
	state_machine.add_state(state_attack, Callable(), Callable())
	state_machine.set_initial_state(state_follow)

	target_acquisition_timer.timeout.connect(_on_target_acquisition_timeout)

	health_component.max_health = 10.0
	health_component.died.connect(_on_died)
	health_component.health_changed.connect(_on_hurt.unbind(1))
	marker.visible = true

	invincible_timer.timeout.connect(func(): 
		health_component.is_invincible = false
		
		)


func _process(_delta: float) -> void:
	state_machine.update()

func state_follow() -> void:	

	follow_component.start_follow(follow_component.TargetType.NECROMANCER)
	marker.modulate = Color(1,1,1)
	if global_position.distance_to(get_player().global_position) > 48:
		marker.visible = false
	else:
		marker.visible = true

func state_posessed() -> void:
	follow_component.stop_follow()
	velocity = GameManager.get_direction() * SPEED
	move_and_slide()
	marker.visible = true

	if global_position.distance_to(get_player().global_position) > 48:
		marker.modulate = Color(1,0,0)
	else:
		marker.modulate = Color(1, 1, 0)


	var enemies	= get_tree().get_nodes_in_group(ENEMY_GROUP)
	for enemy in enemies:
		if enemy_target == null:
			enemy_target = enemy
			continue
		if is_instance_valid(enemy_target):

			if enemy.global_position.distance_squared_to(global_position) < enemy_target.global_position.distance_squared_to(global_position):
				enemy_target = enemy

	if is_instance_valid(enemy_target):
		if enemy_target.global_position.distance_to(global_position) < COMBAT_RANGE && state_machine.current_state == "state_posessed":
			state_machine.change_state(state_attack)

func state_attack() -> void:
	SPEED = 120 
	move_and_slide()
	if is_instance_valid(enemy_target):
		if enemy_target.global_position.distance_to(global_position) > COMBAT_RANGE && state_machine.current_state == "state_attack":
			state_machine.change_state(state_follow)

	if !is_instance_valid(enemy_target):
		state_machine.change_state(state_follow)
		return

	if attack_timer.is_stopped():
		enemy_target.health_component.damage(damage_amount)
		attack_timer.start(1)


func _on_necromancer_posessed(value: bool) -> void:
	if health_component.current_health <= 0:
		return

	if value:
		state_machine.change_state(state_posessed)
	else:
		state_machine.change_state(state_follow)
	
func get_player() -> CharacterBody2D:
	return get_tree().get_first_node_in_group(PLAYER_GROUP)

func acquire_target() -> void:
	var player = get_player()
	if player:
		target_position = player.global_position + MathUtils.get_random_direction() * randi_range(16,24)

func _on_target_acquisition_timeout() -> void:
	acquire_target()
	target_acquisition_timer.start(randf_range(0.2, 0.6))	

func _on_died() -> void:
	queue_free()

func _on_hurt() -> void:
	if health_component.is_invincible:
		return
	health_component.is_invincible = true
	invincible_timer.start()


