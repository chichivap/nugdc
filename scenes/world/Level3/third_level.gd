extends Node2D

const LEVEL_ID = 3

@onready var skeleton_perm_pressure_plate: SkeletonPermPressurePlate = $YSortOrigin/SkeletonPermPressurePlate
@onready var permanent_pressure_plate: PermanentPressurePlate = $YSortOrigin/PermanentPressurePlate
@onready var trapdoor: Trapdoor = $YSortOrigin/Trapdoor
@onready var goblin: Goblin = $YSortOrigin/Goblin
@onready var tutorial_menu: CombatTutorialMenu = $TutorialMenu

func _ready():
	tutorial_menu.timer.start()
	tutorial_menu.timer.timeout.connect(_on_timer_timeout)

func _process(_delta: float) -> void:
	if permanent_pressure_plate.pressed and skeleton_perm_pressure_plate.pressed and !is_instance_valid(goblin):
		trapdoor.open()
	else:
		trapdoor.close()

func _on_timer_timeout() -> void:
	tutorial_menu.show_tutorial(true)

