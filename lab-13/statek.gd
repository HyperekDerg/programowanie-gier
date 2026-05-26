extends Area3D

const MAX_BULLETS := 5

@export var move_speed: float = 5.0
@export var LIMIT_X: float = 2.0
@export var LIMIT_Y: float = 1.0
@export var bullet_scene: PackedScene
@export var shoot_cooldown_time: float = 0.3

var active_bullets: Array = []
var _shoot_cooldown: float = 0.0
var is_invincible: bool = false

@onready var wall_1: StaticBody3D = $"../../../World/Wall1"
@onready var wall_2: StaticBody3D = $"../../../World/Wall2"
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	add_to_group("player")
	body_entered.connect(_on_body_entered)
	GameManager.game_over.connect(_on_game_over)
	GameManager.hp_changed.connect(_on_hp_changed)

func _on_game_over() -> void:
	add_to_group("player")
	set_process(false)
	set_process_input(false)
	# np. get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _on_hp_changed(new_hp: int) -> void:
	if new_hp < GameManager.player_max_hp:
		anim_player.play("hit")


func _on_body_entered(body: Node3D) -> void:
	if body == wall_1 or body == wall_2:
		_take_damage(1)


func _take_damage(amount: int = 1) -> void:
	if is_invincible:
		return
	GameManager.player_hit(amount)


func _barrel_roll() -> void:
	if is_invincible:
		return
	is_invincible = true
	anim_player.play("barrel_roll")
	await anim_player.animation_finished
	is_invincible = false


func _process(delta: float) -> void:
	_handle_shoot(delta)
	_handle_movement(delta)

func _handle_shoot(delta: float) -> void:
	if _shoot_cooldown > 0.0:
		_shoot_cooldown -= delta

	if Input.is_action_just_pressed("ui_accept") \
	and _shoot_cooldown <= 0.0 \
	and active_bullets.size() < MAX_BULLETS:
		_shoot_cooldown = shoot_cooldown_time
		_shoot()

func _handle_movement(delta: float) -> void:
	if Input.is_action_just_pressed("barell_roll"):
		_barrel_roll()

	var input_vector := Vector2.ZERO
	if Input.is_action_pressed("ui_left"):  input_vector.x -= 1.0
	if Input.is_action_pressed("ui_right"): input_vector.x += 1.0
	if Input.is_action_pressed("ui_up"):    input_vector.y += 1.0
	if Input.is_action_pressed("ui_down"):  input_vector.y -= 1.0

	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()

	position.x = clamp(position.x + input_vector.x * move_speed * delta, -LIMIT_X, LIMIT_X)
	position.y = clamp(position.y + input_vector.y * move_speed * delta, -LIMIT_Y, LIMIT_Y)


func _shoot() -> void:
	var bullet := bullet_scene.instantiate()
	bullet.bullet_type = "player"
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = Vector3(0, 0, -1)
	active_bullets.append(bullet)
	bullet.tree_exited.connect(func(): active_bullets.erase(bullet))
	
