extends AnimatableBody2D

@onready var point_light_2d: PointLight2D = $PointLight2D

@export var flicker_speed: float = 2.0
@export var jitter_strength: float = 0.4
@export var min_energy: float = 0.4
@export var max_energy: float = 1.2

var noise := FastNoiseLite.new()
var t := 0.0

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = randi()
	noise.frequency = 0.8

func _process(delta: float) -> void:
	t += delta * flicker_speed

	# Two noise samples offset in time — richer than one + randf
	var n1 = noise.get_noise_1d(t)
	var n2 = noise.get_noise_1d(t * 2.3 + 17.0)
	var combined = n1 * 0.7 + n2 * 0.3

	# Occasional sharp jitter (not every frame)
	if randf() < 0.08:
		combined += randf_range(-jitter_strength, jitter_strength)

	point_light_2d.energy = lerp(min_energy, max_energy, clamp(combined * 0.5 + 0.5, 0.0, 1.0))
