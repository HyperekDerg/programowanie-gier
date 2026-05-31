extends Node

signal coin_collected(total: int)

var count: int = 0


func add_coin() -> void:
	count += 1
	emit_signal("coin_collected", count)
