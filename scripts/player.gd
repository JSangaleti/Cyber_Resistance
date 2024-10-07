extends CharacterBody2D

# Underline antes das variáveis no GDScript, indica que a variável é privada e não pode ser alterada por meio de outras classes ou scripts.

var _player_velocity : float = 150.0
var _movement_direction : Vector2 = Vector2.ZERO
var _is_moving : bool = false

@onready var _player_animation := $AnimatedSprite2D as AnimatedSprite2D

func _process(_delta):
	_update_movement()
	_animate()
	# acessou_local("Computador")

func _update_movement() -> void:
	_movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if _movement_direction != Vector2.ZERO:
		_is_moving = true
		velocity = _movement_direction.normalized() * _player_velocity
		move_and_slide()
	else:
		_is_moving = false

func _animate() -> void:
	match _movement_direction:
		Vector2.RIGHT:
			_player_animation.play("right")
		Vector2.LEFT:
			_player_animation.play("left")
		Vector2.UP:
			_player_animation.play("up")
		Vector2.DOWN:
			_player_animation.play("down")
		_:
			if !_is_moving:
				_player_animation.stop()
				_player_animation.frame = 1
