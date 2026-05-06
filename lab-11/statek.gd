extends MeshInstance3D

const MAX_BULLETS := 5

@export var move_speed: float = 5.0
@export var LIMIT_X: float = 2.0
@export var LIMIT_Y: float = 1.0
@export var bullet_scene: PackedScene
@export var shoot_cooldown_time: float = 0.3

var active_bullets: Array = []
var _shoot_cooldown: float = 0.0


func _ready() -> void:
	add_to_group("player")
	set_process(true)
	set_process_input(true)


func _process(delta: float) -> void:
	# Cooldown
	if _shoot_cooldown > 0.0:
		_shoot_cooldown -= delta

	# Strzał
	if Input.is_action_just_pressed("ui_accept") \
	and _shoot_cooldown <= 0.0 \
	and active_bullets.size() < MAX_BULLETS:
		_shoot_cooldown = shoot_cooldown_time
		_shoot()

	# Ruch
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


func _shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.bullet_type = "player"
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = Vector3(0, 0, -1)
	active_bullets.append(bullet)
	bullet.tree_exited.connect(
		func():
			active_bullets.erase(bullet)
	)
