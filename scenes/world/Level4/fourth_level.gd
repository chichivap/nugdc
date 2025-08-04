extends Node2D

const LEVEL_ID = 4

@onready var dynamic_pressure_plate: DynamicPressurePlate = $YSortOrigin/DynamicPressurePlate
@onready var trapdoor: Trapdoor = %Trapdoor

func _process(_delta):
    if dynamic_pressure_plate.pressed:
        trapdoor.open()
    else:
        trapdoor.close()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("restart"):
        GameEvent.restart_level(LEVEL_ID)