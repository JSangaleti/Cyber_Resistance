extends CharacterBody2D

# Variáveis para interação
var can_interact: bool = false
var current_npc: Node = null

# Sinal para verificação de Tasks
signal talking_to_npc(current_npc)

func _ready() -> void:
	# Conecta o sinal 'dialogue_finished' ao método local '_on_dialogue_finished'
	DialogueUI.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))


func _process(delta: float) -> void:
	# Se podemos interagir e a tecla de diálogo foi pressionada
	if can_interact and Input.is_action_just_pressed("chat_accept"):
		emit_signal("talking_to_npc", current_npc)
		_start_dialogue()

# Inicia o diálogo com o NPC atual
func _start_dialogue() -> void:
	if current_npc == null:
		return
	
	var npc_id: String = current_npc.get_meta("npc_id")
	
	# (1) Recarrega as falas válidas no exato momento da interação
	var dialogues_array: Array = DialogueManager.get_valid_dialogues(npc_id)
	
	# (2) Se o array estiver vazio, não há falas
	if dialogues_array.size() == 0:
		return
	
	# (3) Puxa o retrato atualizado
	var portrait_path: String = DialogueManager.get_npc_portrait(npc_id)
	
	# (4) Nome do NPC
	var npc_name = "NPC"
	if current_npc.has_meta("npc_name"):
		npc_name = current_npc.get_meta("npc_name")
	
	# (5) Abre a UI de diálogo
	DialogueUI.open_dialogue(dialogues_array, npc_name, npc_id, portrait_path)

func _on_chat_detector_body_entered(body: Node) -> void:
	if body.is_in_group("NPC"):
		can_interact = true
		current_npc = body

func _on_chat_detector_body_exited(body: Node) -> void:
	if body.is_in_group("NPC"):
		can_interact = false
		current_npc = null

func _on_dialogue_finished(last_line_id: String):
	# Se a última fala do NPC Hubner foi 'quiz_1', abre o Quiz
	print("O SINAL FOI EMITIDO")
	if last_line_id == "quiz_1":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$"../Quiz"._on_quiz_open()  # Ou get_node("/root/Quiz")._on_quiz_open(), etc.
