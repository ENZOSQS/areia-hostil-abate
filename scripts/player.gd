# Explorador: movimento em 4 direções, mira com o mouse, disparo, vida com invulnerabilidade e estados de animação.
# Origem: escrito com auxílio do OpenAI Codex, principalmente na máquina de estados do jogador.
extends CharacterBody2D
class_name ArenaPlayer

signal attack_requested(origin: Vector2, direction: Vector2)
signal health_changed(current: int, maximum: int)
signal state_changed(previous: int, current: int)
signal defeated

enum State { IDLE, RUNNING, ATTACKING, HURT, DEAD }

@export var speed := 220.0
@export var max_health := 100
@export var attack_cooldown := 0.28

var health := 100
var state := State.IDLE
var facing := Vector2.DOWN
var _moving := false
var _attack_timer := 0.0
var _hurt_timer := 0.0
var _attack_anim_timer := 0.0
var _invulnerable_timer := 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	health = max_health
	add_to_group("player")
	health_changed.emit(health, max_health)
	_update_animation()


func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	var input_dir := Vector2.ZERO
	_attack_timer = maxf(0.0, _attack_timer - delta)
	_invulnerable_timer = maxf(0.0, _invulnerable_timer - delta)
	_attack_anim_timer = maxf(0.0, _attack_anim_timer - delta)
	if state == State.HURT:
		_hurt_timer -= delta
		_moving = false
		velocity = Vector2.ZERO
		move_and_slide()
		if _hurt_timer <= 0.0:
			_transition(State.IDLE)
	else:
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		_moving = input_dir.length_squared() > 0.001
		velocity = input_dir * speed
		if _moving:
			facing = _cardinal_direction(input_dir)
			_transition(State.RUNNING)
		elif _attack_anim_timer <= 0.0:
			_transition(State.IDLE)
		move_and_slide()
		if Input.is_action_pressed("attack") and _attack_timer <= 0.0:
			_attack()
	_update_animation()


func _attack() -> void:
	_attack_timer = attack_cooldown
	_attack_anim_timer = 0.14
	_transition(State.ATTACKING)
	var aim := get_global_mouse_position() - global_position
	if aim.length_squared() < 0.01:
		aim = facing
	attack_requested.emit(global_position + aim.normalized() * 17.0, aim.normalized())


func take_damage(amount: int) -> void:
	if state == State.DEAD or _invulnerable_timer > 0.0:
		return
	health = maxi(0, health - amount)
	health_changed.emit(health, max_health)
	_invulnerable_timer = 1.0
	if health == 0:
		_moving = false
		_transition(State.DEAD)
		velocity = Vector2.ZERO
		defeated.emit()
	else:
		_hurt_timer = 0.12
		_transition(State.HURT)
	_update_animation()


func heal(amount: int) -> void:
	if state == State.DEAD:
		return
	health = mini(max_health, health + amount)
	health_changed.emit(health, max_health)


func _transition(next_state: State) -> void:
	if state == next_state:
		return
	var previous := state
	state = next_state
	state_changed.emit(previous, state)


func _cardinal_direction(direction: Vector2) -> Vector2:
	if absf(direction.x) > absf(direction.y):
		return Vector2.RIGHT if direction.x > 0.0 else Vector2.LEFT
	return Vector2.DOWN if direction.y > 0.0 else Vector2.UP


func _update_animation() -> void:
	if state == State.DEAD:
		sprite.modulate = Color(0.42, 0.28, 0.2, 0.7)
		sprite.stop()
		return
	if state == State.HURT:
		sprite.modulate = Color(1.0, 0.42, 0.38, 1.0)
	elif _invulnerable_timer > 0.0 and int(_invulnerable_timer * 18.0) % 2 == 0:
		sprite.modulate = Color(1, 1, 1, 0.45)
	else:
		sprite.modulate = Color.WHITE
	var motion := "run" if _moving and state != State.HURT else "idle"
	var direction := "down"
	if facing == Vector2.UP:
		direction = "up"
	elif facing == Vector2.LEFT:
		direction = "left"
	elif facing == Vector2.RIGHT:
		direction = "right"
	var animation_name := "%s_%s" % [motion, direction]
	if sprite.animation != animation_name or not sprite.is_playing():
		sprite.play(animation_name)
