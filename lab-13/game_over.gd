extends Control
@onready var label_2: Label = $VBoxContainer/Label2
@onready var button: Button = $VBoxContainer/Button


func _ready() -> void:
	label_2.text = "Wynik końcowy: " + str(GameManager.score)
	button.pressed.connect(_on_menu_pressed)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")
