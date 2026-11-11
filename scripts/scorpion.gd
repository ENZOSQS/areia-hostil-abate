extends CharacterBody2D

@export var speed: float = 72.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var touch_area: Area2D = $TouchArea

var target: Node2D
var damage_timer: float = 0.0
var defeated: bool = false

func _ready() -> void:
	add_to_group("scorpions")
	var players := get_tree().get_nodes_in_group("players")
	if not players.is_empty(): target = players[0]

func _physics_process(delta: float) -> void:
	if defeated: return
	damage_timer = maxf(0.0, damage_timer - delta)
	if not is_instance_valid(target):
		var players := get_tree().get_nodes_in_group("players")
		if not players.is_empty(): target = players[0]
	if is_instance_valid(target):
		var direction := global_position.direction_to(target.global_position)
		velocity = direction * speed
		if absf(direction.x) > absf(direction.y):
			sprite.play("walk_right" if direction.x > 0 else "walk_left")
		else:
			sprite.play("walk_down" if direction.y > 0 else "walk_up")
		move_and_slide()
	if damage_timer <= 0.0:
		for body in touch_area.get_overlapping_bodies():
			if body.is_in_group("players"):
				body.take_damage(10)
				damage_timer = 0.75
				break

func defeat() -> void:
	if defeated: return
	defeated = true
	queue_free()
