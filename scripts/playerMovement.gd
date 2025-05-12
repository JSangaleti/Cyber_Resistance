# Arquivo: PlayerMovement.gd
class_name PlayerMovement
extends Node

@export var player_velocity: float = 150.0
var _movement_direction: Vector2 = Vector2.ZERO
var _is_moving: bool = false

@onready var player_body: CharacterBody2D = get_parent() as CharacterBody2D
@onready var player_animation: AnimatedSprite2D = $"../AnimatedSprite2D"

func _ready() -> void:
	# Se quisermos capturar input
	set_process(true)

func _process(delta: float) -> void:
	_update_movement(delta)
	_animate()

# Movimento do Player
func _update_movement(delta: float) -> void:
	# If para verificar se o Player está em uma conversa com NPC. Se estiver, ele não pode se movimentar. 
	if Global.is_talking:
		player_body.velocity = Vector2.ZERO
		player_body.move_and_slide()
		_is_moving = false
		return

	_movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if _movement_direction != Vector2.ZERO:
		_is_moving = true
		player_body.velocity = _movement_direction * player_velocity
		player_body.move_and_slide()
	else:
		_is_moving = false


# Animação do Player
func _animate() -> void:
	match _movement_direction:
		Vector2.RIGHT:
			player_animation.play("right")
		Vector2.LEFT:
			player_animation.play("left")
		Vector2.UP:
			player_animation.play("up")
		Vector2.DOWN:
			player_animation.play("down")
		_:
			if not _is_moving:
				player_animation.stop()
				player_animation.frame = 1
