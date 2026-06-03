extends Node3D

@onready var wynik: Label      = $Path3D/PathFollow3D/HUD/Wynik
@onready var życia: Label      = $Path3D/PathFollow3D/HUD/Życia
@onready var hp: ProgressBar   = $Path3D/PathFollow3D/HUD/HP
@onready var przeciwnicy: Label = $Path3D/PathFollow3D/HUD/Przeciwnicy
@onready var boss: Node3D = $Boss

func _ready() -> void:
	_on_score_changed(GameManager.score)
	_on_lives_changed(GameManager.lives)
	_on_hp_changed(GameManager.player_hp)
	_on_enemies_count_changed(GameManager.active_enemies)
	hp.max_value = GameManager.player_max_hp

	GameManager.score_changed.connect(_on_score_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.hp_changed.connect(_on_hp_changed)
	GameManager.game_over.connect(_on_game_over)
	GameManager.level_complete.connect(_on_level_complete)
	GameManager.enemies_count_changed.connect(_on_enemies_count_changed)

	_connect_boss()

func _on_enemies_count_changed(count: int) -> void:
	przeciwnicy.text = "Przeciwnicy: %d" % count

func _connect_boss() -> void:
	if boss == null:
		return
	boss.died.connect(func(): GameManager.level_complete.emit())

	var hb1 := boss.get_node_or_null("MeshInstance3D/HitboxPhase1")
	var hb2 := boss.get_node_or_null("MeshInstance3D/HitboxPhase2")
	if hb1:
		hb1.area_entered.connect(func(_a): boss.take_hit(1))
	if hb2:
		hb2.area_entered.connect(func(_a): boss.take_hit(2))

func _on_score_changed(new_score: int) -> void:
	wynik.text = "Wynik: %d" % new_score

func _on_lives_changed(new_lives: int) -> void:
	życia.text = "Życia: %d" % new_lives

func _on_hp_changed(new_hp: int) -> void:
	hp.value = new_hp

func _on_game_over() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over.tscn")

func _on_level_complete() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_complete.tscn")
