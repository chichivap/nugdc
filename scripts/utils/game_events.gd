class_name GameEvents
extends Node

var current_level: int = 1

var first_level: PackedScene = preload("uid://cd1o03tuhuo40")
var second_level: PackedScene = preload("uid://npek0mnbykcy")
var third_level: PackedScene = preload("uid://cj75bp0dc2bld")
var fourth_level: PackedScene = preload("uid://c5ka12evskcej")
var fifth_level: PackedScene = preload("uid://nthnqa2ckrb0")

func completed_level():
	current_level += 1
	match current_level:
		2:
			get_tree().change_scene_to_packed.call_deferred(second_level)
		3:
			get_tree().change_scene_to_packed.call_deferred(third_level)
		4:
			get_tree().change_scene_to_packed.call_deferred(fourth_level)
		5:
			get_tree().change_scene_to_packed.call_deferred(fifth_level)


		