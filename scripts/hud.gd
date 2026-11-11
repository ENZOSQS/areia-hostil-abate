extends CanvasLayer

@onready var health_bar: ProgressBar = $Panel/Margin/VBox/HealthBar
@onready var health_text: Label = $Panel/Margin/VBox/HealthText
@onready var count_text: Label = $Panel/Margin/VBox/CountText
@onready var message: Label = $Panel/Margin/VBox/Message

func _ready() -> void:
	message.text = "WASD/Setas: mover  |  Espaço: atacar"

func set_health(current: int, maximum: int) -> void:
	health_bar.max_value = maximum
	health_bar.value = current
	health_text.text = "VIDA  %d / %d" % [current, maximum]

func set_count(total: int) -> void:
	count_text.text = "ESCORPIÕES  %d / 50" % total
	if total >= 50: message.text = "ÁREA LIMPA! MISSÃO CONCLUÍDA"

func set_defeated() -> void:
	message.text = "VOCÊ FOI DERROTADO"
