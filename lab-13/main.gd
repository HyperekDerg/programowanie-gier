extends Node3D

@onready var wynik: Label = $Path3D/PathFollow3D/HUD/Wynik
@onready var życia: Label = $Path3D/PathFollow3D/HUD/Życia
@onready var hp: ProgressBar = $Path3D/PathFollow3D/HUD/HP

func _ready() -> void:
	_on_score_changed(GameManager.score)
	_on_lives_changed(GameManager.lives)
	_on_hp_changed(GameManager.player_hp)
	hp.max_value = GameManager.player_max_hp

	GameManager.score_changed.connect(_on_score_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.hp_changed.connect(_on_hp_changed)
	GameManager.game_over.connect(_on_game_over)
	
	if GameManager.has_signal("level_complete"):
		GameManager.level_complete.connect(_on_level_complete)

func _on_score_changed(new_score: int) -> void:
	wynik.text = "Wynik: %d" % new_score

func _on_lives_changed(new_lives: int) -> void:
	życia.text = "Życia: %d" % new_lives

func _on_hp_changed(new_hp: int) -> void:
	hp.value = new_hp

func _on_game_over() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://game_over.tscn")

func _on_level_complete() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://level_complete.tscn")
