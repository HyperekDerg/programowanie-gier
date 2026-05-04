extends CharacterBody2D

## Player Movement Settings
@export_group("Movement")
@export var speed: float = 140.0
@export var acceleration: float = 400.0
@export var friction: float = 600.0

@export_group("Jump")
@export var jump_velocity: float = -250.0
@export var gravity_scale: float = 1.0

func _physics_process(delta: float) -> void:
	#Apply Gravity
	if not is_on_floor():
		velocity += get_gravity() * gravity_scale * delta

	# Handle Jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Handle Horizontal Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		# Gradually reach top speed
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		# Gradually stop
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Execute Movement
	move_and_slide()
