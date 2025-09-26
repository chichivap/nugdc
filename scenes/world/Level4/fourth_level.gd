extends Node2D

const LEVEL_ID = 4

@onready var dynamic_pressure_plate: DynamicPressurePlate = $YSortOrigin/DynamicPressurePlate
@onready var trapdoor: Trapdoor = %Trapdoor
@onready var skeleton_perm_pressure_plate: SkeletonPermPressurePlate = $YSortOrigin/SkeletonPermPressurePlate
func _process(_delta):
    if dynamic_pressure_plate.pressed and skeleton_perm_pressure_plate.pressed:
        trapdoor.open()
    else:
        trapdoor.close()
