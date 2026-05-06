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

## Audio Levels
@export_group("Audio Levels (dB)")
@export var volume_jump_db: float = -2.0
@export var volume_death_db: float = 6.0

var dead: bool = false
var crouching: bool = false
var _was_walking: bool = false
var _jump_lock: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $DeathTimer
@onready var collider_stand = $CollisionShape2D
@onready var collider_crouch = $CollisionShape2D_Crouch
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

const SFX_STEP  = preload("res://assets/sounds/walk.mp3")
const SFX_JUMP  = preload("res://assets/sounds/jump.mp3")
const SFX_DEATH = preload("res://assets/sounds/sonicded.mp3")

func _play(stream: AudioStream, volume_db: float) -> void:
	sfx.stream = stream
	sfx.volume_db = volume_db
	sfx.play()

func _set_walking_audio(walking: bool) -> void:
	if _jump_lock > 0.0:
		return
	if walking == _was_walking:
		return
	_was_walking = walking
	if walking:
		sfx.stream = SFX_STEP
		sfx.play()
	else:
		sfx.stop()

func _physics_process(delta: float) -> void:
	if _jump_lock > 0.0:
		_jump_lock -= delta
	if dead:
		velocity.y += get_gravity().y * delta
		move_and_slide()
		return

	# Apply Gravity
	if not is_on_floor():
		velocity += get_gravity() * gravity_scale * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not crouching:
		velocity.y = jump_velocity
		_jump_lock = 0.15
		sfx.stop()
		_was_walking = false
		_play(SFX_JUMP, volume_jump_db)

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

	# Footstep audio — play/stop on state change only
	var is_walking := is_on_floor() and direction != 0 and not crouching
	_set_walking_audio(is_walking)

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
	sfx.stop()
	_was_walking = false
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	animated_sprite.play("Death")
	_play(SFX_DEATH, volume_death_db)
	velocity.y = -300
	death_timer.start()

func _on_DeathTimer_timeout() -> void:
	get_tree().reload_current_scene()
