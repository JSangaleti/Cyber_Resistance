# Arquivo: NPCMovement.gd
class_name NPCMovement
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

# Enum para estados do NPC
enum {
	IDLE,
	NEW_DIRECTION,
	MOVEMENT
}

@onready var area2d: Area2D = $ChatDetector
@onready var sprite: AnimatedSprite2D = $Animated
@onready var timer: Timer = $Timer

func _ready() -> void:
	$NpcData.set_metadata()
	
	randomize()
	_setup_timer()
	_connect_signals()

# Configura o tempo inicial do Timer
func _setup_timer() -> void:
	timer.wait_time = _select_random_time([0.5, 1.0, 1.5, 2.0])
	timer.timeout.connect(_on_timer_timeout)

# Conecta os sinais necessários
func _connect_signals() -> void:
	area2d.body_entered.connect(_on_chat_detector_body_entered)
	area2d.body_exited.connect(_on_chat_detector_body_exited)

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
	sprite.play(_animate_by_direction.get(_movement_direction, "stop"))

# Para a animação do NPC
func _stop_animation() -> void:
	sprite.stop()
	sprite.frame = 1

# Seleciona um valor aleatório de um array
func _select_random_time(array: Array) -> Variant:
	array.shuffle()
	return array.front()

# Quando o jogador entra na área de chat
func _on_chat_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.can_interact = true
		body.current_npc = self

# Quando o jogador sai da área de chat
func _on_chat_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.can_interact = false
		body.current_npc = null

# Quando o Timer é finalizado
func _on_timer_timeout() -> void:
	# Aqui podemos verificar se o NPC está em chat ou não, dependendo da lógica
	timer.wait_time = _select_random_time([0.5, 1.0, 1.5, 2.0])
	_update_npc_status()

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
