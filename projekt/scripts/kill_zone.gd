extends Area2D

@onready var timer: Timer = $Timer

@export var time: float = 0.5

func _on_body_entered(body: Node2D) -> void:
	print("You Died!")
	timer.start(time)

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
