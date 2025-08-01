class_name MathUtils

static func get_random_direction() -> Vector2:
    return Vector2.RIGHT.rotated(randf() * TAU)