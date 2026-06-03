extends Node3D

@export var speed: float = 30.0
@export var lifetime: float = 3.0
@export var direction: Vector3 = Vector3.ZERO
@export_enum("player", "enemy") var bullet_type: String = "player"


func _ready() -> void:
	$Area3D.monitorable = true
	$Area3D.monitoring = true
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.area_entered.connect(_on_area_entered)
	if bullet_type == "player":
		$Area3D.collision_layer = 3
		$Area3D.collision_mask = 2
	else:
		$Area3D.collision_layer = 4
		$Area3D.collision_mask = 1


func _process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if bullet_type == "player" and body.is_in_group("enemy"):
		if body.has_method("hit"):
			body.hit()
		queue_free()
	elif bullet_type == "enemy" and body.is_in_group("player"):
		GameManager.player_hit(1)
		queue_free()


func _on_area_entered(area: Area3D) -> void:
	if bullet_type == "player":
		var target = area.get_parent()
		if target.is_in_group("enemy"):
			if target.has_method("hit"):
				target.hit()
			queue_free()
			
	elif bullet_type == "enemy":
		if area.is_in_group("player"):
			if area.has_method("_take_damage"):
				area._take_damage(1)
			else:
				GameManager.player_hit(1)
			queue_free()
