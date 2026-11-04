@tool
extends CharacterBody2D

# Código desenvolvido com assistência de IA (OpenAI Codex); consulte e adapte entendendo cada função.
@export var speed: float = 220.0

func _ready() -> void:
	if not Engine.is_editor_hint():
		$Camera2D.make_current()

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var direction := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1.0
		
	velocity = direction.normalized() * speed
	move_and_slide()
