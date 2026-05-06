extends Node2D

var _bgm_player: AudioStreamPlayer

func _ready() -> void:
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.stream = preload("res://assets/bgm/StockTune-Creepy Whispers In Shadows_1778079680.mp3")
	_bgm_player.bus = "BGM"
	_bgm_player.volume_db = 0.0
	_bgm_player.autoplay = false
	add_child(_bgm_player)
	_bgm_player.play()

func _process(delta: float) -> void:
	pass
