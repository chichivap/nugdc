class_name FlashingLoopComponent
extends Node


@export var health_component: HealthComponent

@export var animated_sprite_2d: AnimatedSprite2D

@export var animation_player: AnimationPlayer
var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)

func _process(_delta: float) -> void:
	if !health_component.is_invincible:
		animated_sprite_2d.visible = true
	animation_player.play("flash")
