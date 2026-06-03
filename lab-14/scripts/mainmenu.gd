extends Control
@onready var button: Button = $VBoxContainer/Button


func _ready() -> void:
	button.pressed.connect(_on_play_pressed)

func _on_play_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
