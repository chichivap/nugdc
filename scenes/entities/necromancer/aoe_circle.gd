extends Node2D

var circle_color_static : Color = Color(0.439, 0.4, 0.459, 0.2)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 48, circle_color_static)
	draw_arc(Vector2.ZERO, 48, 0, TAU, 32, circle_color_static, 2.0)

func _process(_delta):
	queue_redraw()
