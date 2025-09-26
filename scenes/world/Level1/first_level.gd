extends Node2D

const LEVEL_ID = 1

@onready var permanent_pressure_plate: PermanentPressurePlate = $YSortOrigin/PermanentPressurePlate
@onready var trapdoor: Trapdoor = %Trapdoor
@onready var skill_layer: CanvasLayer = $YSortOrigin/Necromancer/SpellUI
func _ready():
	skill_layer.visible = false

func _process(_delta: float) -> void:
	if permanent_pressure_plate.pressed:
		trapdoor.open()
	else:
		trapdoor.close()


	
