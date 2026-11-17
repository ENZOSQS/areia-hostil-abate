extends CanvasLayer

signal restart_requested

var health_bar: ProgressBar
var health_label: Label
var score_label: Label
var wave_label: Label
var timer_label: Label
var end_overlay: ColorRect
var end_title: Label
var end_details: Label


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	var top := PanelContainer.new()
	top.position = Vector2(18, 16)
	top.custom_minimum_size = Vector2(345, 100)
	root.add_child(top)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 3)
	top.add_child(stack)
	var heading := Label.new()
	heading.text = "AREIA HOSTIL   •   ABATE"
	heading.add_theme_color_override("font_color", Color("#ffdf9a"))
	heading.add_theme_font_size_override("font_size", 19)
	stack.add_child(heading)
	var health_row := HBoxContainer.new()
	stack.add_child(health_row)
	health_label = Label.new()
	health_label.custom_minimum_size.x = 90
	health_row.add_child(health_label)
	health_bar = ProgressBar.new()
	health_bar.custom_minimum_size = Vector2(220, 18)
	health_bar.show_percentage = false
	health_row.add_child(health_bar)
	score_label = Label.new()
	score_label.text = "Escorpiões abatidos: 0 / 50"
	stack.add_child(score_label)

	var objective := PanelContainer.new()
	objective.anchor_left = 1.0
	objective.anchor_right = 1.0
	objective.offset_left = -245
	objective.offset_right = -18
	objective.offset_top = 16
	objective.offset_bottom = 80
	root.add_child(objective)
	var objective_stack := VBoxContainer.new()
	objective_stack.add_theme_constant_override("separation", 1)
	objective.add_child(objective_stack)
	wave_label = Label.new()
	wave_label.text = "Horda 1"
	wave_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	objective_stack.add_child(wave_label)
	timer_label = Label.new()
	timer_label.text = "00:00"
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	objective_stack.add_child(timer_label)

	var controls := Label.new()
	controls.text = "WASD / setas: mover   •   Espaço ou mouse: disparar   •   R: reiniciar"
	controls.anchor_top = 1.0
	controls.anchor_bottom = 1.0
	controls.offset_left = 18
	controls.offset_top = -35
	controls.offset_right = 700
	controls.offset_bottom = -10
	controls.add_theme_color_override("font_color", Color("#fff0cc"))
	controls.add_theme_font_size_override("font_size", 14)
	root.add_child(controls)

	end_overlay = ColorRect.new()
	end_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	end_overlay.color = Color(0.10, 0.07, 0.05, 0.72)
	end_overlay.visible = false
	end_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(end_overlay)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	end_overlay.add_child(center)
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(440, 220)
	center.add_child(card)
	var end_stack := VBoxContainer.new()
	end_stack.alignment = BoxContainer.ALIGNMENT_CENTER
	end_stack.add_theme_constant_override("separation", 12)
	card.add_child(end_stack)
	end_title = Label.new()
	end_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_title.add_theme_font_size_override("font_size", 32)
	end_title.add_theme_color_override("font_color", Color("#ffdf9a"))
	end_stack.add_child(end_title)
	end_details = Label.new()
	end_details.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_stack.add_child(end_details)
	var restart := Button.new()
	restart.text = "Jogar novamente"
	restart.custom_minimum_size = Vector2(180, 42)
	restart.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	restart.pressed.connect(func() -> void: restart_requested.emit())
	end_stack.add_child(restart)


func set_health(current: int, maximum: int) -> void:
	if not is_instance_valid(health_bar):
		return
	health_bar.max_value = maximum
	health_bar.value = current
	health_label.text = "Vida %d/%d" % [current, maximum]


func set_kills(kills: int, target: int) -> void:
	score_label.text = "Escorpiões abatidos: %d / %d" % [kills, target]
	wave_label.text = "Horda %d" % (1 + kills / 10)


func set_elapsed(seconds: float) -> void:
	var total := int(seconds)
	timer_label.text = "%02d:%02d" % [total / 60, total % 60]


func show_end(won: bool, kills: int, seconds: float) -> void:
	end_title.text = "ARENA CONQUISTADA!" if won else "VOCÊ FOI DERROTADO"
	end_details.text = "50 escorpiões em %s" % _format_time(seconds) if won else "Você derrotou %d escorpiões em %s" % [kills, _format_time(seconds)]
	end_overlay.visible = true


func _format_time(seconds: float) -> String:
	var total := int(seconds)
	return "%02d:%02d" % [total / 60, total % 60]
