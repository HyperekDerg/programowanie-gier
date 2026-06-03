extends Node3D

signal died

enum State { IDLE, ATTACK, RETREAT, DEATH }
var current_state: State = State.IDLE

@export var max_hp: int = 20
@export var bullet_scene: PackedScene
@export var explosion_scene: PackedScene
@export var boss_distance: float = 20.0
@export var fire_rate: float = 0.5

const IDLE_DURATION      := 2.0
const ATTACK_DURATION    := 5.0
const RETREAT_DURATION   := 2.0
const STRAFE_AMPLITUDE   := 4.0
const RETREAT_DEPTH      := 5.0 

var hp: int
var phase2_activated: bool = false
var _player_ref: Node3D = null 
var _fire_timer: float = 0.0
var _time_passed: float = 0.0
var _flash_material: StandardMaterial3D
const FLASH_DURATION := 0.1

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var shape_phase1: CollisionShape3D = $MeshInstance3D/HitboxPhase1/CollisionShape3D
@onready var shape_phase2: CollisionShape3D = $MeshInstance3D/HitboxPhase2/CollisionShape3D

func _ready() -> void:
	hp = max_hp
	shape_phase1.disabled = true 
	shape_phase2.disabled = true
	visible = false
	set_process(false)
	
	_flash_material = StandardMaterial3D.new()
	_flash_material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
	_flash_material.albedo_color = Color.WHITE
	
	if GameManager.has_signal("all_enemies_defeated"):
		GameManager.all_enemies_defeated.connect(_on_all_enemies_defeated)

func _process(delta: float) -> void:
	if not _player_ref: return
	
	_time_passed += delta
	
	# 1. PODĄŻANIE ZA GRACZEM (Oś Z)
	# Używamy lerp, aby boss nie "skakał" sztywno za kamerą
	var target_z = _player_ref.global_position.z - boss_distance
	if current_state == State.RETREAT:
		target_z -= RETREAT_DEPTH # Cofa się dalej w fazie odwrotu
	
	global_position.z = lerp(global_position.z, target_z, delta * 2.0)
	
	# 2. LOGIKA STANÓW
	match current_state:
		State.ATTACK:
			# Ruch po sinusoidzie (lewo-prawo)
			global_position.x = lerp(global_position.x, sin(_time_passed * 2.0) * STRAFE_AMPLITUDE, delta)
			# Ciągły ostrzał
			_fire_timer += delta
			if _fire_timer >= fire_rate:
				_shoot_at_player()
				_fire_timer = 0.0
		
		State.IDLE:
			# Delikatne unoszenie się (hover effect)
			global_position.y = lerp(global_position.y, cos(_time_passed * 1.5) * 1.0, delta)

func _on_all_enemies_defeated() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_player_ref = players[0] as Node3D
		# Startowa pozycja przed graczem
		global_position = _player_ref.global_position - Vector3(0, 0, boss_distance)
	
	visible = true
	set_process(true)
	shape_phase1.disabled = false
	enter_state(State.IDLE)

func enter_state(new_state: State) -> void:
	current_state = new_state
	_fire_timer = 0.0 # Reset timera strzału
	
	match current_state:
		State.IDLE:
			get_tree().create_timer(IDLE_DURATION).timeout.connect(func(): enter_state(State.ATTACK))
		State.ATTACK:
			get_tree().create_timer(ATTACK_DURATION).timeout.connect(func(): enter_state(State.RETREAT))
		State.RETREAT:
			get_tree().create_timer(RETREAT_DURATION).timeout.connect(func(): enter_state(State.IDLE))
		State.DEATH:
			start_death()

func _shoot_at_player() -> void:
	if bullet_scene == null or _player_ref == null: return
	
	# Oblicz kierunek do gracza
	var dir = (_player_ref.global_position - global_position).normalized()
	_spawn_bullet(dir)
	
	# W fazie 2 strzelaj serią (dwie dodatkowe kule pod kątem)
	if phase2_activated:
		_spawn_bullet(dir.rotated(Vector3.UP, deg_to_rad(15)))
		_spawn_bullet(dir.rotated(Vector3.UP, deg_to_rad(-15)))

func _spawn_bullet(dir: Vector3) -> void:
	var bullet = bullet_scene.instantiate()
	if "direction" in bullet: bullet.direction = dir
	if "bullet_type" in bullet: bullet.bullet_type = "enemy"
	
	get_tree().root.add_child(bullet)
	
	bullet.global_position = global_position + (dir * 3.0) 
	
	bullet.look_at(bullet.global_position + dir)

func take_hit(damage: int) -> void:
	if current_state == State.DEATH: return
	
	hp -= damage
	_hit_flash()
	
	if not phase2_activated and hp <= max_hp / 2:
		phase2_activated = true
		fire_rate *= 0.6
		_activate_phase2()
		
	if hp <= 0:
		enter_state(State.DEATH)
		
func _hit_flash() -> void:
	if not mesh_instance: return
	mesh_instance.material_override = _flash_material
	var flash_tween = create_tween()
	flash_tween.tween_callback(func(): mesh_instance.material_override = null).set_delay(FLASH_DURATION)

func _activate_phase2() -> void:
	print("PHASE 2!")
	shape_phase1.set_deferred("disabled", true)
	shape_phase2.set_deferred("disabled", false)

func start_death() -> void:
	set_process(false)
	died.emit()
	# Sekwencja wybuchów
	for i in range(5):
		var random_offset = Vector3(randf_range(-2, 2), randf_range(-2, 2), randf_range(-2, 2))
		_spawn_explosion(global_position + random_offset, 1.5)
		await get_tree().create_timer(0.2).timeout
		
	_spawn_explosion(global_position, 4.0)
	queue_free()

func _spawn_explosion(pos: Vector3, scale_factor: float) -> void:
	if explosion_scene:
		var exp = explosion_scene.instantiate()
		get_tree().root.add_child(exp)
		exp.global_position = pos
		exp.scale = Vector3.ONE * scale_factor
