extends Node2D

const LEVEL_ID = 3

@onready var skeleton_perm_pressure_plate: SkeletonPermPressurePlate = $YSortOrigin/SkeletonPermPressurePlate
@onready var permanent_pressure_plate: PermanentPressurePlate = $YSortOrigin/PermanentPressurePlate
@onready var trapdoor: Trapdoor = $YSortOrigin/Trapdoor
@onready var goblin: Goblin = $YSortOrigin/Goblin
func _ready():
	pass

func _process(_delta: float) -> void:
	if permanent_pressure_plate.pressed and skeleton_perm_pressure_plate.pressed and !is_instance_valid(goblin):
		trapdoor.open()
	else:
		trapdoor.close()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		GameEvent.restart_level(LEVEL_ID)