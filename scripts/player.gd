@tool
extends CharacterBody2D

signal health_changed(current: int, maximum: int)
signal scorpions_defeated_changed(total: int)
signal player_defeated

enum PlayerState { IDLE, WALKING }
enum Facing { DOWN, LEFT, RIGHT, UP }

@export var speed: float = 175.0
@export var max_health: int = 100
@export var attack_range: float = 88.0

@onready var sprite: AnimatedSprite2D = $Sprite2D
var current_state: PlayerState = PlayerState.IDLE
var facing: Facing = Facing.DOWN
var health: int = 100
var damage_cooldown: float = 0.0
var is_defeated: bool = false
var scorpions_defeated: int = 0

func _ready() -> void:
	health = max_health
	add_to_group("players")
	if Engine.is_editor_hint(): return
	$Camera2D.make_current()
	_show_idle_pose()
	health_changed.emit(health, max_health)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or is_defeated: return
	damage_cooldown = maxf(0.0, damage_cooldown - delta)
	var direction := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): direction.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): direction.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): direction.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): direction.y += 1.0
	if direction.length_squared() > 1.0: direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	if direction.is_zero_approx():
		_change_state(PlayerState.IDLE)
	else:
		_update_facing(direction)
		_change_state(PlayerState.WALKING)
		_play_walk_animation()
	if Input.is_action_just_pressed("attack"): _attack()

func take_damage(amount: int = 10) -> void:
	if is_defeated or damage_cooldown > 0.0: return
	damage_cooldown = 0.75
	health = maxi(health - amount, 0)
	health_changed.emit(health, max_health)
	if health == 0:
		is_defeated = true
		velocity = Vector2.ZERO
		player_defeated.emit()

func _attack() -> void:
	var direction := _facing_vector()
	var target: Node2D = null
	var nearest_distance := attack_range
	for enemy in get_tree().get_nodes_in_group("scorpions"):
		if not is_instance_valid(enemy): continue
		var offset: Vector2 = enemy.global_position - global_position
		var distance := offset.length()
		if distance < nearest_distance and offset.normalized().dot(direction) > 0.2:
			target = enemy
			nearest_distance = distance
	if target != null:
		target.call("defeat")
		scorpions_defeated += 1
		scorpions_defeated_changed.emit(scorpions_defeated)

func _facing_vector() -> Vector2:
	match facing:
		Facing.DOWN: return Vector2.DOWN
		Facing.LEFT: return Vector2.LEFT
		Facing.RIGHT: return Vector2.RIGHT
		Facing.UP: return Vector2.UP
	return Vector2.DOWN

func _change_state(next_state: PlayerState) -> void:
	if current_state == next_state: return
	current_state = next_state
	if current_state == PlayerState.IDLE: _show_idle_pose()

func _update_facing(direction: Vector2) -> void:
	if absf(direction.x) > absf(direction.y):
		facing = Facing.RIGHT if direction.x > 0.0 else Facing.LEFT
	else:
		facing = Facing.DOWN if direction.y > 0.0 else Facing.UP

func _animation_name(prefix: String) -> String:
	match facing:
		Facing.DOWN: return prefix + "_down"
		Facing.LEFT: return prefix + "_left"
		Facing.RIGHT: return prefix + "_right"
		Facing.UP: return prefix + "_up"
	return prefix + "_down"

func _show_idle_pose() -> void:
	if not is_instance_valid(sprite): return
	sprite.play(_animation_name("walk"))
	sprite.stop()
	sprite.frame = 0

func _play_walk_animation() -> void:
	var animation_name := _animation_name("walk")
	if sprite.animation != animation_name or not sprite.is_playing(): sprite.play(animation_name)
