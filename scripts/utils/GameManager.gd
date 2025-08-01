class_name GameManager

const ACTION_MOVE_UP: StringName = "move_up" 
const ACTION_MOVE_DOWN: StringName = "move_down"
const ACTION_MOVE_LEFT: StringName = "move_left"
const ACTION_MOVE_RIGHT: StringName = "move_right"

static func get_direction() -> Vector2:
	return Input.get_vector(
		ACTION_MOVE_LEFT, ACTION_MOVE_RIGHT,
		ACTION_MOVE_UP, ACTION_MOVE_DOWN
	)
