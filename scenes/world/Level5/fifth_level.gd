extends Node2D

const LEVEL_ID = 5

@onready var skeleton_perm_pressure_plate: SkeletonPermPressurePlate = $YSortOrigin/SkeletonPermPressurePlate
@onready var dynamic_pressure_plate_1: DynamicPressurePlate = $YSortOrigin/DynamicPressurePlate1
@onready var dynamic_pressure_plate_2: DynamicPressurePlate = $YSortOrigin/DynamicPressurePlate2

@onready var trapdoor: Trapdoor = $YSortOrigin/Trapdoor
@onready var goblin: Goblin = $YSortOrigin/Goblin


func _process(_delta: float) -> void:
	if !is_instance_valid(goblin) and dynamic_pressure_plate_1.pressed and skeleton_perm_pressure_plate.pressed and dynamic_pressure_plate_2.pressed:
		trapdoor.open()
	else:
		trapdoor.close()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		GameEvent.restart_level(LEVEL_ID)
