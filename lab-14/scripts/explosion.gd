extends Node3D

@export var explosion_scale: float = 1.0

func _ready() -> void:
	$GPUParticles3D.scale = Vector3.ONE * explosion_scale
	$GPUParticles3D.emitting = true 
	
	await get_tree().create_timer(1.5).timeout
	queue_free()
