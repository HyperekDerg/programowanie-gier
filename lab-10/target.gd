extends Node3D

func _ready():
	$Area3D.monitorable = true
	$Area3D.monitoring = true
	$Area3D.area_entered.connect(_on_hit)

func _on_hit(_area: Area3D):
	print("trafiony!")

	var main = get_tree().current_scene
	main.add_score()

	queue_free()
