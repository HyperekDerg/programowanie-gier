extends AnimatableBody2D

@export var flicker_speed: float = 2.0
@export var jitter_strength: float = 0.4
@export var min_energy: float = 0.4
@export var max_energy: float = 1.2

var noise := FastNoiseLite.new()
var t := 0.0

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var screen_notifier: VisibleOnScreenNotifier2D = $ScreenNotifier


func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = randi()
	noise.frequency = 0.8

	# Start disabled screen notifier enables on demand
	set_process(false)
	point_light_2d.enabled = false

	screen_notifier.screen_entered.connect(_on_screen_entered)
	screen_notifier.screen_exited.connect(_on_screen_exited)

	TorchAudioManager.register_torch(self)


func _process(delta: float) -> void:
	t += delta * flicker_speed

	var n1 := noise.get_noise_1d(t)
	var n2 := noise.get_noise_1d(t * 2.3 + 17.0)
	var combined := n1 * 0.7 + n2 * 0.3

	if randf() < 0.08:
		combined += randf_range(-jitter_strength, jitter_strength)

	point_light_2d.energy = lerp(
		min_energy,
		max_energy,
		clamp(combined * 0.5 + 0.5, 0.0, 1.0),
	)


func _exit_tree() -> void:
	TorchAudioManager.unregister_torch(self)


func _on_screen_entered() -> void:
	set_process(true)
	point_light_2d.enabled = true


func _on_screen_exited() -> void:
	set_process(false)
	point_light_2d.enabled = false
