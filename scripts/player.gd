extends CharacterBody2D

# Underline antes das variáveis no GDScript, indica que a variável é privada e não pode ser alterada por meio de outras classes ou scripts.

var _player_velocity : float = 150.0
var _movement_direction : Vector2 = Vector2.ZERO
var _is_moving : bool = false

var classPlayerPosition : playerState.PlayerPosition

@onready var player_animation := $AnimatedSprite2D as AnimatedSprite2D


func _process(_delta : float):
	_update_movement()
	_animate()
	# acessou_local("Computador")
	#emit_signal("updatePlayerState")


func _update_movement() -> void:
	_movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if _movement_direction != Vector2.ZERO:
		_is_moving = true
		velocity = _movement_direction * _player_velocity
		move_and_slide()
	else:
		_is_moving = false

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
			if !_is_moving:
				player_animation.stop()
				player_animation.frame = 1


#func _on_update_player_state() -> void:
	#print("position, ", position)
	#print("name, ", get_parent().name)
#
	#print("TESTE", playerState.PlayerPosition)
#
	#var p = playerState.PlayerPosition.new()
	#p.positionState = position
	#p.scene = get_parent().name
	#playerState.save_state();
	#
	#print(p)
	#print(p.positionState, "+ ", p.scene )
