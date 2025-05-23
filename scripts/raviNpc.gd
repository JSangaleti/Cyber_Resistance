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
var _in_chat: bool = false
var _player: Node
var in_dialogue: bool = false

@onready var area2d = $ChatDetector
@onready var sprite = $Animated
@onready var dialog_manager = $"../DialogManager"

# Sinais
signal start_dialogue(dialogue)
signal body_entered(body)
signal talking_to_npc
signal start_quiz

# Enum para estados do NPC
enum {
	IDLE,
	NEW_DIRECTION,
	MOVEMENT
}

func _ready() -> void:
	# Definindo o npc_id via metadados
	set_meta("npc_id", "ravi") 
	set_meta("npc_name", "Ravi")
	
	# Referente a movimentação
	randomize()
	_setup_timer()
	_connect_signals()

# Configura o tempo inicial do Timer
func _setup_timer() -> void:
	$Timer.wait_time = _select_random_time([0.5, 1.0, 1.5, 2.0])

# Conecta os sinais necessários
func _connect_signals() -> void:
	area2d.body_entered.connect(_on_chat_detector_body_entered)
	area2d.body_exited.connect(_on_chat_detector_body_exited)

	# Conecta o sinal ao DialogUI
	var dialog_ui = $DialogUI
	start_dialogue.connect(dialog_ui.show_dialog)

	# Conecta o sinal de falar com o NPC à tarefa
	var tasks_node = $Tasks
	talking_to_npc.connect(tasks_node._task_01)

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

# Inicia o diálogo com o NPC
func dialog_start() -> void:
	# Para o movimento e a animação do NPC
	_in_movement = false
	_stop_animation()

	# Carrega o diálogo e emite os sinais
	var dialogue = Global.load_json("res://assets/dialogs/npcs/violet/dialog01.json")
	emit_signal("start_dialogue", dialogue)
	emit_signal("talking_to_npc")  # Sinal para missão 01

	## Espera o diálogo terminar antes de iniciar o quiz
	#await get_tree().create_timer(1.0).timeout  # Espera 1 segundo antes de carregar o quiz
	#get_tree().change_scene_to_file("res://scenes/quiz.tscn")  # Carrega a cena do quiz

# Finaliza o diálogo
func finish_dialog() -> void:
	in_dialogue = false
	_status = NEW_DIRECTION
	_in_movement = true  # Reativa o movimento
	_movement_direction = _select_random_time([Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])  # Define uma nova direção
	
# Seleciona um valor aleatório de um array
func _select_random_time(array: Array) -> Variant:
	array.shuffle()
	return array.front()

# Quando o jogador entra na área de chat
func _on_chat_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.can_interact = true
		body.current_npc = self
		print("Chat detector - Player está na área de chat")

# Quando o jogador sai da área de chat
func _on_chat_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.can_interact = false
		body.current_npc = null

# Quando o Timer é finalizado
func _on_timer_timeout() -> void:
	if !_in_chat:
		$Timer.wait_time = _select_random_time([0.5, 1.0, 1.5, 2.0])
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
