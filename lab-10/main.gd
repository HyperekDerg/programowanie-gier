extends Node3D

var score: int = 0
@onready var score_label: Label = $Path3D/PathFollow3D/HUD/Wynik

func _ready() -> void:
	score_label.text = "Score: %d" % score

func add_score(amount: int = 1) -> void:
	score += amount
	score_label.text = "Score: %d" % score
	print("Score:", score)
