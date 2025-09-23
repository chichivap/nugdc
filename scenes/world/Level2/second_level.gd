extends Node2D

const LEVEL_ID = 2

@onready var trapdoor: Trapdoor = $YSortOrigin/Trapdoor
@onready var permanent_pressure_plate: PermanentPressurePlate = $YSortOrigin/PermanentPressurePlate
@onready var skill_layer: CanvasLayer = $YSortOrigin/Necromancer/SpellUI
@onready var skeleton_perm_pressure_plate: SkeletonPermPressurePlate = $YSortOrigin/SkeletonPermPressurePlate

func _ready():
	skill_layer.visible = true


func _process(_delta: float) -> void:
	if permanent_pressure_plate.pressed and skeleton_perm_pressure_plate.pressed:
		trapdoor.open()
	else:
		trapdoor.close()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		GameEvent.restart_level(LEVEL_ID)