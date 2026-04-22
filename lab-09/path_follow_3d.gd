extends PathFollow3D

@export var rail_speed: float = 0.02

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_ratio = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += rail_speed * delta
	if progress_ratio > 1.0:
		progress_ratio -= 1.0
