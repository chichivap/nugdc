class_name PixelTransition
extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pixel_rect: ColorRect = $shader_rect 

func transition_to(next_scene: PackedScene) -> void:
    animation_player.play("dissolve")
    await animation_player.animation_finished
    get_tree().change_scene_to_packed.call_deferred(next_scene)
    animation_player.play_backwards("dissolve")