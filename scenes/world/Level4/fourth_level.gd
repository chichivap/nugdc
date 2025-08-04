extends Node2D

@onready var dynamic_pressure_plate: DynamicPressurePlate = $YSortOrigin/DynamicPressurePlate
@onready var trapdoor: Trapdoor = %Trapdoor

func _process(_delta):
    if dynamic_pressure_plate.pressed:
        trapdoor.open()
    else:
        trapdoor.close()