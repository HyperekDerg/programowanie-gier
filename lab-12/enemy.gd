extends Node3D

signal died(points: int)

@export var hp: int = 2
@export var speed: float = 3.0
@export var score_value: int = 100
@export var bullet_scene: PackedScene
@export var shoot_interval: float = 2.5
@export var sway_amplitude: float = 1.0
@export var sway_period: float = 2.0
@export var min_distance: float = 5.0
@export var retreat_speed: float = 6.0

var _shoot_timer: float = 0.0
var _start_x: float
var _sway_time: float = 0.0
var _retreating: bool = false


func _ready() -> void:
	$Area3D.monitorable = true
	$Area3D.monitoring = true
	$Area3D.area_entered.connect(_on_area_entered)
	_reset_shoot_timer()
	call_deferred("_init_sway")


func _process(delta: float) -> void:
	var player := _get_player()

	if not _retreating and player:
		var dist := global_position.distance_to(player.global_position)
		if dist < min_distance:
			_retreating = true

	if _retreating:
		position.z -= retreat_speed * delta
	else:
		position.z += speed * delta

	_sway_time += delta
	position.x = _start_x + sin((_sway_time / sway_period) * TAU) * sway_amplitude

	if not _retreating:
		_shoot_timer -= delta
		if _shoot_timer <= 0.0:
			_shoot()
			_reset_shoot_timer()

	if _retreating and position.z < -50.0:
		queue_free()


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
	if bullet_scene == null:
		return
	var spread := Vector3(randf_range(-0.05, 0.05), 0.0, 1.0).normalized()
	var bullet = bullet_scene.instantiate()
	bullet.bullet_type = "enemy"
	bullet.direction = spread
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position + Vector3(0, 0, 1)


func _on_area_entered(area: Area3D) -> void:
	if area.collision_layer != 3:
		return
	hp -= 1
	print("Enemy HP: ", hp)
	if hp <= 0:
		died.emit(score_value)
		queue_free()
