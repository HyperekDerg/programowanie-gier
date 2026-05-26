extends Node

var score: int = 0
var lives: int = 3
var player_max_hp: int = 5
var player_hp: int = 5

signal score_changed(new_score)
signal lives_changed(new_lives)
signal hp_changed(new_hp)

signal game_over
signal level_complete
signal enemy_killed
signal player_damaged

var _sfx_score := AudioStreamPlayer.new()
var _sfx_hit := AudioStreamPlayer.new()
var _sfx_game_over := AudioStreamPlayer.new()

func _ready() -> void:
	add_child(_sfx_score)
	add_child(_sfx_hit)
	add_child(_sfx_game_over)
	
	_sfx_score.stream = preload("res://score.mp3")
	_sfx_hit.stream = preload("res://hit.mp3")
	_sfx_game_over.stream = preload("res://game_over.mp3")
	
	enemy_killed.connect(func(): _sfx_score.play())
	player_damaged.connect(func(): _sfx_hit.play())
	game_over.connect(func(): _sfx_game_over.play())

func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)
	enemy_killed.emit()

func player_hit(damage: int = 1) -> void:
	player_hp -= damage
	hp_changed.emit(player_hp)
	player_damaged.emit()
	print("Trafiony")

	if player_hp <= 0:
		lives -= 1
		lives_changed.emit(lives)

		if lives <= 0:
			game_over.emit()
		else:
			player_hp = player_max_hp
			hp_changed.emit(player_hp)

func reset() -> void:
	score = 0
	lives = 3
	player_hp = player_max_hp
	score_changed.emit(score)
	lives_changed.emit(lives)
	hp_changed.emit(player_hp)
