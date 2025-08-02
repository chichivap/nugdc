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
signal resurrected

var state_machine := CallableStateMachine.new()
var target_position : Vector2
var last_faced_direction: Vector2
var enemy_target: CharacterBody2D

@onready var bone_pile: Sprite2D = $BonePile
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var target_acquisition_timer: Timer = $TargetAcquisitionTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_timer: Timer = $AttackTimer
@onready var marker: Sprite2D = $Marker
@onready var health_bar_component: HealthBarComponent = $HealthBarComponent
func _ready() -> void:
	state_machine.add_state(state_follow, Callable(), Callable())
	state_machine.add_state(state_posessed, Callable(), Callable())
	state_machine.add_state(state_attack, Callable(), Callable())
	state_machine.add_state(state_corpse, Callable(), Callable())
	
	state_machine.set_initial_state(state_follow)

	target_acquisition_timer.timeout.connect(_on_target_acquisition_timeout)

	health_component.died.connect(_on_died)

	necromancer_posessed.connect(_on_necromancer_posessed)
	resurrected.connect(_on_resurrected)
func _process(_delta: float) -> void:
	state_machine.update()
	
func state_follow() -> void:
	
	bone_pile.visible = false
	sprite_2d.visible = true
	if health_component.current_health <= 0:
		return
	marker.visible = false
	var direction = global_position.direction_to(target_position)

	#if is_instance_valid(enemy_target):
	#	state_machine.change_state(state_attack)

	if global_position.distance_to(target_position) > 0.5:
		velocity = direction * SPEED
		move_and_slide()
	else:
		global_position = target_position
	print("state_follow")


func get_player() -> CharacterBody2D:
	return get_tree().get_first_node_in_group(PLAYER_GROUP)

func acquire_target() -> void:
	var player = get_player()
	if player:
		target_position = player.global_position + MathUtils.get_random_direction() * randi_range(16,24)



func _on_target_acquisition_timeout() -> void:
	acquire_target()
	target_acquisition_timer.start(randf_range(0.2, 0.6))

func state_posessed() -> void:
	bone_pile.visible = false
	sprite_2d.visible = true
	marker.modulate = Color(1, 1, 0)
	velocity = GameManager.get_direction() * SPEED
	move_and_slide()
	marker.visible = true

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
	bone_pile.visible = false
	sprite_2d.visible = true
	SPEED = 120 
	move_and_slide()
	marker.modulate = Color(1, 0, 0)
	if is_instance_valid(enemy_target):
		if enemy_target.global_position.distance_to(global_position) > COMBAT_RANGE && state_machine.current_state == "state_attack":
			state_machine.change_state(state_posessed)

	if !is_instance_valid(enemy_target):
		state_machine.change_state(state_follow)
		return

	if attack_timer.is_stopped():
		enemy_target.health_component.damage(randf_range(.5, 1.5))
		attack_timer.start(randf_range(0.1,0.2))
	

func _on_died() -> void:
	state_machine.change_state(state_corpse)

func state_corpse() -> void:
	health_bar_component.progress_bar.visible = false

	velocity = Vector2.ZERO

	bone_pile.visible = true
	sprite_2d.visible = false
	#resurrected.connect(_on_resurrected)
	
	

func _on_necromancer_posessed(value: bool) -> void:
	if health_component.current_health <= 0:
		return
	if value:
		state_machine.change_state(state_posessed)
	else:
		state_machine.change_state(state_follow)

func _on_resurrected() -> void:
	bone_pile.visible = false
	sprite_2d.visible = true
	health_bar_component.progress_bar.visible = false
	state_machine.change_state(state_follow)

	health_component.current_health = health_component.max_health
	