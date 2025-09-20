class_name FollowComponent
extends Node

enum TargetType {
	NECROMANCER,
	SKELETON,
	NULL
}
var target_type: TargetType = TargetType.NULL
@export var target_position: Vector2
@export var actor: CharacterBody2D
@onready var target_acquisition_timer: Timer = $TargetAcquisitionTimer


func start_follow(target: TargetType) -> void:
	match target:
		TargetType.NECROMANCER:
			target_type = TargetType.NECROMANCER

		TargetType.SKELETON:
			target_type = TargetType.SKELETON

		_:
			push_error("FollowComponent: Unknown target type '%s'" % target)

func stop_follow() -> void:
	target_type = TargetType.NULL

func _process(_delta):
	if target_type == TargetType.NULL:
		return
	var direction = actor.global_position.direction_to(target_position)

	if actor.global_position.distance_to(target_position) > 0.5:
		actor.velocity = direction * actor.SPEED
		actor.move_and_slide()
	else:
		actor.global_position = target_position

func _on_target_acquisition_timer_timeout() -> void:
	match target_type:
		TargetType.NECROMANCER:
			acquire_necromancer_target()
		TargetType.SKELETON:
			acquire_skeleton_target()
		
		TargetType.NULL:
			stop_follow()
		_:
			push_error("FollowComponent: Unknown target type '%s'" % target_type)
	target_acquisition_timer.start(0.7)	

func acquire_skeleton_target() -> void:
	if is_instance_valid(get_skeleton()):
		var skeleton = get_skeleton()
		target_position = skeleton.global_position + MathUtils.get_random_direction() * randi_range(16,24)

func acquire_necromancer_target() -> void:
	if is_instance_valid(get_necromancer()):
		var necromancer = get_necromancer()
		target_position = necromancer.global_position + MathUtils.get_random_direction() * randi_range(16,24)

func get_skeleton() -> CharacterBody2D:
	return get_tree().get_first_node_in_group("skeleton")

func get_necromancer() -> CharacterBody2D:
	return get_tree().get_first_node_in_group("player")
