extends CharacterBody2D

enum State { WANDERING, ATTACKER, SEARCHING }

@export var patrol_points: Array[Vector2] = [Vector2(-200, 0), Vector2(200, 0)]
@export var move_speed: float = 80.0
@export var charge_speed: float = 180.0
@export var detection_range: float = 150.0
@export var search_duration: float = 3.0
@export var search_flip_interval: float = 0.8

var current_state: State = State.WANDERING
var patrol_index: int = 0
var world_patrol_points: Array[Vector2] = []
var search_timer: float = 0.0
var search_flip_timer: float = 0.0
var player: Node2D = null
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var vision_ray: RayCast2D = $VisionRay


func _ready() -> void:
	for p in patrol_points:
		world_patrol_points.append(global_position + p)
	player = get_tree().get_first_node_in_group("player")
	current_state = State.WANDERING


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	match current_state:
		State.WANDERING:
			_state_wandering(delta)
		State.ATTACKER:
			_state_attacker(delta)
		State.SEARCHING:
			_state_searching(delta)

	move_and_slide()


func _change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	print("DEBUG: %s -> %s" % [State.keys()[current_state], State.keys()[new_state]])
	current_state = new_state


func _state_wandering(delta: float) -> void:
	var target: Vector2 = world_patrol_points[patrol_index]
	var to_target: Vector2 = target - global_position

	if to_target.length() < 4.0:
		patrol_index = (patrol_index + 1) % world_patrol_points.size()
	else:
		velocity.x = to_target.normalized().x * move_speed
		_face_direction(velocity.x)

	if _can_see_player():
		velocity.x = 0
		_change_state(State.ATTACKER)


func _state_attacker(delta: float) -> void:
	if player == null:
		_change_state(State.SEARCHING)
		return

	if _can_see_player():
		var dir: Vector2 = (player.global_position - global_position).normalized()
		velocity.x = dir.x * charge_speed
		_face_direction(velocity.x)
	else:
		velocity.x = 0
		search_timer = 0.0
		search_flip_timer = 0.0
		_change_state(State.SEARCHING)


func _state_searching(delta: float) -> void:
	velocity.x = 0
	search_timer += delta
	search_flip_timer += delta

	if search_flip_timer >= search_flip_interval:
		search_flip_timer = 0.0
		animated_sprite.flip_h = !animated_sprite.flip_h

	if _can_see_player():
		_change_state(State.ATTACKER)
		return

	if search_timer >= search_duration:
		animated_sprite.flip_h = false
		_change_state(State.WANDERING)


func _can_see_player() -> bool:
	if player == null:
		return false
	var to_player: Vector2 = player.global_position - global_position
	if to_player.length() > detection_range:
		return false
	vision_ray.target_position = to_player
	vision_ray.force_raycast_update()
	if vision_ray.is_colliding():
		var hit = vision_ray.get_collider()
		return hit.is_in_group("player")
	return false


func _face_direction(x_vel: float) -> void:
	if x_vel != 0:
		animated_sprite.flip_h = x_vel < 0
