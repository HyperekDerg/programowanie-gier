extends Camera3D

@export var lag_speed: float = 2.6

@onready var camera_target: Node3D = $"../Path3D/PathFollow3D/CameraTarget"


func _process(delta: float) -> void:
	global_position = global_position.lerp(camera_target.global_position, lag_speed * delta)
