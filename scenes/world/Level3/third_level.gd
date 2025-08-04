extends Node2D

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


