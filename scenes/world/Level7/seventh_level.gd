extends Node2D

const LEVEL_ID = 7

@onready var trapdoor: Trapdoor = $YSortOrigin/Trapdoor
@onready var goblin: Goblin = $YSortOrigin/Goblin
@onready var goblin_2: Goblin = $YSortOrigin/Goblin2
@onready var dynamic_pressure_plate: DynamicPressurePlate = $YSortOrigin/DynamicPressurePlate
@onready var permanent_pressure_plate: PermanentPressurePlate = $YSortOrigin/PermanentPressurePlate
@onready var skeleton_perm_pressure_plate: SkeletonPermPressurePlate = $YSortOrigin/SkeletonPermPressurePlate

func _process(_delta: float) -> void:
	if !is_instance_valid(goblin_2) and !is_instance_valid(goblin) and dynamic_pressure_plate.pressed and permanent_pressure_plate.pressed and skeleton_perm_pressure_plate.pressed:
		trapdoor.open()
	else:
		trapdoor.close()
