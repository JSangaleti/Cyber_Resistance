extends CharacterBody2D



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

# Enum para estados do NPC

func _ready() -> void:
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





# Para a animação do NPC
func _stop_animation() -> void:
	sprite.stop()
	sprite.frame = 1

	# Carrega o diálogo e emite os sinais
	var dialogue = Global.load_json("res://assets/dialogs/npcs/hubner/dialogues.json")
	emit_signal("start_dialogue", dialogue)
	emit_signal("talking_to_npc")  # Sinal para missão 01

# Finaliza o diálogo
func finish_dialog() -> void:
	in_dialogue = false

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
