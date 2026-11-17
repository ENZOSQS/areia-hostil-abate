extends Area2D
class_name SandProjectile

enum State { FLYING, IMPACT, EXPIRED }

@export var speed := 560.0
@export var damage := 1

var state := State.FLYING
var direction := Vector2.RIGHT
var _life := 1.25


func _ready() -> void:
	add_to_group("projectiles")
	body_entered.connect(_on_body_entered)


func launch(heading: Vector2) -> void:
	direction = heading.normalized()
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	if state != State.FLYING:
		return
	global_position += direction * speed * delta
	_life -= delta
	if _life <= 0.0:
		_transition(State.EXPIRED)


func _on_body_entered(body: Node2D) -> void:
	if state != State.FLYING or not body.is_in_group("enemies"):
		return
	_transition(State.IMPACT)
	body.take_damage(damage)


func _transition(next_state: State) -> void:
	if state != State.FLYING:
		return
	state = next_state
	queue_free()
