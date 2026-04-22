extends MeshInstance3D

@export var move_speed: float = 5.0
@export var LIMIT_X: float = 2.0
@export var LIMIT_Y: float = 1.0

func _ready() -> void:
	set_process(true)
	set_process_input(true)

func _process(delta: float) -> void:
	var input_vector := Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1.0
	if Input.is_action_pressed("ui_up"):
		input_vector.y += 1.0
	if Input.is_action_pressed("ui_down"):
		input_vector.y -= 1.0

	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()

	position.x += input_vector.x * move_speed * delta
	position.y += input_vector.y * move_speed * delta
	position.x = clamp(position.x, -LIMIT_X, LIMIT_X)
	position.y = clamp(position.y, -LIMIT_Y, LIMIT_Y)
