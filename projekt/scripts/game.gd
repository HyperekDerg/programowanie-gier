extends Node2D

var _bgm_player: AudioStreamPlayer


func _ready() -> void:
	var bus_idx: int = AudioServer.get_bus_index("BGM")
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, 0.0)
	else:
		push_warning("GameMusic: 'BGM' audio bus not found.")

	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.stream = preload("res://assets/bgm/StockTune-Creepy Whispers In Shadows_1778079680.mp3")
	_bgm_player.bus = "BGM"
	_bgm_player.volume_db = 0.0
	_bgm_player.autoplay = false
	add_child(_bgm_player)
	_bgm_player.play()
