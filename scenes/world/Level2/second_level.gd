extends Node2D

const LEVEL_ID = 2

@onready var trapdoor: Trapdoor = $YSortOrigin/Trapdoor
@onready var permanent_pressure_plate: PermanentPressurePlate = $YSortOrigin/PermanentPressurePlate
@onready var skill_layer: CanvasLayer = $YSortOrigin/Necromancer/SpellUI
@onready var skeleton_perm_pressure_plate: SkeletonPermPressurePlate = $YSortOrigin/SkeletonPermPressurePlate
@onready var tutorial_layer: TutorialSecondLevel = $TutorialLayer
@onready var ysort_origin: Node2D = $YSortOrigin
@onready var necromancer: Necromancer = $YSortOrigin/Necromancer

var skeleton_resurrected: bool = false:
	set(value):
		skeleton_resurrected = value

func _ready():
	skill_layer.visible = true
	tutorial_layer.timer.start()
	tutorial_layer.timer.timeout.connect(_on_tutorial_timer_timeout)
	necromancer.first_resurrection_ended.connect(_on_first_resurrection)

func _process(_delta: float) -> void:
	if permanent_pressure_plate.pressed and skeleton_perm_pressure_plate.pressed:
		trapdoor.open()
	else:
		trapdoor.close()
	
	if ysort_origin.has_node("Skeleton"):
		skeleton_resurrected = true
		

func _on_tutorial_timer_timeout() -> void:
	tutorial_layer.show_key_r(true)


func _on_first_resurrection(value) -> void:
	if value != 1:
		return
	tutorial_layer.show_spacebar(true)	

