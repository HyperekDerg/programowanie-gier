extends PathFollow3D

@export var rail_speed: float = 0.02

func _ready() -> void:
	progress_ratio = 0.0


func _process(delta: float) -> void:
	progress_ratio += rail_speed * delta
	if progress_ratio > 1.0:
		progress_ratio -= 1.0
