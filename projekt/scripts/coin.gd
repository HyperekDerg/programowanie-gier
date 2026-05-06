extends Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var point_light_2d: PointLight2D = $PointLight2D


func _on_body_entered(body: Node2D) -> void:
	print('+1 coin')
	animated_sprite_2d.visible = false
	point_light_2d.visible = false
	
	$CollisionShape2D.set_deferred("disabled", true)
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished
	queue_free()
