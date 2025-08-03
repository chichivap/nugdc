class_name CorpseSpawnerComponent
extends Node

const CORPSE_SCENE: PackedScene = preload("uid://cvr06bsxotsvl")

@export var health_component: HealthComponent

func _ready() -> void:
	health_component.died.connect(_on_died)


func _on_died() -> void:
	spawn_corpse()
	print("Corpse spawned at position: ", owner.global_position)

func spawn_corpse() -> void:
	var corpse = CORPSE_SCENE.instantiate()
	owner.get_parent().add_child(corpse)
	corpse.global_position = owner.global_position
