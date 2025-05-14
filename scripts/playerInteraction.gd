extends CharacterBody2D

# Variáveis para interação
var can_interact: bool = false
var current_npc: Node = null

# Sinal para verificação de Tasks
signal talking_to_npc(current_npc)

func _ready() -> void:
	randomize()
	# Conecta o sinal 'dialogue_finished' ao método local '_on_dialogue_finished'
	DialogueUI.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))


func _process(delta: float) -> void:
	# Se podemos interagir e a tecla de diálogo foi pressionada
	if can_interact and Input.is_action_just_pressed("chat_accept"):
		emit_signal("talking_to_npc", current_npc)
		_start_dialogue()

# Inicia o diálogo com o NPC atual
func _start_dialogue() -> void:
	if Global.is_talking or current_npc == null:
		return

	var npc_id: String = current_npc.get_meta("npc_id")
	var dialogues_array: Array = DialogueManager.get_valid_dialogues(npc_id)

	if dialogues_array.is_empty():
		return

	var specific_dialogues: Array = []
	var random_dialogues: Array = []

	for d in dialogues_array:
		var once = d.get("conditions", {}).get("once", false)
		if once:
			specific_dialogues.append(d)
		else:
			random_dialogues.append(d)

	var dialogues_to_show: Array = []

	if specific_dialogues.size() > 0:
		# Prioridade: mostrar todos os específicos
		dialogues_to_show = specific_dialogues
	elif random_dialogues.size() > 0:
		# Se não há específicos, mostra só UM aleatório
		dialogues_to_show = [random_dialogues[randi() % random_dialogues.size()]]

	# Pega o nome e retrato
	var portrait_path: String = DialogueManager.get_npc_portrait(npc_id)
	var npc_name = current_npc.get_meta("npc_name") if current_npc.has_meta("npc_name") else "NPC"

	# Abre a UI com os diálogos filtrados
	DialogueUI.open_dialogue(dialogues_to_show, npc_name, npc_id, portrait_path)



	
	#DialogueUI.open_dialogue(dialogues_array, npc_name, npc_id, portrait_path)

func _on_chat_detector_body_entered(body: Node) -> void:
	if body.is_in_group("NPC"):
		can_interact = true
		current_npc = body

func _on_chat_detector_body_exited(body: Node) -> void:
	if body.is_in_group("NPC"):
		can_interact = false
		current_npc = null

func _on_dialogue_finished(last_line_id: String):
	
	# permitindo a movimentação do player:
	Global.is_talking = false;
	
	# Se a última fala do NPC Hubner foi 'quiz_1', abre o Quiz
	if last_line_id == "quiz_1":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$"../Quiz"._on_quiz_open()  # Ou get_node("/root/Quiz")._on_quiz_open(), etc.
