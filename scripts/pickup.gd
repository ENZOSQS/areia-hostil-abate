# Kit médico: cura ao ser tocado e some depois de um tempo.
# Origem: escrito com auxílio do OpenAI Codex.
extends Area2D
class_name HealthPickup

enum State { AVAILABLE, COLLECTED, EXPIRED }

@export var heal_amount := 20
var state := State.AVAILABLE
var _life := 12.0
var _phase := 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	if state != State.AVAILABLE:
		return
	_life -= delta
	_phase += delta
	$Sprite2D.position.y = sin(_phase * 3.0) * 3.0
	if _life <= 0.0:
		state = State.EXPIRED
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if state != State.AVAILABLE or not body.is_in_group("player"):
		return
	state = State.COLLECTED
	body.heal(heal_amount)
	queue_free()
