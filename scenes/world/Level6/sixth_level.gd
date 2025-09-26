extends Node2D

const LEVEL_ID = 6

@onready var trapdoor: Trapdoor = %Trapdoor
@onready var dynamic_pressure_plate_1: DynamicPressurePlate = $YSortOrigin/DynamicPressurePlate1
@onready var goblin: Goblin = $YSortOrigin/Goblin

func _process(_delta: float) -> void:
	if dynamic_pressure_plate_1.pressed and !is_instance_valid(goblin):
		trapdoor.open()
	else:
		trapdoor.close()

