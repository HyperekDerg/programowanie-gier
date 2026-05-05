extends CharacterBody2D

## Player Movement Settings
@export_group("Movement")
@export var speed: float = 140.0
@export var run_speed: float = 220.0
@export var acceleration: float = 400.0
@export var friction: float = 600.0

@export_group("Jump")
@export var jump_velocity: float = -250.0
@export var gravity_scale: float = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $DeathTimer

var dead: bool = false


func _physics_process(delta: float) -> void:
	if dead:
		# Death
		velocity.y += get_gravity().y * delta
		move_and_slide()
		return

	# Apply Gravity
	if not is_on_floor():
		velocity += get_gravity() * gravity_scale * delta

	# Handle Jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Handle Horizontal Movement
	var direction := Input.get_axis("ui_left", "ui_right")

	# Running (Shift)
	var current_speed := speed
	if Input.is_action_pressed("ui_shift") and is_on_floor():
		current_speed = run_speed

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Acceleration / Friction
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * current_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Animations
	if not is_on_floor():
		animated_sprite.play("Jump")
	else:
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			if current_speed == run_speed:
				animated_sprite.play("Run")
			else:
				animated_sprite.play("Walk")

	move_and_slide()


func die() -> void:
	if dead:
		return

	dead = true

	# Stop movement
	velocity = Vector2.ZERO

	# Disable collision safely
	$CollisionShape2D.set_deferred("disabled", true)

	# Play death animation
	animated_sprite.play("Death")

	# Mario jump
	velocity.y = -300

	# Restart timer
	death_timer.start()


func _on_DeathTimer_timeout() -> void:
	get_tree().reload_current_scene()
