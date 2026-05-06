extends Area2D

@export var time: float = 0.6

@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	print("You Died!")

	if body.has_method("die"):
		body.die()

	Engine.time_scale = 0.5
	timer.start(time)


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
