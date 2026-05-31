extends Area2D

@export var time: float = 0.6
@export var next_scene: String = ""

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func _on_body_entered(body: Node2D) -> void:
	print("Level Complete!")
	if body.has_method("complete_level"):
		body.complete_level()
	Engine.time_scale = 0.5
	timer.start(time)


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)
	else:
		get_tree().reload_current_scene()
