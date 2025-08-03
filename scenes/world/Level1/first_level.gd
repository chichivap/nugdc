extends Node2D

@onready var permanent_pressure_plate: PermanentPressurePlate = $YSortOrigin/PermanentPressurePlate
@onready var trapdoor: Trapdoor = %Trapdoor
@onready var skill_layer: CanvasLayer = $YSortOrigin/Necromancer/SpellUI
func _ready():
	skill_layer.visible = false
	PostProcessing.set_shader_param('scanline_strength', 0.16)
	PostProcessing.set_shader_param('vigniette_strength', 1)
	PostProcessing.set_shader_param('noise_strength', 0.047)
	PostProcessing.set_shader_param('glow_strength', 0.3)
	PostProcessing.set_shader_param('glow_radius', 1.0)
func _process(_delta: float) -> void:
	if permanent_pressure_plate.pressed:
		trapdoor.open()
	else:
		trapdoor.close()
