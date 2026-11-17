extends CharacterBody2D
class_name SandScorpion

signal player_contact(damage: int)
signal defeated(points: int, at: Vector2)

enum State { ENTERING, CHASING, ATTACKING, HURT, DEAD }

@export var speed := 67.0
@export var max_health := 3
@export var contact_damage := 10
@export var attack_range := 28.0

var health := 3
var state := State.ENTERING
var target: Node2D
var _state_timer := 0.22
var _contact_timer := 0.0
var _frame_timer := 0.0
var _walk_frame := 0
var _facing_row := 2

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	health = max_health
	add_to_group("enemies")
	sprite.modulate.a = 0.0


func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	_state_timer = maxf(0.0, _state_timer - delta)
	_contact_timer = maxf(0.0, _contact_timer - delta)
	_frame_timer += delta
	if _frame_timer >= 0.12:
		_frame_timer = 0.0
		_walk_frame = (_walk_frame + 1) % 4
	if state == State.ENTERING:
		sprite.modulate.a = 1.0 - _state_timer / 0.22
		if _state_timer <= 0.0:
			_transition(State.CHASING)
	elif state == State.HURT:
		if _state_timer <= 0.0:
			_transition(State.CHASING)
	elif state == State.ATTACKING:
		velocity = Vector2.ZERO
		if _contact_timer <= 0.0:
			player_contact.emit(contact_damage)
			_contact_timer = 0.8
		if _state_timer <= 0.0:
			_transition(State.CHASING)
	elif state == State.CHASING:
		_chase_target(delta)
	_update_frame()


func _chase_target(delta: float) -> void:
	if not is_instance_valid(target):
		velocity = Vector2.ZERO
		move_and_slide()
		return
	var to_target := target.global_position - global_position
	if to_target.length() <= attack_range:
		_transition(State.ATTACKING)
		return
	var desired := to_target.normalized()
	var motion := desired * speed * delta
	if test_move(global_transform, motion):
		# Tenta contornar a borda do obstáculo sem ficar preso de frente nele.
		var alternatives: Array[Vector2] = [desired.rotated(0.7), desired.rotated(-0.7), desired.rotated(1.45), desired.rotated(-1.45), -desired]
		for alternative in alternatives:
			if not test_move(global_transform, alternative * speed * delta):
				desired = alternative
				break
	velocity = desired * speed
	move_and_slide()
	if velocity.length_squared() > 0.01:
		_facing_row = _direction_row(velocity)


func take_damage(amount: int) -> void:
	if state == State.DEAD:
		return
	health = maxi(0, health - amount)
	if health == 0:
		_transition(State.DEAD)
		defeated.emit(1, global_position)
		queue_free()
	else:
		_state_timer = 0.08
		_transition(State.HURT)
		sprite.modulate = Color(1.4, 0.72, 0.48, 1.0)


func _transition(next_state: State) -> void:
	if state == next_state:
		return
	state = next_state
	match state:
		State.ATTACKING:
			_state_timer = 0.28
		State.HURT:
			_state_timer = 0.08
		State.CHASING:
			sprite.modulate = Color.WHITE


func _direction_row(direction: Vector2) -> int:
	if absf(direction.x) > absf(direction.y):
		return 1 if direction.x > 0.0 else 3
	return 2 if direction.y > 0.0 else 0


func _update_frame() -> void:
	sprite.frame = _facing_row * 4 + _walk_frame
