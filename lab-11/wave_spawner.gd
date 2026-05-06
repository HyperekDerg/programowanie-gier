extends Node

@export var enemy_scene: PackedScene
@export var path_follow: PathFollow3D
@export var bullet_scene: PackedScene

var waves = [
	{ "count": 3, "x_positions": [-3.0, 0.0, 3.0], "z_offset": -30.0, "delay": 0.0 },
	{ "count": 5, "x_positions": [-4.0, -2.0, 0.0, 2.0, 4.0], "z_offset": -40.0, "delay": 3.0 },
	{ "count": 2, "x_positions": [-2.0, 2.0], "z_offset": -25.0, "delay": 6.0 },
]
var _time: float = 0.0


func _process(delta: float) -> void:
	if path_follow == null:
		push_error("WaveSpawner: path_follow is NOT assigned!")
		return

	if not path_follow.is_inside_tree():
		return

	if waves.is_empty():
		return

	_time += delta

	var wave = waves[0]
	if _time >= wave.delay:
		_spawn_wave(wave)
		waves.pop_front()


func _spawn_wave(wave: Dictionary) -> void:
	if path_follow == null or not path_follow.is_inside_tree():
		return

	var base_pos: Vector3 = path_follow.global_position

	for i in range(wave.count):
		var enemy = enemy_scene.instantiate()

		var x: float = wave.x_positions[i]
		var z: float = wave.z_offset

		get_tree().current_scene.add_child(enemy)
		enemy.global_position = base_pos + Vector3(wave.x_positions[i], 0.0, wave.z_offset)
		enemy.bullet_scene = bullet_scene
