extends Node2D

const ESC_HOLD_TIME: float = 1.5
const MAIN_MENU_SCENE: String = "res://scenes/main_menu.tscn"

var _bgm_player: AudioStreamPlayer
var _esc_overlay: Control = null
var _arc_node: Control = null
var _esc_held: float = 0.0
var _esc_showing: bool = false


func _ready() -> void:
	var bus_idx: int = AudioServer.get_bus_index("BGM")
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, 0.0)

	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.stream = preload("res://assets/bgm/StockTune-Creepy Whispers In Shadows_1778079680.mp3")
	_bgm_player.bus = "BGM"
	_bgm_player.volume_db = 0.0
	_bgm_player.autoplay = false
	add_child(_bgm_player)
	_bgm_player.play()

	_build_esc_overlay()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_esc_showing = true
		_esc_held = 0.0
		_esc_overlay.visible = true

	if _esc_showing:
		if Input.is_action_pressed("ui_cancel"):
			_esc_held += delta
			_arc_node.queue_redraw()
			if _esc_held >= ESC_HOLD_TIME:
				get_tree().change_scene_to_file(MAIN_MENU_SCENE)
		else:
			_esc_showing = false
			_esc_held = 0.0
			_esc_overlay.visible = false
			_arc_node.queue_redraw()


func _build_esc_overlay() -> void:
	var cl = CanvasLayer.new()
	cl.layer = 128
	add_child(cl)

	_esc_overlay = Control.new()
	_esc_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_esc_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_esc_overlay.visible = false
	cl.add_child(_esc_overlay)

	var bg = ColorRect.new()
	bg.color = Color(0, 0, 0, 0.6)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_esc_overlay.add_child(bg)

	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_esc_overlay.add_child(center)

	var vbox = VBoxContainer.new()
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_theme_constant_override("separation", 15)
	center.add_child(vbox)

	_arc_node = _ArcNode.new(self)
	_arc_node.custom_minimum_size = Vector2(100, 100)
	_arc_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(_arc_node)

	var pct_label = Label.new()
	pct_label.name = "PctLabel"
	pct_label.text = "0%"
	pct_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pct_label.add_theme_font_size_override("font_size", 24)
	pct_label.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(pct_label)

	var info_label = Label.new()
	info_label.text = "EXITING"
	info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_label.add_theme_font_size_override("font_size", 12)
	info_label.modulate = Color(1, 1, 1, 0.6)
	vbox.add_child(info_label)


class _ArcNode extends Control:
	var _p: Node


	func _init(parent: Node):
		_p = parent


	func _draw() -> void:
		var c = size / 2
		var r = size.x / 2 - 10
		var prog = clamp(_p._esc_held / _p.ESC_HOLD_TIME, 0.0, 1.0)

		var label = get_parent().get_node("PctLabel")
		label.text = str(int(prog * 100)) + "%"

		draw_arc(c, r, 0, TAU, 64, Color(1, 1, 1, 0.15), 1.0, false)

		if prog > 0.0:
			var glitch_offset = Vector2.ZERO
			var current_width = 4.0

			if prog < 1.0 and randf() > 0.9:
				glitch_offset = Vector2(randf_range(-3, 3), randf_range(-2, 2))
				current_width = randf_range(2, 10)
				draw_arc(c - glitch_offset, r, -PI / 2, -PI / 2 + TAU * prog, 64, Color(1, 1, 1, 0.4), 1.0, false)

			draw_arc(c + glitch_offset, r, -PI / 2, -PI / 2 + TAU * prog, 64, Color.WHITE, current_width, false)

			if randf() > 0.85:
				var angle = -PI / 2 + TAU * prog
				var spark_pos = c + glitch_offset + Vector2(cos(angle), sin(angle)) * r
				draw_rect(Rect2(spark_pos - Vector2(2, 2), Vector2(4, 4)), Color.WHITE)
