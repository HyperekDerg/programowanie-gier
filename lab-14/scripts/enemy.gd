extends Node3D

signal died(points: int)

@export var hp: int = 2
@export var speed: float = 3.0
@export var score_value: int = 100
@export var bullet_scene: PackedScene
@export var shoot_interval: float = 2.5
@export var sway_amplitude: float = 1.0
@export var sway_period: float = 2.0

@export var min_distance: float = 8.0
@export var max_distance: float = 25.0
@export var retreat_speed: float = 10.0
@export var catch_up_speed: float = 20.0

@export var explosion_scene: PackedScene

const BULLET_SPAWN_OFFSET := Vector3(0, 0, 1)
const EXPLOSION_SCALE      := 0.5
const SPREAD_RANGE         := 0.05

var _shoot_timer: float = 0.0
var _start_x: float
var _sway_time: float = 0.0
var _retreating: bool = false
var _catching_up: bool = false

var _follow_player: bool = false
var _follow_offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	$Area3D.monitorable = true
	$Area3D.monitoring = true
	$Area3D.area_entered.connect(_on_area_entered)
	_reset_shoot_timer()
	call_deferred("_init_sway")
	died.connect(GameManager.add_score)

	if GameManager.has_signal("path_end_reached"):
		GameManager.path_end_reached.connect(_on_path_end_reached)

func _process(delta: float) -> void:
	var player := _get_player()
	
	if _follow_player:
		if player:
			_sway_time += delta
			var current_sway = sin((_sway_time / sway_period) * TAU) * sway_amplitude
			global_position.z = player.global_position.z + _follow_offset.z
			global_position.x = player.global_position.x + _follow_offset.x + current_sway
			global_position.y = player.global_position.y + _follow_offset.y
		return

	if player:
		var dist = global_position.distance_to(player.global_position)
		
		if dist < min_distance:
			_retreating = true
			_catching_up = false
		elif dist > max_distance:
			_catching_up = true
			_retreating = false
		else:
			_retreating = false
			_catching_up = false

	# 3. Wykonanie ruchu
	if _retreating:
		position.z -= retreat_speed * delta
	elif _catching_up:
		position.z += catch_up_speed * delta
	else:
		position.z += speed * delta

	_sway_time += delta
	position.x = _start_x + sin((_sway_time / sway_period) * TAU) * sway_amplitude

	if not _retreating and not _catching_up:
		_shoot_timer -= delta
		if _shoot_timer <= 0.0:
			_shoot()
			_reset_shoot_timer()

func _init_sway() -> void:
	_start_x = position.x

func _get_player() -> Node3D:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0] as Node3D
	return null

func _reset_shoot_timer() -> void:
	_shoot_timer = shoot_interval

func _shoot() -> void:
	var spread := Vector3(randf_range(-SPREAD_RANGE, SPREAD_RANGE), 0.0, 1.0).normalized()
	_spawn_bullet(spread)

func _spawn_bullet(dir: Vector3) -> void:
	if bullet_scene == null: return
	var bullet = bullet_scene.instantiate()
	bullet.bullet_type = "enemy"
	bullet.direction = dir
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position + BULLET_SPAWN_OFFSET

func _on_path_end_reached() -> void:
	var player := _get_player()
	if player:
		var current_sway = sin((_sway_time / sway_period) * TAU) * sway_amplitude
		_follow_offset = global_position - player.global_position
		_follow_offset.x -= current_sway
		_follow_player = true
		_retreating = false
		_catching_up = false

func _on_area_entered(area: Area3D) -> void:
	if area.collision_layer != 3: return
	hp -= 1
	if hp <= 0: _die()

func _die() -> void:
	_spawn_explosion()
	died.emit(score_value)
	queue_free()

func _spawn_explosion() -> void:
	if explosion_scene == null: return
	var explosion = explosion_scene.instantiate()
	get_tree().root.add_child(explosion)
	explosion.global_position = global_position
	explosion.scale = Vector3.ONE * EXPLOSION_SCALE
