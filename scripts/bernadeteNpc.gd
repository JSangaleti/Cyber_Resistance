extends CharacterBody2D

# Movimento do NPC ---
const _NPC_VELOCITY: float = 35.0
var _status: int = IDLE
var _movement_direction: Vector2 = Vector2.ZERO
var _in_movement: bool = true
# ---

# Direção do NPC ---
var _animate_by_direction: Dictionary = {
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
	Vector2.UP: "up",
	Vector2.DOWN: "down",
	Vector2.ZERO: "stop"
}
# ---

# Relacionado ao Diálogo ---
var _player: Node

@onready var sprite = $Animated

# Sinais
signal talking_to_npc


# Enum para estados do NPC
enum {
	IDLE,
	NEW_DIRECTION,
	MOVEMENT
}

func _ready() -> void:
	randomize()
	_setup_timer()

# Configura o tempo inicial do Timer
func _setup_timer() -> void:
	$Timer.wait_time = _select_random_time([0.5, 1.0, 1.5, 2.0])

func _process(delta: float) -> void:
	if _in_movement:
		_npc_movement(delta)
		_animate_npc()
	else:
		_stop_animation()

# Controla o movimento do NPC
func _npc_movement(delta: float) -> void:
	if _movement_direction != Vector2.ZERO:
		velocity = _movement_direction.normalized() * _NPC_VELOCITY
		move_and_slide()

# Anima o NPC com base na direção
func _animate_npc() -> void:
	sprite.play(_animate_by_direction[_movement_direction])

# Para a animação do NPC
func _stop_animation() -> void:
	sprite.stop()
	sprite.frame = 1

# Seleciona um valor aleatório de um array
func _select_random_time(array: Array) -> Variant:
	array.shuffle()
	return array.front()

# Atualiza o status do NPC
func _update_npc_status() -> void:
	_status = _select_random_time([IDLE, NEW_DIRECTION, MOVEMENT])
	match _status:
		IDLE:
			_in_movement = false
		NEW_DIRECTION:
			_movement_direction = _select_random_time([Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])
		MOVEMENT:
			_in_movement = true
