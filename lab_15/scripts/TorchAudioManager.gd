extends Node

const FLICKER_SPEED := 1.5
const BASE_DB := 3
const FLICKER_DB := 1.5
const PITCH_VARIATION := 0.03

var _shared_player: AudioStreamPlayer2D
var _torches: Array[Node2D] = []
# Audio flicker params
var _noise := FastNoiseLite.new()
var _t := 0.0


func _ready() -> void:
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	_noise.seed = randi()
	_noise.frequency = 0.6

	_shared_player = AudioStreamPlayer2D.new()
	_shared_player.stream = preload("res://assets/sounds/torch.wav")
	_shared_player.max_distance = 250.0
	_shared_player.attenuation = 1.5
	_shared_player.bus = "SFX"
	add_child(_shared_player)


func _process(delta: float) -> void:
	if _torches.is_empty():
		return

	_t += delta * FLICKER_SPEED

	# Move shared player to nearest torch relative to camera
	var listener_pos := _get_listener_position()
	var nearest := _find_nearest(listener_pos)
	_shared_player.global_position = nearest.global_position

	# Subtle audio flicker
	var n := _noise.get_noise_1d(_t)
	_shared_player.volume_db = BASE_DB + n * FLICKER_DB
	_shared_player.pitch_scale = 1.0 + n * PITCH_VARIATION

	if randf() < 0.015:
		_shared_player.pitch_scale += randf_range(0.05, 0.12)
		_shared_player.volume_db += randf_range(1.0, 2.0)


func register_torch(torch: Node2D) -> void:
	if torch not in _torches:
		_torches.append(torch)
	_update_player_active()


func unregister_torch(torch: Node2D) -> void:
	_torches.erase(torch)
	_update_player_active()


func _update_player_active() -> void:
	if _torches.is_empty():
		_shared_player.stop()
		set_process(false)
	elif not _shared_player.playing:
		_shared_player.play()
		set_process(true)


func _find_nearest(from: Vector2) -> Node2D:
	var best: Node2D = _torches[0]
	var best_dist := from.distance_squared_to(best.global_position)
	for torch in _torches:
		var d := from.distance_squared_to(torch.global_position)
		if d < best_dist:
			best_dist = d
			best = torch
	return best


func _get_listener_position() -> Vector2:
	var vp := get_viewport()
	if vp:
		return vp.get_camera_2d().global_position if vp.get_camera_2d() else vp.get_visible_rect().get_center()
	return Vector2.ZERO
