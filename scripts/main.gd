# Partida: surgimento dos escorpiões pela borda, contagem de abates, vitória/derrota e reinício.
# Origem: escrito com auxílio do OpenAI Codex.
extends Node2D

const ScorpionScene := preload("res://entities/scorpion.tscn")
const ProjectileScene := preload("res://entities/projectile.tscn")
const PickupScene := preload("res://entities/health_pickup.tscn")
const HudScript := preload("res://scripts/hud.gd")

const EDGE_SPAWN_X := 590.0
const EDGE_SPAWN_Y := 320.0

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
	var spawn_position := _random_perimeter_position()
	for attempt in range(8):
		if spawn_position.distance_to(player.global_position) >= 220.0:
			break
		spawn_position = _random_perimeter_position()
	enemy.global_position = spawn_position
	enemy.target = player
	enemy.player_contact.connect(player.take_damage)
	enemy.defeated.connect(_on_scorpion_defeated)
	add_child(enemy)


func _random_perimeter_position() -> Vector2:
	# Sorteia ao longo do perímetro, ponderando os lados pelo comprimento.
	var horizontal_length := EDGE_SPAWN_X * 2.0
	var vertical_length := EDGE_SPAWN_Y * 2.0
	var distance := rng.randf_range(0.0, 2.0 * horizontal_length + 2.0 * vertical_length)
	if distance < horizontal_length:
		return Vector2(-EDGE_SPAWN_X + distance, -EDGE_SPAWN_Y)
	distance -= horizontal_length
	if distance < vertical_length:
		return Vector2(EDGE_SPAWN_X, -EDGE_SPAWN_Y + distance)
	distance -= vertical_length
	if distance < horizontal_length:
		return Vector2(EDGE_SPAWN_X - distance, EDGE_SPAWN_Y)
	distance -= horizontal_length
	return Vector2(-EDGE_SPAWN_X, EDGE_SPAWN_Y - distance)


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
	return mini(10, 3 + kills / 5)
