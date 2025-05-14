extends CharacterBody2D

var _player_velocity: float = 150.0
var _movement_direction: Vector2 = Vector2.ZERO
var _is_moving: bool = false

@onready var player_animation := $AnimatedSprite2D

# Variáveis relacionada ao movimento durante o Diálogo ---
var can_interact: bool = false
var current_npc: Node = null
# -------------------------------------------------------- 

func _ready() -> void:
	set_process_unhandled_input(true)
	get_tree().root.add_child(self)  # Torna o nó persistente ao adicioná-lo ao root
	
func _process(_delta: float):
	_update_movement()
	_animate()
	
#	Diálogo -----
	if can_interact and Input.is_action_just_pressed("chat_accept"):
		if current_npc and !current_npc.in_dialogue:
			current_npc.dialog_start()
# Fim Diálogo -------

# Movimento do Player 
func _update_movement() -> void:
	_movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if _movement_direction != Vector2.ZERO:
		_is_moving = true
		velocity = _movement_direction * _player_velocity
		move_and_slide()
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
			if !_is_moving:
				player_animation.stop()
				player_animation.frame = 1

# Detecção de proximidade para ativação do Diálogo
func _on_chat_detector_body_entered(body: Node2D):
	if body.name == "NPC":
		can_interact = true
		current_npc = body

func _on_chat_detector_body_exited(body: Node2D):
	if body.name == "NPC":
		can_interact = false
		current_npc = null
