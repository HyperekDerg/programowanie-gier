extends Control

const CURSOR_BLINK_INTERVAL: float = 0.5
const IDLE_PULSE_DELAY: float = 3.0

@export var game_scene_path: String = "res://scenes/game.tscn"
@export var settings_scene_path: String = "res://scenes/game.tscn"
@export var fade_duration: float = 0.6
@export var bgm_volume_db: float = 0.0
@export var flicker_min: float = 0.2
@export var flicker_max: float = 1.2
@export var flicker_interval_min: float = 0.04
@export var flicker_interval_max: float = 0.18
@export var flicker_lerp_speed: float = 14.0

var _pending_scene: String = ""
var _hovered_button: Button = null
var _cursor_visible: bool = true
var _cursor_blink_timer: float = 0.0
var _idle_timer: float = 0.0
var _idle_pulsing: bool = false
var _idle_tween: Tween = null
var _flicker_target: float = 1.0
var _flicker_timer: float = 0.0

@onready var start_button: Button = $MarginContainer/VBoxContainer/StartButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/SettingsButton
@onready var exit_button: Button = $MarginContainer/VBoxContainer/ExitButton
@onready var fade_overlay: ColorRect = $FadeOverlay
@onready var bgm_player: AudioStreamPlayer2D = $BGMPlayer
@onready var animation_player: AnimationPlayer = $FadeOverlay/AnimationPlayer
@onready var point_light_2d: PointLight2D = $Background/PointLight2D
@onready var cursor_label: Label = $CursorLabel
@onready var sfx_hover: AudioStreamPlayer2D = $SFXHover
@onready var sfx_press: AudioStreamPlayer2D = $SFXPress


func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	animation_player.animation_finished.connect(_on_animation_finished)

	for btn in [start_button, settings_button, exit_button]:
		btn.mouse_entered.connect(_on_button_hover.bind(btn))
		btn.mouse_exited.connect(_on_button_unhover.bind(btn))
		btn.focus_entered.connect(_on_button_hover.bind(btn))
		btn.focus_exited.connect(_on_button_unhover.bind(btn))
		btn.button_down.connect(_on_button_press.bind(btn))

	cursor_label.text = "▶"
	cursor_label.visible = false

	sfx_hover.bus = "SFX"
	sfx_press.bus = "SFX"
	bgm_player.bus = "BGM"
	if AudioServer.get_bus_index("SFX") == -1:
		push_warning("MainMenu: 'SFX' audio bus not found. Create it in Project > Audio.")

	_play_fade_in()
	_start_bgm()
	_flicker_target = point_light_2d.energy
	_pick_next_flicker()


func _process(delta: float) -> void:
	_update_flicker(delta)
	_update_cursor_blink(delta)
	_update_idle_pulse(delta)


func _on_button_hover(btn: Button) -> void:
	_hovered_button = btn
	_idle_timer = 0.0
	_stop_idle_pulse()

	var tw: Tween = create_tween()
	tw.tween_property(btn, "self_modulate", Color(1.4, 1.4, 1.4, 1.0), 0.08)

	var tw2: Tween = create_tween()
	tw2.tween_property(btn, "scale", Vector2(1.06, 1.06), 0.08).set_trans(Tween.TRANS_BACK)
	btn.pivot_offset = btn.size / 2.0

	_move_cursor_to(btn)
	cursor_label.visible = true
	_cursor_visible = true

	if sfx_hover and sfx_hover.stream:
		sfx_hover.play()


func _on_button_unhover(btn: Button) -> void:
	if _hovered_button == btn:
		_hovered_button = null
		cursor_label.visible = false

	var tw: Tween = create_tween()
	tw.tween_property(btn, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)

	var tw2: Tween = create_tween()
	tw2.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK)


func _on_button_press(_btn: Button) -> void:
	if sfx_press and sfx_press.stream:
		sfx_press.play()


func _move_cursor_to(btn: Button) -> void:
	var btn_global: Vector2 = btn.global_position
	cursor_label.global_position = Vector2(
		btn_global.x - cursor_label.size.x - 8.0,
		btn_global.y + (btn.size.y - cursor_label.size.y) / 2.0,
	)


func _update_cursor_blink(delta: float) -> void:
	if _hovered_button == null:
		return
	_cursor_blink_timer += delta
	if _cursor_blink_timer >= CURSOR_BLINK_INTERVAL:
		_cursor_blink_timer = 0.0
		_cursor_visible = !_cursor_visible
		cursor_label.visible = _cursor_visible


func _update_idle_pulse(delta: float) -> void:
	if _hovered_button != null or _idle_pulsing:
		return
	_idle_timer += delta
	if _idle_timer >= IDLE_PULSE_DELAY:
		_start_idle_pulse()


func _start_idle_pulse() -> void:
	_idle_pulsing = true
	_idle_tween = create_tween().set_loops()
	_idle_tween.tween_property(start_button, "self_modulate:a", 0.55, 0.6).set_trans(Tween.TRANS_SINE)
	_idle_tween.tween_property(start_button, "self_modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE)


func _stop_idle_pulse() -> void:
	if _idle_tween:
		_idle_tween.kill()
		_idle_tween = null
	_idle_pulsing = false
	_idle_timer = 0.0
	start_button.self_modulate.a = 1.0


func _update_flicker(delta: float) -> void:
	point_light_2d.energy = lerp(
		point_light_2d.energy,
		_flicker_target,
		clamp(flicker_lerp_speed * delta, 0.0, 1.0),
	)
	_flicker_timer -= delta
	if _flicker_timer <= 0.0:
		_pick_next_flicker()


func _pick_next_flicker() -> void:
	_flicker_target = flicker_min if randf() < 0.15 else randf_range(flicker_min, flicker_max)
	_flicker_timer = randf_range(flicker_interval_min, flicker_interval_max)


func _on_start_pressed() -> void:
	_begin_transition(game_scene_path)


func _on_settings_pressed() -> void:
	_begin_transition(settings_scene_path)


func _on_exit_pressed() -> void:
	_pending_scene = "quit"
	_disable_buttons()
	_fade_out_bgm()
	animation_player.play("fade_out")


func _begin_transition(path: String) -> void:
	if not ResourceLoader.exists(path):
		push_error("MainMenu: Scene not found at path: %s" % path)
		return
	_pending_scene = path
	_disable_buttons()
	_fade_out_bgm()
	animation_player.play("fade_out")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		if _pending_scene == "quit":
			get_tree().quit()
		elif _pending_scene != "":
			get_tree().change_scene_to_file(_pending_scene)


func _play_fade_in() -> void:
	fade_overlay.modulate.a = 1.0
	animation_player.play("fade_in")


func _start_bgm() -> void:
	if not bgm_player.playing:
		bgm_player.play()
	var bus_idx: int = AudioServer.get_bus_index("BGM")
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, bgm_volume_db)
	else:
		push_warning("MainMenu: 'BGM' audio bus not found.")


func _fade_out_bgm() -> void:
	var tween: Tween = create_tween()
	var bus_idx: int = AudioServer.get_bus_index("BGM")
	if bus_idx != -1:
		tween.tween_method(
			func(vol: float) -> void: AudioServer.set_bus_volume_db(bus_idx, vol),
			bgm_volume_db,
			-80.0,
			fade_duration,
		)
	else:
		tween.tween_property(bgm_player, "volume_db", -80.0, fade_duration)


func _disable_buttons() -> void:
	_stop_idle_pulse()
	start_button.disabled = true
	settings_button.disabled = true
	exit_button.disabled = true
