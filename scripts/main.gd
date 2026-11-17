extends Node2D

const ScorpionScene := preload("res://entities/scorpion.tscn")
const ProjectileScene := preload("res://entities/projectile.tscn")
const PickupScene := preload("res://entities/health_pickup.tscn")
const HudScript := preload("res://scripts/hud.gd")

enum SessionState { PLAYING, VICTORY, GAME_OVER }

@export var kill_target := 50

var session_state := SessionState.PLAYING
var kills := 0
var elapsed := 0.0
var spawn_timer := 1.8
var rng := RandomNumberGenerator.new()
var hud: CanvasLayer

@onready var player: ArenaPlayer = $Player


func _ready() -> void:
	rng.randomize()
	hud = HudScript.new()
	add_child(hud)
	hud.restart_requested.connect(_restart)
	player.attack_requested.connect(_spawn_projectile)
	player.health_changed.connect(hud.set_health)
	player.defeated.connect(_on_player_defeated)
	hud.set_health(player.health, player.max_health)
	hud.set_kills(kills, kill_target)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") and session_state != SessionState.PLAYING:
		_restart()
	if session_state != SessionState.PLAYING:
		return
	elapsed += delta
	hud.set_elapsed(elapsed)
	spawn_timer -= delta
	if spawn_timer <= 0.0 and _alive_enemy_count() < _enemy_limit():
		_spawn_scorpion()
		spawn_timer = maxf(0.65, 1.9 - float(kills) * 0.02) * rng.randf_range(0.88, 1.12)


func _spawn_scorpion() -> void:
	var enemy := ScorpionScene.instantiate() as SandScorpion
	var angle := rng.randf_range(0.0, TAU)
	var radius := rng.randf_range(330.0, 420.0)
	var spawn_position := player.global_position + Vector2.from_angle(angle) * radius
	spawn_position.x = clampf(spawn_position.x, -590.0, 590.0)
	spawn_position.y = clampf(spawn_position.y, -320.0, 320.0)
	if spawn_position.distance_to(player.global_position) < 200.0:
		spawn_position = player.global_position + (player.global_position - spawn_position).normalized() * 240.0
		spawn_position.x = clampf(spawn_position.x, -590.0, 590.0)
		spawn_position.y = clampf(spawn_position.y, -320.0, 320.0)
	enemy.global_position = spawn_position
	enemy.target = player
	enemy.player_contact.connect(player.take_damage)
	enemy.defeated.connect(_on_scorpion_defeated)
	add_child(enemy)


func _spawn_projectile(origin: Vector2, direction: Vector2) -> void:
	if session_state != SessionState.PLAYING:
		return
	var projectile := ProjectileScene.instantiate() as SandProjectile
	projectile.global_position = origin
	projectile.launch(direction)
	add_child(projectile)


func _on_scorpion_defeated(_points: int, at: Vector2) -> void:
	if session_state != SessionState.PLAYING:
		return
	kills += 1
	hud.set_kills(kills, kill_target)
	if rng.randf() < 0.14:
		var pickup := PickupScene.instantiate() as HealthPickup
		pickup.global_position = at
		add_child(pickup)
	if kills >= kill_target:
		_finish(SessionState.VICTORY)


func _on_player_defeated() -> void:
	_finish(SessionState.GAME_OVER)


func _finish(next_state: SessionState) -> void:
	if session_state != SessionState.PLAYING:
		return
	session_state = next_state
	player.set_physics_process(false)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.set_physics_process(false)
	hud.show_end(session_state == SessionState.VICTORY, kills, elapsed)


func _restart() -> void:
	get_tree().reload_current_scene()


func _alive_enemy_count() -> int:
	return get_tree().get_nodes_in_group("enemies").size()


func _enemy_limit() -> int:
	return mini(10, 3 + kills / 8)
