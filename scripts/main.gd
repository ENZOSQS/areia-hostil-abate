extends Node2D

const TOTAL_SCORPIONS := 50
const ScorpionScene := preload("res://entities/scorpion.tscn")

@onready var player: CharacterBody2D = $Player
@onready var hud = $HUD

func _ready() -> void:
	player.add_to_group("players")
	player.health_changed.connect(hud.set_health)
	player.scorpions_defeated_changed.connect(hud.set_count)
	player.player_defeated.connect(hud.set_defeated)
	hud.set_health(player.health, player.max_health)
	hud.set_count(0)
	_spawn_scorpions()

func _spawn_scorpions() -> void:
	# Limita a distribuição à área interna das cercas (x ±612, y ±332).
	var already_in_scene := get_tree().get_nodes_in_group("scorpions").size()
	for index in range(maxi(TOTAL_SCORPIONS - already_in_scene, 0)):
		var slot := index + already_in_scene
		var angle := TAU * float(slot) / float(TOTAL_SCORPIONS)
		var ring_scale := 0.76 + float(slot % 3) * 0.08
		var scorpion = ScorpionScene.instantiate()
		scorpion.position = Vector2(
			cos(angle) * 560.0 * ring_scale,
			sin(angle) * 290.0 * ring_scale
		)
		add_child(scorpion)
