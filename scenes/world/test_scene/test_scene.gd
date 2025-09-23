extends Node2D

@onready var necromancer: Necromancer = $Necromancer

@onready var game_lose_component: Control = $CanvasLayer/GameLoseComponent

func _ready() -> void:
	GameManager.toggle_crt(true)