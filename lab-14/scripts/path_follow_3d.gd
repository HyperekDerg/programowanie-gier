extends PathFollow3D

@export var rail_speed: float = 0.02

const PATH_END := 1.0

func _ready() -> void:
	progress_ratio = 0.0
	if GameManager.has_signal("all_enemies_defeated"):
		GameManager.all_enemies_defeated.connect(_on_all_enemies_defeated)

func _process(delta: float) -> void:
	if progress_ratio >= PATH_END:
		return
	progress_ratio += rail_speed * delta
	if progress_ratio >= PATH_END:
		progress_ratio = PATH_END
		if GameManager.has_signal("path_end_reached"):
			GameManager.path_end_reached.emit()

func _on_all_enemies_defeated() -> void:
	progress_ratio = 0.0
