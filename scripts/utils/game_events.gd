class_name GameEvents
extends Node

var current_level: int = 0

var first_level: PackedScene = preload("uid://cd1o03tuhuo40")
var second_level: PackedScene = preload("uid://npek0mnbykcy")
var third_level: PackedScene = preload("uid://cj75bp0dc2bld")
var fourth_level: PackedScene = preload("uid://c5ka12evskcej")
var fifth_level: PackedScene = preload("uid://nthnqa2ckrb0")
var sixth_level: PackedScene = preload("uid://bmaq0ycauoabx")
var seventh_level: PackedScene = preload("uid://debhycifde0ro")
var game_end: PackedScene = preload("uid://goavjgafunoi")


const TRANSITION_SCENE: PackedScene = preload("uid://bbwobgmcbrmmi")

var transition: PixelTransition

func _ready() -> void:
	transition = TRANSITION_SCENE.instantiate()
	add_child(transition)

func skip_level():
	completed_level()



func completed_level():
	current_level += 1
	var next_scene = match_level_scene(current_level)
	if next_scene:
		transition.transition_to(next_scene)

func restart_level(value):
	match value:
		1:
			await transition.transition_to(first_level)
			get_tree().change_scene_to_packed.call_deferred(first_level)
		
		2:
			await transition.transition_to(second_level)
			get_tree().change_scene_to_packed.call_deferred(second_level)
	
		3:
			await transition.transition_to(third_level)
			get_tree().change_scene_to_packed.call_deferred(third_level)

		4:
			await transition.transition_to(fourth_level)
			get_tree().change_scene_to_packed.call_deferred(fourth_level)
		5:
			await transition.transition_to(fifth_level)
			get_tree().change_scene_to_packed.call_deferred(fifth_level)
		6:
			await transition.transition_to(sixth_level)
			get_tree().change_scene_to_packed.call_deferred(sixth_level)
		7:
			await transition.transition_to(seventh_level)
			get_tree().change_scene_to_packed.call_deferred(seventh_level)

		8:
			get_tree().change_scene_to_packed.call_deferred(game_end)


func match_level_scene(level: int) -> PackedScene:
	match level:
		1: return first_level
		2: return second_level
		3: return third_level
		4: return fourth_level
		5: return fifth_level
		6: return sixth_level
		7: return seventh_level
		8: return game_end
		_: return
