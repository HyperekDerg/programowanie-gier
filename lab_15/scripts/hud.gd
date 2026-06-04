extends CanvasLayer

@onready var coins: Label = $Coins


func _ready() -> void:
	CoinManager.coin_collected.connect(_on_coin_collected)
	coins.text = "COINS: 0"

func _on_coin_collected(total: int) -> void:
	coins.text = "COINS: " + str(total)
