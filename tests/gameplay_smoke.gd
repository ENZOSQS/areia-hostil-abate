extends Node

const MainScene := preload("res://scenes/main.tscn")
const ScorpionScene := preload("res://entities/scorpion.tscn")
const ProjectileScene := preload("res://entities/projectile.tscn")
const PickupScene := preload("res://entities/health_pickup.tscn")

var failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var game := MainScene.instantiate()
	add_child(game)
	await get_tree().process_frame
	var player := game.get_node("Player")
	_check(player.health == player.max_health, "Player starts at full health")
	_check(player.state == 0, "Player starts idle")
	_check(player.sprite.animation == "idle_down", "Player starts with the downward idle animation")
	player.facing = Vector2.UP
	player._moving = true
	player.state = 1
	player._update_animation()
	_check(player.sprite.animation == "run_up", "Upward movement selects the upward run cycle")
	player.facing = Vector2.LEFT
	player._update_animation()
	_check(player.sprite.animation == "run_left", "Leftward movement selects the left run cycle")
	player._moving = false
	player.state = 0
	player._update_animation()
	_check(player.sprite.animation == "idle_left", "Stopping selects the matching idle animation")
	var water_body := game.get_node("OasisWaterBlocker")
	var water_shape: RectangleShape2D = water_body.get_node("CollisionShape2D").shape
	_check(water_shape.size.x >= 160.0 and water_shape.size.y >= 120.0, "Oasis water has a blocking rectangle")
	var water_query := PhysicsShapeQueryParameters2D.new()
	var player_shape: CircleShape2D = player.get_node("CollisionShape2D").shape
	water_query.shape = player_shape
	water_query.transform = Transform2D(0.0, water_body.global_position)
	water_query.collision_mask = 1
	var water_hits: Array[Dictionary] = game.get_world_2d().direct_space_state.intersect_shape(water_query, 16)
	var water_is_solid := false
	for hit in water_hits:
		if hit.collider == water_body:
			water_is_solid = true
	_check(water_is_solid, "Player collision query detects the oasis blocker")
	player.take_damage(10)
	_check(player.health == player.max_health - 10, "Player damage reduces health")
	_check(player.state == 3, "Player damage enters hurt state")
	player.heal(500)
	_check(player.health == player.max_health, "Healing clamps at maximum health")

	var enemy := ScorpionScene.instantiate()
	enemy.target = player
	game.add_child(enemy)
	_check(enemy.state == 0, "Scorpion enters through its spawn state")
	_check(enemy.sprite.hframes == 4 and enemy.sprite.vframes == 4, "Scorpion uses the directional sprite atlas")
	enemy.defeated.connect(game._on_scorpion_defeated)
	for hit in range(3):
		var shot := ProjectileScene.instantiate()
		game.add_child(shot)
		shot.launch(Vector2.RIGHT)
		shot._on_body_entered(enemy)
		if hit == 0:
			_check(enemy.state == 3, "A projectile hit enters the scorpion hurt state")
	_check(enemy.state == 4, "Scorpion reaches dead state at zero health")
	_check(game.kills == 1, "Three player shots award one scorpion defeat")

	var projectile := ProjectileScene.instantiate()
	game.add_child(projectile)
	var shot_sprite: Sprite2D = projectile.get_node("Sprite2D")
	_check(shot_sprite.texture.get_size() == Vector2(18.0, 12.0), "Projectile uses the compact desert bolt sprite")
	_check(shot_sprite.scale == Vector2(0.8, 0.8), "Projectile visual stays close to its hitbox size")
	projectile.launch(Vector2.RIGHT)
	_check(projectile.state == 0 and projectile.direction == Vector2.RIGHT, "Projectile launches in the requested direction")
	projectile._transition(1)
	_check(projectile.state == 1, "Projectile impact leaves the flying state")

	player._invulnerable_timer = 0.0
	player.take_damage(30)
	var pickup := PickupScene.instantiate()
	game.add_child(pickup)
	pickup._on_body_entered(player)
	_check(pickup.state == 1, "Health item enters collected state")
	_check(player.health == player.max_health - 10, "Health item restores the player")

	game.kills = 49
	game._on_scorpion_defeated(1, Vector2(400, 200))
	_check(game.kills == 50, "Kill counter reaches the Abate objective")
	_check(game.session_state == 1, "Fifty kills finish the session in victory")
	game.session_state = 0
	game._on_player_defeated()
	_check(game.session_state == 2, "Player defeat enters the game over state")

	if failures.is_empty():
		print("Gameplay smoke checks passed: directional animation, water blocker, projectile art and hits, kill target, pickup and end states.")
	else:
		for failure in failures:
			push_error("Gameplay check failed: " + failure)
	get_tree().quit(0 if failures.is_empty() else 1)


func _check(condition: bool, description: String) -> void:
	if not condition:
		failures.append(description)
