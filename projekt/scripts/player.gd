extends CharacterBody2D
## Player Movement Settings

@export_group("Movement")
@export var speed: float = 140.0
@export var run_speed: float = 220.0
@export var crouch_speed: float = 25.0
@export var acceleration: float = 400.0
@export var friction: float = 600.0
@export_group("Jump")
@export var jump_velocity: float = -250.0
@export var gravity_scale: float = 1.0

var dead: bool = false
var crouching: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $DeathTimer
@onready var collider_stand = $CollisionShape2D
@onready var collider_crouch = $CollisionShape2D_Crouch


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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not crouching:
		velocity.y = jump_velocity

	# Handle Horizontal Movement
	var direction := Input.get_axis("ui_left", "ui_right")

	# Running (Shift)
	var current_speed := speed
	if Input.is_action_pressed("ui_shift") and is_on_floor():
		current_speed = run_speed

	# Crouch
	if Input.is_action_pressed("ui_down") and is_on_floor():
		crouching = true
		collider_stand.set_deferred("disabled", true)
		collider_crouch.set_deferred("disabled", false)

		# set speed of crouch-walk
		current_speed = crouch_speed
	else:
		crouching = false
		collider_stand.set_deferred("disabled", false)
		collider_crouch.set_deferred("disabled", true)

	# Acceleration / Friction
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * current_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Animations
	if crouching and is_on_floor():
		animated_sprite.play("Crouch")

		if direction == 0:
			animated_sprite.speed_scale = 0
			animated_sprite.frame = 0
		else:
			animated_sprite.speed_scale = 0.8
	else:
		animated_sprite.speed_scale = 1.0

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
	velocity = Vector2.ZERO

	$CollisionShape2D.set_deferred("disabled", true)
	animated_sprite.play("Death")

	velocity.y = -300
	death_timer.start()


func _on_DeathTimer_timeout() -> void:
	get_tree().reload_current_scene()
