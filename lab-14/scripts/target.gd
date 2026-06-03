extends Node3D

@export var point_value: int = 100

func _ready() -> void:
	$Area3D.monitorable = true
	$Area3D.monitoring = true
	$Area3D.area_entered.connect(_on_hit)

func _on_hit(area: Area3D) -> void:
	if not area.is_in_group("player"):
		return
	GameManager.add_score(point_value)
	queue_free()
